#include "Fivedos.ch"

   /* Se usa para oDbDict y Database */

CLASS TDB
 
   DATA cAlias, cFile, cDriver AS CHARACTER
   DATA lShared, lReadOnly     AS LOGICAL
   DATA nArea                  AS NUMBER
   DATA aField                 AS ARRAY INIT {}
   DATA aIndex                 AS ARRAY INIT {}

   CLASSDATA cExtFld AS CHARACTER INIT ".FLD"
   CLASSDATA cExtInd AS CHARACTER INIT ".IND"

   METHOD New( nArea, cDriver, cFile, cAlias, lShared, lReadOnly, aField, aIndex ),;
                                                       ;
          AddField( cName, cType, nLen, nDec, cPict ) ,;
          AddIndex( cName, cFile, cKey, cFor, lUnique, lDescend ) ,;
                            ;
          GetField( cName ),;
          GetIndex( cName ),;
                            ;
          Create()         ,;
                            ;
          Redefine( cName, cAlias, oDict ),;
                            ;
          ReadFields(),;
          ReadIndexs(),;
                       ;
          WriteFields(),;
          WriteIndexs()

   METHOD Read()  VIRTUAL  // Lee los datos de un db.
   METHOD Write() VIRTUAL  // Escribe los datos de un db.

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nArea, cDriver, cFile, cAlias, lShared, lReadOnly, aField, aIndex )

    cAlias := Upper( if( Empty( cAlias ), cFile, cAlias ) )

    BYNAME nArea     DEFAULT Select( cAlias )
    BYNAME cAlias
    BYNAME cFile     DEFAULT cAlias
    BYNAME cDriver   DEFAULT "DBFNTX"
    BYNAME lShared   INIT LOGICAL
    BYNAME lReadOnly INIT LOGICAL
    DEFAULT aField := {}
    DEFAULT aIndex := {}
    BYNAME aField    INIT ARRAY
    BYNAME aIndex    INIT ARRAY
   // provoca error
   a:=5+"3"
RETURN Self

//----------------------------------------------------------------------------//
// cName  = Alias de dbf en oDict.
// cAlias = Alias que se asigna a oDb redefinida.

METHOD Redefine( cName, cAlias, oDict )

   local o, p

   cName := Upper( if( Empty( cName ), cAlias, cName ) )

   if Empty( o:= oDict:GetDb( cName ) )
      Alert( "Alias '" + cAlias + "' * NO ENCONTRADO en el Diccionario *" )
     else
      ::cAlias    := Upper( if( Empty( cAlias ), cName, cAlias ) )
      ::cFile     := o:cFile
      ::cDriver   := o:cDriver
      ::lShared   := o:lShared
      ::lReadOnly := o:lReadOnly
      ::aField    := o:aField
      ::aIndex    := oClone( o:aIndex )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Create() 

  local nOldArea := Select()

   DbCreate( ::cFile, ::aField, ::cDriver )
   DbUseArea( .t., ::cDriver, ::cFile, ::cAlias, .f., .t. )
   aEval( ::aIndex,;
      {|e| ordCondSet( e:cFor, Compila( e:cFor ),,,,,,,,,e:lDescend ),;
           dbCreateIndex( e:cFile, e:cKey, Compila( e:cKey ), e:lUnique ) } )
   DbCloseArea()
   Select( nOldArea )

return nil

//----------------------------------------------------------------------------//

METHOD AddField( cName, cType, nLen, nDec, cPict )

   local i

   if IS_OBJECT( cName )
       aAdd( ::aField, cName )
      else 
       do case
          case cType == 'L'
               nLen:= 1
          case cType == 'D'
               nLen:= 8
          case cType == 'M'
               nLen:= 10
       endcase

       if cType != 'N'
          nDec := 0
       endif

       if IS_ARRAY( cName )
          for i:= 1 to len( cName )
              aAdd( ::aField, TField():New( cName[i], cType, nLen, nDec, cPict ) )
          next
        else
          aAdd( ::aField, TField():New( cName, cType, nLen, nDec, cPict ) )
       end
   end

Return nil

//----------------------------------------------------------------------------//

METHOD AddIndex( cName, cFile, cKey, cFor, lUnique, lDescend )
   // provoca error
   a:=5+"3"
   if IS_OBJECT( cName )
      aAdd( ::aIndex, cName )
     else
      aAdd( ::aIndex, TIndex():New( cName, cFile, cKey, cFor, lUnique, lDescend ) )
   end

Return nil

//----------------------------------------------------------------------------//

METHOD ReadFields()

   local o, i:= 1, aField,;
         nOldArea:= Select()

   USE ( ::cFile + ::cExtFLD ) NEW READONLY ALIAS Field

   aField := Array( FCount() )

   While !Eof()
         aField[i++] := TField():New( Trim( FieldGet( 1 ) ),;  // cName.
                                            FieldGet( 2 ),;    // cType.
                                            FieldGet( 3 ),;    // nLen.
                                            FieldGet( 4 ),;    // nDec.
                                      Trim( FieldGet( 5 ) );   // cPict.
                                    )
         SKIP
   end

   CLOSE

   Select ( nOldArea )

Return aField

//----------------------------------------------------------------------------//

METHOD WriteFields()

    local n, o, nLen,;
          nOldArea:= Select()
 
    nLen := len( ::aField )
 
    DbCreate( ::cFile + ::cExtFLD, aSTRU_FIELD )
 
    USE ( ::cFile + ::cExtFLD ) NEW ALIAS Field
 
    for n = 1 to nLen
        o:= ::aField[n]
        APPEND BLANK
        FieldPut( 1, o:cName )
        FieldPut( 2, o:cType )
        FieldPut( 3, o:nLen )
        FieldPut( 4, o:nDec )
        FieldPut( 5, o:cPict )
    next
 
    CLOSE
 
    Select ( nOldArea )
 
Return nil

//----------------------------------------------------------------------------//

METHOD ReadIndexs()

   local o, i:= 1, aIndex,;
         nOldArea:= Select()

    USE ( ::cFile + ::cExtIND ) NEW READONLY ALIAS Index
    
    aIndex := Array( FCount() )
  
    while !Eof()
          aIndex[i++]:= TIndex():New( Trim( FieldGet(1) ),; // cName.
                                      Trim( FieldGet(2) ),; // cFile.
                                      Trim( FieldGet(3) ),; // cKey.
                                      FieldGet(4),;         // lUnique.
                                      Trim( FieldGet(5) ),; // cFor.
                                      FieldGet(6) )         // lDescend.
          skip
    enddo

    CLOSE

    Select ( nOldArea )

Return aIndex

//----------------------------------------------------------------------------//

METHOD WriteIndexs()

   local o, nLen, n, i:= 1,;
         nOldArea:= Select()

    nLen := len( ::aIndex )

    DbCreate( ::cFile + ::cExtIND, aSTRU_INDEX )

    USE ( ::cFile + ::cExtIND ) NEW ALIAS Index
    
    for n = 1 to nLen
        o:= ::aIndex[n]
        APPEND BLANK
        FieldPut( 1, o:cName )
        FieldPut( 2, o:cFile )
        FieldPut( 3, o:cKey )
        FieldPut( 4, o:lUnique )
        FieldPut( 5, o:cFor )
        FieldPut( 6, o:lDescend )
    next

    CLOSE

    Select ( nOldArea )

Return nil

//----------------------------------------------------------------------------//

METHOD GetField( cName )

  local i

  cName := Upper( cName )

return if( Empty( i:= aScan( ::aField, { |e| e:cName == cName } ) ), i, ::aField[ i ] )

//----------------------------------------------------------------------------//

METHOD GetIndex( cName )

  local i

  cName := Upper( cName )

return if( Empty( i:= aScan( ::aIndex, { |e| e:cName == cName } ) ), i, ::aIndex[ i ] )

//----------------------------------------------------------------------------//

