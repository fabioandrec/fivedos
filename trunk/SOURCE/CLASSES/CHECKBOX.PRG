#include "FiveDos.ch"
#include "FontDef.h"
#include "SysColor.ch"

//----------------------------------------------------------------------------//

CLASS TCheckBox FROM TView

   DATA   nClrFocus, nClrHot                    AS Numeric
   DATA   cText, cBmpCh, cBmp, cBmpCh2, cBmp2   AS NIL, Character
   DATA   bSetGet                               AS Block

   METHOD Destroy() INLINE if( !empty( ::cBmp ),;
                                ReleaseChars( ::cBmp ), ),;
                           if( !empty( ::cBmp2 ),;
                                ReleaseChars( ::cBmp2 ), )

   METHOD   Click( nRow, nCol  ),;
            KeyPressed( nKey ),;
            New( nRow, nCol, cText, cMessage, cColor, oWnd, bWhen, bValid,;
                 bSetGet , cBmpFile, cBmpFile2, lUpdate),;
            Redefine( cText, cMessage, cColor, nHelpId, bSetGet, bWhen,;
                 bValid,lUpdate ),;
            Refresh()

   METHOD SetColors( cColor, n, aSysClr ) INLINE ; // local var = n, aSysClr
          aSysClr     := aSysColor(),;
          ::nColor    := if( Empty( n := nStrColor( cColor, 1 ) ), ;
                             aSysClr[ CLR_CHECKBOX ], n ),;
          ::nClrFocus := if( Empty( n := nStrColor( cColor, 2 ) ), ;
                             aSysClr[ CLR_CHECKBOX_HI ], n ),;
          ::nClrHot   := if( Empty( n := nStrColor( cColor, 3 ) ), ;
                             aSysClr[ CLR_CHECKBOX_HOT ], n )
/* NO SE USA DE MOMENTO.
          ::nClrUnSel := if( Empty( n := nStrColor( cColor, 4 ) ), ;
                             aSysClr[ CLR_CHECKBOX_OFF ], n )
*/

ENDCLASS

METHOD New( nRow, nCol, cText, cMsg, cColor, oWnd, bWhen, bValid, bSetGet, ;
        cBmpFile, cBmpFile2, lUpdate )

   ::cBmp       = cBmpFile
   ::cBmp2      = cBmpFile2
   ::cBmpCh := If( ! Empty( cBmpFile ) .and. File( cBmpFile ),;
                              ReadBitmap( cBmpFile ), Chr( LEFTCHECK ) + ;
                              Chr( CENTERCHECK2 ) + Chr( RIGHTCHECK ) )
   ::cBmpCh2 := If( ! Empty( cBmpFile2 ) .and. File( cBmpFile2 ),;
                              ReadBitmap( cBmpFile2 ), Chr( LEFTCHECK ) + ;
                              Chr( CENTERCHECK1 ) + Chr( RIGHTCHECK ) )

    ::cText   = if( IS_CHARACTER( cText ), cText, "" )
    ::bSetGet = if( IS_BLOCK( bSetGet ), bSetGet, blSetGet() )  // Don`t touch.

    if IS_NUMBER( cColor ) .and. oWnd != nil // Colores del padre: TChkMenu()
        ::nClrFocus = oWnd:nClrFocus
        ::nClrHot   = oWnd:nClrHot
/* NO SE USA DE MOMENTO
        ::nClrUnSel = oWnd:nClrUnSel
*/
    else
        ::SetColors( cColor )
    endif

    Super:New( nRow, nCol, 4 + nLabelLen( cText ), 1, ::nColor,, oWnd, cMsg,;
                  bWhen, bValid )

    ::nHotKey = nGetHotKey( cText )
    ::lUpdate := lUpdate

return Self


//----------------------------------------------------------------------------//

METHOD Redefine( cText, cMessage, cColor, nHelpId, bSetGet, bWhen, ;
            bValid, lUpdate )

//   BYNAME nHelpId                INIT NUMBER
    BYNAME cText, cMessage        INIT CHARACTER
    BYNAME bSetGet, bWhen, bValid INIT BLOCK

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

   ::SayHot( 0, 0, If( eval( ::bSetGet ), ::cBmpCh, ::cBmpCh2 ) + ::cText, ;
                   If( ::lFocussed, ::nClrFocus, ::nColor ), ::nClrHot )

return nil

//----------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol )

    local bAct   := ::bSetGet

    if ::lDesign .or. lMRight()
        return Super:Click( nMRow, nMCol )
    endif

    while LMPressed() ; MUpdate() ; end

    if ::lIsOver( ::oWnd:nMRow(), ::oWnd:nMCol() )
        eval( bAct, !eval( bAct ) )
        ::Refresh()
    endif

return nil

//----------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

   local b := ::bSetGet

   if ::lDesign
       return Super:KeyPressed( nKey )
   endif

   if nKey == K_SPACE .or. nKey == K_ENTER .or. lIsHotKey( nKey, ::cText )

      eval( b, !eval( b ) )
      ::Refresh()

      while( lAnyKeyPressed() ); end
   
      // Limpia el buffer de teclado.
      nKey = set( _SET_TYPEAHEAD, 0 )
      set( _SET_TYPEAHEAD, nKey )
      return 0
   endif

return Super:KeyPressed( nKey )

//----------------------------------------------------------------------------//
