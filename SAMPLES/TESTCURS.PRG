#include "FiveDos.ch"

//----------------------------------------------------------------------------//

function Main()

   local oWnd, oBrush

   DEFINE WINDOW oWnd TITLE F2VERSION ;
      FROM 3, 6 TO 20, 70

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT ) ;
      CENTERED

   // Set user cursor to Window Client area
   oWnd:oClient:nMouseCursor = cLoadCursor( "Test.cur" )

   ACTIVATE WINDOW oWnd ;
      ON LEFT CLICK MsgInfo( "Left Click", "Event!" ) ;
      ON RESIZE MsgInfo( "ReSize", "Event!" ) ;
      ON PAINT  oWnd:Say( 2, 2, "Hello World!" )



return nil

//----------------------------------------------------------------------------//
