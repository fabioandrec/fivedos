#include "FiveDos.ch"
#include "report.ch"

Function Rep01()

    local oReport

     USE TEST INDEX TEST NEW

     REPORT oReport TITLE  "*** My First Report ***" PREVIEW

     COLUMN TITLE "St"         DATA Test->State
     COLUMN TITLE "First Name" DATA Test->First
     COLUMN TITLE "   Salary"  DATA Test->Salary

     END REPORT

     ACTIVATE REPORT oReport WHILE Test->State < "MA"

     CLOSE TEST
   /**
     while oReport:oDevice:lPrinting()
        SysRefresh()
     end
   **/
RETURN oReport


