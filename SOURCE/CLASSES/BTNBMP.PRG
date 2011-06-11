#include "FiveDos.ch"
#include "FontDef.h"
#include "SysColor.ch"

//----------------------------------------------------------------------------//

CLASS TBtnBmp FROM TView

    DATA    bAction, bWhilePressed      AS Block INIT bNil()
    DATA    cChars, cBmpCh ,;
            cChars2, cBmpCh2,;
            cTips, cColorTips           AS Character
    DATA    cBmp, cBmp2
    DATA    lGroup, lPressed            AS Logical
    DATA    nClrLeft, nClrRight         AS Numeric

    DATA    nMouseCursor INIT IDC_HAND  // Overload previus init value

    CLASSDATA nTimer      AS Numeric
    CLASSDATA lShowTips   AS Logical

    METHOD New( oBar, cBmpFile, cBmpFile2, cCars, bAction, lGroup, ;
                cColors, cMsg, bWhilePressed, cTips, cColorTips ) CONSTRUCTOR
    METHOD Click()
    METHOD Destroy() INLINE if( !empty( ::cBmp ),;
                                ReleaseChars( ::cBmp ), ),;
                            if( !empty( ::cBmp2 ),;
                                ReleaseChars( ::cBmp2 ), )

    METHOD MouseMove( nMRow, nMCol )
    METHOD Refresh()
    METHOD SetColors( cColor )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oBar, cBmpFile, cBmpFile2, cCars, bAction, lGroup, cColor, ;
            cMsg, bWhilePressed, cTips, cColorTips )

   local cBmp, cBmp2, cChars, cChars2

   DEFAULT  cBmpFile2   := cBmpFile
   BYNAME   cTips       DEFAULT ''
   BYNAME   cColorTips  DEFAULT 'N/GR*'

   ::cBmp       = cBmpFile
   ::cBmp2      = cBmpFile2
   ::cBmpCh     = If( ! Empty( cBmpFile ),  ReadBitmap( cBmpFile ), '' )
   ::cBmpCh2    = If( ! Empty( cBmpFile2 ), ReadBitmap( cBmpFile2 ), '' )

   BYNAME   lGroup          DEFAULT .f.
   BYNAME   bAction         IFNONIL
   BYNAME   bWhilePressed   IFNONIL

   cChars = ::cBmpCh + if( !Empty( cBmp ) .and. !empty( cCars ), ' ','' ) + ;
            if( !Empty( cCars ), cCars, '' )

   cChars2 = ::cBmpCh2 + if( !Empty( cBmp2 ) .and. !empty( cCars ), ' ','' ) + ;
            if( !Empty( cCars ), cCars, '' )

   if Empty( cChars )
      cChars = " "
   endif

   if empty( cChars2 )
      cChars2 := " "
   endif

   BYNAME cChars
   BYNAME cChars2

   ::SetColors( cColor )

return Super:New( 0, 0, max( Len( cChars ), 1 ) + 2, 1, ::nColor,, oBar, cMsg )

//----------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol )

    local lPress := .t., lOldPress := .f.

    if ::lDesign .or. lMRight()
       return Super:Click( nMRow, nMCol )
    endif

    ::lPressed := lPress

    while lMPressed()

        if lOldPress != lPress
           ::lPressed = lPress
           ::Refresh()
           lOldPress  = lPress
        endif

        MUpdate()

        if lMPressed() .and. ( lPress := ::lIsover( nMRow := ::oWnd:nMRow(), ;
                                                    nMCol := ::oWnd:nMCol() ) )
            eval( ::bWhilePressed )
        endif
    end

    ::lPressed = .f.
    ::Refresh()

    if ::lIsover( nMRow, nMCol )
        eval( ::bAction )
    end

return nil

//----------------------------------------------------------------------------//

static procedure TimerEvent( oBtn )
    local oWnd  := oBtn:oWnd
    local oWndOver, nMRow, nMCol

    if oWnd:nAtOver( oWnd:nMRow(), oWnd:nMCol() ) != 0
        if !oBtn:lShowTips
            oBtn:lShowTips := .t.
            if !IS_NIL( oWndOver := MouseOver( GetActiveWindow(), ;
                                    nMRow := nMRow(), ;
                                    nMCol := nMCol() ) )

                oWndOver:MouseMove( nMRow, nMCol )
            endif
        endif
    else

            TimerRelease( oBtn:nTimer )
            oBtn:nTimer := 0
            SetTipsTo(,,,)
            oBtn:lShowTips := .f.
    endif

return

//---------------------------------------------------------------------------//


METHOD MouseMove( nMRow, nMCol )

    local oWnd

    Super:MouseMove( nMRow, nMCol )

    if ! Empty( ::cTips )


        if ::nTimer == 0 .and. ! ::lShowTips ;
           .and. ! lMPressed() .and. NextKey() == 0

            oWnd = ::oWnd
            DEFINE TIMER ::nTimer   ;
                INTERVAL 728        ;
                ACTION TimerEvent( Self )
                /*
                if( oWnd:nAtOver( oWnd:nMRow(), oWnd:nMCol() ) != 0,;
                           if( !::lShowTips,;
                               ( ::lShowTips := .t., MouseOver( GetActiveWindow(), nMRow(), nMCol() ):MouseMove( nMRow(), nMCol() )),),;
                            ( TimerRelease( ::nTimer ), ::nTimer := 0, SetTipsTo(,,,), ::lShowTips := .f. ) )
                */
            ACTIVATE TIMER ::nTimer

        endif

        if ::lShowTips

            oWnd = GetActiveWindow()

            nMRow = ::nOrgTop 
            nMCol = ::nOrgLeft

            if nMCol > ScrMaxCol() / 2 .and. ;
               nMCol + len( ::cTips ) + ::nWidth > ScrMaxCol()

                SetTipsTo( nMRow + if( ScrMaxRow() > nMRow, 1, -1 ), ;
                           nMCol + ( ::nWidth / 2 ) - len( ::cTips ) - 2 ,;
                           chr( BORDERLEFT ) + ::cTips + chr( BORDERRIGHT ),;
                           ::cColorTips )
            else
                SetTipsTo( nMRow + if( ScrMaxRow() > nMRow, 1, -1 ), ;
                           nMCol + 1 + ::nWidth / 2 ,;
                           chr( BORDERLEFT ) + ::cTips + chr( BORDERRIGHT ),;
                           ::cColorTips )
            endif

            while ::lIsOver( ::oWnd:nMRow(), ;
                             ::oWnd:nMCol() ) ;
                  .and. !lMPressed() ;
                  .and. NextKey() == 0

                SysRefresh()
                MUpdate()
            end


            if lMPressed() .or. NextKey() != 0
                TimerRelease( ::nTimer )
                ::nTimer := 0
                SetTipsTo(,,,)
                ::lShowTips := .f.
            endif

            /*
            if !::lIsOver( ::oWnd:nMRow(), ::oWnd:nMCol() )
                SetTipsTo( ,,, )
                oWnd:MouseMove( nMRow(), nMCol() )
            endif
            */
        endif

    elseif ::lShowTips
        SetTipsTo(,,,)
    endif

return nil

//----------------------------------------------------------------------------//

METHOD Refresh()

   local nClr1, nClr2

   if ::lPressed
      nClr1 = ::nClrRight
      nClr2 = ::nClrLeft
   else
      nClr1 = ::nClrLeft
      nClr2 = ::nClrRight
   endif

   ::BeginPaint()
   ::Say( 0, 0, Chr( BORDERLEFT ), nClr1 )
   ::SayHot( 0, 1, if( ::lPressed, ::cChars2, ::cChars ) + "&" + Chr( BORDERRIGHT ), ;
             if( ::lPressed, nClr2, ::nColor ), nClr2 )
   ::EndPaint()

return nil

//----------------------------------------------------------------------------//

METHOD SetColors( cColor )

    local n, aSysClr := aSysColor()

   ::nColor    = if( Empty( n := nStrColor( cColor, 1 ) ), ;
                     aSysClr[ CLR_BUTTONBMP ], n )
   ::nClrLeft  = if( Empty( n := nStrColor( cColor, 2 ) ), ;
                     aSysClr[ CLR_BUTTONBMP_LEFT ], n )
   ::nClrRight = if( Empty( n := nStrColor( cColor, 3 ) ), ;
                     aSysClr[ CLR_BUTTONBMP_RIGHT ], n )
return nil

//----------------------------------------------------------------------------//
