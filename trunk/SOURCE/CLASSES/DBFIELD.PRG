#include "fivedos.ch"

//----------------------------------------------------------------------------//

CLASS TField

  DATA cName, cType AS CHARACTER
  DATA nLen, nDec   AS NUMERIC
  DATA cPict        AS CHARACTER INIT "@K"

  METHOD New( cName, cType, nLen, nDec, cPict )
  
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cName, cType, nLen, nDec, cPict )

   cName := if( IS_CHARACTER( cName ), Upper( cName ), "" )

   DEFAULT cType := 'C'

   do case
      case cType == 'L'
           nLen:= 1
           nDec:= 0
      case cType == 'D'
           nLen:= 8
           nDec:= 0
      case cType == 'M'
           nLen:= 10
           nDec:= 0
   endcase

   BYNAME cName, cType
   BYNAME nLen, nDec INIT NUMBER
   BYNAME cPict      INIT CHARACTER
       
Return Self

//----------------------------------------------------------------------------//
