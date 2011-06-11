//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Contruir con BUILD Tutor02
//  Build with   BUILD Tutor02
//----------------------------------------------------------------------------//

// ннн Nuestra primera ventana en Dos !!!
// Our first Window in Dos !!!

#include "FiveDos.ch"

//----------------------------------------------------------------------------//

function Main()

   local oWnd

   DEFINE WINDOW oWnd FROM 3, 6 TO 20, 70 ;
          TITLE "Wellcome to FiveDos"     

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT ) ;
      CENTERED
      
   @ 2, 2 SAY "Hello" OF oWnd

   ACTIVATE WINDOW oWnd

return nil

//----------------------------------------------------------------------------//
