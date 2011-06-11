#include "FiveDos.ch"
#include "SysColor.ch"

//---------------------------------------------------------------------------//

CLASS TSay FROM TLabel

    DATA bGetText   AS Block        INIT {|| "" }
    DATA cPicture   AS Character

    METHOD New( nTop, nLeft, bGetText, cColor, oWnd, nJustify, cPicture,;
                nWidth, nHeight, lUpdate )

    METHOD ReDefine( cColor, nHelpId, bText, cPicture, nJustify, lUpdate )
    METHOD Refresh()           INLINE ::SetText( eval( ::bGetText ) )

//    METHOD SetColors( cColor ) INLINE ::aColors := aSetColors( cColor )
    METHOD SetText( cText ) 
    METHOD SetFocus( lOnOff )  INLINE ::lFocussed := lOnOff, ::Refresh()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, bGetText, cColor, oWnd, nJustify, cPicture,;
            nWidth, nHeight, lUpdate )

    local nRect, cText, a, n

    if IS_BLOCK( bGetText )
       ::bGetText = bGetText
       cText      = if( IS_NIL( cPicture ),;
                        cValtoChar( eval( bGetText ) ),;
                        Transform( eval( bGetText ), ::cPicture := cPicture ) )
    else
       cText      = " "
    endif

    nRect = nLabelRect( cText )

    DEFAULT nWidth   := RectWidth( nRect ), ;
            nHeight  := RectHeight( nRect ),;
            nJustify := -1

return Super:New( nTop, nLeft, cText, ;
                  { a := if( Empty( n := nStrColor( cColor, 1 ) ), ;
                             if( oWnd != nil, oWnd:nColor, aSysColor( CLR_LABEL ) ), n ),;
                    if( Empty( n := nStrColor( cColor, 2 ) ), a, n ),;
                    if( Empty( n := nStrColor( cColor, 3 ) ), a, n ),;
                    if( Empty( n := nStrColor( cColor, 4 ) ), a, n ) },;
                  nWidth, nHeight, oWnd,, nJustify, lUpdate )

//---------------------------------------------------------------------------//

METHOD ReDefine( cColor, nHelpId, bGetText, cPicture, nJustify, lUpdate  )

    if !IS_NIL( cColor )
       ::SetColors( cColor )
    endif

    BYNAME cPicture INIT CHARACTER
    BYNAME nJustify INIT NUMERIC
*   BYNAME nHelpId  INIT NUMERIC

    if IS_BLOCK( bGetText )
       ::bGetText = bGetText
       ::SetText( if( IS_NIL( cPicture ),;
                      cValtoChar( eval( bGetText ) ),;
                      Transform( eval( bGetText ), ::cPicture := cPicture ) ) )
    else
       ::bGetText = { || " " }
       ::SetText()
    endif
    ::lUpdate := lUpdate

return Self

//---------------------------------------------------------------------------//

METHOD SetText( cText )             //  Posibilidad de uso en llamada a parent.

    Super:SetText( if( Empty( ::cPicture ), cText,;
                                            Transform( cText, ::cPicture ) ) )
return nil

//---------------------------------------------------------------------------//
/*
static function aSetColors( cColor, oWnd )

    local n, a, aColors := array( 4 )

    aColors[ CLRLBL_NORMAL ]:= a := if( Empty( n := nStrColor( cColor, 1 ) ), ;
                     if( oWnd != nil, oWnd:nColor, aSysColor( CLR_LABEL ) ), n )
    aColors[ CLRLBL_HILITE ]    = if( Empty( n := nStrColor( cColor, 2 ) ), a, n )
    aColors[ CLRLBL_HOTKEY ]    = if( Empty( n := nStrColor( cColor, 3 ) ), a, n )
    aColors[ CLRLBL_HOTKEY_HI ] = if( Empty( n := nStrColor( cColor, 4 ) ), a, n )

return aColors

//---------------------------------------------------------------------------//
*/
