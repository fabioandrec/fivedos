#include <ClipApi.h>


extern void SetChar( char far * );  // En MSText.c
/*
#pragma option -k

static BYTE bCharScanLines( void )
{
    _AX = 0x1130;
    _BH = 0;
    asm int 0x10;  // Ojo que toca BP

    return _CX;
}
*/

//---------------------------------------------------------------------------//

CLIPPER SETChar()
{
    char cCharDef[ 17 ];

    if( _pcount >= 2 )
    {

        cCharDef[ 0 ] = _parni( 1 );
        // if( bCharScanLines() > 8 )
            _bcopy( (LPBYTE) cCharDef + 1, _parc( 2 ), 16 );
        /*
        else
        {
            int i;
            LPBYTE pSource = _parc( 2 );

            for( i = 0; i < 8; i++ )
               cCharDef[ 1 + i ] = pSource[ i * 2 ];

        }
        */
        SetChar( cCharDef );
    }

}
