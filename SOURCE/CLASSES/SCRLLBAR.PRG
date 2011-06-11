#include "FiveDos.ch"
#include "FontDef.h"
#include "SysColor.ch"

#define UP_ARROW     Chr( ARROWUPLEFT ) + Chr( ARROWUPRIGHT )
#define DOWN_ARROW   Chr( ARROWDNLEFT ) + Chr( ARROWDNRIGHT )
#define LEFT_ARROW   Chr( ARROWLFLEFT ) + Chr( ARROWLFRIGHT )
#define RIGHT_ARROW  Chr( ARROWRGLEFT ) + Chr( ARROWRGRIGHT )

#define THE_BLANK Chr( 32 )  + Chr( 32 )
#define THE_THUMB Chr( THUMBLEFT ) + Chr( THUMBRIGHT )

//------------------------------------------------------------------------//

CLASS TScrollBar FROM TView

    DATA   nOption, nRange, nPage, nOldOption, nThumbStep,; 
           nLen, nClrArrows, nClrFocus, nPos               AS Numeric
    DATA   bUP, bDown, bPgUp, bPgDown, bThumbPos           AS Block INIT bTrue()
    DATA   lHorizontal                                     AS Logical

    METHOD New( nRow, nCol, lHorizontal, nLen, nRange, nPage, ;
                bUP, bDown, bPgUp, bPgDown, bThumbPos, bValid, bWhen, ;
                cColor, cMessage, oWnd, lUpdate )

    METHOD Click( nMRow, nMCol )

    METHOD GoUp()
    METHOD GoDown()
    METHOD GoPgUp()
    METHOD GoPgDown()

    METHOD KeyPressed( nKey )

    METHOD Resized( nRect )

    METHOD ReDefine( cMessage, cColor, nLen, nRange, nPage, bUp, bDown, bPgUp,;
                     bPgDown, bThumbPos, bWhen, bValid, lUpdate )
    METHOD Refresh()

    METHOD SetColors( cColor,  n, aSysClr ) INLINE ; // local var == n, aSysClr
           aSysClr      := aSysColor(),;
           ::nColor     := if( Empty( n := nStrColor( cColor, 1 ) ), ;
                               aSysClr[ CLR_SCROLLBAR ], n ),;
           ::nClrArrows := if( Empty( n := nStrColor( cColor, 2 ) ), ;
                               aSysClr[ CLR_SCROLLBARARROWS ], n ),;
           ::nClrFocus  := if( Empty( n := nStrColor( cColor, 3 ) ), ;
                               aSysClr[ CLR_SCROLLBAR_HI ], n )

    METHOD SetOption( nNewVal ) INLINE ::nOption    := nNewVal, ;
                                       ::Refresh(),;
                                       ::nOldOption := -1
    METHOD SetRange( nRange )

ENDCLASS

//------------------------------------------------------------------------//

METHOD New( nRow, nCol, lHorizontal, nLen, nRange, nPage, ;
            bUP, bDown, bPgUp, bPgDown, bThumbPos, bValid, bWhen, ;
            cColor, cMessage, oWnd, lUpdate  )

    local nOption, bTrue := bTrue()

    DEFAULT nLen        := 10           ,;
            nRange      := nLen         ,;
            nPage       := nRange / 4   ,;
            lHorizontal := .f.

    ::nOption    = 1
    ::nOldOption = -1
    ::nLen       = nLen - if( lHorizontal, 5 , 2 )
    ::nPos       = if( lHorizontal, 2, 1 )
    ::SetRange( nRange )

    ::BeginPaint()

    ::SetColors( cColor )

    BYNAME nPage       INIT NUMBER
    BYNAME lHorizontal INIT LOGICAL
    BYNAME bUp, bDown, bPgUp, bPgDown, bThumbPos INIT BLOCK

    if !lHorizontal
        Super:New( nRow, nCol, 2 , nLen, ::nColor,,oWnd, cMessage, bWhen, bValid )
        ::Say( nLen - 1, 0, DOWN_ARROW, ::nClrArrows )
        ::Say( 0, 0, UP_ARROW, ::nClrArrows )
	else
        Super:New( nRow, nCol, nLen, 1, ::nColor,,oWnd, cMessage, bWhen, bValid )
        ::Say( 0 ,0 , LEFT_ARROW, ::nClrArrows )
        ::Say( 0, nLen - 2, RIGHT_ARROW, ::nClrArrows )
    endif

    ::Refresh()
    ::EndPaint()
    ::lUpdate := lUpdate
return Self

//------------------------------------------------------------------------//

METHOD ReDefine( cMessage, cColor, nLen, nRange, nPage, bUp, bDown, bPgUp,;
                 bPgDown, bThumbPos, bWhen, bValid, lUpdate  )

    local nOption, bTrue := bTrue()

    DEFAULT nLen   := 10        ,;
            nRange := nLen      ,;
            nPage  := nRange / 4

    ::nOption    = 1
    ::nOldOption = -1
    ::nLen       = nLen - if( ::lHorizontal, 5 , 2 )
    ::nPos       = if( ::lHorizontal, 2, 1 )
    ::SetRange( nRange )

    BYNAME nPage    INIT NUMBER
    BYNAME cMessage INIT CHARACTER
    BYNAME bUp, bDown, bPgUp, bPgDown, bThumbPos, bWhen, bValid INIT BLOCK

    if !IS_NIL( cColor )
       ::SetColors( cColor )
    endif

    ::Refresh()
    ::lUpdate := lUpdate

return Self

//------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol )

    local nPos, nOld  := ::nOption
    local lHorizontal := ::lHorizontal
    local n, nDelay   := 100
    local nOldPos

    if ::lDesign
        return Super:Click( nMRow, nMCol )
    endif

    nPos = if( lHorizontal, ::nMCol(), ::nMRow() )

    if nPos == ::nPos .or. ( lHorizontal .and. nPos == ::nPos + 1 )

        nOld    = ::nOption
        nOldPos = ::nPos

        while lMPressed()

            nPos = if( lHorizontal, ::nMCol(), ::nMRow() )

            do case
                case nPos <= if( lHorizontal, 2, 1 )
                    ::nOption = 1
                    nPos = if( lHorizontal, 2, 1 )

                case nPos > ::nLen + if( lHorizontal, 1, 0 )
                    ::nOption = ::nRange
                    nPos = ::nLen + if( lHorizontal, 1, 0 )

                otherwise

                    if ::nRange >= ::nLen
                        // ::nOption = int( ( nPos - if( lHorizontal, 1, 0 ) ) * ::nThumbStep )
                        ::nOption = round( 0.500 - if( lHorizontal, 1, 0 ) + nPos * ::nThumbStep, 0 )
                    else
                        ::nOption = round( 0.5 + ( nPos - if( lHorizontal, 1, 0 ) )/ ::nThumbStep, 0 )
                    endif

                    /*
                    if ::nRange > ::nLen
                        ::nPos = if( lHorizontal, 2, 1 ) + ;
                                        int( ( ::nOption - 1 ) / ::nThumbStep )
                    else
                        ::nPos = if( lHorizontal, 2, 1 ) + ;
                                        int( ( ::nOption - 1 ) * ::nThumbStep )
                    endif


                    */
                    
            endcase

            if nOldPos != nPos
                ::BeginPaint()
                if lHorizontal
                    ::Say( 0, nOldPos, THE_BLANK, ::nColor )
                    ::Say( 0, nPos, THE_THUMB, ::nClrFocus )
                else
                    ::Say( nOldPos, 0, THE_BLANK, ::nColor )
                    ::Say( nPos, 0, THE_THUMB, ::nClrFocus )
                endif
                ::EndPaint()
                nOldPos = nPos

                if nOld != ::nOption
                    Eval( ::bThumbPos, ::nOption - nOld )
                    nOld = ::nOption
                endif

            endif

            MUpdate()

        end

        ::nPos = nPos
        ::nOldOption = -1
        ::Refresh()

    elseif nPos == 0 .or. ( lHorizontal .AND. nPos == 1 )
        while lMPressed()
            if nPos == 0 .or. ( ::lHorizontal .AND. nPos == 1 )
                ::GoUp()
                if nDelay > 20
                    MiliDelay( nDelay -= 20 )
                endif
            endif
            MUpdate()
            nPos = if( lHorizontal, ::nMCol(), ::nMRow() )
        end

    elseif if( lHorizontal, ;
               nPos == ::nLen + 3 .or. nPos == ::nLen + 4,;
               nPos == ::nLen + 1 )
        while lMPressed()
            if if( lHorizontal, ;
                   nPos == ::nLen + 3 .or. nPos == ::nLen + 4,;
                   nPos == ::nLen + 1 )
                ::GoDown()
                if nDelay > 20
                    MiliDelay( nDelay -= 20 )
                endif
            endif
            MUpdate()
            nPos = if( lHorizontal, ::nMCol(), ::nMRow() )
        end

    elseif nPos < ::nPos

        while lMPressed()
            if nPos < ::nPos
                ::GoPgUp()
                MiliDelay( nDelay := if( nDelay > 20, nDelay - 20, 1 ) )
            endif
            MUpdate()
            nPos = if( lHorizontal, ::nMCol(), ::nMRow() )
        end

    elseif nPos > ::nPos

        while lMPressed()
            if nPos > ::nPos
                ::GoPgDown()
                MiliDelay( nDelay := if( nDelay > 20, nDelay - 20, 1 ) )
            endif
            MUpdate()
            nPos = if( lHorizontal, ::nMCol(), ::nMRow() )
        end

    endif

return nil

//---------------------------------------------------------------------------//

METHOD GoUp()

    Eval( ::bUp )
    if ::nOption == ::nOldOption
        ::nOption--
        ::Refresh()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD GoDown()

    Eval( ::bDown )
    if ::nOption == ::nOldOption
        ::nOption++
        ::Refresh()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD GoPgUp()

    Eval( ::bPgUp )
    if ::nOption == ::nOldOption
        ::nOption -= ::nPage
        ::Refresh()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD GoPgDown()

    Eval( ::bPgDown )
    if ::nOption == ::nOldOption
        ::nOption += ::nPage
        ::Refresh()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    if ::lHorizontal

        do case
            case nKey == K_LEFT
                ::GoUp()
 			case nKey == K_RIGHT
                ::GoDown()
            case nKey == K_CTRL_LEFT
                ::GoPgUp()
            case nKey == K_CTRL_RIGHT
                ::GoPgDown()
            otherwise
                return Super:KeyPressed( nKey )
		endcase

    else

		do case
			case nKey == K_UP
				::GoUp()
			case nKey == K_DOWN
				::GoDown()
            case nKey == K_PGUP
                ::GoPgUp()
            case nKey == K_PGDN
                ::GoPgDown()
            otherwise
                return Super:KeyPressed( nKey )
		endcase

    endif

return 0

//---------------------------------------------------------------------------//

METHOD Resized( nRect )
    local nLen
    if IS_NIL( nRect )
        nRect = NewRect( ::nTop, ::nLeft, ::nWidth, ::nHeight )
    endif

    ::BeginPaint()
    nLen   = if( ::lHorizontal, ::nWidth, ::nHeight )
    ::nLen = nLen - if( ::lHorizontal, 5 , 2 )

    if !::lHorizontal
        ::Say( nLen - 1, 0, DOWN_ARROW, ::nClrArrows )
        ::Say( 0, 0, UP_ARROW, ::nClrArrows )
	else
        ::Say( 0 ,0 , LEFT_ARROW, ::nClrArrows )
        ::Say( 0, nLen - 2, RIGHT_ARROW, ::nClrArrows )
    endif
    ::SetRange( ::nRange )
    ::Refresh()
    ::EndPaint()

return nil

//---------------------------------------------------------------------------//

METHOD Refresh()

    local lHorizontal := ::lHorizontal

    ::BeginPaint()

    if ::nOption != ::nOldOption

        ::nOption = Min( ::nRange, Max( 1, ::nOption ) )

        if lHorizontal
            ::Say( 0, ::nPos, THE_BLANK, ::nColor)
        else
            ::Say( ::nPos, 0, THE_BLANK, ::nColor)
        endif

        if ::nRange > ::nLen
            ::nPos = if( lHorizontal, 2, 1 ) + ;
                            int( ( ::nOption - 1 ) / ::nThumbStep )
        else
            ::nPos = if( lHorizontal, 2, 1 ) + ;
                            int( ( ::nOption - 1 ) * ::nThumbStep )
        endif

        ::nOldOption = ::nOption

    endif

    if lHorizontal
        ::Say( 0, ::nPos, THE_THUMB, ;
                If( ::lFocussed, ::nClrFocus, ::nColor ) )
    else
        ::Say( ::nPos, 0, THE_THUMB, ;
                If( ::lFocussed, ::nClrFocus, ::nColor ) )
    endif

    ::EndPaint()

return nil

//---------------------------------------------------------------------------//

METHOD SetRange( nRange )

    local nOld := ::nRange

    ::nRange = nRange

    if nRange > ::nLen
        ::nThumbStep = nRange / ::nLen
    else
        ::nThumbStep = ( ::nLen - 1 ) / ( nRange - 1 )
    endif

return nOld

//---------------------------------------------------------------------------//
