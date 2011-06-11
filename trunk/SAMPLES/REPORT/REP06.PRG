#include "FiveWin.ch"
#include "report.ch"

Function Rep06()

    local oReport

     USE TEST INDEX TEST NEW

     REPORT oReport TITLE  "*** My First Report ***"  ;
          CAPTION "The Firm - Salary Report" ;
          PREVIEW

     COLUMN TITLE "St"         DATA Test->State
     COLUMN TITLE "First Name" DATA Test->First
     COLUMN TITLE "Last Name"  DATA Test->Last
     COLUMN TITLE "   Salary"  DATA Test->Salary TOTAL

     END REPORT

     ACTIVATE REPORT oReport

     CLOSE TEST

RETURN oReport
