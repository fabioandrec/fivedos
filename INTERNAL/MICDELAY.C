#include <ClipApi.h>
#include <Dos.h>

//---------------------------------------------------------------------------//
// Return TRUE if error.

BOOL MicroDelay( LONG lMicroSegs )
{
    _CX = FP_OFF( (void*) lMicroSegs );
    _DX = FP_SEG( (void*) lMicroSegs );
    _AX = 0x8600;
    asm int 0x15;

    return ( _FLAGS & 1 );

}

//---------------------------------------------------------------------------//
