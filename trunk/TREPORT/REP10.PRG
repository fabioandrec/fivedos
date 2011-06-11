#include "FiveDos.ch"
#include "report.ch"

STATIC oReport

Function Rep10()

     LOCAL oFont1, oFont2

     DEFINE FONT oFont1 NAME "ARIAL" SIZE 0,-10
     DEFINE FONT oFont2 NAME "ARIAL" SIZE 0,-10 BOLD

     USE TEST INDEX TEST NEW

     REPORT oReport TITLE  "*** My First Report ***"  ;
          FONT oFont1, oFont2 ;
          PREVIEW

     COLUMN TITLE "St"         DATA Test->State

     COLUMN TITLE "First Name", "Last Name" ;
            DATA  Test->First, Test->Last

     COLUMN TITLE "Street", "City"  ;
            DATA  Test->Street, Test->City

     COLUMN TITLE "   Salary"  ;
            DATA  Test->Salary ;
            TOTAL              ;
            RIGHT              ;
            PICTURE "9,999,999";
            FONT 2             ;
            SIZE 9


     GROUP ON Test->State ;
           FOOTER "Total State "+oReport:aGroups[1]:cValue+ ;
                  " ("+ltrim(str(oReport:aGroups[1]:nCounter))+")" ;
           FONT 2 ;
           EJECT

     END REPORT

     ACTIVATE REPORT oReport

     CLOSE TEST

     oFont1:Release()
     oFont2:Release()

RETURN NIL


