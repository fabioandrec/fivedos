#include "Fivedos.ch"

CLASS TDBDICT FROM TDB

   DATA aDb AS ARRAY INIT {}

   CLASSDATA cExtDBS AS CHARACTER INIT ".DBS"
   CLASSDATA cExtFld AS CHARACTER INIT ".FLS"
   CLASSDATA cExtInd AS CHARACTER INIT ".INS"

   METHOD New( cFile ) INLINE ;
                       ::cFile := if( Empty( cFile ), "dbDict", cFile ), Self

   METHOD Redefine( cFile ) INLINE ::New( cFile ), ::Read(), Self

   METHOD AddDb( nArea, cDriver, cFile, cAlias, lShared, lReadOnly, aField, aIndex )

   METHOD GetDb( cName )

   METHOD CreateDb() INLINE aEval( ::aDb, { |db| db:Create() } )

   METHOD ReadDb(),;
          WriteDb()

   METHOD Read()          INLINE ::aField := ::ReadFields(),;
                                 ::aIndex := ::ReadIndexs(),;
                                 ::ReadDb()

   METHOD Write()         INLINE ::WriteFields(),;
                                 ::WriteIndexs(),;
                                 ::WriteDb()
ENDCLASS

//----------------------------------------------------------------------------//

METHOD AddDb( nArea, cDriver, cFile, cAlias, lShared, lReadOnly, aField, aIndex )

   local i, o

   cAlias := Upper( if( Empty( cAlias ), cFile, cAlias ) )

   if Empty( ::GetDb( cAlias ) )

      if !Empty( aField )
         for i = 1 to len( aField )
             aField[i] := if( Empty( o:=::GetField( aField[i] ) ),;
                              Alert( "Campo " + aField[i] + " definido en " + ;
                                      cAlias + " no Existe." ), o )
         next
      end

      if !Empty( aIndex )   
         for i:= 1 to len( aIndex )
             aIndex[i] := if( Empty( o:=::GetIndex( aIndex[i] ) ),;
                              Alert( "Indice " + aIndex[i] + " definido en " + ;
                                      cAlias + " no Existe." ), o )
         next
      end   

      aAdd( ::aDb, TDb():New( nArea, cDriver, cFile, cAlias, lShared, lReadOnly,;
                              aField, aIndex ) )
   end

Return nil

//----------------------------------------------------------------------------//

METHOD ReadDb()

   local o, nOldArea:= Select()

   USE ( ::cFile + ::cExtDBS ) NEW READONLY ALIAS ( ::cFile )

   while !Eof()
         o:= TDb():New( Upper( Trim( FieldGet(1) ) ),;  // Alias.
                        Upper( Trim( FieldGet(2) ) ),;  // File.
                        Upper( Trim( FieldGet(3) ) ),;  // Driver.
                        FieldGet(4) ,;                  // Shared.
                        FieldGet(5) ,;                  // ReadOnly.
                        FieldGet(6) )                   // nArea.

         o:aField := o:ReadFields()
         o:aIndex := o:ReadIndexs()

         ::AddDb( o )

         SKIP
   enddo
   CLOSE

   Select ( nOldArea )

Return nil

//----------------------------------------------------------------------------//

METHOD WriteDb()

   local o, n, nLen:= len( ::aDb )
   local nOldArea:= Select()

   DbCreate( ::cFile + ::cExtDBS, aSTRU_DB )

   USE ( ::cFile + ::cExtDBS ) NEW ALIAS ( ::cFile )

   nLen := len( ::aDb )

   for n:= 1 to nLen
       o:= ::aDb[n]
       APPEND BLANK
       FieldPut( 1, o:cAlias )
       FieldPut( 2, o:cFile )
       FieldPut( 3, o:cDriver )
       FieldPut( 4, o:lShared )
       FieldPut( 5, o:lReadOnly )
       FieldPut( 6, o:nArea )

       o:WriteFields()
       o:WriteIndexs()
   next

   CLOSE

   Select ( nOldArea )

Return nil

//----------------------------------------------------------------------------//

METHOD GetDb( cName )

  local i

  cName := Upper( cName )

return if( Empty( i:= aScan( ::aDb, { |e| e:cAlias == cName } ) ), i, ::aDb[ i ] )

//----------------------------------------------------------------------------//
