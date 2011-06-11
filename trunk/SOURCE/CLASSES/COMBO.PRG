#include "FiveDos.ch"
#include "FontDef.h"
#include "SysColor.ch"
#include "redefine.ch"

#define OPEN_LOCK    Chr( MAXIMIZELEFT ) + Chr( MAXIMIZERIGHT )
#define DOWN_ARROW   Chr( MINIMIZELEFT ) + Chr( MINIMIZERIGHT )

//---------------------------------------------------------------------------//

CLASS TComboBox FROM TGet

    DATA oList                 AS Object
    DATA lOpen                 AS Logical
    DATA nOption, nClrArrow    AS Numeric
    DATA bChanged              AS Block   INIT bNil()

    METHOD Click( nMRow, nMCol, lDblClick )

    METHOD Close()

	METHOD KeyPressed( nKey )

    METHOD New( nRow, nCol, nWidth, nHeight, bSetGet, acItems, cLabel, cMessage,;
                cColor, cPicture, oWnd, bWhen, bValid, lEdit, lUpdate )

    METHOD Open()

    METHOD ReDefine( cMessage, cColor, nHelpId, bSetGet, acItems, cLabel, cPicture,;
                     bWhen, bValid, bChanged, lUpdate )

    METHOD Refresh() INLINE ;
            ::BeginPaint(),;
            Super:Refresh(),;
            ::Say( 0, ::nWidth -2, if( ::lOpen, OPEN_LOCK, DOWN_ARROW ), ::nClrArrow ),;
            if( ::lOpen, ::oList:Refresh(), ),;
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
                                     if( ::oList != nil, ::oList:SetFocus( lOnOff ),),;
                                     if( !lOnOff, ::Close(), ),;
                                     ::EndPaint()

ENDCLASS

//---------------------------------------------------------------------------//
METHOD New( nRow, nCol, nWidth, nHeight, bSetGet, acItems, cLabel, cMessage,;
            cColor, cPicture, oWnd, bWhen, bValid, bChanged, lEdit, lUpdate )

    local nLen := 0

    DEFAULT lEdit   := .t.,;
            nHeight := Max( 1, Len( acItems ) )

    if Empty( eval( bSetGet ) )
       aEval( acItems, { |e| nLen := max( nLen, len( e ) ) } )
       eval( bSetGet, space( nLen ) )
    endif
    
    BYNAME bChanged INIT BLOCK

    ::SetColors( cColor )

    Super:New( nRow, nCol, bSetGet, ::nColor, cLabel, cMessage, cPicture,;
               oWnd, bWhen, bValid,,, lEdit )
    ::ChangeSize( ::nWidth + 3, nHeight  )

    ::nOption = 1

    @ 1, 1 LISTBOX ::oList VAR ::nOption ARRAY acItems ;
           SIZE ::nWidth - 1, nHeight
    ::oList:oWnd = Self
    ::oList:bSelect:= {|| ::BeginPaint(),;
                          ::oGet:VarPut ( pad( ::oList:acItems[ ::nOption ] ,;
                                          len( ::oGet:Buffer ) ) ),;
                          ::oGet:Reset(),;
                          ::oGet:Home(),;
                          ::Close(),;
                          ::EndPaint()}

    ::ChangeSize( ::nWidth, nHeight + 1 )
    ::nClipRect  = NewRect( ::nTop, ::nLeft, ::nWidth , 1 )
    ::lOpen      = .f.

    ::lUpdate := lUpdate

return Self

//---------------------------------------------------------------------------//

METHOD ReDefine( cMessage, cColor, nHelpId, bSetGet, acItems, cLabel, cPicture,;
                 bWhen, bValid, bChanged, lUpdate )

*   BYNAME nHelpId                    INIT NUMERIC
    BYNAME bWhen, bValid, bChanged    INIT BLOCK
    BYNAME cPicture                   INIT CHARACTER

    if !Empty( cColor )
       ::SetColors( cColor )
    endif

    if !IS_NIL( cLabel )
       ::oLabel:SetText( cLabel )
    endif

    if IS_CHARACTER( cMessage )
       ::oLabel:cMessage = cMessage
    endif

    ::nOption = 1

    ::oList:ReDefine( ,,,;
         { | uVal | If( Empty( PCount() ), ::nOption, ::nOption := uVal ) },;
         acItems,,,,, {|| ( ::cText := pad( ::oList:acItems[ ::nOption ],;
                                           len( ::cText ) ),;
                           ::Close() ) } )
/*
    REDEFINE LISTBOX ::oList VAR ::nOption ARRAY acItems OF Self ID ::oList
                     ON DBLCLICK ( ::cText := pad( ::oList:acItems[ ::nOption ],;
                                                   len( ::cText ) ),;
                                   ::Close() )
*/
    ::lUpdate := lUpdate

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
    elseif ::lOpen .and. ::oList:lIsOver( nMRow, nMCol )
        ::oList:Click( nMRow, nMCol, lDblClick )
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
            nKey := ::oList:Keypressed( nKey )
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
