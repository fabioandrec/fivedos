#include "FiveWin.ch"
#include "report.ch"

STATIC oReport

Function Rep16()

     LOCAL oPen1, oPen2

     DEFINE PEN oPen1 WIDTH 2
     DEFINE PEN oPen2 WIDTH 5

     USE TEST INDEX TEST NEW

     REPORT oReport ;
          TITLE  "*** Fivewin Report ***"  ;
          PEN oPen1, oPen2 ;
          PREVIEW

     COLUMN TITLE "St" DATA Test->State GRID

     COLUMN TITLE "First Name", "Last Name" ;
            DATA  Test->First, Test->Last ;
            GRID

     COLUMN TITLE "Street", "City"  ;
            DATA  Test->Street, Test->City ;
            GRID

     COLUMN TITLE "   Salary"  ;
            DATA  Test->Salary ;
            TOTAL ;
            SHADOW ;
            GRID 2


     END REPORT

     ACTIVATE REPORT oReport

     CLOSE TEST

     oPen1:Release()
     oPen2:Release()

RETURN NIL


