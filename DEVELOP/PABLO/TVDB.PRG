#include "Fivedos.ch"

// ------------------------------------------------------------------
CLASS tVDb FROM tWorkArea

READONLY:

   DATA cAlias               AS CHAR

   DATA nLockCount           INIT  0

EXPORT:

   DATA bZap                 INIT bTrue()


   METHOD Blank()   INLINE if( ::lOpen , Super:Blank() , NIL )

   METHOD Load()    INLINE if( ::lOpen , Super:Load() , NIL )
   METHOD Save()    INLINE if( ::lOpen , Super:Save()  , NIL )
   METHOD SetBuffer( lOnOff ) INLINE ;
                           if( ::lOpen , Super:SetBuffer(lOnOff), 0 )

   METHOD Append()  INLINE if( ::lOpen , Super:Append() , NIL )
   METHOD Bof()     INLINE if( ::lOpen , Super:Bof()  , .T. )
   METHOD Close()   INLINE if( ::lOpen , Super:Close() , NIL )

   // OJO  Tenia DBAppend()
   METHOD Commit()  INLINE if( ::lOpen , ( ::nArea )->( DbCommit() ),NIL)

   METHOD DbEval( bBlock, bFor, bWhile, nNext, nRecord, lRest ) INLINE ;
                iif( ::lOpen ,::Super:DbEval( bBlock, bFor, bWhile,;
                 nNext, nRecord, lRest ), NIL )

   METHOD Delete()  INLINE if( ::lOpen ,( ::nArea )->( DbDelete() ),NIL)


   METHOD Deleted() INLINE if( ::lOpen , Super:Deleted()  , NIL )
   METHOD Eof()     INLINE if( ::lOpen , Super:Eof()  , NIL )
   METHOD FCount()  INLINE if( ::lOpen , Super:FCount()  , NIL )
   METHOD FieldGet( nField ) INLINE ;
                           if( ::lOpen , Super:FieldGet(nField) , NIL )

   METHOD FieldPut( nField, uVal ) INLINE ;
                           if( ::lOpen , Super:FieldPut( nField, uVal),NIL)

   METHOD Found()   INLINE if( ::lOpen , Super:Found()  , .F. )
   METHOD GoTo( nRecNo ) INLINE iif( ::lOpen , ::Super:GoTo(nRecNo),NIL )
   METHOD GoTop() INLINE iif( ::lOpen , ::Super:GoTop(),NIL )
   METHOD GoBottom() INLINE iif( ::lOpen , ::Super:GoBottom() , NIL )

   METHOD LastRec() INLINE iif( ::lOpen , ::Super:LastRec(), 0 )
   METHOD Pack() INLINE iif( ::lOpen , ::Super:Pack() , NIL )
   METHOD ReCall() INLINE iif( ::lOpen , ::Super:ReCall() , NIL )

   METHOD RecCount() INLINE  ::LastRec()
   METHOD RecLock() INLINE iif( ::lOpen , ::Super:RecLock()  , NIL )
   METHOD RecNo() INLINE iif( ::lOpen , ::Super:RecNo()  , 0 )
   METHOD Seek( uExp, lSoft ) INLINE iif( ::lOpen ,;
                             ::Super:Seek(uExp,lSoft) , .F.)
   METHOD Skip( nRecords ) INLINE iif( ::lOpen , ::Super:Skip(nRecords),NIL)
   METHOD Skipper( nRecords ) INLINE iif(::lOpen,::Super:Skipper(nRecords),0)


   // --------------------
   METHOD Commit() INLINE iif( ::lOpen ,( ::nArea )->( DbAppend() ),NIL)

   METHOD New() INLINE Self
   METHOD lOpen(lRet):SETGET
   METHOD Lock()    = TVDbLock()
   METHOD UnLock()  = TVDbUnLock()
   
   METHOD Zap()
          
   METHOD Used() INLINE ::lOpen
   METHOD SetArea()
   METHOD ResetArea()

   METHOD Locate(bFor,bWhile,nNext,lRest) INLINE iif( ::lOpen ,;
             ( ::nArea )->( __DbLocate(bFor,bWhile,nNext,lRest) ),NIL)
   METHOD Continue() INLINE iif( ::lOpen ,( ::nArea )->( __DbContinue() ), NIL)

  // --------------  METODOS VIRTUALIZADOS

   METHOD Create()              VIRTUAL
   METHOD Use()                 VIRTUAL

                                // --------------

   METHOD AddIndex()            VIRTUAL
   METHOD CloseIndex()          VIRTUAL
   METHOD CreateIndex()         VIRTUAL
   METHOD ClearRelation()       VIRTUAL
   METHOD DeleteIndex()         VIRTUAL
   METHOD IndexKey()            VIRTUAL
   METHOD IndexOrder( )         VIRTUAL
   METHOD SetOrder()            VIRTUAL
   METHOD SetRelation()         VIRTUAL
   
ENDCLASS

//---------------------------------------------------------------------------
METHOD FUNCTION lOpen(lRet)
    lRet := ( ValType(::nArea) == "N" )
    lRet := iif( lRet , ::nArea > 0 , .f. )
Return( iif( lRet , ::Super:Used() , .f. ) )
//---------------------------------------------------------------------------
METHOD FUNCTION SetArea()
//   local nBackArea := Select()   // ??????
local nArea := 0
      FOR nArea := 0 TO 256
          DbSelectArea( nArea )
          if ( ! Used() )
             EXIT
          end
      NEXT
        // si nArea == 256 deberiamos generar un error de la clase
        // indicando que no quedan m s areas disponibles.
::Super:New( nArea )
Return(Self)
//---------------------------------------------------------------------------
METHOD FUNCTION ResetArea()
   ::Close()
   ::nArea := 0
   ::aBuffer := {}
Return(Self)
//---------------------------------------------------------------------------
METHOD FUNCTION TVDbLock()
local lRet := .f.
if (::lOpen )
   lRet := iif( ::nLockCount < 1 , ::Super:Lock() , .t. )
end
if ( lRet )
  ::nLockCount++
end
Return(lRet)
//---------------------------------------------------------------------------
METHOD FUNCTION TVDbUnLock()
::nLockCount--
::nLockCount := iif( ::nLockCount < 0 , 0 , ::nLockCount )
if ( ::nLockCount == 0 )
   ::Super:UnLock()
end
Return(NIL)
//---------------------------------------------------------------------------
METHOD FUNCTION Zap()
if ( Eval( ::bZap ) )
    ::Super:Zap()
end
Return(NIL)
//---------------------------------------------------------------------------






