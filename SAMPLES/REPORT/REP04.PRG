#include "FiveDos.ch"
#include "report.ch"

Function Rep04()

    local oReport

     USE TEST INDEX TEST NEW

     REPORT oReport TITLE  "*** My First Report ***" ;
          HEADER "This is the first line of the header", ;
                 "This is the second line of the header", ;
                 "" RIGHT ;
          FOOTER "This is the footer" CENTER ;
          PREVIEW

     COLUMN TITLE "St"         DATA Test->State
     COLUMN TITLE "First Name" DATA Test->First
     COLUMN TITLE "   Salary"  DATA Test->Salary TOTAL

     END REPORT

     ACTIVATE REPORT oReport

     CLOSE TEST

RETURN oReport

