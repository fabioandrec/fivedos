#include "FiveDos.ch"
#include "Eval.ch"

// Testing EVAL Translate/Commands

function main()

    local nCount

    nCount := 0
    EVAL alert( str( nCount++ ) ) ;
         WHILE nCount < 3
    nCount := 0
    EVAL alert( str( nCount ) ) ;
         UNTIL nCount++ > 3

    EVAL Alert( str( param( 1 ) ) ) ;
        FOR 1 TO 3

    EVAL Tock() FOR 1 TO 200 STEP 2

    // ANIDANDO Translates EVAL....
    EVAL ;
        EVAL Alert( str( param(1)) + str(param(2)) ) ;
        FOR 3 TO 1 STEP -1 WITH param( 1 ) ;
    FOR 1 TO 3

    nCount := 0
    EVAL Tock() UNTIL ++nCount < 100 WITH 1,2,3

    EVAL alert( str( param( 1 ) ) + param( 2 ) + param( 3 ) ) ;
        FOR 1 TO 3 WITH "  Bucle for", " next: EN LINEA..."

    // Cuidado que viene......
    // Un EVAL FOR Anida dos EVAL FOR en secuencia
    EVAL ;
        EVAL Sound( param( 1 ) ), MiliDelay( 10 ) ;
        FOR 100 TO 1000 STEP 100,;
        EVAL Sound( param( 1 ) ), MiliDelay( 10 ) ;
        FOR 1000 TO 100 STEP -100 ;
    FOR 1 TO 4

    SoundOff()

return nil

