#include <ClipApi.h>

//----------------------------------------------------------------------------//

CLIPPER LGETTEXTLI()   // NE()
{
   WORD wHandle = _parni( 1 );
   BYTE bBuffer[ 300 ];
   BYTE b, bPos = 0;
   BOOL bNoEoF;

   while( ( bNoEoF = _tread( wHandle, &b, 1 ) ) && b != 10 )
      bBuffer[ bPos++ ] = b;

   if( bPos )
      _storclen( bBuffer, bPos - 1, 2 );
   else
      _storc( "", 2 );

   _retl( bNoEoF );
}

//----------------------------------------------------------------------------//

CLIPPER cStrWord()   // cString, @ nOffset
{
   LPBYTE pString = _parc( 1 );
   BYTE bChar;
   WORD wStart    = _parni( 2 );
   WORD wEnd      = wStart;

   while( ( bChar = * ( pString + wEnd++ ) ) && bChar == ' ' );

   if( ! bChar )
      wEnd = wStart + 1;
   else
      while( ( bChar = * ( pString + wEnd++ ) ) && bChar != ' ' );

   _retclen( pString + wStart, wEnd - wStart - 1 );
   _storni( wEnd - 1, 2 );
}

//----------------------------------------------------------------------------//

WORD _TReadLn( WORD wHandle, LPBYTE pBuffer )
{
   BYTE b;
   LPBYTE pTemp = pBuffer;

   while( _tread( wHandle, &b, 1 ) && ( b != 13 ) )
      * pTemp++ = b;
   * pTemp++ = 0;

   _tread( wHandle, &b, 1 );           // 0 --> only 1 byte

   return pTemp - pBuffer;
}

//----------------------------------------------------------------------------//

CLIPPER nTxtLines()
{
   WORD wHandle;
   BYTE bBuffer[ 300 ];
   LONG lLines = 0;

   if( wHandle = _topen( _parc( 1 ), 0 ) )
   {
      while( _TReadLn( wHandle, bBuffer ) )
         lLines++;
      _tclose( wHandle );
   }

   _retnl( lLines );
}

//----------------------------------------------------------------------------//

CLIPPER cFReadLine()
{
   BYTE bBuffer[ 500 ];
   WORD wLineLen;

   if( wLineLen = _TReadLn( _parni( 1 ), bBuffer ) )
      _retclen( bBuffer, wLineLen );
   else
      _retc( "" );
}

//----------------------------------------------------------------------------//
