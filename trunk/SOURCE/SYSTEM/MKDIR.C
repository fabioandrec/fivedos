#include <WinTen.h>
#include <Windows.h>
#include <dos.h>
#include <ClipApi.h>

void pascal Dos3Call( void );

//----------------------------------------------------------------------------//

CLIPPER lMkDir()
{
   char * szDirName = _parc( 1 );

   asm push ds;
   _AH = 0x39;
   _DS = FP_SEG( szDirName );
   _DX = FP_OFF( szDirName );
   Dos3Call();
   asm pop ds;

   _retl( !( _FLAGS & 1 ) );
}

//----------------------------------------------------------------------------//

CLIPPER lRmDir()
{
   char * szDirName = _parc( 1 );

   asm push ds;
   _AH = 0x3A;
   _DS = FP_SEG( szDirName );
   _DX = FP_OFF( szDirName );
   Dos3Call();
   asm pop ds;

   _retl( !( _FLAGS & 1 ) );
}

//----------------------------------------------------------------------------//

CLIPPER lChDir()
{
   char * szPath = _parc( 1 );

   asm push ds;

   _DX = FP_OFF( szPath );
   _DS = FP_SEG( szPath );
   _AH = 0x3B;
   asm int 0x21;

   asm pop ds;

   _retl( _AX != 3 );
}

//----------------------------------------------------------------------------//

CLIPPER CurDrive()            // Returns the letter of the selected drive
{
    BYTE bDrive;
    BYTE cResult[ 2 ];

    _AH = 0x19;
    Dos3Call();
    bDrive = _AL;

   cResult[ 0 ] = bDrive + 'A';
   cResult[ 1 ] = 0;

   _retc( cResult );
}

//---------------------------------------------------------------------------//

CLIPPER GETWINDOWS()  // DIRECTORY()
{
   BYTE bBuffer[ 250 ];

   _retclen( bBuffer, GetWindowsDirectory( bBuffer, 249 ) );
}

//----------------------------------------------------------------------------//
