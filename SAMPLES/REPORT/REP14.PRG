#include "FiveWin.ch"
#include "report.ch"

Function Rep14()

    local oReport

     USE TEST INDEX TEST NEW

     REPORT oReport ;
          TITLE  "*** GOING BACKWARDS ***"  ;
          PREVIEW

     COLUMN TITLE "St" DATA Test->State

     COLUMN TITLE "First Name", "Last Name" ;
            DATA  Test->First, Test->Last

     COLUMN TITLE "Street", "City"  ;
            DATA  Test->Street, Test->City

     COLUMN TITLE "   Salary"  ;
            DATA  Test->Salary ;
            TOTAL


     END REPORT

     /*
     Just the following
     */

     GO BOTTOM
     oReport:bSkip := {|| Test->(DbSkip(-1)) }


     ACTIVATE REPORT oReport WHILE !Test->(Bof())

     CLOSE TEST

RETURN oReport
