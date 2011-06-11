#include "FiveDos.ch"
#include "Eval.ch"

// Testing DO... translates...

function main()

    local nCount

    nCount := 0
    DO alert( str( nCount++ ) ) ;
         WHILE nCount < 3
    nCount := 0
    DO alert( str( nCount ) ) ;
         UNTIL nCount++ > 3

    DO Alert( str( nIdx ) ) ;
        FOR nIdx := 1 TO 3

    FOR nIdx := 1 TO 3 ;
        DO Alert( str( nIdx ) )

    DO Tock() FOR n := 1 TO 200 STEP 2

    FOR n := 1 TO 200 STEP 2 DO Tock(), MiliDelay( 100 ), if( n > 6, EvalExit(), )

    // ANIDANDO Translates DO...FOR...
    DO ;
        DO Alert( str( nIdx ) + str( nIdx2 ) ) ;
        FOR nIdx := 3 TO 1 STEP -1      ;
        PARAMETERS nIdx2 ;
        WITH nIdx1              ;
    FOR nIdx1 := 1 TO 3

    // ANIDANDO Translates FOR...DO....
    FOR nIdx1 := 1 TO 3 ;
    DO  ( FOR nIdx := 3 TO -20 STEP -1      ;
          DO Alert( str( nIdx ) + str( nIdx2 ) ), if( nIdx <= 1, EvalExit(), ) ;
          PARAMETERS nIdx2 ;
          WITH nIdx1 ;
        )


    nCount := 0
    DO Tock() UNTIL ++nCount < 100 WITH 1,2,3

    DO alert( str( nIdx ) + uParm1 + uParm2 ) ;
        FOR nIdx := 1 TO 3 ;
        PARAMETERS uParm1, uParm2 ;
        WITH "  Bucle for", " next: EN LINEA..."

    // ­ Cuidado ! ­­ Qu‚ viene...... haciendo ruido !!
    // Un DO FOR Anida a dos DO FOR en secuencia
    DO ;
        DO Sound( n ), MiliDelay( 10 ) ;
         FOR n := 100 TO 1000 STEP 100          ,;
        DO Sound( n ), MiliDelay( 10 ) ;
         FOR n := 1000 TO 100 STEP -100              ;
    FOR n := 1 TO 4

    SoundOff()

    do while .t.
        exit
    enddo

    do
        exit
    until .f.

return nil

