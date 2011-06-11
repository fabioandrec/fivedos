#include "FiveDos.ch"
#include "Eval.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   local oBar, n

   DEFINE WINDOW oWnd TITLE "Hello world!" ;
      MENU BuildMenu()

   DEFINE BUTTONBAR oBar OF oWnd

   // Actions with control structures....

   DEFINE BUTTON OF oBar PROMPT "1"                     ;
      ACTION Tock()                                     ;
      MESSAGE "Pulse dial 1"

   // Bucle FOR...
   DEFINE BUTTON OF oBar PROMPT "2"                     ;
      ACTION EVAL Tock(), MiliDelay( param( 2 ) )       ; // Param 1 es indice del bucle...
             FOR 1 TO 2  WITH 10 * 10                   ;
      MESSAGE "Pulse dial 2"

   // Bucle WHILE...
   DEFINE BUTTON OF oBar PROMPT "3"                         ;
      ACTION n := 0, EVAL Tock(), MiliDelay( param( 1 ) )   ;
                     WHILE ++n <= 3  WITH 10 * 10           ;
      MESSAGE "Pulse dial 3"

   // Bucle UNTIL...
   DEFINE BUTTON OF oBar PROMPT "4"                     ;
      ACTION n := 0, EVAL Tock(), MiliDelay( 100 )      ;
                     UNTIL ++n > 4                      ;
      MESSAGE "Pulse dial 4"

   DEFINE BUTTON OF oBar PROMPT "5"                     ;
      ACTION EVAL Tock(), MiliDelay( 100 )              ;
             FOR 1 TO 5                                 ;
      MESSAGE "Pulse dial 5"

   DEFINE BUTTON OF oBar PROMPT "6"                     ;
      ACTION EVAL Tock(), MiliDelay( 100 )              ;
             FOR 1 TO 6                                 ;
      MESSAGE "Pulse dial 6"

   DEFINE BUTTON OF oBar PROMPT "7"                     ;
      ACTION EVAL Tock(), MiliDelay( 100 )              ;
             FOR 1 TO 7                                 ;
      MESSAGE "Pulse dial 7"

   DEFINE BUTTON OF oBar PROMPT "8"                     ;
      ACTION EVAL Tock(), MiliDelay( 100 )              ;
             FOR 1 TO 8                                 ;
      MESSAGE "Pulse dial 8"

   DEFINE BUTTON OF oBar PROMPT "9"                     ;
      ACTION EVAL Tock(), MiliDelay( 100 )              ;
             FOR 1 TO 9                                 ;
      MESSAGE "Pulse dial 9"

   DEFINE BUTTON OF oBar PROMPT "0"                     ;
      ACTION EVAL Tock(), MiliDelay( 100 )              ;
             FOR 1 TO 10                                ;
      MESSAGE "Pulse dial 0"

   SET MESSAGE OF oWnd TO "FiveDos - CA-Clipper for Dos library"

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Confirm exit" )

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "&Information"
      MENU
         MENUITEM "&About..."
         SEPARATOR
         MENUITEM "&Exit..." ACTION oWnd:End()
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//
