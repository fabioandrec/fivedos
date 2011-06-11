// alarm fuction ...

#include 'fivedos.ch'

static nTimer:= 0 , cAlarm


Function AlarmSet(cTime)

    DEFAULT cALARM := '00:00'

    if pCount() >0
        cAlarm := cTime
    else
        cTime := cAlarm
        if lMsgGet('Alarma','Hora:',@cTime,'99:99')
            cAlarm:=cTime
          else
            cAlarm := ''
        end
     end
     if !empty(cAlarm)
        if nTimer != 0
            deactivate timer nTimer
            release timer ntimer
         end
         tone(50,.1)
        define timer nTimer interval 100 action alarm()
        activate timer nTimer
        tone(100,.1)
      end
return nil


function alarm()
    local oWnd
    if cAlarm =substr(time(),1,5)
         deactivate timer nTimer
         release timer ntimer
         nTimer = 0
         define dialog oWnd from 0,0 to 5,20 title 'Alarm'

         @ 2,4 button '&Alarm' of oWnd action oWnd:end()

        activate dialog oWnd on init  DO ;
                    DO Sound( n ), MiliDelay( 10 ) ;
                     FOR n := 100 TO 1000 STEP 100          ,;
                    DO Sound( n ), MiliDelay( 10 ) ;
                     FOR n := 1000 TO 100 STEP -100              ;
                FOR n := 1 TO 4,;
                SoundOff()
     endif
return nil
