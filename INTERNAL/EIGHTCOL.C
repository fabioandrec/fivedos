#include <ClipApi.h>
#include <dos.h>

//----------------------------------------------------------------------------//

void EightCols( void )
{
   while( !( ( inport( 0x3DA ) & 8 ) == 8 ) );
   while( !( ( inport( 0x3DA ) & 8 ) == 0 ) );

   outportb( 0x3C2, ( inportb( 0x3CC ) & 0xF3 ) );

   asm cli;
   outport( 0x3C4, 0x0100 );
   outport( 0x3C4, 0x0101 );
   outport( 0x3C4, 0x0300 );
   asm sti;

   _AX = 0x1000;
   _BX = 0x0013;
   asm int 0x10;
}

//----------------------------------------------------------------------------//

void NineCols( void )
{
   BYTE b;

   b = inportb( 0x3CC ) & 0xF3;
   b |= 4;

   outportb( 0x3C2, b );

   disable();
   outport( 0x3C4, 0x0100 );
   outport( 0x3C4, ( ( 0x0800 ) << 8 ) + 1 );
   outport( 0x3C4, 0x0300 );
   enable();

   _AX = 0x1000;
   _BX = 0x0813;
   asm int 0x10;
}

//----------------------------------------------------------------------------//

CLIPPER EIGHTCOLS() { EightCols(); }
CLIPPER NINECOLS()  { NineCols(); }

