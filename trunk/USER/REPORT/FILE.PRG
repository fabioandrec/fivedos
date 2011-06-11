#include "FiveDos.ch"

// Warning!, the buffer of File is Share.
// The information on buffer is reporter by last ::skip() by the last oFile.
//----------------------------------------------------------------------------//

CLASS TFile

   DATA cName   AS CHARACTER PROTECTED
   DATA cStruct AS CHARACTER HIDDEN

   MESSAGE New( cFileName )      EXTERN TFNew
   MESSAGE Open( nOpenMode )     EXTERN TFOpen   // See FileIO.ch
   MESSAGE Create( nCreateMode ) EXTERN TFCreate // See FileIO.ch
   MESSAGE Close()               EXTERN TFClose
   MESSAGE GoTop()               EXTERN TFGoTop
   MESSAGE RecNo()               EXTERN TFRecNo
   MESSAGE GoBottom()            EXTERN TFGoBottom
   MESSAGE Skip( nRecords )      EXTERN TFSkip
   MESSAGE Skipper( nRecords )   EXTERN TFSkipper
   MESSAGE ReadLN( nTabSize )    EXTERN TFReadLN
   MESSAGE LastRec()             EXTERN TFLastRec
   MESSAGE RecCount()            EXTERN TFLastRec
   MESSAGE Eof()                 EXTERN TFEof
   MESSAGE Bof()                 EXTERN TFBof
   MESSAGE GoTo( nRecord )       EXTERN TFGoTo
   MESSAGE WriteLN( cRecord, lInsert ) EXTERN TFWriteLN
   MESSAGE Append( nRecords )    EXTERN TFAppend
   MESSAGE Delete( nRecords )    EXTERN TFDelete
   MESSAGE Insert( nRecords )    EXTERN TFInsert

   METHOD Seek( cText )

   __TFInit()

ENDCLASS

//---------------------------------------------------------------------------//

                    // First Line OffSet
METHOD Seek( cText, nOffSet )  // -> Si lo encuentra Cambia Registro y devuelve offset del registro nuevo

    local nRec := ::RecNo(),;
          nAt  := 0,;
          cLine

    if ! empty( cText )

        DEFAULT nOffSet := 1

        cLine   = ::ReadLN()
        nOffSet = max( 1, Min( Len( cLine ), nOffSet ) )
        cLine   = substr( cLine, nOffSet, len( cLine ) - nOffSet + 1 )

        while ( nAt := AT( cText, cLine ) ) == 0 .and. !::Eof()
              ::Skip( 1 )
              cLine = ::ReadLN()
        end

        if nAt == 0
           ::GoTo( nRec )
        endif

    endif

return nAt

//---------------------------------------------------------------------------//
