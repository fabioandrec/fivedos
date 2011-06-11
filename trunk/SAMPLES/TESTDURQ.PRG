#include "FiveDos.ch"

//----------------------------------------------------------------------------//

function Main()

   local oWnd

   setevents( .f. )

   DEFINE WINDOW oWnd TITLE F2VERSION ;
      FROM 3, 6 TO 20, 70

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT ) ;
      CENTERED

   ACTIVATE WINDOW oWnd ;
      ON LEFT CLICK Duro( oWnd )

return nil

//----------------------------------------------------------------------------//

static function duro( oMain )

    local oWnd, n

    for n := 1 to 2000

       oMain:Say( 2, 2, str( n ) )

       DEFINE WINDOW oWnd TITLE "Cuenta :" + str( n )  ;
          FROM 3, 6 TO 20, 70

       ACTIVATE WINDOW oWnd ;
          ON INIT oWnd:End()

    next


//----------------------------------------------------------------------------//
