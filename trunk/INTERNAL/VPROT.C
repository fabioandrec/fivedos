#include <stdio.h>
#include <stdlib.h>
#include <dos.h>

typedef unsigned char UCHAR;

#define SCANEDPOS 0x028A

void main( int args, char * arg[] )
{
   FILE * wFile;
   // char Prot[ 4 ] = { 0x1E, 0x0, 0x0, 0x60 };
   char Prot[ 4 ] = { 0x1E, 0x0, 0x0, 0x5f };
   unsigned char EndCode[ 4 ];
   char Old[ 4 ];

   if( args == 1 )
   {
      printf( "VProt 1.0" );
      return;
   }
   else
   {
      wFile = fopen( arg[ 1 ], "r+" );
      fseek( wFile, SCANEDPOS, 0 );
      fread( EndCode, 4, 1, wFile );

      if( EndCode[ 0 ] != 0x83 || EndCode[ 1 ] != 0xC4 ||
          EndCode[ 2 ] != 0x08 || EndCode[ 3 ] != 0xCB )
      {
         printf( "Cambio en posici¢n PCode\n" );
         fclose( wFile );
         return;
      }
      fread( Old, 4, 1, wFile );
      printf( "Old PCode: %X, %X, %X, %X \n\l", ( UCHAR ) Old[ 0 ], ( UCHAR ) Old[ 1 ], ( UCHAR ) Old[ 2 ], (UCHAR) Old[ 3 ] );

      fseek( wFile, SCANEDPOS + 4, 0 );
      fwrite( Prot, 4, 1, wFile );
      fclose( wFile );
   }
}
