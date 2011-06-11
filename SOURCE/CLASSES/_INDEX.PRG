#include "fivedos.ch"

//----------------------------------------------------------------------------//

CLASS TIndex

  DATA cName, cFile, cKey, cFor AS CHARACTER
  DATA lUnique, lDescend        AS LOGIC

  METHOD New( cName, cFile, cKey, bKey, cFor, bFor, lUnique, lDescend )
  
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cName, cFile, cKey, bKey, cFor, bFor, lUnique, lDescend )

   cName := Upper( if( !Empty( cName ), cName, cFile ) )

   BYNAME cName
   BYNAME cFile    DEFAULT cName
   BYNAME cKey     INIT CHARACTER
   BYNAME cFor     DEFAULT "!Deleted()"
   BYNAME lUnique  INIT LOGICAL
   BYNAME lDescend INIT LOGICAL

Return Self

//----------------------------------------------------------------------------//
