#include "FiveDos.ch"
#include "Report.ch"

STATIC oReport

Function Rep02()

     USE TEST INDEX TEST NEW

     REPORT oReport TITLE  "*** My First Report ***" PREVIEW

     COLUMN TITLE "St"         DATA Test->State
     COLUMN TITLE "First Name" DATA Test->First
     COLUMN TITLE "   Salary"  DATA Test->Salary TOTAL

     END REPORT

     ACTIVATE REPORT oReport

     CLOSE TEST

RETURN NIL


