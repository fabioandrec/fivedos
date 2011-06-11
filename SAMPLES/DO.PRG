#include "FiveDos.ch"
#include "Eval.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   local oBar, n

   DEFINE WINDOW oWnd TITLE "FiveDos control structures in codeblocks!" ;
      at 2, 2 size 40, 10 ;
      MENU BuildMenu()

   DEFINE BUTTONBAR oBar OF oWnd

   // Actions with control structures....

   DEFINE BUTTON OF oBar PROMPT "1"                     ;
      ACTION Tock()                                     ;
      MESSAGE "Pulse dial 1"

   // Bucle FOR...
   DEFINE BUTTON OF oBar PROMPT "2"                 ;
      ACTION FOR n := 1 TO 2                        ;
             DO Tock(), MiliDelay( nFreq )          ;
             PARAMETERS nFreq                       ;
             WITH 10 * 10                           ;
      MESSAGE "Pulse dial 2"

   // Bucle WHILE...
   DEFINE BUTTON OF oBar PROMPT "3"                     ;
      ACTION n := 0, DO Tock(), MiliDelay( param( 1 ) ) ;
                     WHILE ++n <= 3                     ;
                     WITH 10 * 10                       ;
      MESSAGE "Pulse dial 3"

   // Bucle UNTIL...
   DEFINE BUTTON OF oBar PROMPT "4"                     ;
      ACTION n := 0, DO Tock(), MiliDelay( 100 )      ;
                     UNTIL ++n > 4                      ;
      MESSAGE "Pulse dial 4"

   DEFINE BUTTON OF oBar PROMPT "5"                 ;
      ACTION FOR n := 1 TO 5                        ;
             DO Tock(), MiliDelay( 100 )            ;
      MESSAGE "Pulse dial 5"

   DEFINE BUTTON OF oBar PROMPT "6"                     ;
      ACTION DO Tock(), MiliDelay( 100 )              ;
             FOR n := 1 TO 6                                 ;
      MESSAGE "Pulse dial 6"

   DEFINE BUTTON OF oBar PROMPT "7"                     ;
      ACTION n := 0                                    ,;
             WHILE ++n <= 7                             ;
             DO Tock(), MiliDelay( 100 )                ;
      MESSAGE "Pulse dial 7"

   DEFINE BUTTON OF oBar PROMPT "8"                     ;
      ACTION DO Tock(), MiliDelay( 100 ) ;
             FOR n := 1 TO 8                           ;
      MESSAGE "Pulse dial 8"

   DEFINE BUTTON OF oBar PROMPT "9"                     ;
      ACTION DO Tock(), MiliDelay( 100 )              ;
             FOR n := 1 TO 9                                 ;
      MESSAGE "Pulse dial 9"

   DEFINE BUTTON OF oBar PROMPT "0"                     ;
      ACTION DO Tock(), MiliDelay( 100 )              ;
             FOR n := 1 TO 10                                ;
      MESSAGE "Pulse dial 0"

   DEFINE BUTTON OF oBar PROMPT "Alarm..." ;
      ACTION    DO ;
                    DO Sound( n ), MiliDelay( 10 ) ;
                     FOR n := 100 TO 1000 STEP 100          ,;
                    DO Sound( n ), MiliDelay( 10 ) ;
                     FOR n := 1000 TO 100 STEP -100              ;
                FOR n := 1 TO 4,;
                SoundOff()


   DEFINE BUTTON OF oBar PROMPT "Colgado..."            ;
      GROUP                                             ;
      ACTION DO Tock(), MiliDelay( 100 )              ;
             WHILE .T.                                  ;
      MESSAGE "Deja colgado el programa...bucle sin fin: Salir con Alt-C"


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
