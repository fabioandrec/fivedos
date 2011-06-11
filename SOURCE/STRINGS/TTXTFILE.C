/*
ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
บ Mขdulo: TFile.c                                               บ
บ Lenguaje: C Para Clipper 5.xx                                 บ
บ Fecha: Nov.   1993                                            บ
ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
*/
#pragma inline

#include <ClipApi.h>

//- ----------------------------------------------------- From FileIO.ch

// Error value (all functions)
#define F_ERROR      (-1)
// FSEEK() modes
#define FS_SET       0     // Seek from beginning of file
#define FS_RELATIVE  1     // Seek from current file position
#define FS_END       2     // Seek from end of file
// FOPEN() access modes
#define FO_READ      0     // Open for reading (default)
#define FO_WRITE     1     // Open for writing
#define FO_READWRITE 2     // Open for reading or writing
// FOPEN() sharing modes (combine with open mode using +)
#define FO_COMPAT    0     // Compatibility mode (default)
#define FO_EXCLUSIVE 16    // Exclusive use (other processes have no access)
#define FO_DENYWRITE 32    // Prevent other processes from writing
#define FO_DENYREAD  48    // Prevent other processes from reading
#define FO_DENYNONE  64    // Allow other processes to read or write
#define FO_SHARED    64    // Same as FO_DENYNONE
// FCREATE() file attribute modes
// NOTE:  FCREATE() always opens with (FO_READWRITE + FO_COMPAT)
#define FC_NORMAL    0     // Create normal read/write file (default)
#define FC_READONLY  1     // Create read-only file
#define FC_HIDDEN    2     // Create hidden file
#define FC_SYSTEM    4     // Create system file

//- --------------------------------------------------------- end fileio.ch


extern int  _terror;
extern int  _tcommit( int );

typedef struct
{
   WORD wDummy[ 3 ];
} OVM;

typedef OVM* OVMP;

extern OVMP  _vmAlloc( WORD );
extern char* _vmLock( OVMP );
extern char* _vmDirtyPtr( OVMP );
extern void  _vmUnLock( OVMP );
extern void  _vmFree( OVMP );

extern LPBYTE pascal _VSTRX( PCLIPVAR );

static LONG near lSkip( int );
static int  near iScanEol( char *, int );
static int  near iScanBol( char *, int );
static void near RetSelf( void );
static void near SetStruct( void );
static void near GetStruct( void );
static long lFileMove( long read1, long read2, long end1, long end2,
                        char *pBuff1, char *pBuff2 );

CLIPPER TFNew( void );     // ( cFileName )   -> Initiated TFile Object.
CLIPPER TFOpen( void );    // ( nOpenMode )   -> Handle. Si > 0 OK.
CLIPPER TFCreate( void );  // ( nCreateMode ) -> Handle. Si > 0 OK.
CLIPPER TFClose( void );   // ( )             -> lClosed
CLIPPER TFGoTop( void );   // ()              -> nil
CLIPPER TFRecno( void );   // ()              -> nRecno    ( nLine )
CLIPPER TFGoBottom( void );// ()              -> nil
CLIPPER TFSkip( void );    // ( +- nLines )   -> nil
CLIPPER TFSkipper( void ); // ( +- nLines )   -> +- nLinesSkiped
CLIPPER TFReadLn( void );  // ( nTabExpand )  -> cLine
CLIPPER TFLastRec( void ); // ()              -> nLastRec
CLIPPER TFEof( void );    // ()              -> BOOL
CLIPPER TFBof( void );    // ()              -> BOOL
CLIPPER TFGoTo( void );   // ( nLine )       -> nil
CLIPPER TFWriteLn( void ); // ( cCadena, lInsert ) -> nil
CLIPPER TFAppend( void );  // ( nLines )      -> nil
CLIPPER TFDelete( void );  // ( nLines )      -> nil
CLIPPER TFInsert( void );  // ( nLines )      -> nil
        

// TFile instances.
#define OT_cFILENAME      1
#define OT_cFILESTRT      2


// Allocation sizes
#define BIGBLOCK   4096
#define LITBLOCK   1024
#define KBIGBLOCK     4
#define KLITBLOCK     1

typedef struct
{
    long lRecno;
    long lOffSet;
    int  iHandle;
    long lLastRec;
    long lLastOff;
    long lLastByte;
    int  isEof;

} OFILE;

static OFILE * oFile;

static BOOL bCharged = FALSE;

// Nuestro Handle.
static WORD wHandle = 0;

static char crlf[] = { (char) 0x0D, (char) 0x0A };

static OVMP oMBuff = 0;     // Buffer normal de 1Kb.
static OVMP oMBig1;         // 1er. Buffer Gordo  de 4Kb.
static OVMP oMBig2;         // 2ง Buffer Gordo  de 4Kb.


//---------------------------------------------------------------------------//

static void near RetSelf()
{
    _bcopy( (LPBYTE) _eval, (LPBYTE) ( _lbase + 1), 14 );
}

//---------------------------------------------------------------------------//

static void near SetStruct()
{
    if( bCharged )
    {
       _VSTRUNLOCK( _tos );
       // _cAtPut( _lbase + 1, OT_cFILESTRT, _tos-- );
       bCharged = FALSE;
    }
}

//---------------------------------------------------------------------------//

static void near GetStruct()
{
    if( !bCharged )
    {
       _cAt( _lbase + 1, OT_cFILESTRT, -1, ++_tos );
       _VSTRLOCK( _tos );
       oFile = ( OFILE * ) _VSTRX( _tos );
       bCharged = TRUE;
    }
}

//---------------------------------------------------------------------------//

CLIPPER TFNew() // ( cFileName )
{
    PCLIPVAR pcFile = _param( 1, CHARACTER );

    if( pcFile )
    {
       _cAtPut( _lbase + 1, OT_cFILENAME, pcFile );
    }

    _BYTESNEW( sizeof( OFILE ) );
    _VSTRLOCK( _eval );

    _bset( (LPBYTE) _VSTRX( _eval ), 0, sizeof( OFILE ) );
    _VSTRUNLOCK( _eval );

    _cAtPut( _lbase + 1, OT_cFILESTRT, _eval );

    // Un mtodo constuctor debe devolver SELF.
    RetSelf();

    
}

//---------------------------------------------------------------------------//

CLIPPER TFOpen() // ( nOpenMode )
{
    int iOpenAttr = _param( 1, ANYNUMBER ) ? _parni( 1 ) : FO_READ | FO_DENYNONE;

    GetStruct();

    if( !oFile->iHandle )
    {
       oFile->iHandle   = _topen( _parc( 0, OT_cFILENAME ), iOpenAttr ) ;
       if( oFile->iHandle != -1 )
       {
            oFile->lOffSet   = 0;
            oFile->lRecno    = 1;
            oFile->lLastByte = _tlseek( oFile->iHandle, 0, FS_END );
       }

    }

    _retni( oFile->iHandle );

    SetStruct();
}

//---------------------------------------------------------------------------//

CLIPPER TFCreate() // ( nCreateMode )
{
    int iCreaAttr = ( _param( 1, ANYNUMBER ) ? _parni( 1 ) : FC_NORMAL );

    GetStruct();

    if( !oFile->iHandle )
    {
       oFile->iHandle   = _tcreat( _parc( 0, OT_cFILENAME ), iCreaAttr ) ;
       oFile->lOffSet   = 0;
       oFile->lRecno    = 1;
       if( oFile->iHandle > 0 )
            oFile->lLastByte = _tlseek( oFile->iHandle, 0, FS_END );
    }

    _retni( oFile->iHandle );

    SetStruct();
}

//---------------------------------------------------------------------------//

CLIPPER TFClose() // ()
{
    GetStruct();

    if( oFile->iHandle )
    {
       _tclose( oFile->iHandle );
         
       _bset( (LPBYTE) ( oFile ), 0, sizeof( OFILE ) );

       _retl( TRUE );
    }
    else
       _retl( FALSE );

    SetStruct();
}

//---------------------------------------------------------------------------//

CLIPPER TFGoTop() // ()
{
    GetStruct();

    oFile->lOffSet = 0;
    oFile->lRecno  = 1;

    SetStruct();
}

//---------------------------------------------------------------------------//

CLIPPER TFRecno() // ()
{
    GetStruct();

    _retnl( oFile->lRecno );

    SetStruct();
}

//---------------------------------------------------------------------------//

CLIPPER TFGoBottom() // ()
{
    int  iEolOffSet;
    int  iLen, iBlockLen;
    char * cBuff, * cTemp;

    GetStruct();

    if( oFile->iHandle )
    {

        if( oFile->lLastRec != 0 )
        {
            oFile->lRecno  = oFile->lLastRec;
            oFile->lOffSet = oFile->lLastOff;
        }
        else
        {
            cBuff  = _vmLock( oMBig1 );

            do
            {
                cTemp = cBuff;

                _tlseek( oFile->iHandle, oFile->lOffSet, FS_SET );
                iLen  = _tread(  oFile->iHandle, cTemp, BIGBLOCK );
                iBlockLen = iLen;
                do
                {
                     iEolOffSet = iScanEol( cTemp, iLen );
                     if( ( iEolOffSet == iLen ) ||
                         ( ( iEolOffSet + 1 ) == iLen ) )
                     {
                        break;
                     }
                     cTemp   += iEolOffSet + 2;
                     iLen    -= ( iEolOffSet + 2 );
                     oFile->lRecno++;
                     oFile->lOffSet += iEolOffSet + 2;

                } while ( ( iLen > 0 ) );

            } while ( iBlockLen == BIGBLOCK );

            oFile->lLastRec = oFile->lRecno;
            oFile->lLastOff = oFile->lOffSet;
            _vmUnLock( oMBig1 );
        }
    }

    SetStruct();

    lSkip( -1 );
}

//---------------------------------------------------------------------------//

CLIPPER TFSkip()
{
    GetStruct();

    if( oFile->iHandle )
    {
        if( _param( 1, ANYNUMBER ) )
            lSkip( _parni( 1 ) );
        else
            lSkip( 1 );
    }
    SetStruct();
}

//---------------------------------------------------------------------------//

CLIPPER TFSkipper()
{
    long lOldRec;

    GetStruct();

    if( oFile->iHandle )
    {
        lOldRec = oFile->lRecno;
        _retnl( ( _param( 1, ANYNUMBER ) ? lSkip( _parni( 1 ) ) : lSkip( 1 ) )
                 - lOldRec );
    }
    SetStruct();
}

//---------------------------------------------------------------------------//

static long near lSkip( int iRecs )
{

   int  iEolOffSet;
   LONG lReadPos;
   int  iLen;
   int  icRecs;
   char * cBuff = _vmLock( oMBuff );

   if ( iRecs > 0 )
   {
      for( icRecs = 0; icRecs < iRecs; icRecs++ )
      {
         _tlseek( oFile->iHandle, oFile->lOffSet, FS_SET );
         iLen = _tread( oFile->iHandle, cBuff, LITBLOCK );

         iEolOffSet = iScanEol( cBuff, iLen );

         if ( ( iEolOffSet != iLen ) &&
              ( ( oFile->lOffSet + iEolOffSet + 2 ) < oFile->lLastByte ) )
         {
            oFile->isEof    = FALSE;
            oFile->lOffSet += ( iEolOffSet + 2 );
            oFile->lRecno++;
         }
         else
         {
            oFile->isEof = TRUE;
            icRecs      = iRecs; // termina bucle
         }
      }
   }
   else
   {
      iRecs       = -iRecs;
      oFile->isEof = FALSE;

      if ( ( oFile->lRecno - iRecs ) > 1 )      // <--- reversed if condition
      {
         for ( icRecs = iRecs; icRecs > 0; icRecs-- )
         {
            if ( LITBLOCK > oFile->lOffSet )
            {
               lReadPos = 0;
               iLen     = (int) oFile->lOffSet;
            }
            else
            {
               lReadPos = oFile->lOffSet - LITBLOCK;
               iLen     = LITBLOCK;
            }

            _tlseek( oFile->iHandle, lReadPos, FS_SET );

            iLen = _tread( oFile->iHandle, cBuff, iLen );

            iEolOffSet = iScanBol( cBuff, iLen ) ;

            if( iLen - iEolOffSet )
            {
                iEolOffSet = iScanBol( cBuff, iEolOffSet ) ;
                oFile->lOffSet = lReadPos + iEolOffSet + 2;
                oFile->lRecno--;
            }
            else
            {
               oFile->lOffSet = 0;
               oFile->lRecno  = 1;
            }
         }
      }
      else
      {
         oFile->lOffSet = 0;
         oFile->lRecno  = 1;
      }
   }

   _vmUnLock( oMBuff );

   return ( oFile->lRecno );

}

//---------------------------------------------------------------------------//

static WORD near wTabExpand( LPBYTE pTgt, LPBYTE pSrc, WORD wSrcLen, WORD wTabSize )
{
    WORD w, wSrc, wTgt = 0;

    for( wSrc = 0; wSrc < wSrcLen; wSrc++ )
    {
        if( pSrc[ wSrc ] == 9 )
        {
            for( w = 0; w < wTabSize; w++ )
                 pTgt[ wTgt++ ] = 32;
        }
        else
            pTgt[ wTgt++ ] = pSrc[ wSrc ];
    }

    return wTgt;
}

//---------------------------------------------------------------------------//

CLIPPER TFReadLn( void ) // nTabExpand
{
   int iTabSize = _parni( 1 );
   int iEolOffSet;
   int iRead;
   char * cBuff = _vmLock( oMBuff );

   GetStruct();

   if( oFile->iHandle )
   {

       _tlseek( oFile->iHandle, oFile->lOffSet, FS_SET );

       iRead      = (int) _tread( oFile->iHandle, cBuff, LITBLOCK );

       iEolOffSet = iScanEol( cBuff, iRead );

       if( !iTabSize )
           _retclen( cBuff, iEolOffSet );
       else
       {
           char * cBig = _vmLock( oMBig1 );
           WORD wNewSize =  wTabExpand( cBig, cBuff, iEolOffSet, iTabSize );

           _retclen( cBig, wNewSize );
           _vmUnLock( oMBig1 );
       }

   }
   else
      _retc( "" );

   _vmUnLock( oMBuff );

   SetStruct();

}

//---------------------------------------------------------------------------//

CLIPPER TFLastRec()
{
   LONG  lOldRec;
   LONG  lOldOffSet;

   GetStruct();

   lOldRec    = oFile->lRecno;
   lOldOffSet = oFile->lOffSet;

   TFGoBottom();

   GetStruct();

   _retnl( oFile->lLastRec );

   oFile->lRecno  = lOldRec;
   oFile->lOffSet = lOldOffSet;

   SetStruct();

}

//---------------------------------------------------------------------------//

CLIPPER TFBof()
{
   GetStruct();
   _retl( ( oFile->lRecno == 1 ) );
   SetStruct();
}


//---------------------------------------------------------------------------//

CLIPPER TFEof()
{
   GetStruct();
   _retl( oFile->isEof );
   SetStruct();
}

//---------------------------------------------------------------------------//

CLIPPER TFGoTo() // ( nRec )
{
   LONG lTarget  = _parnl( 1 );
   LONG lLastRec = 0;

   GetStruct();

   if( oFile->iHandle )
   {
       if ( oFile->lRecno > lTarget )
       {
          while ( oFile->lRecno != lTarget )
          {
             lLastRec = oFile->lRecno;
             lSkip( -1 );
             if ( oFile->lRecno == lLastRec )
                break;
          }
       }
       else
       {
          while ( oFile->lRecno != lTarget )
          {
             lLastRec = oFile->lRecno;
             lSkip( 1 );
             if ( oFile->lRecno == lLastRec )
                break;
          }
       }
   }

   SetStruct();
}

//---------------------------------------------------------------------------//

CLIPPER TFWriteLn() // ( cCadenaToWrite, lInsertMode )
{
   int iEolOffSet;
   char * cBuff = _parc( 1 );
   int iLen     = _parclen( 1 );
   long read1;
   long read2;
   long end1;
   long end2;

   if( oFile->iHandle )
   {
       char * pTmp  = _vmLock( oMBuff );
       char * pBig1 = _vmLock( oMBig1 );
       char * pBig2 = _vmLock( oMBig2 );

       GetStruct();

       /* find end of first record to be replaced */

       end1  = _tlseek( oFile->iHandle, oFile->lOffSet, FS_SET );
       read1 = _tread ( oFile->iHandle, pTmp, LITBLOCK );

       /* if insert mode, leave pointer alone and skip below */

       if( _param( 2, LOGICAL ) && _parl( 2 ) )
       {
          iEolOffSet = 0;
       }
       else
       {
          iEolOffSet = iScanEol( pTmp, (int) read1 );
       }

       /* save two buffers' worth of data from end of record on */
                                //
       _tlseek( oFile->iHandle, end1 + iEolOffSet, FS_SET );
       read1 = _tread( oFile->iHandle, pBig1, BIGBLOCK );  /* now read in a big glob */
       read2 = _tread( oFile->iHandle, pBig2, BIGBLOCK );  /* now read in a big glob */
       end2  = end1 + read1 + read1 + iEolOffSet;

       /* write the new record */
                                //
       _tlseek( oFile->iHandle, end1, FS_SET );
       _twrite( oFile->iHandle, cBuff, iLen );
       end1 +=  (long)iLen;

       end1 = lFileMove( read1, read2, end1, end2, pBig1, pBig2 ); /* loop to write */
                                //
       _tlseek( oFile->iHandle, end1, FS_SET );
       _twrite( oFile->iHandle, pBig1, 0 );
       oFile->lLastRec  = 0;
       oFile->lLastByte = _tlseek( oFile->iHandle, 0L, FS_END );
       _vmUnLock( oMBuff );
       _vmUnLock( oMBig1 );
       _vmUnLock( oMBig2 );

       SetStruct();

   }
}

//---------------------------------------------------------------------------//

CLIPPER TFAppend() // nLines
{
   int iLines = ( ISNUM( 1 ) ? _parni( 1 ) : 1 );
   long read1;
   int iIdx;

   if( oFile->iHandle )
   {
       char * pBuff = _vmLock( oMBuff );

       /* go to end of file */

       TFGoBottom();

       GetStruct();

       /* find end of record */

       _tlseek( oFile->iHandle, oFile->lOffSet, FS_SET );
       read1 = _tread( oFile->iHandle, pBuff, LITBLOCK );

       /* determine if CRLF pair exists, if not, add one */

       if ( iScanEol( pBuff, (int)read1 ) == (int)read1 )
       {
          _tlseek( oFile->iHandle, oFile->lLastByte, FS_SET );
          _twrite( oFile->iHandle, crlf, 2 );
          iLines--;
       }

       /* loop to write new lines */

       for( iIdx = 0; iIdx < iLines; iIdx++ )
           _twrite( oFile->iHandle, crlf, 2 );

       _vmUnLock( oMBuff );

       oFile->lLastRec = 0L;

       TFGoBottom();  // El SetStruct() de gobottom guarda los datos del objeto.
   }
}

//---------------------------------------------------------------------------//

CLIPPER TFDelete() // ( nLines )
{
   int  iLines = ( ISNUM( 1 ) ? _parni( 1 ) : 1 );
   long read1;
   long read2;
   long end1;
   long end2;
   long lCurRec;
   long lCurOff;

   if( oFile->iHandle )
   {
       char * pBig1 = _vmLock( oMBig1 );
       char * pBig2 = _vmLock( oMBig2 );

       GetStruct();

       lCurRec = oFile->lRecno;
       lCurOff = oFile->lOffSet;

       /* save address to current record ( first record to be deleted ) */
       end1 = lCurOff;

       /* skip over deleted records, point to first 'to be retained' record */

       lSkip( iLines ) ;
       _tlseek( oFile->iHandle, oFile->lOffSet, FS_SET );

       /* save two buffers' worth of data */
       read1 = _tread( oFile->iHandle, pBig1, BIGBLOCK );  /* now read in a big glob */
       read2 = _tread( oFile->iHandle, pBig2, BIGBLOCK );  /* now read in a big glob */
       end2  = oFile->lOffSet+ read1 + read1;

       end1 = lFileMove( read1, read2, end1, end2, pBig1, pBig2 ); /* loop to write */
                                //
       _tlseek( oFile->iHandle, end1, FS_SET );
       _twrite( oFile->iHandle, pBig1, 0 );
       oFile->lLastRec  = 0;
       oFile->lLastByte = _tlseek( oFile->iHandle, 0L, FS_END );
       oFile->lRecno    = lCurRec;
       oFile->lOffSet   = lCurOff;

       _vmUnLock( oMBig1 );
       _vmUnLock( oMBig2 );

       SetStruct();
   }
}

//---------------------------------------------------------------------------//

CLIPPER TFInsert() // ( [ nLines ] )
{
   int iLines = ( ISNUM( 1 ) ? _parni( 1 ) : 1 );
   long read1;
   long read2;
   long end1;
   long end2;

   if( oFile->iHandle )
   {
       char * pBig1 = _vmLock( oMBig1 );
       char * pBig2 = _vmLock( oMBig2 );

       GetStruct();

       /* find end of first record to be replaced */
       end1 = _tlseek( oFile->iHandle, oFile->lOffSet, FS_SET );

       /* save two buffers' worth of data from current record */
       read1 = _tread( oFile->iHandle, pBig1, BIGBLOCK );  /* now read in a big glob */
       read2 = _tread( oFile->iHandle, pBig2, BIGBLOCK );  /* now read in a big glob */
       end2  = end1 + read1 + read2;

       /* write the new records */
                                //
       _tlseek( oFile->iHandle, end1, FS_SET );


       /* need this loop to consider that No. lines inserted may be more than
          the amount saved by the two buffers above
       */

       do
       {
          _twrite( oFile->iHandle, crlf, 2 );
          end1 += 2;
       } while( --iLines );

       end1 = lFileMove( read1, read2, end1, end2, pBig1, pBig2 ); /* loop to write */
                                                   //
       oFile->lLastByte = _tlseek( oFile->iHandle, end1, FS_SET );
       oFile->lLastRec  = 0L;
       _twrite( oFile->iHandle, pBig1, 0 );

       _vmUnLock( oMBig1 );
       _vmUnLock( oMBig2 );

       SetStruct();
   }
}

//---------------------------------------------------------------------------//

//  Busca el Par CRLF en un buffer.

static int near iScanEol( char *buf, int buf_len )
{
   if( buf_len <= 0 )
       return 0;

   asm {
            push  di             // save flags and registers
            push  es
            pushf
            cld                  // move forward
            les   di, buf        // point to buffer
            mov   bx, di         // save buffer start for offset calc later
            mov   cx, buf_len    // scan entire buffer
            mov   al, 00Dh
       }
   _feol1:
   asm {
            repne scasb        // look for a CR
            jcxz  _feolerr       // no find, return entire buffer
            cmp   byte ptr es:[di], 00Ah    // got a CRLF pair?
            jne   _feol1
            dec   di
            jmp   _feoldone
       }

   _feolerr:
   asm {
            mov   di, bx         // on no find return entire length of buffer
            add   di, buf_len    //  but truncate any LF or EOF markers
            cmp   byte ptr es:[di-1], 01Ah // test for end of file marker
            je    _feolerr1
            cmp   byte ptr es:[di-1], 00Ah // test for an errant LF
            jne   _feoldone
       }

   _feolerr1:
   asm      dec   di;

   _feoldone:
   asm {
            mov   ax, di         // subtract current pointer pos from start to
            sub   ax, bx         // learn offset within buffer
            popf
            pop   es
            pop   di
       }

   return _AX;
}

//---------------------------------------------------------------------------//

//  Busca el Par CRLF en un buffer. PA' atras.

static int near iScanBol( char *buf, int buf_len )
{
   asm {
            push  di             // save flags and registers
            push  es
            pushf
            std                  // move back'rdz
            les   di, buf        // point to buffer tail
            mov   bx, di         // save buffer start for offset calc later
            add   di, buf_len
            dec   di
            mov   cx, buf_len    // scan entire buffer
            mov   al, 00Dh
       }
   _fbol1:
   asm {
            repne scasb          // look for a CR
            jcxz  _fbolerr       // no find, return entire buffer
            cmp   byte ptr es:[di+2], 00Ah  // check for CRLF pair
            jne   _fbol1
            inc   di             // yes, point to CR
            jmp   _fboldone      // otherwise keep looking
       }
   _fbolerr:
   asm      mov   di, bx;        // on no find return length of buffer
   _fboldone:
   asm {
            mov   ax, di         // subtract current pointer pos from start to
            sub   ax, bx         //  learn offset within buffer
            popf
            pop   es
            pop   di
       }

   return _AX;
}

//---------------------------------------------------------------------------//

// Mueve texto en el fichero arriba ข abajo despues de "Insert" ข "delete".

static long lFileMove( long read1, long read2, long end1, long end2,
                       char * pBuff1, char * pBuff2 )
{
   do
   {                           //
      _tlseek( oFile->iHandle, end1, FS_SET );
      _twrite( oFile->iHandle, pBuff1, (int)read1 );
      end1 += read1 ;     // end1 should now point to eof

      if( read2 == 0 )
      {
         break;
      }
                               //
      _tlseek( oFile->iHandle, end2, FS_SET );
      read1 = _tread( oFile->iHandle, pBuff1, BIGBLOCK );
      end2 += read1;
                               //
      _tlseek( oFile->iHandle, end1, FS_SET );
      _twrite( oFile->iHandle, pBuff2, (int)read2 );
      end1 += read2 ;
                               //
      _tlseek( oFile->iHandle, end2, FS_SET );
      read2 = _tread( oFile->iHandle, pBuff2, BIGBLOCK );   // now read in a big glob
      end2 += read2 ;

   } while ( read1 > 0 );

   return ( end1 );

}


//---------------------------------------------------------------------------//

CLIPPER __TFInit() // ( nClassHandle )
{
    if( !oMBuff )
    {
        oMBuff  = _vmAlloc( KLITBLOCK );
        oMBig1  = _vmAlloc( KBIGBLOCK );
        oMBig2  = _vmAlloc( KBIGBLOCK );
    }
}

//---------------------------------------------------------------------------//

CLIPPER TFError( void )
{
    _retni( _terror );
}

//---------------------------------------------------------------------------//
