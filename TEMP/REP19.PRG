#include "FiveWin.ch"
#include "report.ch"



Function Rep19()

     LOCAL oReport, oPen1, oPen2

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
          ON STARTPAGE LinBox( oReport )

     CLOSE TEST

RETURN oReport


STATIC Function LinBox( oReport )

     LOCAL nInchWidth, nInchHeight


     nInchWidth  := oReport:PhyWidth(RPT_INCHES)
     nInchHeight := oReport:PhyHeight(RPT_INCHES)

     oReport:Box(.1                ,;            // nRow
                 .1                ,;            // nCol
                 nInchHeight-.1    ,;            // nBottom
                 nInchWidth-.1     ,;            // nRight
                 1       ,;                      // first pen created
                 RPT_INCHES)

     oReport:Line(0.9    ,;                      // nTop
                  0.55   ,;                      // nLeft
                  2      ,;                      // nBottom
                  0.55   ,;                      // nRight
                  2      ,;                      // second pen created
                  RPT_INCHES)


RETURN NIL
