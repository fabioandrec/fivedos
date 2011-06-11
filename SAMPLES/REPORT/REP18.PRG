#include "FiveWin.ch"
#include "report.ch"


Function Rep18()

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

     ACTIVATE REPORT oReport ;
          ON STARTPAGE Bitmaps( oReport )

     CLOSE TEST

RETURN oReport


STATIC Function Bitmaps( oReport )

     oReport:SayBitmap(.3,.3,"ICO.BMP",.5,.5)
     oReport:SayBitmap(3,2,"CONFIDEN.BMP",4,4)

RETURN NIL
