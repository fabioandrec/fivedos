// -------------------------------------------------------------------------- //
// Test for the TMemo class
// -------------------------------------------------------------------------- //
#include "FiveDos.ch"

// -------------------------------------------------------------------------- //
Function Main()

    Local oWndMain, oMemo, cText, acItems
    Local cFileName

    DEFINE WINDOW oWndMain ;
        FROM 0, 0 TO 24, 79 ;
        TITLE "TMemo example (By FiveTech Team)"

    SET MESSAGE OF oWndMain TO "File text reader ..."

    cText := ""

    @  1,  1 GET oMemo VAR cText ;
        SIZE 76, 19 ;
        MESSAGE "this is the TMemo message." ;
        MEMO ; // COLOR "N/BG, N/W"  ;
        OF oWndMain

    @ 21,  5 BUTTON " &Open " OF oWndMain;
        MESSAGE "Open a file..." ;
        ACTION If( File( cFileName := cGetFile( "*.txt" ) ), ;
            oMemo:cText := MemoRead( cFileName ), )

    @ 21, 13 BUTTON " &Save " OF oWndMain ;
        MESSAGE "Save the file..." ;
        WHEN !Empty( cFileName ) ;
        ACTION MemoWrit( cFileName, oMemo:cText )

    ACTIVATE WINDOW oWndMain ;
        VALID lMsgEnd()

Return NIL

// -------------------------------------------------------------------------- //
