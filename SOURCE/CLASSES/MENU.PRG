#include "FiveDos.ch"
#include "SysColor.ch"

//---------------------------------------------------------------------------//

CLASS TMenu FROM TView

    DATA lOrganized, lOpen              AS Logical
    DATA aColors                        AS Array
    DATA oParent, oWindow

    METHOD New( nTop, nLeft, nWidth, nHeight, cColors, oWnd ) CONSTRUCTOR

    METHOD  Add( oItem ),;
            ChangeFocus( nItem ),;
            Click( nMRow, nMCol ),;
            GetNext(),;
            GetPrevius(),;
            KeyPressed( nKey ),;
            lIsOver( nMRow, nMCol ),;
            nHotAt( nHotKey ),;
            SetWindow( oWindow ),;
            Organize()


    METHOD Close()              INLINE ::lOpen := .f.
    METHOD Open()               INLINE ::lOpen := .t.
    METHOD SetColors( cColor )  INLINE ::aColors := aSetColors( cColor )
    METHOD SetAction( bAction ) INLINE ::oWindow:oMenu:SetAction( bAction )

    DELEGATE MESSAGE SetMessage( cMsg ) TO oWindow

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cColor, oWnd )

    ::SetColors( cColor )

    Super:New( nTop, nLeft, nWidth, nHeight, cColor,, oWnd )

    ::nColor = ::aColors[ 1 ]

return Self

//---------------------------------------------------------------------------//

METHOD Add( oItem )

    if empty( ::aChilds )
       ::nFocussed     = 1
       ::oFocussed     = oItem
       oItem:lFocussed = .t.
    endif
    
    oItem:oWnd    = Self
    oItem:aColors = ::aColors
    oItem:nColor  = ::aColors[ 1 ] // Para Borrar el fondo del menuitem
    AAdd( ::aChilds, oItem )
    ::lOrganized  = .f.

return oItem  // OJO: Clausula MENUITEM

//---------------------------------------------------------------------------//

METHOD ChangeFocus( nCtrl )

    local oFocussed

    if !Empty( nCtrl ) .and. !( ::nFocussed == nCtrl )
        ::BeginPaint()
        if ( oFocussed := ::oFocussed ) != nil
            oFocussed:Close()
            oFocussed:SetFocus( .f. )
        endif
        (::oFocussed := oFocussed := ::aChilds[::nFocussed := nCtrl]):SetFocus( .t. )
        if ::lOpen
            oFocussed:Open()
        endif
        ::EndPaint()

    endif

return nil

//---------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol )

    local n, oFocussed

    nMRow -= ::nTop()  // de coordenadas padre a coordenadas de view
    nMCol -= ::nLeft()

    ::lOpen = .t.

    while lMPressed() .and. ::lIsOver( nMRow(), nMCol() )

          // Sobre Cual Hijo est  el raton
        if !Empty( n := ::nAtOver( nMRow, nMCol ) ) .and. ::aChilds[ n ]:lActive
            ::ChangeFocus( n )
            ::oFocussed:Click( nMRow, nMCol )
        endif
        MUpdate()
        nMRow = ::nMRow()
        nMCol = ::nMCol()
    end

    if ( oFocussed := ::oFocussed):lIsOver( nMRow, nMCol )
        if oFocussed:lActive .and. oFocussed:oSubmenu == nil
           ::SetAction( oFocussed:bAction )
        endif
    else
        ::lOpen = oFocussed:lOpened
    endif

return nil

//---------------------------------------------------------------------------//

METHOD GetNext()

    local nNext    := ::nFocussed
    local aChilds  := ::aChilds
    local nInitial := nNext

    if !Empty( nNext )
        DO
           nNext = If( nNext == Len( aChilds ), 1, nNext + 1 )
        UNTIL nInitial == nNext .or. aChilds[ nNext ]:lActive
    endif

return nNext

//---------------------------------------------------------------------------//

METHOD GetPrevius()

    local nNext    := ::nFocussed
    local aChilds  := ::aChilds
    local nInitial := nNext

    DO
        nNext = If( nNext == 1, Len( aChilds ), nNext - 1 )
    UNTIL nInitial == nNext .or. aChilds[ nNext ]:lActive

return nNext

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    local nNewOption

    if ::lOpen .and. ::oFocussed:oSubMenu != nil
        nKey = ::oFocussed:oSubMenu:KeyPressed( nKey )
    endif

    do case
        case nKey == K_UP
            ::GoPrevius( K_UP )

        case nKey == K_DOWN
            ::GoNext( K_DOWN )

        case nKey == K_RIGHT 
            if !::lOpen
               ::oFocussed:Open()
               if ::oFocussed:lOpened
                  ::lOpen := .t.
                  return 0
               else
                  return nKey
               endif
            else
               return nKey
            endif

        case nKey == K_ENTER .or. nKey  == K_SPACE

            if !::lOpen .and. ::oFocussed:lOpened( ::oFocussed:Open() )
                  ::lOpen = .t.
                  return 0
            else
               ::SetAction( ::oFocussed:Action() )
               ::oParent:Close()
            endif
            return K_ESC

        case nKey == K_ESC
            ::oParent:Close()
            return K_ESC

        case nKey == K_HOME
            ::ChangeFocus( 1 )

        case nKey == K_END
            ::ChangeFocus( Len( ::aChilds ) )

        otherwise

            if ( nNewOption := ::nHotAt( nUpperKey( nKey ) ) ) > 0
                ::ChangeFocus( nNewOption )
                ::oFocussed:Open()
                if ::oFocussed:lOpened
                    ::lOpen := .t.
                else
                    ::SetAction( ::oFocussed:Action() )
                    ::oParent:Close()
                    return K_ESC
                endif
            else
                return nKey
            endif

    endcase

return 0

//---------------------------------------------------------------------------//

METHOD lIsOver( nMRow, nMCol )
return Super:lIsOver( nMRow, nMCol ) .or. ::oFocussed:lIsOver( ::nMRow(), ::nMCol() )

//---------------------------------------------------------------------------//

METHOD nHotAt( nHotKey )
return AScan( ::aChilds, { | oItem | oItem:nHotKey == nHotKey .and. oItem:lActive } )

//---------------------------------------------------------------------------//

METHOD Organize()

    local i, oItem, nRow := 0 , nCol := 1, nWidth := 0

    if ! ::lOrganized

        aeval( ::aChilds, { | o | nWidth := max( nWidth, o:nWidth() + 1 ) } )
        ::ChangeSize( nWidth, len( ::aChilds ) )
        aeval( ::aChilds, { | o, i | o:ChangeSize( nWidth, 1 ), ;
                                     o:SetPos( i - 1, 0 ), ;
                                     o:Paint( ::cVPort ) } )
        ::lOrganized := .t.

    endif

return nil

//---------------------------------------------------------------------------//

METHOD SetWindow( oWindow )

    ::oWindow = oWindow

    aEval( ::aChilds, { |o,i| if( ( i := o:oSubMenu ) != nil, i:SetWindow( oWindow ), ) } )

return nil

//---------------------------------------------------------------------------//

static function aSetColors( cColor )

    local n, i,;
          aColors := Array( 7 ),;
          aSysClr := aSysColor()

    for i = 1 to 7
        aColors[ i ] = if( Empty( n := nStrColor( cColor, i ) ),;
                           aSysClr[ CLR_MENU + i - 1 ], n )
    next

return aColors

//---------------------------------------------------------------------------//
