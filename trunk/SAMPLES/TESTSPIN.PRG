// testing tSpin class

#include 'fivedos.ch'

function main()

    local oWnd, oWnd1, oGet
    local nVar    := 5

    DEFINE WINDOW oWnd FROM 5, 5 TO 20, 74 ;
            TITLE "Testing 'Spin' control"

    @ 5, 2 GET oGet VAR nVar OF oWnd                            ;
            PROMPT "&Get Confirmation"

    @ 2, 2 SPIN oGet:cText OF oWnd                              ;
            PROMPT "&Spin control"                              ;
            ACTION oWnd1:ChangeSize( oWnd1:nWidth, nVar + 2 )   ;
            EDITABLE

    @ 8, 5 BUTTON ' E&xit ' OF oWnd                             ;
           ACTION oWnd:End()

    DEFINE DIALOG oWnd1 FROM 7,40 TO 18,70                      ;
            TITLE 'Resizable'

    ACTIVATE WINDOW oWnd  ;
            ON INIT go( oWnd1 ) ;
            valid oWnd1:close()
return nil

static proc go( oWnd1 )
    ACTIVATE DIALOG oWnd1 NOWAIT
return
