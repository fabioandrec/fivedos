// Funcion para ventana de reloj

#include "MegaReco.ch"

Static oWndClock

// -------------------------------------------------------------------------- //
Function OpenClock()

    Static nTPHClock := 0

    If oWndClock == NIL

        DEFINE WINDOW oWndClock ;
            SIZE 12, 5 ;
            TITLE " Hora " ;
            NOMAXIMIZE ;
            NORESIZE

        DEFINE TIMER nTPHClock ;
            INTERVAL 1000 ;
            ACTION ShowClock()

        ACTIVATE WINDOW oWndClock ;
            ON INIT TimerActivate( nTPHClock ) ;
            ON CLOSE TimerRelease( nTPHClock ) ;
            ON PAINT ShowClock() ;
            VALID oWndClock := NIL, .T. ;
            CENTERED ;
            NOWAIT

    Else

        oWndClock:SetCurrent()
        If oWndClock:lMinimized
            oWndClock:Normal()
        EndIf

    EndIf

Return NIL

// -------------------------------------------------------------------------- //
Static Function ShowClock()
    oWndClock:Say(  1,  1, DToC( Date() ), N_BG )
    oWndClock:Say(  2,  1, Time(), N_BG )
Return NIL

// -------------------------------------------------------------------------- //
