#include "FiveDos.ch"

#define CLR_NORMAL      1
#define CLR_HILITE      2
#define CLR_HOT         3
#define CLR_HOTHILITE   4
#define CLR_DISABLE     5
#define CLR_BORDERLEFT  6
#define CLR_BORDERRIGHT 7


//---------------------------------------------------------------------------//

CLASS TMenuItem FROM TView

    DATA    nShortCut INIT 0
    DATA    aColors,    ;
            cItem,      ;
            bAction,    ;
            oSubMenu

    DATA    lActive,    ;
            lOpened,    ;
            lChecked,   ;
            lMenuBar    ; // Si el iTem es de Menubar, para posicionar el submenu.
            AS Logical

    METHOD New( nRow, nCol, cItem, cMsg, bAction, lActive, lChecked,;
                nShortCut ) CONSTRUCTOR

    METHOD  Click( nMRow, nMCol ),;
            Close(),;
            lIsOver( nMRow, nMCol ),;
            KeyPressed( nKey ),;
            Open(),;
            Refresh(),;
            SetMenu( oSubMenu )

    METHOD  Action()    INLINE  if( ::oSubMenu == nil .and. ::bAction != nil, ;
                                    ::bAction, )
    METHOD  Enable()    INLINE  ::lActive := .t., ::Refresh()
    METHOD  Disable()   INLINE  ::lActive := .f., ::Refresh()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nRow, nCol, cItem, cMsg, bAction, lActive, lChecked, ;
                 nShortCut ) CLASS TMenuItem

    DEFAULT cItem := "", cMsg := "", lActive := .t.

    ::cItem := cItem := Alltrim( cItem )

    Super:New( nRow, nCol, nLabelLen( cItem ) + if( len( cItem ) > 2, 2, 0 ), 1, ;
                31, , , cMsg )

    ::lActive   = lActive .and. !empty( cItem )
    ::nHotKey   = nGetHotKey( cItem )

    BYNAME bAction   IFNONIL
    BYNAME lChecked  IFNONIL
    BYNAME nShortCut IFNONIL

return nil

//---------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol )

    if ::oSubMenu != nil
        if ::lOpened
            ::oSubMenu:Click( nMRow(), nMCol() )
        else
            ::Open()
        endif
    endif

return nil

//---------------------------------------------------------------------------//

METHOD Close()
    local aPops, oWin
    if ::lOpened
        oWin := ::oWnd:oWindow
        aPops := oWin:aPopMenus

        oWin:BeginPaint()

        while ! aTail( aPops ) == ::oSubMenu
             aTail( aPops ):oParent:Close()
        end
        ::lOpened := .f.
        ::SetMessage( ::cMessage )
        ::oSubMenu:Hide()
        oWin:EndPaint()

    endif
return nil

//---------------------------------------------------------------------------//

METHOD lIsOver( nMRow, nMCol )
return VIsOver( ::cVPort, nMrow, nMCol ) .or. ;
              ( ::lOpened .and. ::oSubMenu:lIsOver( nMRow(), nMCol() ) )

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    if ::lOpened
       nKey := ::oSubMenu:KeyPressed( nKey )
       ::UpdateOwner()
    elseif ::oSubMenu != nil .and. ;
             ( ( nKey == K_DOWN .and. ::lMenuBar ) .or. ;
               ( nKey == K_RIGHT .and. !::lMenuBar ) )
       ::Open()
       nKey = 0
    endif

return nKey

//---------------------------------------------------------------------------//

METHOD Open()

    local nTop     , ;
          nLeft    , ;
          nOrgTop  , ;
          nOrgLeft ,;
          oSubMenu := ::oSubMenu

    if ! ::lOpened .and. oSubMenu != nil
        nOrgTop  := ::nOrgTop()
        nOrgLeft := ::nOrgLeft()

        ::lOpened = .t.

        oSubMenu:Display()
        ::SetMessage( oSubMenu:oFocussed:cMessage )

        if ::lMenuBar
            nTop  = nOrgTop  + 1
            if nTop + oSubMenu:nHeight() - 1 > ScrMaxRow()
               nTop = nOrgTop - oSubMenu:nHeight()
            endif
            nLeft = nOrgLeft - 1
            if nLeft < 0
               nLeft = 0
            elseif nLeft + oSubMenu:nWidth() - 1 > ScrMaxCol()
               nLeft = Max( 0, MaxCol() - oSubMenu:nWidth() )
            endif
        else
            nTop  = nOrgTop - 1
            if nTop + oSubMenu:nHeight() > ScrMaxRow()
               nTop = nOrgTop - oSubMenu:nHeight() + 2
            endif
            nLeft = nOrgLeft + ::nWidth()
            if nLeft < 0
               nLeft = 0
            elseif nLeft + oSubMenu:nWidth() - 1 > ScrMaxCol()
               nLeft = Max( 0, nOrgLeft - oSubMenu:nWidth() )
            endif
        endif
        oSubMenu:SetPos( nTop, nLeft )
        ::UpdateOwner()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD Refresh()
    local nColor, nClrHot
    local lFocussed := ::lFocussed

    if empty( ::cItem )
        ::Say( 0, 0, replicate( Chr( 196 ), ::nWidth ), ::aColors[ CLR_BORDERLEFT ] )
    else
        if ::lActive
            if lFocussed
                nColor  := ::aColors[ CLR_HILITE ]
                nClrHot := ::aColors[ CLR_HOTHILITE ]
            else
                nColor  := ::aColors[ CLR_NORMAL ]
                nClrHot := ::aColors[ CLR_HOT ]
            endif
        else
            nColor    := nClrHot := ::aColors[ CLR_DISABLE ]
            lFocussed := .f.
        endif

        VMnitDraw( ::cVPort, ::cItem, lFocussed, nColor, nClrHot,;
                               ::lChecked, ::oSubMenu != nil .and. !::lMenuBar,;
                               ::aColors[ CLR_BORDERLEFT ], ;
                               ::aColors[ CLR_BORDERRIGHT ] )
        ::UpdateOwner()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD SetMenu( oSubMenu ) CLASS TMenuItem

   ::oSubMenu = oSubMenu
   ::bAction  = nil
   // oSubMenu:oWnd := Self
   oSubMenu:oParent := Self
   oSubMenu:aColors := ::aColors

return nil

//----------------------------------------------------------------------------//
