#include "FiveDos.ch"
#include "Eval.ch"

// Testing DO... translates...

function main()

    local nCount

    // ANIDANDO Translates FOR...DO....
    FOR nIdx1 := 1 TO 7 ;
    DO  ( FOR nIdx := 3 TO -2 STEP -1      ;
          DO Alert( str( nIdx ) + str( nIdx2 ) ), if( nIdx2 > 3, nIdx2 := 7, ), if( nIdx <= 1, EvalExit(), ) ;
          PARAMETERS nIdx2 ;
          WITH @nIdx1 ;
        )

return
