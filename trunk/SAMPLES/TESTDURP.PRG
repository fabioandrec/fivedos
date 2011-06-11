#include "FiveDos.ch"

//----------------------------------------------------------------------------//

function Main()

   local oWnd, n := 0


   for n := 1 to 200

   DEFINE WINDOW oWnd TITLE F2VERSION ;
      FROM 3, 6 TO 20, 70

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT ) ;
      CENTERED

   ACTIVATE WINDOW oWnd ;
      ON INIT oWnd:End()

   ? n
   next

return nil

//----------------------------------------------------------------------------//
