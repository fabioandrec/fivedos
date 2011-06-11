#include "Objects.ch"

//----------------------------------------------------------------------------//

CLASS TWorkArea

   PROTECTED:

   DATA nArea          AS NUMERIC             // No cambiar el orden
   DATA lBuffer        AS LOGICAL             // de estas declaraciones
   DATA aBuffer        AS ARRAY               // de datos.
   DATA nInitArea      AS NIL, NUMERIC

   PUBLIC:
                                      
   // ::SetArea() no funciona en New(), si la Dbf no esta abierta.!!!!!!!!!
   METHOD New( nArea ) INLINE ;
    ( if( lNumber( nArea ), ::nInitArea := nArea, Select() ) )->( ::SetArea() ),;
    Self

   ERROR HANDLER TWAErrHand EXTERN

   // nRecNo es Variable local del metodo.
   METHOD Blank( nRecNo )     INLINE ( ::nArea )->( nRecNo := RecNo(),;
                                                    DBGoBottom(), ;
                                                    DBSkip( 1 ), ;
                                                    ::Load(),;
                                                    DBGoTo( nRecNo ) )
   METHOD Load()              EXTERN TWALoad()
   METHOD Save()              EXTERN TWASave()
   METHOD SetBuffer( lOnOff ) INLINE ; // if TRUE reloads buffer, return lBuffer.
                                if( lOnOff == nil,,;
                                    if( ( ::lBuffer := lOnOff ), ::Load(), ) ),;
                                ::lBuffer


   HIDE METHOD SetArea()      // Open at nArea and self-Init .
   HIDE METHOD ResetArea()    VIRTUAL
   
   METHOD Append()            INLINE    ( ::nArea )->( DBAPPEND() )
                              /* No se hace ::Load() porque si alguien est 
                                 editando no quiere cepillarse su buffer de
                                 edici¢n
                              */

   METHOD Bof()               EXTERN TWABof()
   METHOD Close()             INLINE ( ::nArea )->( DbCloseArea() ),;
                                       ::nArea := ::nInitArea
   METHOD Commit()            INLINE if( ::lBuffer, ::Save(), ),;
                                       ( ::nArea )->( DBCommit() )
   METHOD Create( cFile, aStruct, cDriver ) ;
                              INLINE DbCreate( cFile, aStruct, cDriver )
   METHOD DbEval( bBlock, bFor, bWhile, nNext, nRecord, lRest ) ;
                              INLINE ( ::nArea )->( DBEval( bBlock, bFor, ;
                                                    bWhile, nNext, nRecord, ;
                                                    lRest ) )
   METHOD Delete()            INLINE ( ::nArea )->( DBDelete() )
   METHOD Deleted()           EXTERN TWADeleted()
   METHOD Eof()               EXTERN TWAEof()
   METHOD FCount()            EXTERN TWAFCount()
   METHOD FieldGet( nField )       EXTERN TWAFieldGe()  // if buffering
   METHOD FieldPut( nField, uVal ) EXTERN TWAFieldSe()  // access to buffer.
   METHOD Found()             INLINE ( ::nArea )->( Found() )
   METHOD GoTo( nRecNo )      INLINE ( ::nArea )->( DBGoTo( nRecNo ) ),;
                                     if( ::lBuffer, ::Load(), )
   METHOD GoTop()             INLINE ( ::nArea )->( DBGoTop() ),;
                                     if( ::lBuffer, ::Load(), )
   METHOD GoBottom()          INLINE ( ::nArea )->( DBGoBottom() ),;
                                     if( ::lBuffer, ::Load(), )
   METHOD LastRec()           EXTERN TWALastRec()
   METHOD Lock()              EXTERN TWALock()   // Bloqueo de Fichero.
   METHOD Pack()              EXTERN TWAPack()
   METHOD ReCall()            INLINE ( ::nArea )->( DBRecall() )

   METHOD RecCount()          EXTERN TWALastRec()
   METHOD RecLock()           EXTERN TWARLock()  // Bloqueo de Registro.
   METHOD RecNo()             EXTERN TWARecNo()
   METHOD Seek( uExp, lSoft ) EXTERN TWASeek()  // if buffering reloads buffer
   METHOD Skip( nRecords )    EXTERN TWASkip()  //    "
   METHOD Skipper( nRecords ) EXTERN TWASkipper() // -> nRecsSkipped,  "
   METHOD UnLock()            INLINE ( ::nArea )->( DBUnLock() )
   
   METHOD Use( nArea, cDriver, cFile, cAlias, lShared, lReadOnly ) INLINE ;
          ( nArea )->( DbUseArea( .f., cDriver, cFile, cAlias, lShared, lReadOnly ),;
                       ::SetArea() )
          
   METHOD Used()              INLINE ( ::nArea )->( Used() )
   METHOD Zap()               EXTERN TWAZap() // if buffering reloads buffer

   METHOD CloseIndex()        INLINE ( ::nArea )->( DbClearIndex() )
   METHOD CreateIndex( cFile, cKey, bKey, lUnique ) INLINE ;
                  ( ::nArea )->( DbCreateIndex( cFile, cKey, bKey, lUnique ) )
   METHOD ClearRelation()     INLINE ( ::nArea )->( DbClearRelation() )
   METHOD DeleteIndex()       INLINE ::CloseIndex()
   METHOD IndexKey( nOrder )  INLINE ( ::nArea )->( IndexKey( nOrder ) )
//   METHOD IndexBagName( nInd )      INLINE ( ::nArea )->( OrdBagName( nInd ) )
//   METHOD IndexName( nTag, cFile )  INLINE ( ::nArea )->( OrdName( nTag, cFile ) )
   METHOD IndexOrder( )       INLINE ( ::nArea )->( IndexOrd() )
   METHOD SetIndex( cFile )   INLINE ( ::nArea )->( dbSetIndex( cFile ) )
   METHOD SetOrder( nOrder )  INLINE ( ::nArea )->( dbSetOrder( nOrder ) )
   METHOD SetRelation( ncArea, cExp ) INLINE ;
                 ( ::nArea )->( DbSetRelation( ncArea, Compila( cExp ), cExp ) )
   
ENDCLASS

//---------------------------------------------------------------------------//

METHOD SetArea()

   static nClassH
   local  n, nFields := FCount()
   
   DEFAULT nClassH := TWorkArea():ClassH()

   for n = 1 to nFields
       TWADictAdd( nClassH, "_" + Field( n ), Field( n ) )
   next
   ::aBuffer = Array( nFields )
   ::SetBuffer( .f. ) // Buffering OFF By Default.
   ::nArea = Select()
   if ( ::nInitArea == nil )
      ::nInitArea := ::nArea
   end

return nFields

//----------------------------------------------------------------------------//
