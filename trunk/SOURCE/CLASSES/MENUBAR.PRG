#include "FiveDos.ch"

//----------------------------------------------------------------------------//

CLASS TMenuBar FROM TMenu

    DATA  bAction    AS Block, Undefined
    DATA  aShortCut
    DATA  lSysMenu   AS Logical

    METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cColors ) CONSTRUCTOR

    METHOD  Click( nMRow, nMCol ),;
            Close(),;
            Flash( cVPTgt ),;
            lIsOver( nMRow, nMCol ),;
            KeyPressed( nKey ),;
            Organize( oMenuOwner, nWidth ),;
            Adjust( nRect ),;
            SetFocus( lOnOff ),;
            SetSysMenu( oSysItem )

    // El m‚todo Add() de Menu debe devolver siempre el item a¤adido...
    METHOD Add( oItem )         INLINE  oItem:lMenuBar := .t. , ;
                                        Super:Add( oItem )    , ;
                                        oItem:lFocussed := .f., ;
                                        oItem
    METHOD Open()               INLINE ::lOpen := .t.
    METHOD SetAction( bAction ) INLINE if( pCount() > 1, ;
                                    ::oFocussed:Close( ::bAction := bAction ), )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, cColors )

    DEFAULT nWidth  := 80,;
            nHeight := 1

    ::aShortCut := {}

return Super:New( nTop, nLeft, nWidth, nHeight, cColors, oWnd )

//---------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol )

    local n, b, lChange := ! ::oWnd:lMinimized
    local oFocussed := ::oFocussed

    ::lOpen := .t.

    nMRow -= ::nTop()  // de coordenadas padre a coordenadas de view
    nMCol -= ::nLeft()

    while lMPressed()

        if oFocussed:lIsOver( nMRow, nMCol ) .and. oFocussed:lActive
           oFocussed:Click( nMRow, nMCol )
        else
           if ( ( lChange .and. !Empty( n := ::nAtOver( nMRow, nMCol ) ) ) .or. ;
                ( !lChange .and. n == 1 ) ) .and. ::aChilds[ n ]:lActive
               ::ChangeFocus( n )
               (oFocussed := ::oFocussed):Click( nMRow, nMCol )
           endif
        endif

        MUpdate()
        nMRow = ::nMRow()
        nMCol = ::nMCol()
    end

    if oFocussed:lIsOver( nMRow, nMCol )
       if oFocussed:lActive .and. oFocussed:bAction != nil
          ::SetAction( oFocussed:Action() )
       endif
    else
       oFocussed:Close()
    endif

    if IS_BLOCK( b := ::bAction )
        eval( b )
        ::bAction = nil
    endif

return nil

//---------------------------------------------------------------------------//

METHOD Close()

    ::lOpen = .f.
    ::oFocussed:Close()

return nil

//---------------------------------------------------------------------------//

METHOD Flash( cVPTgt )

    local oWnd := ::oWnd

    cVPTgt = Super:Flash( cVPTgt )
    cVPTgt = VMnBarDraw( cVPTgt, ;
                    RectWidth( ::nClipRect ), ;
                    RectHeight( ::nClipRect ), ;
                    oWnd:nStyle,;
                    if( oWnd:lFocussed, oWnd:nClrHiBox, oWnd:nClrLoBox ) % 16 + int( ::nColor / 16  ) * 16, ;
                    if( oWnd:lFocussed, oWnd:nClrHiTitle, oWnd:nClrLoTitle ), ;
                    oWnd:cTitle, ;
                    oWnd:lMaximized )

return cVPTgt

//---------------------------------------------------------------------------//

METHOD lIsOver( nMRow, nMCol )

return ( nMRow > ::nTop() .and. Super:lIsOver( nMRow, nMCol ) ) .or. ;
         !Empty( ::nAtOver( nMRow, ::nMCol() ) )

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey ) CLASS TMenuBar

   local nNewOption, nSinAlt,;
         lChange   := !::oWnd:lMinimized

   if ::lOpen .and. ::oFocussed:oSubMenu != nil
       nKey = ::oFocussed:oSubMenu:KeyPressed( nKey )
   endif

   do case
      case nKey == K_RIGHT .and. lChange
            ::GoNext( K_RIGHT )

      case nKey == K_LEFT .and. lChange
            ::GoPrevius( K_LEFT )

      case nKey == K_UP .and. lChange
            ::GoPrevius( K_UP )

      case nKey == K_DOWN 
            ::oFocussed:Open()
            if ::oFocussed:lOpened
               ::lOpen := .t.
            elseif lChange
               ::GoNext( K_DOWN )
            endif

      case nKey == K_ENTER .or. nKey  == K_SPACE
            ::oFocussed:Open()
            if ::oFocussed:lOpened
               ::lOpen := .t.
            else
               ::SetAction( ::oFocussed:Action() )
               ::lOpen = .f.
            endif

      case !::lOpen .and. !Empty( nNewOption := ascan( ::aShortCut, nKey ) )
              ::SetAction( ::aShortCut[ nNewOption +  1 ] )
              ::lOpen = .f.

      case nKey == K_HOME
           ::ChangeFocus( 1 )

      case nKey == K_ESC
            ::Close()
            ::oWindow:ChangeFocus( ::oWindow:oClient )

      case nKey == K_END .and. lChange
            ::ChangeFocus( len( ::aChilds ) )

      case lAltChr( nKey, @nSinAlt ) .and. lChange
            nNewOption = ::nHotAt( nSinAlt )
            if nNewOption > 0
                ::oWnd:ChangeFocus( Self )
                ::ChangeFocus( nNewOption )
                ::oFocussed:Open()
                if ::oFocussed:lOpened
                   ::lOpen = .t.
                else
                   ::SetAction( ::oFocussed:Action() )
                   ::lOpen = .f.
                endif
            else
                return nKey // No procesamos la tecla podr¡a ser una hot
                            // de un control del Client.
            endif

      otherwise

            if lChange .and. ( nNewOption := ::nHotAt( nUpperKey( nKey ) ) ) > 0
                ::ChangeFocus( nNewOption )
                ::oFocussed:Open()
                if ::oFocussed:lOpened
                   ::lOpen = .t.
                else
                   ::SetAction( ::oFocussed:Action() )
                   ::lOpen = .f.
                endif
            else
                return nKey
            endif
   endcase

   if IS_BLOCK( ::bAction )
      eval( ::bAction )
      ::bAction = nil
   endif

return 0

//---------------------------------------------------------------------------//

METHOD Organize( oWnd, nWidth )

    local aChilds:= ::aChilds, oItem, nRow := 1 , nCol := 1, n
    local nFirst := if( ::lSysMenu, 2, 1 )

    ::oWnd = oWnd

    // ::BeginPaint()

    VClear( ::cVPort, ::cChar, ::nColor )
    ::lPainted = .f.

    for n = nFirst to Len( aChilds )
        oItem = aChilds[ n ]
        if n > nFirst .and. nCol + oItem:nWidth() - 1 >= nWidth // No Cabe
           nCol = 1
           nRow++
        endif
        oItem:SetPos( nRow, nCol )
        nCol += oItem:nWidth()
        oItem:lOpened = .f.
       //  oItem:Flash( ::cVPort )
    next

    if oItem != nil
        ::nClipRect = NewRect( 0, 0, nWidth + 2, oItem:nBottom() + 1 )
    else
        ::nClipRect = NewRect( 0, 0, nWidth + 2, 1 )
    endif

    // ::nPaintCount--

return nil

//---------------------------------------------------------------------------//

METHOD Adjust( nRect )

    local aChilds:= ::aChilds, oItem, nRow := 1 , nCol := 1, n
    local nFirst := if( ::lSysMenu, 2, 1 )
    local nWidth := RectWidth( nRect ) - 2

    // ::BeginPaint()

    VClear( ::cVPort, ::cChar, ::nColor )
    ::lPainted = .f.

    for n = nFirst to Len( aChilds )
        oItem = aChilds[ n ]
        if n > nFirst .and. nCol + oItem:nWidth() - 1 >= nWidth // No Cabe
           nCol = 1
           nRow++
        endif
        oItem:SetPos( nRow, nCol )
        nCol += oItem:nWidth()
        oItem:lOpened = .f.
       //  oItem:Flash( ::cVPort )
    next

    if oItem != nil
        ::nClipRect = NewRect( 0, 0, nWidth + 2, oItem:nBottom() + 1 )
    else
        ::nClipRect = NewRect( 0, 0, nWidth + 2, 1 )
    endif

    nRect := NewRect( RectHeight( ::nClipRect ),;
                      0,;
                      RectWidth( nRect ),;
                      RectHeight( nRect ) - ( RectHeight( ::nClipRect ) - 1 ) )
    // ::nPaintCount--

return nRect


//---------------------------------------------------------------------------//

METHOD SetFocus( lOnOff )

    if lOnOff
        if ::oWnd:lMinimized
            ::ChangeFocus( 1 )
        endif
    else
        ::Close()
    endif

    Super:SetFocus( lOnOff )

return nil

//---------------------------------------------------------------------------//

METHOD SetSysMenu( oSysItem )

    local n, nLen, oSubItem, aChilds := ::aChilds

    if ! ::lSysMenu
        ::lSysMenu = .t.
        aSize( aChilds, len( aChilds ) + 1 )
        aIns( aChilds, 1 )
        if ::oFocussed == nil
            ::oFocussed = oSysItem
        endif
        ::nFocussed++
    endif
    aChilds[ 1 ]      = oSysItem
    oSysItem:lMenuBar = .t.
    oSysItem:SetPos( 0, 0 )
    oSysItem:lOpened = .f.
    oSysItem:oWnd    = Self
    ::lOrganized     = .f.

    nLen = len( oSysItem:oSubMenu:aChilds )

    for n = 1 to nLen
        oSubItem = oSysItem:oSubMenu:aChilds[ n ]
        if !Empty( oSubItem:nShortCut )
            aadd( ::aShortCut, oSubItem:nShortCut )
            aadd( ::aShortCut, oSubItem:bAction   )
        endif
    next

return nil

//---------------------------------------------------------------------------//
