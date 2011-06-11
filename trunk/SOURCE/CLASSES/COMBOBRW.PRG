#include "FiveDos.ch"
#include "FontDef.h"
#include "SysColor.ch"
#include "redefine.ch"

#define UP_ARROW     Chr( MAXIMIZELEFT ) + Chr( MAXIMIZERIGHT )
#define DOWN_ARROW   Chr( MINIMIZELEFT ) + Chr( MINIMIZERIGHT )

//---------------------------------------------------------------------------//

CLASS TComboBrw FROM TComboBox

    DATA oLbx         AS Object
    DATA nOption      AS Numeric
    DATA lOpen        AS Logical
    DATA nClrArrow    AS Numeric
    DATA bChanged     AS Block   INIT bNil()

    METHOD Click( nMRow, nMCol, lDblClick )

    METHOD Close()

	METHOD KeyPressed( nKey )

    METHOD New( nRow, nCol, nWidth, nHeight, bSetGet, cPicture, lEdit, oBrowse,;
                cLabel, cMsg, cColors, oWnd, bLogicLen, bChanged, bDblClick,;
                bWhen, bValid, bRight, lUpdate )

    METHOD Open()

    METHOD ReDefine( cMessage, cColor, nHelpId, bSetGet, acList, cLabel, cPicture,;
                     bWhen, bValid, bChanged, lUpdate ) VIRTUAL

    METHOD Refresh() INLINE ;
            ::BeginPaint(),;
            Super:Refresh(),;
            ::Say( 0, ::nWidth -2, if( ::lOpen, UP_ARROW, DOWN_ARROW ), ::nClrArrow ),;
            if( ::lOpen, ::oLbx:Refresh(), ),;
            ::EndPaint()

    METHOD SetColors( cColor,  n, aSysClr ) INLINE ;  // local var = n, aSysClr
           aSysClr     := aSysColor(),;
           ::nColor    := if( Empty( n := nStrColor( cColor, 1 ) ), ;
                               aSysClr[ CLR_COMBO ], n ),;
           ::nClrFocus := if( Empty( n := nStrColor( cColor, 2 ) ), ;
                               aSysClr[ CLR_COMBO_HI ], n ),;
           ::nClrArrow := if( Empty( n := nStrColor( cColor, 3 ) ), ;
                               aSysClr[ CLR_COMBO_ARROW ], n )

    METHOD SetFocus( lOnOff ) INLINE ::BeginPaint(),;
                                     Super:SetFocus( lOnOff ),;
                                     if( ::oLbx != nil, ::oLbx:SetFocus( lOnOff ),),;
                                     if( !lOnOff, ::Close(), ),;
                                     ::EndPaint()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nRow, nCol, nWidth, nHeight, bSetGet, cPicture, lEdit, oBrowse,;
            cLabel, cMsg, cColors, oWnd, bLogicLen, bChanged, bDblClick,;
            bWhen, bValid, bRight, lUpdate )

    local nLen := 0

    DEFAULT lEdit   := .t.,;
            nWidth  := oBrowse:nRight - oBrowse:nLeft + 3,;
            nHeight := oBrowse:nBottom - oBrowse:nTop + 2
 
    BYNAME bChanged INIT BLOCK

    ::SetColors( cColors )

    Super:New( nRow, nCol, bSetGet, ::nColor, cLabel, cMsg, cPicture,;
               oWnd, bWhen, bValid,,, lEdit )
    ::lUpdate := lUpdate

    ::ChangeSize( nWidth + 3, nHeight  )

    ::oLbx := TCtlBrowse():New( nRow, nCol, nWidth, nHeight, oBrowse,,,;
                                cColors,, bLogicLen, bChanged, bDblClick,,,;
                                bRight )

    ::oLbx:oWnd = Self
/*
    ::oLbx:bDblClick := {|| ::BeginPaint(),;
                         ::oGet:VarPut( pad( ::oLbx:GetColumn( ::oLbx:ColPos() ) ,;
                                         len( ::oGet:Buffer ) ) ),;
                         ::oGet:Reset(),;
                         ::oGet:Home(),;
                         ::Close(),;
                         ::EndPaint()}
*/
    ::ChangeSize( ::nWidth, ::nHeight + 1 )
    ::nClipRect  = NewRect( ::nTop, ::nLeft, ::nWidth, 1 )
    ::lOpen      = .f.
    
return Self

//---------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol, lDblClick )

    if ::lDesign .or. lMRight()
       return Super:Click( nMRow, nMCol, lDblClick )
    endif

    nMRow -= ::nTop()  // de coordenadas padre a coordenadas de view
    nMCol -= ::nLeft()
    if nMRow == 0 .and. nMCol >= ::nWidth() - 2
        if ::lOpen
            ::Close()
        else
            ::Open()
        endif
    elseif ::lOpen .and. ::oLbx:lIsOver( nMRow, nMCol )
        ::oLbx:Click( nMRow, nMCol, lDblClick )
    elseif !::lOpen()
        Super:Click( nMRow, nMCol )
    endif

return nil

//---------------------------------------------------------------------------//

METHOD Close()

    if ::lOpen
        ::lOpen := ::lPainted := .f.
        ::nClipRect = NewRect( ::nTop, ::nLeft, ::nWidth , 1 )
        ::oWnd:Clear()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )
    local nSinAlt := 0

    if ::lDesign
        return Super:KeyPressed( nKey )
    endif

    if ! ::lOpen
        if nKey == K_DOWN
            ::Open()
            nKey = 0
        else
            nKey := Super:Keypressed( nKey )
        endif
	else
        if nKey == K_ESC
            ::Close()
            nKey = 0
        else
            nKey := ::oLbx:Keypressed( nKey )
        endif
    endif

return nKey

//---------------------------------------------------------------------------//

METHOD Open()
    if !::lOpen
        ::lOpen := .t.
        ::nClipRect = NewRect( ::nTop, ::nLeft, ::nWidth , ::nHeight )
        ::Refresh()
    endif
return nil

//---------------------------------------------------------------------------//
