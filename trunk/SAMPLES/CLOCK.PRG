// prueba de timers
#include "fivedos.ch"
static oWnd, nTimer, lMode := .f.

Function Clock()

    if lMode
        return
    end
    lMode := .t.
    define dialog oWnd from 0,0 to 7,20 title 'Reloj'

    @ 4, 3 button ' &Cerrar ' of oWnd action ClockClose()

    activate dialog oWnd nowait centered

    oWnd:say(1,1,'Fecha :' + dtoc(date()))
    oWnd:say(2,1,'Hora  :' + Time() )

    define timer nTimer interval 10 action  oWnd:say(2,1,'Hora  :' + Time() ),tock()
    activate timer nTimer
return
static function ClockClose()
    deactivate timer ntimer
    release timer nTimer
    oWnd:close()
    lMode := .f.
return nil
