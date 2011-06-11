#include "fivedos.ch"

//----------------------------------------------------------------------------//

CLASS TIndex

  DATA cName, cFile, cKey, cFor  AS CHARACTER
  DATA lUnique, lDescend, lScope AS LOGIC
  DATA uValTop, uValBottom

  METHOD New( cName, cFile, cKey, cFor, lUnique, lDescend, uValTop, uValBottom )
  
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cName, cFile, cKey, cFor, lUnique, lDescend, uValTop, uValBottom )

   cName := Upper( if( !Empty( cName ), cName, cFile ) )

   BYNAME cName
   BYNAME cFile    DEFAULT cName
   BYNAME cKey     INIT CHARACTER
   BYNAME cFor     INIT DEFAULT "!Deleted()"
   BYNAME lUnique  INIT LOGICAL
   BYNAME lDescend INIT LOGICAL
   BYNAME uValTop, uValBottom

Return Self

//----------------------------------------------------------------------------//
