#include <ClipApi.h>

//---------------------------------------------------------------------------//

CLIPPER lFReadStr()
{
   WORD wHandle = _parni( 1 );
   BYTE cBuffer[ 500 ];
   LPSTR szNil = "";
   WORD w = 0, wBytes;

   while( ( w < 250 ) &&
          ( wBytes = _tread( wHandle, cBuffer + w++, 1 ) ) &&
          ! ( ( w > 1 ) &&
              ( cBuffer[ w - 2 ] == 13 && cBuffer[ w - 1 ] == 10 ) ) );

   _retl( ( ( w > 1 ) ? _storclen( cBuffer, w - 2, 2 ):
                        _storclen( szNil, 0, 2 ) ) && wBytes );
}

//---------------------------------------------------------------------------//
