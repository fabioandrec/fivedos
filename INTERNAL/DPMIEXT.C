// 80286 code
#pragma option -2

#include <ClipApi.h>
#include <dos.h>

typedef struct
{
    DWORD edi, esi, ebp, reserved, ebx, edx, ecx, eax;
    WORD  flags, es, ds, fs, gs, ip, cs, sp, ss;
} REALMODEINT;


typedef WORD  ( far * W_FUNC_WW  )( WORD, WORD );
typedef WORD  ( far * W_FUNC_W   )( WORD  );
typedef DWORD ( far * DW_FUNC_W  )( WORD  );
typedef void  ( far * V_FUNC_DW  )( DWORD );
typedef void  ( far * V_FUNC_W   )( WORD );
typedef void  ( far * V_FUNC_WDW )( WORD, DWORD );
typedef BOOL  ( far * B_FUNC_WRM )( WORD, REALMODEINT * );

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

extern DPMITABLE far DpmiTable;

//---------------------------------------------------------------------------//

static WORD SegmentToSel( WORD Segment, WORD wLimit )
{
    WORD Sel;
    asm {
            mov bx, Segment
            mov ax, 0x0002
            int 0x31
            jnc OK
            xor ax, ax
        }
    OK:

    Sel = _AX;

    if( Sel )
    {
        // Lock Selector ( Prevent pagin )
        /*
        asm {
                mov ax, 0x0004
                mov bx, Sel
                int 0x31
            }
        */

    }
    return Sel;
}

//---------------------------------------------------------------------------//

static WORD CreateDSAlias( WORD CodeSel )
{
    asm {
            mov bx, CodeSel
            mov ax, 0x000A
            int 0x31
            jnc OK
            xor ax, ax
        }
    OK:
    return _AX ;
}

//---------------------------------------------------------------------------//

static DWORD DosLowAlloc( WORD wBytes )
{
    WORD wParrafos = ( wBytes / 16 ) + ( wBytes % 16 ? 1 : 0 );
    WORD Sel, Seg;

    asm {
            mov bx, wParrafos
            mov ax, 0x0100
            int 0x31
            jnc OK
            xor ax, ax
            xor dx, dx
        }
    OK:
    Seg = _AX;
    Sel = _DX;
    /*
    if( Sel )
    {
        // Lock Selector ( Prevent pagin )
        asm {
                mov ax, 0x0004
                mov bx, Sel
                int 0x31
            }
    }
    */
    return (DWORD) MK_FP( Sel, Seg );    // High -> Selector
                                         // Low  -> Real Mode segment
}

//---------------------------------------------------------------------------//

static void DosLowFree( DWORD SelSeg )
{
    WORD Sel = FP_SEG( SelSeg );



    asm {
        /*
            mov ax, 0x0005  // UnLock Selector
            mov bx, Sel
            int 0x31
        */
            mov dx, Sel
            mov ax, 0x0101
            int 0x31
        }

}

//---------------------------------------------------------------------------//

static BOOL RealModeInt( WORD wIntNo, REALMODEINT * pReal )
{
    asm {
            push  di
            mov   bx, wIntNo
            and   bx, 0x00FF
            mov   cx, 0
            les   di, pReal
            mov   ax, 0x0300
            int   0x31
            pop   di
        }

    return _FLAGS & 1;
}

//---------------------------------------------------------------------------//

static void LockSel( WORD Sel )
{
    asm {
            mov ax, 0x0004  // Lock Selector ( Prevent pagin )
            mov bx, Sel
            int 0x31
        }
}


//---------------------------------------------------------------------------//

static void UnlockSel( WORD Sel )
{
    asm {
            mov ax, 0x0005  // UnLock Selector
            mov bx, Sel
            int 0x31
        }
}

//---------------------------------------------------------------------------//

static DWORD GetVector( WORD wIntNo )
{
    /*
    REALMODEINT sInt;

    sInt.eax = 0x00003500 | ( (BYTE) wIntNo );

    RealModeInt( 0x0021, &sInt );

    return (DWORD) MK_FP( sInt.es, (WORD) sInt.ebx );
    */

    asm {
            mov   ax, 0x0200
            mov   bx, wIntNo
            int   0x31
            jnc OK
            xor   cx, cx
            xor   dx, dx
        }
    OK:
    asm {
            mov   ax, cx
            xchg  ax, dx
        }

    return (DWORD) MK_FP( _DX, _AX );    ;

}

//---------------------------------------------------------------------------//

static void SetVector( WORD wIntNo, DWORD pNewVector )
{
    /*
    REALMODEINT sInt;

    sInt.eax = 0x00002500 | ( (BYTE) wIntNo );
    sInt.ds  = FP_SEG( pNewVector );
    sInt.edx = (LONG) FP_OFF( pNewVector );

    RealModeInt( 0x0021, &sInt );
    */
    asm {
            mov   ax, 0x0201
            mov   bl, wIntNo
            mov   dx, [ pNewVector ]
            mov   cx, [ pNewVector + 2 ]
            int   0x31
        }

}

//---------------------------------------------------------------------------//

WORD GenDpmiInit( void )
{
    DpmiTable.pSegToSel    = (W_FUNC_WW)  SegmentToSel;
    DpmiTable.pCreDSAlias  = (W_FUNC_W)   CreateDSAlias;
    DpmiTable.pLowAlloc    = (DW_FUNC_W)  DosLowAlloc;
    DpmiTable.pLowFree     = (V_FUNC_DW)  DosLowFree;
    DpmiTable.pRealModeInt = (B_FUNC_WRM) RealModeInt;
    DpmiTable.pLockSel     = (V_FUNC_W)   LockSel;
    DpmiTable.pUnlockSel   = (V_FUNC_W)   UnlockSel;
    DpmiTable.pGetVector   = 0 ; // (DW_FUNC_W)  GetVector;
    DpmiTable.pSetVector   = 0 ; // (V_FUNC_WDW) SetVector;

    DpmiTable.bIsExtended  = TRUE;

    return 0;
}

//---------------------------------------------------------------------------//
