// 80286 code
#pragma option -2

#include <ClipApi.h>
#include <dos.h>


typedef struct
{
    DWORD edi, esi, ebp, reserved, ebx, edx, ecx, eax;
    WORD  flags, es, ds, fs, gs, ip, cs, sp, ss;
} REALMODEINT;


typedef WORD ( far * W_FUNC_WW )( WORD, WORD );
typedef WORD ( far * W_FUNC_W )( WORD );
typedef DWORD ( far * DW_FUNC_W )( WORD );
typedef void ( far * V_FUNC_DW )( DWORD );
typedef void ( far * V_FUNC_WDW )( WORD, DWORD );
typedef void ( far * V_FUNC_W )( WORD );
typedef BOOL ( far * B_FUNC_WRM )( WORD, REALMODEINT * );

typedef struct
{
    W_FUNC_WW  pSegToSel;
    W_FUNC_W   pCreDSAlias;
    DW_FUNC_W  pLowAlloc;
    V_FUNC_DW  pLowFree;
    B_FUNC_WRM pRealModeInt;
    V_FUNC_W   pLockSel;
    V_FUNC_W   pUnlockSel;
    DW_FUNC_W  pGetVector;
    V_FUNC_WDW pSetVector;
    BOOL       bIsExtended;
} DPMITABLE;

DPMITABLE far DpmiTable = { 0, 0, 0, 0, 0, 0, 0, FALSE };


static WORD SegmentToSel( WORD wSegment, WORD wLimit );

static WORD far wTextVideo = 0;
static WORD far wGrapVideo = 0;
static WORD far wBaseSeg   = 0;

//---------------------------------------------------------------------------//

LPBYTE BaseSegment( void )
{
    wBaseSeg = SegmentToSel( 0x0000, 0x3FFF );

    return ( LPBYTE ) MK_FP( wBaseSeg, 0 );
}

//---------------------------------------------------------------------------//

LPBYTE TextVideo( void )
{
    while( wTextVideo == 0 )
        wTextVideo = SegmentToSel( ( BaseSegment()[ 0x0449 ] == 0x07 ?
                                     0xB000 :
                                     0xB800 ), 0x7FFF  );

    return ( LPBYTE ) MK_FP( wTextVideo, 0 );
}

//---------------------------------------------------------------------------//

LPBYTE GraphVideo( void )
{
    while( wGrapVideo == 0 )
        wGrapVideo = SegmentToSel( 0xA000, 0xFFFF );

    return ( LPBYTE ) MK_FP( wGrapVideo, 0 );
}


//---------------------------------------------------------------------------//

static WORD SegmentToSel( WORD wSegment, WORD wLimit )
{
    if( DpmiTable.pSegToSel == 0 )
        return wSegment;

    return ( DpmiTable.pSegToSel )( wSegment, wLimit );
}

//---------------------------------------------------------------------------//

WORD CreateDSAlias( WORD CodeSel )
{
    if( DpmiTable.pCreDSAlias == 0 )
        return CodeSel;

    return ( DpmiTable.pCreDSAlias )( CodeSel );
}

//---------------------------------------------------------------------------//

DWORD DosLowAlloc( WORD wBytes )
{

    if( DpmiTable.pLowAlloc == 0 )
        return (DWORD) _xgrab( wBytes );

    return ( DpmiTable.pLowAlloc )( wBytes );

}

//---------------------------------------------------------------------------//

void DosLowFree( DWORD SelSeg )
{
    if( DpmiTable.pLowFree == 0 )
    {
        _xfree( (LPBYTE) SelSeg );
        return;
    }

    DpmiTable.pLowFree( SelSeg );
    return;
}

//---------------------------------------------------------------------------//

BOOL RealModeInt( WORD wIntNo, REALMODEINT * pReal )
{
    if( DpmiTable.pRealModeInt == 0 )
        return FALSE;

    return ( DpmiTable.pRealModeInt )( wIntNo, pReal );
}

//---------------------------------------------------------------------------//

void LockSel( WORD Sel )
{
    if( DpmiTable.pLockSel == 0 )
        return ;

    ( DpmiTable.pLockSel )( Sel );
}

//---------------------------------------------------------------------------//

void UnlockSel( WORD Sel )
{
    if( DpmiTable.pUnlockSel == 0 )
        return ;

    ( DpmiTable.pUnlockSel )( Sel );
}

//---------------------------------------------------------------------------//

DWORD _getvector( WORD wIntNo )
{
    if( DpmiTable.pGetVector == 0 )
    {
        asm {
            push    si
            push    di
            push    ds
            push    es
            
            mov ax, wIntNo
            mov ah, 0x35
            int 0x21

            mov dx, es
            mov ax, bx

            pop es
            pop ds
            pop di
            pop si
        }
        return (DWORD) MK_FP( _DX,_AX );
    }
    else
        return ( DpmiTable.pGetVector )( wIntNo );

}

//---------------------------------------------------------------------------//

void _setvector( WORD wIntNo, void ( interrupt far * pVector )() )
{
    if( DpmiTable.pSetVector == 0 )
    {
        asm {
            push    si
            push    di
            push    ds
            push    es
            
            mov ax, wIntNo
            mov ah, 0x25
            lds dx, pVector
            int 0x21

            pop es
            pop ds
            pop di
            pop si

        }
    }
    else
        ( DpmiTable.pSetVector )( wIntNo, (DWORD) pVector );

}

//---------------------------------------------------------------------------//

BOOL bIsExtendedExe( void )
{
    return DpmiTable.bIsExtended;
}

//---------------------------------------------------------------------------//
