#include "FiveDos.ch"
#include "FontDef.h"
#include "SysColor.ch"

//----------------------------------------------------------------------------//

CLASS TRadio FROM TView

   DATA   cText                               AS Character
   DATA   nClrFocus, nClrHot, nClrUnSel       AS Numeric
   DATA   lPressed                            AS Logical
   // beguin mod
   DATA   cBmpCh            AS CHARACTER
   DATA   cBmp
   DATA   cBmpCh2           AS CHARACTER
   DATA   cBmp2

   METHOD Click( nRow, nCol  )

   METHOD Destroy() INLINE ( if( !empty( ::cBmp ),;
                                ReleaseChars( ::cBmp ) , ) ,;
                             if( !empty( ::cBmp2 ), ;
                                ReleaseChars( ::cBmp2 ) , ) )

   METHOD KeyPressed( nKey )

   METHOD New( nRow, nCol, cText, cMessage, cColor, oWnd, bWhen, bValid,;
         cFile1, cFile2, lUpdate ) CONSTRUCTOR
   // end mod

   METHOD Redefine( cText, cMessage, cColor, nHelpId, bWhen, bValid, lUpdate )

   METHOD Refresh()

   METHOD SetColors( cColor, n, aSysClr ) INLINE ;  // local vars == n, aSysClr
          aSysClr     := aSysColor(),;
          ::nColor    := if( Empty( n := nStrColor( cColor, 1 ) ), ;
                             aSysClr[ CLR_RADIO ], n ),;
          ::nClrFocus := if( Empty( n := nStrColor( cColor, 2 ) ), ;
                             aSysClr[ CLR_RADIO_HI ], n ),;
          ::nClrHot   := if( Empty( n := nStrColor( cColor, 3 ) ), ;
                             aSysClr[ CLR_RADIO_HOT ], n ),;
          ::nClrUnSel := if( Empty( n := nStrColor( cColor, 4 ) ), ;
                             aSysClr[ CLR_RADIO_OFF ], n )
ENDCLASS

//----------------------------------------------------------------------------//
// begin mod
METHOD New( nRow, nCol, cText, cMessage, cColor, oWnd, bWhen, bValid ,;
         cFile, cFile2, lUpdate )

   ::cText   = if( IS_CHARACTER( cText ), cText, "" )
   ::cBmp       = cFile
   ::cBmp2      = cFile2
   ::cBmpCh := If( ! Empty( cFile ) .and. File( cFile ),;
                              ReadBitmap( cFile ), Chr( LEFTRADIO ) + ;
                              Chr( CENTERRADIO1 ) + Chr( RIGHTRADIO ) )
   ::cBmpCh2 := If( ! Empty( cFile2 ) .and. File( cFile2 ),;
                              ReadBitmap( cFile2 ), Chr( LEFTRADIO ) + ;
                              Chr( CENTERRADIO2 ) + Chr( RIGHTRADIO ) )
// end mod
    if IS_NUMBER( cColor ) .and. oWnd != nil // Colores del padre: TRadMenu()
        ::nClrFocus = oWnd:nClrFocus
        ::nClrHot   = oWnd:nClrHot
        ::nClrUnSel = oWnd:nClrUnSel
    else
        ::SetColors( cColor )
    endif

    Super:New( nRow, nCol, 4 + nLabelLen( cText ), 1, ::nColor,, oWnd,;
                  cMessage, bWhen, bValid, lUpdate )

    ::nHotKey = nGetHotKey( ::cText )

return Self

//----------------------------------------------------------------------------//

METHOD Redefine( cText, cMessage, cColor, nHelpId, bWhen, bValid, lUpdate )

*   BYNAME nHelpId         INIT NUMBER
    BYNAME cText, cMessage INIT CHARACTER
    BYNAME bWhen, bValid   INIT BLOCK

    if IS_CHARACTER( cText )
       ::nHotKey = nGetHotKey( cText )
    endif

    if !IS_NIL( cColor )
       ::SetColors( cColor )
    endif
    ::lUpdate := lUpdate

return Self

//----------------------------------------------------------------------------//

METHOD Refresh()

   ::SayHot( 0, 0, If( ::lPressed, ::cBmpCh2 , ::cBmpCh ) + ::cText,;
      If( ::lFocussed, ::nClrFocus, ::nColor ), ::nClrHot )

return nil

//----------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol )

    if ::lDesign .or. lMRight()
        return Super:Click( nMRow, nMCol )
    endif

    ::lPressed = !::lPressed
    ::Refresh()

    while lMPressed() ; MUpdate() ; end

return nil

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    if ::lDesign
        return Super:KeyPressed( nKey )
    endif

    if nKey == K_SPACE .or. nKey == K_ENTER .or. lIsHotKey( nKey, ::cText )
       ::lPressed = !::lPressed
       ::Refresh()
       return 0
    endif   

return Super:KeyPressed( nKey )

//----------------------------------------------------------------------------//
