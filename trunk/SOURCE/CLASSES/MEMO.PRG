// -------------------------------------------------------------------------- //
// TMemo Class for FiveDos
// -------------------------------------------------------------------------- //

#include "FiveDos.ch"
#include "SysColor.ch"

// -------------------------------------------------------------------------- //
CLASS TMemo FROM TListBox

    DATA    nPos AS NUMERIC

    METHOD  New( nRow, nCol, nWidth, nHeight, bSetGet, cLabel;
                 cMessage, cColor, oWnd, bWhen, bValid, bChanged, ;
                 bSelect, lUpdate ) CONSTRUCTOR

    METHOD Refresh(), ;
        Changed(), ;
        DelChar(), ;
        BSChar(), ;
        Click( nMRow, nMCol, lDblClick  ), ;
        GoLeft(), ;
        GoRight(), ;
        InsertChar( nKey ), ;
        KeyPressed( nKey ), ;
        UpdateCursor(), ;
        SetFocus( lOnOff ), ;
        SplitLine(), ;
        DelLine(), ;
        AdjustLine()

    METHOD Hilite() INLINE ( Super:Hilite(), ::UpdateCursor() )

    METHOD cText( uVal ) SETGET

ENDCLASS

// -------------------------------------------------------------------------- //
METHOD TMemo::New( nRow, nCol, nWidth, nHeight, bSetGet, cLabel, cMessage, cColor, ;
             oWnd, bWhen, bValid, bChanged, bSelect, lUpdate )

    // Convert a Memo type to a array of strings
    ::acItems := Memo2aStr( Eval( bSetGet ), nWidth - 3 )

    // If the Memo is empty
    If Len( ::acItems ) == 0
        ::acItems := { "" }
    EndIf

    Super:New( nRow, nCol, nWidth, nHeight, bSetGet, ::acItems, cLabel, ;
               cMessage, cColor, oWnd, bWhen, bValid, ;
               bChanged, bSelect )
    ::lUpdate := lUpdate

    ::nPos    := 1

Return Self

// -------------------------------------------------------------------------- //
METHOD TMemo::Changed()
    // No llama a ::Super:Changed() para no asignar ::nOption a ::bSetGet
    Eval( ::bChanged )
Return NIL

// -------------------------------------------------------------------------- //
METHOD TMemo::Click( nMRow, nMCol, lDblClick  )
    Super:Click( nMRow, nMCol, lDblClick )
    nMCol := ::nMCol() - ::nLeft() + 2
    nMRow := ::nMRow() - ::nTop
    If nMRow >= 0 .And. nMRow < ::nHeight - ::nLabel .And. ;
       nMCol >= 0 .And. nMCol <= ::nWidth - 2
        ::nPos := nMCol
        ::Hilite()
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
METHOD TMemo::KeyPressed( nKey )

    If ::lDesign
        Return Super:KeyPressed( nKey )
    EndIf

    Do Case

        Case nKey == K_ENTER
            If Set( _SET_INSERT )
                ::SplitLine( ::nPos, ::nOption )
            EndIf
            ::GoDown()
            ::nPos := 1
            ::HiLite()

        Case nKey == K_DOWN
            ::GoDown()

        Case nKey == K_UP
            ::GoUp()

        Case nKey == K_PGUP
            ::GoPgUp()

        Case nKey == K_PGDN
            ::GoPgDown()

        Case nKey == K_DEL
            ::DelChar()

        Case nKey == K_BS
            ::BsChar()

        Case nKey == K_LEFT
            ::GoLeft()

        Case nKey == K_RIGHT
            ::GoRight()

        Case nKey == K_INS
            Set( _SET_INSERT, !Set( _SET_INSERT ) )
            ::SetCursor( If( Set( _SET_INSERT ), 2, 1 ) )
            ::UpdateOwner()

        Case nKey == K_CTRL_PGDN
            ::GoBottom()

        Case nKey == K_CTRL_PGUP
            ::GoTop()

        Case nKey == K_END
            If ::nPos <> Len( Trim( ::acItems[ ::nOption ] ) ) + 1
                ::nPos := Len( Trim( ::acItems[ ::nOption ] ) ) + 1
                ::UpdateCursor()
            EndIf

        Case nKey == K_HOME
            If ::nPos <> 1
                ::nPos := 1
                ::UpdateCursor()
            EndIf

        Case nKey == K_CTRL_HOME
            ::DeHilite()
            ::nOption := ::nFirst
            ::HiLite()

        Case nKey == K_CTRL_END
            ::DeHilite()
            ::nOption := ::nFirst + ::nHeight - 2
            ::HiLite()

        Case nKey == K_CTRL_Y
            ::DelLine()

        OtherWise
            If nKey > 31 .And. nKey < 256
                ::InsertChar( nKey )
            Else
                Return nKey
            EndIf
   EndCase

Return 0

// -------------------------------------------------------------------------- //
METHOD TMemo::GoLeft()
    If ::nPos > 1
        ::nPos--
        ::Hilite()
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
METHOD TMemo::GoRight()
    If ::nPos < ::nWidth - 2
        ::nPos++
        ::Hilite()
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
METHOD TMemo::Refresh()
    Super:Refresh()
    ::UpdateCursor()
Return NIL

// -------------------------------------------------------------------------- //
METHOD TMemo::DelChar()

    local acItems := ::acItems, nOption := ::nOption

    If ::nPos > Len( TRim( acItems[ nOption ] ) )
        acItems[ nOption ] := PadR( RTrim( acItems[ nOption ] ), ::nPos - 1 ) + ;
                                  if( nOption < len( acItems ), RTrim( acItems[ nOption + 1 ] ), "" )
        ::DispBegin()
        ::GoDown()
        ::DelLine()
        ::GoUp()
        ::Hilite()
        ::DispEnd()
    Else
        acItems[ nOption ] := Stuff( acItems[ ::nOption ], ::nPos, 1, '' )
        ::HiLite()
    EndIf
    ::AdjustLine()
Return NIL

// -------------------------------------------------------------------------- //
METHOD TMemo::BSChar()
    Local nNewPos
    If ::nPos > 1
        ::acItems[ ::nOption ] := SubStr( ::acItems[ ::nOption ], 1, ::nPos - 2 ) + ;
            SubStr( ::acItems[ ::nOption ], ::nPos, Len( Alltrim( ::acItems[ ::nOption ] ) ) )
        ::GoLeft()
        ::Hilite()
    Else
        If ::nOption > 1
            nNewPos := Len( RTrim( ::acItems[ ::nOption - 1 ] ) ) + 1
            ::acItems[ ::nOption - 1 ] := RTrim( ::acItems[ ::nOption - 1 ] ) + RTrim( ::acItems[ ::nOption ] )
            ::DelLine()
            ::GoUp()
            ::nPos := nNewPos
            ::Hilite()
        EndIf
    EndIf
    ::AdjustLine()
Return NIL

// -------------------------------------------------------------------------- //
METHOD TMemo::InsertChar( nKey )
    ::acItems[ ::nOption ] := Stuff( ::acItems[ ::nOption ], ::nPos , ;
              If( ReadInsert() , 0, 1 ), Chr( nKey ) )
    ::nPos++
    ::AdjustLine()
Return NIL

// -------------------------------------------------------------------------- //
METHOD TMemo::AdjustLine()
    Local N, nDesp
    If Len( Trim( ::acItems[ ::nOption ] ) ) > ::nWidth - 2
        N := ::nWidth - 2
        While N > 0
            If SubStr( ::acItems[ ::nOption ], N, 1 ) = ' '
                Exit
            End
            N--
        End
        nDesp := Len( RTrim( ::acItems[ ::nOption ] ) ) - N
        If N > 0
            ::SplitLine( N, ::nOption )
        Else
            ::SplitLine( ::nPos, ::nOption )
        End
        If ::nPos > ::nWidth - 2
            ::Dehilite()
            ::GoDown()
            ::nPos := nDesp + 1
        End
        ::oScrBar:nRange := Len( ::acItems )
        ::oScrBar:SetOption( ::nOption )
    End
    ::Hilite()
Return NIL

// -------------------------------------------------------------------------- //
METHOD TMemo::SplitLine( nPos, nLine )
    Local N, nLen, cCar
    cCar := AllTrim( SubStr( ::acItems[ nLine ], nPos, 2000 ) ) // lo que quede
    ::acItems[ nLine] := SubStr( ::acItems[ nLine ], 1, nPos - 1 )
    aAdd( ::acItems, "" )
    aAdd( ::aSelected, .F. )
    aIns( ::acItems , nLine + 1 )
    ::acItems[ nLine + 1 ] := cCar
    ::oScrBar:SetRange( Len( ::acItems ) )
    ::Refresh()
Return NIL

// -------------------------------------------------------------------------- //
METHOD TMemo::UpdateCursor()
    If ::lFocussed
        ::SetCursor( If( Set( _SET_INSERT ), 2, 1 ) ) // Fuerza el cursor
        SetPos( ::nOrgTop() + ::nOption - ::nFirst + ::nLabel , ;
                ::nOrgLeft() + ::nPos - 1 )
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
METHOD TMemo::SetFocus( lOnOff )
    If !lOnOff
        // Actualizamos el ::bSetGet cuando perdemos focus...
        Eval( ::bSetGet, aStr2Memo( ::acItems ) ) // Convert a array of string
                                                  // to a Memo type
        ::SetCursor( 0 )
        SetCursor( 0 )
    End
Return Super:Setfocus( lOnOff )

// -------------------------------------------------------------------------- //
METHOD TMemo::DelLine()
    Local nLen := Len( ::acItems )
    If nLen > 1
        ::acItems := aDel( ::acItems, ::nOption )
        ::acItems := aSize( ::acItems, nLen - 1 )
        If ::nOption > nLen - 1
            ::nOption --
        End
        ::oScrBar:nRange := nLen - 1
        ::oScrBar:SetOption( ::nOption )
    Else
        ::acItems := { "" }
    EndIf
    ::Clear()
Return NIL

// -------------------------------------------------------------------------- //
METHOD TMemo::cText( uVal )
    If Empty( PCount() )
        uVal := aStr2Memo( ::acItems )
    Else
        ::acItems := Memo2aStr( uVal, ::nWidth() - 3 )
        ::nPos := 1
        ::Reset()
        ::GoTop()
    Endif
Return uVal

// -------------------------------------------------------------------------- //
