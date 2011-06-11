//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Construir con BUILD Tutor03
//  Build with    BUILD Tutor03
//----------------------------------------------------------------------------//

// Nuestra primera ventana, ahora con ejemplos de control de eventos y
// con barra de mensajes

// Our first Window, now with Control events examples and with a
// message bar

#include "FiveDos.ch"

//----------------------------------------------------------------------------//

function Main()

   local oWnd, oBrush

   DEFINE BRUSH oBrush FILENAME "..\bitmaps\Back1.bmp"

   DEFINE WINDOW oWnd TITLE F2VERSION ;
      FROM 3, 6 TO 20, 70 ;
      BRUSH oBrush

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT ) ;
      CENTERED

   ACTIVATE WINDOW oWnd ;
      ON LEFT CLICK MsgInfo( "Left Click", "Event!" ) ;
      ON RESIZE MsgInfo( "ReSize", "Event!" ) ;
      ON PAINT  oWnd:Say( 2, 2, "Hello World!" )

return nil

//----------------------------------------------------------------------------//
