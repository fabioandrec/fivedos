#include <ClipApi.h>


#define MAX_TIMERS 20

extern LONG lnTicks( void );

static PCLIPVAR abTimerEvents = 0;  // Clipper array thats hold
                                    // event codeblocks

typedef struct
{
    WORD wTicks;         // Timer period in Ticks
    LONG lTimerCount;    // Next TimerCount event triger.
} FIVETIMER;


static FIVETIMER aTimers[ MAX_TIMERS ];

static void FiveTimerEvent( LONG lTimerCount );

typedef void ( * PTIMEREVENT )( LONG );
extern PTIMEREVENT _TimerCallBack;

//---------------------------------------------------------------------------//

static void near Init( void )
{
    if( abTimerEvents == 0 )
    {
        _TimerCallBack = (PTIMEREVENT) FiveTimerEvent;

        _ARRAYNEW( MAX_TIMERS );
        abTimerEvents = _GetGrip( _eval );
        _bset( (LPBYTE) aTimers, 0, sizeof( FIVETIMER ) * MAX_TIMERS );
    }
}

//---------------------------------------------------------------------------//

static BOOL near TimerActivate( WORD wTimer )
{
    if( wTimer )
        wTimer--;
    else
        wTimer = MAX_TIMERS;

    if( wTimer < MAX_TIMERS &&
        aTimers[ wTimer ].wTicks &&
        aTimers[ wTimer ].lTimerCount == 0 )
    {
        aTimers[ wTimer ].lTimerCount = lnTicks() + aTimers[ wTimer ].wTicks;
        return TRUE;
    }

    return FALSE;
}

//---------------------------------------------------------------------------//

WORD hTimerNew( WORD wTicks, PCLIPVAR bEvent )
{
    WORD wHandle = 0;

    wTicks  = MAX( wTicks, 1 );
                            
    Init();

    if( bEvent && bEvent->wType & BLOCK )
    {
        while( wHandle < MAX_TIMERS && aTimers[ wHandle ].wTicks ) wHandle++;

        if( wHandle < MAX_TIMERS )
        {
            _cAtPut( abTimerEvents, wHandle + 1, bEvent );
            aTimers[ wHandle ].wTicks      = wTicks;
            aTimers[ wHandle ].lTimerCount = 0;

            wHandle++;
        }
        else
            wHandle = 0;
    }

    return wHandle;
}

//---------------------------------------------------------------------------//

static void FiveTimerEvent( LONG lTimerCount )
{
    WORD wTimer;

    if( abTimerEvents )
    {
        for( wTimer = 0; wTimer < MAX_TIMERS; wTimer++ )
        {
            if( aTimers[ wTimer ].lTimerCount &&
                lTimerCount >= aTimers[ wTimer ].lTimerCount )
            {
                _cAt( abTimerEvents, wTimer + 1, -1, _eval );
                aTimers[ wTimer ].lTimerCount = 0; // PREVENT Recursive calls
                _cEval0( _eval );
                // Set timer count for next event if not released...
                if( aTimers[ wTimer ].wTicks )
                    aTimers[ wTimer ].lTimerCount = lnTicks() + aTimers[ wTimer ].wTicks;

            }
        }
    }
}

//---------------------------------------------------------------------------//

BOOL TimerDeActivate( WORD wTimer )
{
    if( wTimer )
        wTimer--;
    else
        wTimer = MAX_TIMERS;

    if( wTimer < MAX_TIMERS &&
        aTimers[ wTimer ].wTicks &&
        aTimers[ wTimer ].lTimerCount )
    {
        aTimers[ wTimer ].lTimerCount = 0;
        return TRUE;
    }

    return FALSE;
}

//---------------------------------------------------------------------------//

BOOL TimerRelease( WORD wTimer )
{
    if( wTimer )
        wTimer--;
    else
        wTimer = MAX_TIMERS;

    if( wTimer < MAX_TIMERS &&
        aTimers[ wTimer ].wTicks )
    {
        aTimers[ wTimer ].lTimerCount =
             aTimers[ wTimer ].wTicks =
             ( ++_tos )->wType        = 0;

        _cAtPut( abTimerEvents, wTimer + 1, _tos-- );

        return TRUE;
    }

    return FALSE;
}

//---------------------------------------------------------------------------//

CLIPPER TimerNew( void ) // ( nTicks, bEvent ) -> nTimerHandle
{
    _retni( hTimerNew( _parni( 1 ), _param( 2, BLOCK ) ) );
}

//---------------------------------------------------------------------------//

CLIPPER TimerActiv( void ) // ate( nTimerHandle )
{
    _retl( TimerActivate( _parni( 1 ) ) );
}

//---------------------------------------------------------------------------//

CLIPPER TimerDeAct( void ) // ivate( nTimerHandle )
{
    _retl( TimerDeActivate( _parni( 1 ) ) );
}

//---------------------------------------------------------------------------//

CLIPPER TimerRelea( void ) // se( nTimerHandle )
{
    _retl( TimerRelease( _parni( 1 ) ) );
}

//---------------------------------------------------------------------------//
