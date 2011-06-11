#include "FiveWin.ch"
#include "report.ch"

#define RPT_LEFT     1
#define RPT_RIGHT    2
#define RPT_CENTER   3
#define RPT_TOP      4
#define RPT_BOTTOM   5

#define INCHES   1
#define CMETERS  2


STATIC oReport

Function Rep18()

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
          ON STARTPAGE Bitmaps()

     CLOSE TEST

RETURN NIL


STATIC Function Bitmaps()

     oReport:SayBitmap(.3,.3,"ICO.BMP",.5,.5)
     oReport:SayBitmap(3,2,"CONFIDEN.BMP",4,4)

RETURN NIL
