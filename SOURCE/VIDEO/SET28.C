#include <ClipApi.h>
#include <dos.h>

// poner la pantalla en modo 28 lineas
//-------------------------------------------------------------------

CLIPPER set28( )
{
    //  _set28() ;
    _AX =0x1111 ;
    asm int 0x10

    }
