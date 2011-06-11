#include "FiveDos.ch"
#include "report.ch"

STATIC oReport

Function Rep05()

     USE TEST INDEX TEST NEW

     REPORT oReport TITLE  "*** My First Report ***",;
                           "Date: "+dtoc(date()) ;
          HEADER "This is the first line of the header", ;
                 "This is the second line of the header", ;
                 "" RIGHT ;
          FOOTER "Page Number: "+str(oReport:nPage,3) CENTER ;
          PREVIEW

     COLUMN TITLE "St"         DATA Test->State
     COLUMN TITLE "First Name" DATA Test->First
     COLUMN TITLE "Last Name"  DATA Test->Last
     COLUMN TITLE "   Salary"  DATA Test->Salary TOTAL

     END REPORT

     ACTIVATE REPORT oReport

     CLOSE TEST

RETURN NIL


