#include <ClipApi.h>

//---------------------------------------------------------------------------//

CLIPPER cDrive()            // Devuelve la letra del Drive por defecto
{
    BYTE bDrive;
    BYTE cResult[ 2 ];

    asm {
            mov ah, 0x19
            int 0x21;
            mov bDrive, al;
        }

   cResult[ 0 ] = bDrive + 'A';
   cResult[ 1 ] = 0;

   _retc( cResult );
}

//---------------------------------------------------------------------------//

/* Devuelve el tipo de Drive:
       0 Desconocido
       1 360K, 5.25, 40 pistas
       2 1.2M, 5.25, 80 pistas
       3 720K, 3.5 , 80 pistas
       4 1.4M, 3.5 , 80 pistas ???
*/

CLIPPER nDriveType()
{
   char cDrive = _parni( 1 );
   char cType = 1;

   _AH = 8;
   _DL = cDrive;
   asm int 0x13;
   cType = _BL;

   _retni( cType );
}

//---------------------------------------------------------------------------//

CLIPPER nLogDrives()
{
   unsigned char nDefaultDrive;

   _AH = 0x19;
   asm int 0x21;
   nDefaultDrive = _AL;

   _AH = 0x0E;
   _DL = nDefaultDrive;
   asm int 0x21;

   _retni( _AL );
}

//---------------------------------------------------------------------------//

    // Solo Clipper 5.2 y superiores....
extern WORD _tIsDrv( WORD );

CLIPPER ValidDrive( void )
{
/*
    BYTE bDrive = _parni( 1 );

    _AH = 0x19;
    asm int 0x21;
    _BL = _AL;
    _DL = bDrive;
    _AH = 0x0E;
    asm int 0x21;
    _AH = 0x19;
    asm int 0x21;
    _CX = ( _AL == _DL );
    _DL = _BL;
    _AH = 0x0E;
    asm int 0x21;

    _retl( _CX );
*/
    _retl( _tIsDrv( _parni( 1 ) ) == 0 );
}

//---------------------------------------------------------------------------//
