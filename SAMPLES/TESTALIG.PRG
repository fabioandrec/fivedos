//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//----------------------------------------------------------------------------//

// ннн Test de alineamiento de controles !!!
// Control align test !!!

#include "FiveDos.ch"
#include "ctlalign.ch"

//----------------------------------------------------------------------------//

function Main()

   local oWnd, oLbx, oBrw, nListBox := 1
   local aList := { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",;
                    "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre",;
                    "Diciembre" }

   USE Dialog READONLY SHARED

   DEFINE WINDOW oWnd FROM 3, 6 TO 20, 70 ;
          TITLE "FiveDOS Control aligment test"

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT ) ;
      CENTERED
      
   @ 0, 0 SAY "I'm Top" ;
        CENTERED ;
        OF oWnd
   aTail( oWnd:oClient:aChilds ):nAlign := ALIGN_TOP

   @ 0, 0 SAY " I'm ; Left " ;
        CENTERED ;
        COLOR "W+/B" ;
        OF oWnd
   aTail( oWnd:oClient:aChilds ):nAlign := ALIGN_LEFT

   @ 0, 0 SAY " I'm ; Right " ;
        CENTERED ;
        COLOR "W+/G" ;
        OF oWnd
   aTail( oWnd:oClient:aChilds ):nAlign := ALIGN_RIGHT

   @ 0, 0 SAY "I'm Bottom" ;
        CENTERED ;
        OF oWnd
   aTail( oWnd:oClient:aChilds ):nAlign := ALIGN_BOTTOM
/*
   @ 0, 0 SAY "&I'm Centered" ;
        CENTERED ;
        OF oWnd
   aTail( oWnd:oClient:aChilds ):nAlign := ALIGN_CLIENT
*/
/*
    @ 0, 0 LISTBOX oLbx VAR nListBox ARRAY aList ;
            PROMPT "&Month Day" ;
		    ON CHANGE Tock()     ;
		    ON DBLCLICK  Tone(1000,1) ;
            OF oWnd
*/

   BEGIN BROWSE oBrw COLOR "W+/W, W+/N, W/N"                  // Browse Colors
        COLUMN TITLE "Nombre"  SHOW Dialog->Name
        COLUMN TITLE "Level"   SHOW Dialog->Level
   ENDBROWSE

   oBrw:SkipBlock := { | n | Dialog->( _DbSkipper( n ) ) }

   @  10,  10 LISTBOX oLbx BROWSE oBrw           ;
            LOGICLEN Dialog->( RecCount() )     ;
            OF oWnd



   oLbx:nAlign := ALIGN_CLIENT

   ACTIVATE WINDOW oWnd

   CLOSE DIALOG

return nil

//----------------------------------------------------------------------------//
