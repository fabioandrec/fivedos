// Class TFile is the base class for binary files manipulation
// From this class we inherit all different kinds of files
// Developed by Ignacio Ortiz de Z£¤¡ga and Antonio Linares

#include "FiveWin.ch"
#include "FileIO.ch"

#define SEEK_FORWARD   0
#define SEEK_BACKWARD  1

#define SEEK_NOCASE    0
#define SEEK_UPCASE    1
#define SEEK_LOCASE    2

//----------------------------------------------------------------------------//

CLASS TFile

   DATA   cName, hFile, nLen, nBufferLen, nMode

   METHOD New( cFileName, nMode ) CONSTRUCTOR

   METHOD Create( cFileName, nMode ) CONSTRUCTOR

   METHOD Open()           INLINE ( ::hFile > 0 )

   METHOD Close()          INLINE FClose( ::hFile ), ::hFile := 0

   METHOD End()            INLINE ::Close()

   METHOD Skip( nBytes )   INLINE FSeek( ::hFile, nBytes, FS_RELATIVE )

   METHOD GoTo( nRecno )   INLINE FSeek( ::hFile, nRecno, FS_SET )

   METHOD GoTop()          INLINE  FSeek( ::hFile, 0, FS_SET )
   METHOD GoBottom()       INLINE  ::nLen := FSeek( ::hFile, 0, FS_END )

   METHOD lEoF()           INLINE  FSeek( ::hFile, 0, FS_RELATIVE ) == ::nLen
   METHOD lBoF()           INLINE  FSeek( ::hFile, 0, FS_RELATIVE ) == 0

   METHOD nGetByte()
   METHOD nGetWord()
   METHOD cGetStr( nLen )

   METHOD PutByte( nByte )
   METHOD PutWord( nWord )
   METHOD PutStr( cStr )   INLINE FWrite( ::hFile, cStr, len(cStr) )

   METHOD AppByte( nByte ) INLINE Fseek( ::hFile, 0, FS_END ) ,;
                                  ::PutByte( nByte )          ,;
                                  ::nLen++
   METHOD AppWord( nWord ) INLINE Fseek( ::hFile, 0, FS_END ) ,;
                                  ::PutWord( nWord )          ,;
                                  ::nLen += 2
   METHOD AppStr( cStr )   INLINE Fseek( ::hFile, 0, FS_END ) ,;
                                  ::PutStr( cStr )            ,;
                                  ::nLen += len( cStr )

   METHOD nRecNo()         INLINE FSeek( ::hFile, 0, FS_RELATIVE )

   METHOD Count( cStr )
   METHOD Seek( cStr, nDirection, nCase )

   METHOD DelBytes( nLen )
   METHOD InsBytes( nLen )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cFileName, nMode ) CLASS TFile

   ::cName := cFileName

   if File( cFileName )
      DEFAULT nMode := FO_READWRITE
      ::nMode = nMode
      ::hFile = FOpen( cFileName, nMode )
      ::nLen  = FSeek( ::hFile, 0, FS_END )
      FSeek( ::hFile, 0, FS_SET )
   else
      DEFAULT nMode := FC_NORMAL
      ::nMode = nMode
      ::hFile = FCreate( cFileName, nMode )
      ::nLen  = 0
   endif

   ::nBufferLen := 2048

return nil

//----------------------------------------------------------------------------//

METHOD Create( cFileName, nMode ) CLASS TFile

   FErase( cFileName )
   ::New( cFileName, nMode )

return nil

//----------------------------------------------------------------------------//

METHOD nGetByte() CLASS TFile

   local cByte := " "

return If( FRead( ::hFile, @cByte, 1 ) == 1, Asc( cByte ), -1 )

//----------------------------------------------------------------------------//

METHOD nGetWord() CLASS TFile

   local cWord := "  "

return If( FRead( ::hFile, @cWord, 2 ) == 2, Bin2I( cWord ), -1 )

//----------------------------------------------------------------------------//

METHOD cGetStr( nLen ) CLASS TFile

   local cStr := Space(nLen)
   local nRead

   nRead := FRead( ::hFile, @cStr, nLen )

return Left(cStr, nRead)

//----------------------------------------------------------------------------//

METHOD PutByte( nByte ) CLASS TFile

   local cByte := Chr( nByte )

return FWrite( ::hFile, @cByte, 1 )

//----------------------------------------------------------------------------//

METHOD PutWord( nWord ) CLASS TFile

   local cWord := I2Bin( nWord )

return FWrite( ::hFile, @cWord, 2 )

//----------------------------------------------------------------------------//

METHOD Count( cStr ) CLASS TFile

   local cBuffer
   local nCounter, nRecno, nAt

   DEFAULT cStr := CRLF

   IF ::nLen == 0
     RETU 0
   ENDIF

   nCounter := 0
   nRecno   := Fseek( ::hFile, 0, FS_RELATIVE )

   FSeek( ::hFile, 0, FS_SET )

   while ! ::lEof()
     cBuffer := ::cGetStr( ::nBufferLen )
     while ( nAt := At( cStr, cBuffer ) ) > 0
        nCounter++
        cBuffer := Substr( cBuffer, nAt + Len( cStr ) )
     end
   end

   Fseek( ::hFile, nRecno, FS_SET )

return nCounter

//----------------------------------------------------------------------------//
// Always from current pointer position

METHOD Seek( cStr, nDirection, nCase ) CLASS TFile

   local cBuffer
   local nRecno, nOffset, nAt, nBufferLen, nCounter

   DEFAULT nDirection := SEEK_FORWARD ,;
           nCase      := SEEK_NOCASE

   nRecno     := Fseek( ::hFile, 0, FS_RELATIVE )
   nBufferLen := ::nBufferLen
   nCounter   := 0
   cBuffer    := space(nBufferLen)

   While len(cBuffer) == ::nBufferLen

     IF nDirection == SEEK_BACKWARD
          nRecno     :=Fseek( ::hFile, 0, FS_RELATIVE )
          nBufferLen := Min(nBufferLen, nRecno)
          Fseek( ::hFile, -nBufferLen, FS_RELATIVE )
     ENDIF

     nOffset := Fseek( ::hFile, 0, FS_RELATIVE )
     cBuffer := ::cGetStr(nBufferLen)

     Do Case
     Case nCase == SEEK_UPCASE
          cBuffer := Upper(cBuffer)
     Case nCase == SEEK_LOCASE
          cBuffer := Lower(cBuffer)
     EndCase

     If nDirection == SEEK_FORWARD
          nAt := At(cStr,cBuffer)
     Else
          nAt := Rat(cStr,cBuffer)
     Endif

     If nAt > 0
          Fseek( ::hFile, nOffset + nAt - 1 , FS_SET )
          retu .T.
     Endif

     IF nDirection == SEEK_FORWARD
          Fseek( ::hFile, -len(cStr), FS_RELATIVE )
     ELSE
          Fseek( ::hFile, len(cStr), FS_RELATIVE )
     ENDIF

   Enddo

   Fseek( ::hFile, nRecno, FS_SET )

return .F.

//----------------------------------------------------------------------------//
// Always from current pointer position

METHOD DelBytes( nLen ) CLASS TFile

     LOCAL cTmpFile, cBuffer
     LOCAL nHandle, nRecno, nCopy, nRead

     IF nLen == NIL .OR. empty(nLen)
          RETU .F.
     ENDIF

     cTmpFile := NoExt(::cName)+".#$#"
     cBuffer  := space(::nBufferLen)
     nHandle  := Fcreate(cTmpFile)
     nRecno   := Fseek( ::hFile, 0, FS_RELATIVE )
     nCopy    := 0

     IF nHandle < 0
          RETU .F.
     ENDIF

     Fseek( ::hFile, 0, FS_SET )

     DO WHILE nRecno > 0 .AND. Fseek( ::hFile, 0, FS_RELATIVE ) < nRecno
          nRead := FRead( ::hFile, @cBuffer, ::nBufferLen )
          nCopy := Min(nRead, nRecno - FSeek( nHandle, 0, FS_RELATIVE ) )
          FWrite(nHandle, cBuffer, nCopy)
     ENDDO

     Fseek( ::hFile, nRecno + nLen, FS_SET )

     nRead := ::nBufferLen

     DO WHILE nRead == ::nBufferLen
          nRead := FRead( ::hFile, @cBuffer, ::nBufferLen )
          FWrite(nHandle, cBuffer, nRead)
     ENDDO

     Fclose(nHandle)
     Fclose(::hFile)

     Ferase(::cName)
     Frename(cTmpFile, ::cName)
     ::nMode := FO_READWRITE + FO_EXCLUSIVE
     ::hFile = FOpen( ::cName, ::nMode )

     nRecno++

     IF nRecno >= ::nLen
          ::nLen := Fseek( ::hFile, 0, FS_END )
     ELSE
          Fseek( ::hFile, nRecno+1, FS_SET )
     ENDIF

     ::nLen -= nLen

RETURN .T.

//----------------------------------------------------------------------------//
// Always from current pointer position

METHOD InsBytes( nLen ) CLASS TFile

     LOCAL cTmpFile, cBuffer
     LOCAL nHandle, nRecno, nCopy, nRead

     IF nLen == NIL .OR. empty(nLen)
          RETU .F.
     ENDIF

     IF ::lEof()
          ::AppStr( Space(nLen) )
          RETU .T.
     ENDIF

     cTmpFile := NoExt(::cName)+".#$#"
     cBuffer  := space(::nBufferLen)
     nHandle  := Fcreate(cTmpFile)
     nRecno   := Fseek( ::hFile, 0, FS_RELATIVE )
     nCopy    := 0

     IF nHandle < 0
          RETU .F.
     ENDIF

     Fseek( ::hFile, 0, FS_SET )

     DO WHILE nRecno > 0 .AND. Fseek( ::hFile, 0, FS_RELATIVE ) < nRecno
          nRead := FRead( ::hFile, @cBuffer, ::nBufferLen )
          nCopy := Min(nRead, nRecno - FSeek( nHandle, 0, FS_RELATIVE ) )
          FWrite(nHandle, cBuffer, nCopy)
     ENDDO

     Fseek( ::hFile, nRecno, FS_SET )
     Fwrite(nHandle, space(nLen), nLen)

     nRead := ::nBufferLen

     DO WHILE nRead == ::nBufferLen
          nRead := FRead( ::hFile, @cBuffer, ::nBufferLen )
          FWrite(nHandle, cBuffer, nRead)
     ENDDO

     Fclose(nHandle)
     Fclose(::hFile)

     Ferase(::cName)
     Frename(cTmpFile, ::cName)
     ::nMode := FO_READWRITE + FO_EXCLUSIVE
     ::hFile := FOpen( ::cName, ::nMode )
     Fseek( ::hFile, nRecno, FS_SET )
     ::nLen += nLen

RETURN .T.

//-------------------------------------------------------------------------//

STATIC FUNCTION NoExt( cFile )

    local i := at( ".", cFile )

RETURN alltrim( if( i > 0, left( cFile, i-1 ), cFile ) )
