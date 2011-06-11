#include <ClipApi.h>
#include <dos.h>

typedef struct
{
    DWORD edi, esi, ebp, reserved, ebx, edx, ecx, eax;
    WORD  flags, es, ds, fs, gs, ip, cs, sp, ss;
} REALMODEINT;

#define COCIENTE     977
#define COCIENTEx10  9770

extern DWORD DosLowAlloc( WORD wBytes );
extern void  DosLowFree( DWORD SelSeg );
extern BOOL  RealModeInt( WORD wIntNo, REALMODEINT * pReal );
extern BOOL  bIsExtendedExe( void );

extern DWORD _getvector( WORD wIntNo );
extern void _setvector( WORD wIntNo, DWORD );


//---------------------------------------------------------------------------//

void interrupt ( far * OldInt8 )( void );

static DWORD    Count = 0;
static BYTE     Flag  = 1;
static DWORD    MicroRetard = 0;
static DWORD    Coef  = 0;

//---------------------------------------------------------------------------//

void interrupt Int8Handler( void )
{
    OldInt8();
    if( !Count-- )
        Flag = 0;
}

//---------------------------------------------------------------------------//

static void GetMicroRetard( void )
{
    DWORD Counter = 0;
    DWORD wMcSec  = 1;
    DWORD wCount  = 0;

    OldInt8 = _getvector( 0x08 );
    _setvector( 0x08, (DWORD) Int8Handler );

    Flag  = 0xFF;
    Count = 1; // 55 milisegundos

    while( Flag );
    Flag  = 0xFF;
    Count = 2; // 110 milisegundos

    // Bucle que vamos a calibrar
    while( Counter < wMcSec )
    {
        ++wCount;
        if( !Flag )
            Counter = wMcSec;
    }

    _setvector( 0x08, (DWORD) OldInt8 );

    MicroRetard = wCount;
    Coef = MicroRetard / 11000;


}

//---------------------------------------------------------------------------//

CLIPPER GetMicroRe( void )
{

    if( !MicroRetard )
        GetMicroRetard();

    _retnl( MicroRetard );

    _retnl( Coef );

}

//---------------------------------------------------------------------------//

void MicroDelay( DWORD wMcSec )
{
    DWORD Counter, wCount  = 0;

    Flag = 0xFF;

    if( ! MicroRetard  )
        GetMicroRetard();

    wMcSec = wMcSec * Coef;

    // Bucle que hemos calibrado
    while( wCount < wMcSec )
    {
        ++wCount;
        if( !Flag )
            Counter = wMcSec;
    }

}

//---------------------------------------------------------------------------//

void MiliDelay( WORD w )
{
    MicroDelay( w * 100 );
}

//---------------------------------------------------------------------------//

CLIPPER MICRODELAY( void )
{
    MicroDelay( _parni( 1 ) );
}

//---------------------------------------------------------------------------//

CLIPPER MILIDELAY( void )
{
    MiliDelay( _parni( 1 ) );
}

//---------------------------------------------------------------------------//
