#include "FiveDos.ch"
#include "report.ch"

STATIC oReport

Function Rep03()

     USE TEST INDEX TEST NEW

     REPORT oReport TITLE  "*** My First Report ***" ;
          HEADER "This is the header" RIGHT ;
          FOOTER "This is the footer" CENTER ;
          PREVIEW

     COLUMN TITLE "St"         DATA Test->State
     COLUMN TITLE "First Name" DATA Test->First
     COLUMN TITLE "   Salary"  DATA Test->Salary TOTAL

     END REPORT

     ACTIVATE REPORT oReport

     CLOSE TEST

RETURN NIL


