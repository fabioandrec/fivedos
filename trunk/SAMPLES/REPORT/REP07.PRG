#include "FiveWin.ch"
#include "report.ch"

Function Rep07()

     local oReport, oFont1, oFont2

     DEFINE FONT oFont1 NAME "ARIAL" SIZE 0,-10
     DEFINE FONT oFont2 NAME "ARIAL" SIZE 0,-10 BOLD

     USE TEST INDEX TEST NEW

     REPORT oReport TITLE  "*** My First Report ***"  ;
          CAPTION "The Firm - Salary Report" ;
          FONT oFont1, oFont2 ;
          PREVIEW

     COLUMN TITLE "St"         DATA Test->State
     COLUMN TITLE "First Name" DATA Test->First
     COLUMN TITLE "Last Name"  DATA Test->Last
     COLUMN TITLE "   Salary"  DATA Test->Salary TOTAL ;
          FONT iif(Test->Salary>100000,2 ,1 )

     END REPORT

     ACTIVATE REPORT oReport

     CLOSE TEST

     oFont1:End()
     oFont2:End()

RETURN oReport
