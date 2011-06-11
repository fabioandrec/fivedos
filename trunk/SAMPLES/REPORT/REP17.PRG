#include "FiveWin.ch"
#include "report.ch"


Function Rep17()

    local oReport

     USE TEST INDEX TEST NEW

     REPORT oReport ;
          TITLE  "*** Fivewin Report ***"  ;
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
     In Spanish
     */

     oReport:lSpanish := .T.

     /*
     Descriptions for page total and grand total
     */

     oReport:cPageTotal := "Page Total..."
     oReport:cGrandTotal := "Grand Total..."

     /*
     No Up line on column titles
     */

     oReport:cTitleUpChr := ""

     /*
     @ for total lines
     */

     oReport:cTotalChr := "@"

     /*
     Left margin at 1 inch
     */

     oReport:Margin(1, RPT_LEFT, RPT_INCHES)

     ACTIVATE REPORT oReport

     CLOSE TEST

RETURN oReport
