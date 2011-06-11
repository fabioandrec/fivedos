// Our first Window, now with Control events examples and with a message bar

#include "FiveWin.ch"

#define TESTFILENAME "TestSave.frm"

//----------------------------------------------------------------------------//

function Main()

   local oWnd, oBrush
   
   if file( TESTFILENAME )
        oWnd := uLoadObject( TESTFILENAME )

        ? ValType( oWnd ), oWnd:Classname()
        oWnd:Create()
        ? ValType( oWnd ), oWnd:Classname()

   else

        DEFINE BRUSH oBrush FILENAME "..\bitmaps\Back1.bmp"

        DEFINE WINDOW oWnd TITLE "FiveWin" ;
            FROM 3, 6 TO 20, 70 ;
            BRUSH oBrush
      
        SET MESSAGE OF oWnd TO F2VERSION + " " + FDCOPYRIGHT // Strings defined
                                                        // inside FiveWin.ch
   endif

   ACTIVATE WINDOW oWnd ;
      ON LEFT CLICK MsgInfo( "Left Click", "Event!" ) ;
      ON RESIZE MsgAlert( "ReSize", "Event!" ) ;
      ON PAINT  oWnd:Say( 2, 2, "Hello World!" )


   lSaveObject( oWnd, TESTFILENAME )

return nil

//----------------------------------------------------------------------------//
