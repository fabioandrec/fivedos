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

Function Rep19()

     LOCAL oPen1, oPen2

     DEFINE PEN oPen1 WIDTH 5
     DEFINE PEN oPen2 WIDTH 2

     USE TEST INDEX TEST NEW

     REPORT oReport ;
          TITLE  "*** Fivewin Report ***"  ;
          PEN oPen1, oPen2 ;
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
          ON STARTPAGE LinBox()

     CLOSE TEST

RETURN NIL


STATIC Function LinBox()

     LOCAL nInchWidth, nInchHeight


     nInchWidth  := oReport:PhyWidth(INCHES)
     nInchHeight := oReport:PhyHeight(INCHES)

     oReport:Box(.1                ,;            // nRow
                 .1                ,;            // nCol
                 nInchHeight-.2    ,;            // nBottom
                 nInchWidth-.2     ,;            // nRight
                 1       ,;                      // first pen created
                 INCHES)

     oReport:Line(0.9    ,;                      // nTop
                  0.55   ,;                      // nLeft
                  2      ,;                      // nBottom
                  0.55   ,;                      // nRight
                  2      ,;                      // second pen created
                  INCHES)


RETURN NIL
