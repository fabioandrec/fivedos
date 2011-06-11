#include "error.ch"

Function SetDriver(cNewPrinter)
static cPrinter := "HPLASERJET"
local cOldPrinter := cPrinter
if ! (cNewPrinter== NIL)
   cPrinter := upper(alltrim(cNewPrinter))
endif
return cOldPrinter

Function SetPort(cNewPort)
static cPort := "LPT1"
local cOldPort := cPort
if ! (cNewPort== NIL)
   cPort := upper(alltrim(cNewPort))
endif
return cOldPort

Function PrinterError(e,bError,nPort)
// Eigene Erweiterung - Druckerfehler !
local bErr
bErr := ErrorBlock()
ErrorSys()
if ( e:genCode == EG_PRINT  )
   if TestPrinter(nPort)
      ErrorBlock(bErr)
      return (.f.)                  // NOTE
   else
      ErrorBlock(bErr)
      break
   endif
end
ErrorBlock(bErr)
return eval(bError,e)

/*
* PrÅfen, ob Drucker verfÅgbar, ggfs. Userdialog
*/
function TestPrinter(nPort)
local lOk := .f., nWahl, bErr
bErr := ErrorBlock()
ErrorSys()
do while ! lOk
   lOk   := isprinter(nPort) // Funcky !
   if ! lOk
      nWahl := alert("Drucker nicht bereit",{"Wiederholen","Ignorieren","Abbruch"})
      do case
         case (nWahl == 1)
            loop
         case (nWahl == 2)
            lOk := .t.
            exit
         otherwise
            exit
      endcase
   endif
enddo
ErrorBlock(bErr)
return lOk
