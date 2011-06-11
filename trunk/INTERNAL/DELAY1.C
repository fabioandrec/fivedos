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

//---------------------------------------------------------------------------//

static unsigned long far wMicroRetard = 0;
static WORD far wCoef        = 0;

//---------------------------------------------------------------------------//

static WORD GetMicroRetard( void )
{

    unsigned long wCounter = 0;
    unsigned long wCount   = 0;
    unsigned long wTest    = 1;

    if( bIsExtendedExe() )
    {
        REALMODEINT sInt;
        WORD * pFlag  = 0;
        void * hMem   = (void*) DosLowAlloc( 2 );

        pFlag = (WORD*) MK_FP( FP_SEG( hMem ), 0 );
        pFlag[ 0 ] = 0;

        sInt.ecx = 0;
        sInt.edx = COCIENTEx10;
        sInt.eax = 0x00008300;       // Set event interval.
        sInt.es  = FP_OFF( hMem );
        sInt.ebx = 0;

        RealModeInt( 0x0015, &sInt );

        while( wCounter < wTest )
        {
            ++wCount;
            if( pFlag[ 0 ] )
                wCounter = 1;
        }

        sInt.ecx = 0;
        sInt.edx = COCIENTEx10;
        sInt.eax = 0x00008300;       // Set event interval.
        sInt.es  = FP_OFF( hMem );
        sInt.ebx = 0;

        RealModeInt( 0x0015, &sInt );

        wCounter = 0;
        wCount   = 0;
        pFlag[ 0 ] = 0;

        while( wCounter < wTest )
        {
            ++wCount;
            if( pFlag[ 0 ] )
                wCounter = 1;
        }

        sInt.ecx = 0;
        sInt.edx = COCIENTEx10;
        sInt.eax = 0x00008301;      // Cancel event interval.
        sInt.es  = FP_OFF( hMem );
        sInt.ebx = 0;

        RealModeInt( 0x0015, &sInt );

        DosLowFree( (DWORD) hMem );
    }
    else
    {

        WORD bFlag = 0;

        asm {
                mov cx, 0
                mov dx, COCIENTEx10
                mov ax, 0x8300
                push ss
                pop  es
                lea bx, bFlag
                int 0x15
            }


        if( !( _FLAGS & 1 ) )
        {
            while( wCounter < wTest )
            {
                ++wCount;
                if( bFlag )
                    wCounter = 1;
            }

            /*
            wCounter = 0;
            wCount   = 0;
            bFlag    = 0;

            asm {
                    mov cx, 0
                    mov dx, COCIENTEx10
                    mov ax, 0x8300
                    push ss
                    pop  es
                    lea bx, bFlag
                    int 0x15
                }

            if( !( _FLAGS & 1 ) )
            {
                while( wCounter < wTest )
                {
                    ++wCount;
                    if( bFlag )
                        wCounter = 1;
                }


            }
            */
            asm {
                    mov cx, 0
                    mov dx, COCIENTEx10
                    mov ax, 0x8301
                    push ss
                    pop  es
                    lea bx, bFlag
                    int 0x15
                }
        }

    }

    wMicroRetard = wCount;
    wCoef = (WORD) ( wMicroRetard / COCIENTE );

    return wMicroRetard;

}

//---------------------------------------------------------------------------//

CLIPPER GetMicroRe( void )
{

    if( !wMicroRetard )
        GetMicroRetard();

    _retnl( wMicroRetard );

    _retnl( wCoef );

}

//---------------------------------------------------------------------------//

void MicroDelay( unsigned long wMcSec )
{
    WORD bFlag;
    unsigned long wCount = 0;
    WORD* pFlag = &bFlag;

    bFlag = 0;

    if( ! wMicroRetard  )
        GetMicroRetard();

    wMcSec = wMcSec * wCoef;

    while( wCount < wMcSec )
    {
        ++wCount;
        if( pFlag[ 0 ] )
            wCount = wMcSec;
    }
}

//---------------------------------------------------------------------------//

void MiliDelay( WORD w )
{
    while( w-- )
        MicroDelay( 100 );
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
