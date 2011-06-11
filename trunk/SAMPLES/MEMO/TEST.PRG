// -------------------------------------------------------------------------- //
// Test for the TMemo class
// -------------------------------------------------------------------------- //
#include "FiveDos.ch"

// -------------------------------------------------------------------------- //
Function Main()
    Local oWndMain
    Local cText
    DEFINE WINDOW oWndMain ;
        FROM 0, 0 TO 24, 79 ;
        TITLE "TMemo example (FiveTech)"

    cText := MemoRead( "Leame.TXT" )
    @ 1, 1 GET cText ;
        SIZE 76, 18 ;
        LABEL "&Memo Edit" ;
        MESSAGE "Este es el mensaje del editor." ;
        MEMO ;
        OF oWndMain

    @ 20, 5 BUTTON "  &Hola  " OF oWndMain;
        ACTION Tock()

    ACTIVATE WINDOW oWndMain

Return NIL

// -------------------------------------------------------------------------- //
