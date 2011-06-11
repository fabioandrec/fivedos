#include <ClipApi.h>
#include <dos.h>

typedef struct {
	unsigned es, ds, di, si, bp, sp, bx, dx, cx, ax, ip, cs, flags;
} INTERRUPT_REGS;

static void ( interrupt far * far pOldVector )( void );

extern void ( interrupt far * _getvector( WORD ) )( void );
extern void _setvector( WORD, DWORD );

typedef struct
{
    WORD       wLapTicks;    // Cada tantos Ticks
    WORD       wTickCount;
    BOOL       bIsClipFunc;  // Es una funcion de prg.
    PCLIPFUNC  pUserFunc;    // pascal en cualquier caso.
} TIMER;

#define MAXTIMERS 8

static TIMER far Timers[ MAXTIMERS ];
static WORD  far wTimers  = 0;
static BOOL  far bWorking = FALSE;

//---------------------------------------------------------------------------//

static void interrupt far TimerServer( INTERRUPT_REGS r )
{
    if ( ! bWorking )
	{
        WORD wIndex;
        
        bWorking = TRUE;

        (* pOldVector )();        // Call old handler

        asm pushf;

        disable();

        for( wIndex = 0; wIndex < wTimers; wIndex++ )
        {
            if( Timers[ wIndex ].wLapTicks &&
                --Timers[ wIndex ].wTickCount == 0 )
            {
                Timers[ wIndex ].wTickCount = Timers[ wIndex ].wLapTicks;
                enable();
                ( Timers[ wIndex ].pUserFunc )();
                disable();
            }

        }

        bWorking = FALSE;

        asm popf;
    }

}

//---------------------------------------------------------------------------//

static void UnInstallTimer( void )
{
    if( pOldVector )
    {
        while( bWorking );
        bWorking       = TRUE;
        _setvector( 0x08, (DWORD) pOldVector );
        pOldVector = 0;
        bWorking       = FALSE;
    }
}

//---------------------------------------------------------------------------//

// Return TRUE if success

BOOL AddUserTimer( WORD wLapTicks, PCLIPFUNC pUserFunc )
{
    BOOL bRet = FALSE;

    if( pOldVector == 0 )  // Not instaled yet.
    {
        pOldVector = _getvector( 0x08 );
        _setvector( 0x08, (DWORD) TimerServer );
    }

    if( wTimers < MAXTIMERS )
    {
        
        Timers[ wTimers ].wLapTicks   = wLapTicks;
        Timers[ wTimers ].wTickCount  = wLapTicks;
        Timers[ wTimers ].bIsClipFunc = FALSE;
        Timers[ wTimers ].pUserFunc   = pUserFunc;

        bRet = TRUE;

        while( bWorking );

        wTimers++;
    }

    return bRet;
}

//---------------------------------------------------------------------------//

// Return TRUE if success

BOOL ReleaseTimer( PCLIPFUNC pUserFunc )
{
    WORD wIndex;

    for( wIndex = 0; wIndex < wTimers; wTimers++ );
    {
        if( Timers[ wIndex ].pUserFunc == pUserFunc )
        {
            while( bWorking );
            bWorking = TRUE;

            while( wIndex < wTimers - 1 )
            {
                Timers[ wIndex ].wLapTicks   = Timers[ wIndex + 1 ].wLapTicks  ;
                Timers[ wIndex ].wTickCount  = Timers[ wIndex + 1 ].wTickCount ;
                Timers[ wIndex ].bIsClipFunc = Timers[ wIndex + 1 ].bIsClipFunc;
                Timers[ wIndex ].pUserFunc   = Timers[ wIndex + 1 ].pUserFunc  ;
                wIndex++;
            }

            Timers[ wIndex ].wLapTicks   = 0;
            Timers[ wIndex ].wTickCount  = 0;
            Timers[ wIndex ].bIsClipFunc = FALSE;
            Timers[ wIndex ].pUserFunc   = 0;

            wTimers--;

            if( !wTimers )
                UnInstallTimer();

            bWorking = FALSE;
            return TRUE;
        }
    }

    return FALSE;

}

//---------------------------------------------------------------------------//
