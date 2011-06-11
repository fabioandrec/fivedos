#include "FiveDos.ch"

static oWndd

//----------------------------------------------------------------------------//

function Main()

   local oWnd

   DEFINE WINDOW oWnd TITLE "Test duro de creaci¢n de ventanas " + F2VERSION ;
      FROM 3, 6 TO 20, 70

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT ) ;
      CENTERED

   oWnd:Say( 2, 2, "Haz click para empezar" )

   ACTIVATE WINDOW oWnd ;
      ON LEFT CLICK Duro( oWnd )

return nil

//----------------------------------------------------------------------------//

static procedure Duro( oMain )

    local n

    for n := 1 to 2000

       oMain:Say( 2, 2, str( n ) + str( memory( 0 ) ) + str( memory( 1 ) ))

       DefWind( n )

    next

return

//----------------------------------------------------------------------------//

static proc DefWind( n )

    DEFINE WINDOW oWndd TITLE "Cuenta :" + str( n )  ;
          FROM 3, 6 TO 20, 70

    @ 4, 20 BUTTON ";&OK" SIZE 8, 3 OF oWndd

    ACTIVATE WINDOW oWndd ;
          ON INIT oWndd:End()
return
