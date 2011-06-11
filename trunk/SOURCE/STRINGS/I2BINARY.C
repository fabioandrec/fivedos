#include <ClipApi.h>


//---------------------------------------------------------------------------//

CLIPPER i2Binary( void )
{
    WORD wNumber = _parni( 1 );
    BYTE bString[ 17 ];
    WORD wTest   = 0x8000;
    WORD wCount  = 0;

    bString[ 16 ] = 0;

    for( wCount = 0; wCount < 16 ; wCount++ )
    {
        bString[ wCount ] = '0' + IF( wNumber & wTest, 1, 0 );
        wTest = wTest >> 1;
    }

    _retc( bString );
}

//---------------------------------------------------------------------------//
