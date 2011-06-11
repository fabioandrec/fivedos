#include <ClipApi.h>
#include <dos.h>

#define  SELDAC    03C8h           // Puerto E/S para Selecionar  DAC
#define  IO_RGB    03C9h           // Puerto E/S para I/O valores RGB
                                   // del DAC selecionado.
typedef struct
{
    BYTE Red;
    BYTE Green;
    BYTE Blue;
} VGAColor;

//---------------------------------------------------------------------------//

void _SetDAC( BYTE bReg, VGAColor * Color )
{

     asm {
            // Selecciona Registro para I/O
            mov dx, SELDAC
            mov al, bReg
            OUT dx, al

            // escribe el DAC
            les bx, Color         // es:bx apunta a estructura VGAColor
            mov dx, IO_RGB
            mov al, es:bx[ 0 ]    // Rojo
            OUT dx, al
            mov al, es:bx[ 1 ]    // Verde
            OUT dx, al
            mov al, es:bx[ 2 ]    // Azul
            OUT dx, al
     }

}

//---------------------------------------------------------------------------//

CLIPPER SetDAC( void ) // nDACindex, , nRed, nGreen, nBlue
{
   VGAColor Color;

   Color.Red    = _parni( 2 );
   Color.Green  = _parni( 3 );
   Color.Blue   = _parni( 4 );

   _SetDAC( _parni( 1 ), &Color );

}

//---------------------------------------------------------------------------//
void _GetDAC( BYTE bReg, VGAColor* Color )
{
    asm {
            mov ah, 10h
            mov al, 15h
            mov bx, bReg
            int 10h
            les bx, Color         // es:bx apunta a estructura VGAColor
            mov es:bx[ 0 ], dh    // Rojo
            mov es:bx[ 1 ], ch    // Verde
            mov es:bx[ 2 ], cl    // Azul
        }
}

//---------------------------------------------------------------------------//

CLIPPER aGetDAC( void ) // ( nDACindex ) -> aDAC -> { nRed, nGreen, nBlue }
{
    VGAColor Color;

    _GetDAC( _parni( 1 ), &Color );

    _reta( 3 );

    _storni( Color.Red  , -1, 1 );
    _storni( Color.Green, -1, 2 );
    _storni( Color.Blue , -1, 3 );

}

//---------------------------------------------------------------------------//
/*
CLIPPER SetDac()
{
    BYTE bDac = _parni( 1 );
    BYTE bColor[ 3 ];

    bColor[ 0 ] = _parni( 2 );
    bColor[ 1 ] = _parni( 3 );
    bColor[ 2 ] = _parni( 4 );

    while( !( ( inport( 0x3DA ) & 8 ) == 8 ) );
    while( !( ( inport( 0x3DA ) & 8 ) == 0 ) );

   _BX = bDac;
   _CX = 1;
   _ES = FP_SEG( bColor );
   _DX = FP_OFF( bColor );
   _AX = 0x1012;

   asm int 0x10;

}
*/

//---------------------------------------------------------------------------//
