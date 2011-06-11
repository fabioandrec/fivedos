#INCLUDE "Fivedos.CH"


function main()

   local oWnd

   DEFINE WINDOW OWND SIZE MAXCOL()+1,MAXROW()+1 TITLE "HOLA TIO"
      @ 10,10 button " pru " of ownd action pru( oWnd )
   ACTIVATE WINDOW OWND

RETURN 0

FUNCTION Pru( oWnd )
LOCAL NCONT:=0

   SETCANCEL(.T.)
   DO WHILE .T.
      ncont++
      PRU3(NCONT, oWnd )
   ENDDO

RETURN nil

FUNCTION Pru3(NCONT, oWnd )
LOCAL ADLG

   DEFINE window ADlg SIZE MAXCOL()+1,MAXROW()+1 TITLE "HOLA" OF oWnd

   ACTIVATE window ADlg ON INIT adlg:end()

   SETPOS(0,0)
   ?? MEMORY(0),MEMORY(1),MEMORY(2),NCONT

RETURN nil
