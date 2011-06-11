#include "FiveDos.ch"
#include "SysColor.ch"

//----------------------------------------------------------------------------//

CLASS TButton FROM TControl

   DATA   lPressed                AS Logical
   DATA   cVBack
   DATA   cBmp, cBmpChars,;
          cBmp2, cBmpChars2,;
          cText, cText2           AS CHARACTER

   DATA   bAction, bWhilePressed  AS Block INIT bNil()

   DATA   nMouseCursor INIT IDC_HAND  // Overload previus init value

   METHOD ChangeSize( nWidth, nHeight ) INLINE ;
                      Super:ChangeSize( max( nWidth, 3 ), max( nHeight, 2 ) ),;
                      ::oLabel:oWnd := nil,;
                      ::oLabel:ChangeSize( ::nWidth-1, ::nHeight-1 ),;
                      ::oLabel:oWnd := Self,;
                      ::cVBack      := nil,;
                      ::lPainted    := .f.

   METHOD EraseBackGround( cChar, nColor ) INLINE ::cVBack      := nil,;
                                        Super:EraseBackGround( cChar, nColor )

   METHOD Destroy() INLINE if( !Empty( ::cBmp ), ;
                                ReleaseChars( ::cBmp ), ),;
                           if( !Empty( ::cBmp2 ), ;
                                ReleaseChars( ::cBmp2 ), )

   METHOD lIsOver( nMRow, nMCol )

   METHOD   Click( nRow, nCol  ),;
            DragOver(),;
            KeyPressed( nKey ),;
            New( nRow, nCol, cText, cColor, nWidth, nHeight, oWnd, ;
                 bAction, cMessage, cBmp, cBmp2, bWhilePressed, bWhen, bValid, lUpdate ),;
            ReDefine( cText, cMsg, cColor, nHelpId, bAction, cBmp, bWhilePressed, lUpdate ),;
            Refresh()

   METHOD SetColors( cColor )  INLINE ::oLabel:aColors := aSetColors( cColor )

   METHOD SetFocus( lOnOff ) INLINE if( ::cVBack == nil,;
                                        ( ::BeginPaint(),;
                                          Super:SetFocus( lOnOff ),;
                                          ::Refresh(),;
                                          ::EndPaint() ;
                                        ),;
                                        Super:SetFocus( lOnOff ) )

   METHOD SetDesign( lDesign ) INLINE ::lDesign := lDesign,;
                                      ::ChangeSize( ::nWidth, ::nHeight )
   METHOD SetPos( nRow, nCol ) INLINE Super:SetPos( nRow, nCol ),;
                                      if( ::cVBack != nil,;
                                          VSetPos( ::cVBack, nRow, nCol ), )
   METHOD SetText( cText )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cText, cColor, nWidth, nHeight, oWnd, ;
            bAction, cMessage, cBmp, cBmp2, bWhilePressed, bWhen,;
            bValid, lUpdate )

    DEFAULT nHeight := 1                 ,;
            nWidth  := nLabelLen( cText )

    BYNAME bAction       IFNONIL
    BYNAME bWhilePressed IFNONIL
    BYNAME cBmp          DEFAULT ""

    DEFAULT cBmp2 := ::cBmp

    ::cBmp2 := cBmp2

    ::cBmpChars := cBmp := If( !Empty( cBmp ) .and. File( cBmp ),;
                                ReadBitmap( cBmp ) + " " , "" )

    ::cBmpChars2 := cBmp2 := If( !Empty( cBmp2 ) .and. File( cBmp2 ),;
                                ReadBitmap( cBmp2 ) + " " , "" )

    ::cText  := cBmp + cText
    ::cText2 := cBmp2 + cText
    Super:New( nRow, nCol, nWidth + 1, nHeight + 1, cColor, , oWnd, ;
               cMessage, ::cText, bWhen, bValid, aSetColors( cColor ) )

    ::oLabel:nJustify = 0
    ::oLabel:oWnd = nil
    ::oLabel:ChangeSize( nWidth, nHeight )
    ::oLabel:oWnd = Self
    ::lUpdate := lUpdate

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( cText, cMessage, cColor, nHelpId, bAction, cBmp, cBmp2,;
                 bWhilePressed, bWhen, bValid, lUpdate )

    local n

    BYNAME bAction, bWhilePressed INIT BLOCK
    BYNAME cBmp                   INIT CHARACTER
    BYNAME cBmp2                  DEFAULT cBmp
//    BYNAME nHelpId                INIT NUMERIC

    if IS_CHARACTER( cText )
       ::oLabel:SetText( ::cBmp + cText )
    endif

    if IS_CHARACTER( cMessage )
       ::oLabel:cMessage = cMessage
    endif

    if !IS_NIL( cColor )
       ::SetColors( cColor )
    endif

    if !IS_NIL( cBmp )
       ::cBmpChars = If( File( cBmp ), ReadBitmap( cBmp ) + " " , "" )
    endif

    if !IS_NIL( cBmp2 )
       ::cBmpChars2 = If( File( cBmp2 ), ReadBitmap( cBmp2 ) + " " , "" )
    endif
    ::lUpdate := lUpdate

return Self

//---------------------------------------------------------------------------//

METHOD lIsOver( nMRow, nMCol )
return if( ::lDesign,;
            Super:lIsOver( nMRow, nMCol ),;
            ::oLabel:lIsOver( ::nMRow(), ::nMCol() ) )

//----------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol ) CLASS TButton

    local oLabel := ::oLabel

    if ::lDesign .or. lMRight()
       return Super:Click( nMRow, nMCol )
    endif

    while lMPressed()

        MUpdate()
        nMRow = ::nMRow()
        nMCol = ::nMCol()

        if !::lPressed
            if oLabel:lIsOver( nMRow, nMCol )
                ::lPressed := .t.
                ::Refresh()
            endif
        else
            if !oLabel:lIsOver( nMRow, if( nMCol == 0, 1, nMCol ) )
                ::lPressed := .f.
                ::Refresh()
            endif

            if lMPressed()
                eval( ::bWhilePressed )
            endif
        endif

    end

    if ::lPressed
        ::lPressed = .f.
        ::Refresh()
        if oLabel:lIsOver( nMRow, nMCol )
            eval( ::bAction )
        endif
    endif

return nil

//---------------------------------------------------------------------------//

METHOD DragOver()
     Super:DragOver()
     ::cVBack   = nil
     ::lPainted = .f.
     ::oWnd:Clear()
return nil

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    if nKey == K_SPACE .or. nKey == K_RETURN .or. ::IsHotKey( nUpperKey( nKey ) )

        ::lPressed = .t.
        ::Refresh()

        while( lAnyKeyPressed() )
            eval( ::bWhilePressed )
        end

        // Limpia el buffer de teclado.
        while Inkey() > 0
        end
    /***
        nKey = set( _SET_TYPEAHEAD, 0 )
        set( _SET_TYPEAHEAD, nKey )
    ***/
        ::lPressed = .f.
        ::Refresh()
        eval( ::bAction )

        return 0
    endif

return Super:KeyPressed( nKey )

//----------------------------------------------------------------------------//

METHOD Refresh()

    if IS_NIL( ::cVBack )
        ::cVBack = GetScreen( ::oWnd:cVPort, ::cVPort )
    endif

    ::BeginPaint()
    CopyPort( ::cVPort, ::cVBack )
    ::oLabel:SetPos( 0, if( ::lPressed, 1, 0 ) )
    ::oLabel:SetText( if( ::lPressed, ::cText2, ::cText ) )
    // no hace falta, settex lo obliga    Super:Refresh()  // Visualiza el Label
    if ! ::lPressed
        VBtnShadow( ::cVPort )
    endif
    ::EndPaint()

return nil

METHOD SetText( cText )

    if IS_CHARACTER( cText  )
        BYNAME cText
    else
        ::cText := cText := ""
    endif

    ::cText  := ::cBmp + cText
    ::cText2 := ::cBmp2 + cText
    ::oLabel:SetText( ::cText )
return nil

//---------------------------------------------------------------------------//

static function aSetColors( cColor )

    local n, aColors := array( 4 ), aSysClr := aSysColor()

    aColors[ CLRLBL_NORMAL ]    = if( Empty( n := nStrColor( cColor, 1 ) ), ;
                                      aSysClr[ CLR_PUSHBUTTON ], n )
    aColors[ CLRLBL_HILITE ]    = if( Empty( n := nStrColor( cColor, 2 ) ), ;
                                      aSysClr[ CLR_PUSHBUTTON_HI ], n )
    aColors[ CLRLBL_HOTKEY ]    = if( Empty( n := nStrColor( cColor, 3 ) ), ;
                                      aSysClr[ CLR_PUSHBUTTONHOT ], n )
    aColors[ CLRLBL_HOTKEY_HI ] = if( Empty( n := nStrColor( cColor, 4 ) ), ;
                                      aSysClr[ CLR_PUSHBUTTONHOT_HI ], n )
return aColors

//---------------------------------------------------------------------------//
