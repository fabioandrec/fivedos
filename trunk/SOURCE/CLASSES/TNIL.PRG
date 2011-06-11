#include "Fivedos.ch"
#include "Error.ch"

/*
   Esta clase deber¡a de (crear) MANTENER EL PUNTERO A LA CLASE a la que se 
   desea sustituir y utilizar los DATAS y METHODOS bloquificados para 
   devolver en cada momento un tipo de valor de acuerdo con lo que se espera.

   Ej: oObj:nOption ++

   Si nOption no es num‚rico, tendr¡amos un error, que podemos solucionar, pues
   estamos dentro del  mbito de la clase, pero... y si hacemos:
   
   Ej: oObj2:nVal := oObj:nOption + 20  ¢  if oObj:lIsOver( nMRow, nMCol )
   
   ya no tenemos control sobre el resultado....
   
   Propongo que esta clase acepte como par metro otra clase de la cual extraiga
   los tipos de DATAS y METHODOS y cuando utilicemos dichos datos, nos devuelvan
   el 'tipo' de valor esperado.
*/

CLASS TNil

    METHOD ArrAt( nIndex, uNewdata ) OPERATOR []
    METHOD Suma( uOper )             OPERATOR +
    METHOD Resta( uOper )            OPERATOR -
    METHOD Incremento()              OPERATOR ++
    METHOD Decremento()              OPERATOR --
    METHOD Producto( uOper )         OPERATOR *
    METHOD Cociente( uOper )         OPERATOR /

    METHOD Modulo( uOper )           OPERATOR %
    METHOD Potencia( uOper )         OPERATOR **

    METHOD Equal( uOper )            OPERATOR "="
    METHOD ExEqual( uOper )          OPERATOR "=="
    METHOD Mayor( uOper )            OPERATOR >
    METHOD MayorEq( uOper )          OPERATOR >=
    METHOD Menor( uOper )            OPERATOR <
    METHOD MenorEq( uOper )          OPERATOR <=

    METHOD TNilError( cMethod, nError ) ERROR HANDLER

ENDCLASS

//---------------------------------------------------------------------------//

METHOD ArrAt( nIndex, uNewData )
return Self

//---------------------------------------------------------------------------//

METHOD Suma( uOper )
return Self

//---------------------------------------------------------------------------//

METHOD Resta( uOper )
return Self

//---------------------------------------------------------------------------//

METHOD Incremento()
return Self

//---------------------------------------------------------------------------//

METHOD Decremento()
return Self

//---------------------------------------------------------------------------//

METHOD Producto( uOper )
return Self

//---------------------------------------------------------------------------//

METHOD Cociente( uOper )
return Self

//---------------------------------------------------------------------------//

METHOD Modulo( uOper )
return Self

//---------------------------------------------------------------------------//

METHOD Potencia( uOper )
return Self

//---------------------------------------------------------------------------//

METHOD Equal( uOper )
return .f.

//---------------------------------------------------------------------------//

METHOD ExEqual( uOper )
return .f.

//---------------------------------------------------------------------------//

METHOD Mayor( uOper )
return .f.

//---------------------------------------------------------------------------//

METHOD MayorEq( uOper )
return .f.

//---------------------------------------------------------------------------//

METHOD Menor( uOper )
return .f.

//---------------------------------------------------------------------------//

METHOD MenorEq( uOper )
return .f.

//---------------------------------------------------------------------------//

METHOD TNilError( cMethod, nError )
Return Self

//---------------------------------------------------------------------------//

