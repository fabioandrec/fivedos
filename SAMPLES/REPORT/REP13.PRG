#include "FiveWin.ch"
#include "report.ch"

Function Rep13()

     LOCAL oReport, oFont1, oFont2, oFont3

     DEFINE FONT oFont1 NAME "ARIAL" SIZE 0,-10
     DEFINE FONT oFont2 NAME "ARIAL" SIZE 0,-10 BOLD
     DEFINE FONT oFont3 NAME "ARIAL" SIZE 0,-20 BOLD

     USE TEST INDEX TEST NEW

     REPORT oReport ;
          TITLE  "*** FIVEWIN REPORT ***"    ,;
                 "Date: "+dtoc(Date())       ,;
                 ""                           ;
          FOOTER "Page Number: "+str(oReport:nPage,3) CENTER ;
          FONT oFont1, oFont2, oFont3 ;
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
           FONT 2


     END REPORT


     /*
     First title line with font 3 (20 bold)
     */

     oReport:oTitle:aFont[1]:= {|| 3 }


     /*
     Use second font for the data when the salary is greater than
     100.000.
     Remember that when you create the column, his title, his data
     and his total have the same font, but you can change it.
     */

     oReport:aColumns[4]:bDataFont := {|| iif(Test->Salary>100000,2 ,1 ) }

     /*
     Comments in Spanish
     */

     oReport:lSpanish := .T.

     ACTIVATE REPORT oReport ON STARTGROUP oReport:NewLine()

     CLOSE TEST

     oFont1:End()
     oFont2:End()
     oFont3:End()

RETURN oReport
