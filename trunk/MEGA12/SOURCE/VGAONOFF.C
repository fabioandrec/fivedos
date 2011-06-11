// Funcion para desconexion de la pantalla.

#include <Dos.h>
#include <ClipApi.h>

typedef struct { BYTE R, G, B; } Rgb;

#define NUMCOLOR      256

static Rgb aPal[ NUMCOLOR ];

// -------------------------------------------------------------------------- //
static void GetPal( BYTE bColor, Rgb * rgb )
{
	outportb( 0x03C7, bColor );
	rgb->R = inportb( 0x3C9 );
	rgb->G = inportb( 0x3C9 );
	rgb->B = inportb( 0x3C9 );
}

// -------------------------------------------------------------------------- //
static void SetPal( BYTE bColor, Rgb * rgb )
{
	outportb( 0x03C8, bColor );
    outportb( 0x03C9, rgb->R );
    outportb( 0x03C9, rgb->G );
    outportb( 0x03C9, rgb->B );
}

// -------------------------------------------------------------------------- //
static void SavePal( void )
{
    int i;
    Rgb * pPal = &aPal[ 0 ];
    for( i = 0; i < 256; i++ )
    {
        GetPal( i, pPal++ );
    }
}

// -------------------------------------------------------------------------- //
static void RestPal( void )
{
    int i;
    Rgb * pPal = &aPal[ 0 ];
    for( i = 0; i < 256; i++ )
    {
        SetPal( i, pPal++ );
    }
}

// -------------------------------------------------------------------------- //
static void WaitRetrace( void )
{
	asm{
		MOV DX, 0x3DA
		}
    L1:
	asm{
		IN	AL, DX
		AND AL, 0x08
        JNZ L1
    }
    L2:
	asm{
		IN	AL, DX
		AND AL, 0x08
        JZ  L2
	}
}

// -------------------------------------------------------------------------- //
void VgaOff( void )
{
    int iColor, iPal;
    Rgb Tmp;
    SavePal();
    for( iColor = 1; iColor < 65; iColor++ )
    {
        WaitRetrace();
        for( iPal = 0; iPal < 256; iPal++ )
        {
            GetPal( iPal, &Tmp );
            if( Tmp.R > 0 )
                Tmp.R--;
            if( Tmp.G > 0 )
                Tmp.G--;
            if( Tmp.B > 0 )
                Tmp.B--;
            SetPal( iPal, &Tmp );
        }
    }

}

// -------------------------------------------------------------------------- //
void VgaOn( void )
{
    int iColor, iPal;
    Rgb Tmp;
    for( iColor = 1; iColor < 65; iColor++ )
    {
        WaitRetrace();
        for( iPal = 0; iPal < 256; iPal++ )
        {
            GetPal( iPal, &Tmp );
            if( Tmp.R < aPal[ iPal ].R )
                Tmp.R++;
            if( Tmp.G < aPal[ iPal ].G )
                Tmp.G++;
            if( Tmp.B < aPal[ iPal ].B )
                Tmp.B++;
            SetPal( iPal, &Tmp );
        }
    }
}

// -------------------------------------------------------------------------- //
CLIPPER VGAOFF()
{
    VgaOff();
}

// -------------------------------------------------------------------------- //
CLIPPER VGAON()
{
    VgaOn();
}

// -------------------------------------------------------------------------- //
