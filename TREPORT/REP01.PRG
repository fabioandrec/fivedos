#include "FiveDos.ch"
#include "report.ch"

STATIC oReport

Function Rep01()

     USE TEST INDEX TEST NEW

     REPORT oReport TITLE  "*** My First Report ***" PREVIEW

     COLUMN TITLE "St"         DATA Test->State
     COLUMN TITLE "First Name" DATA Test->First
     COLUMN TITLE "   Salary"  DATA Test->Salary

     END REPORT

     ACTIVATE REPORT oReport

     CLOSE TEST

RETURN NIL


