#include "FiveWin.ch"
#include "report.ch"



Function Rep22()

     LOCAL oReport, oFont1, oFont2, oFont3, oPen1, oPen2

     DEFINE FONT oFont1 NAME "ARIAL" SIZE 0,-10
     DEFINE FONT oFont2 NAME "ARIAL" SIZE 0,-10 BOLD
     DEFINE FONT oFont3 NAME "ARIAL" SIZE 0,-10 BOLD ITALIC

     DEFINE PEN oPen1 WIDTH 3 COLOR CLR_HGREEN
     DEFINE PEN oPen2 WIDTH 1 COLOR CLR_HMAGENTA

     USE TEST INDEX TEST NEW

     GO TOP

     REPORT oReport ;
          TITLE  "*** FiveWin Report DEMO ***",;
                 "",;
                 OemtoAnsi("by Ignacio Ortiz de Zu¤iga"),;
                 "" ;
          FONT   oFont1,;
                 oFont2,;
                 oFont3 ;
          PEN    oPen1,;
                 oPen2 ;
          HEADER "Date: "+dtoc(date()),;
                 "Time:  "+time() ;
                 RIGHT ;
          FOOTER OemtoAnsi("Page: ")+str(oReport:nPage,3) ;
                 CENTERED ;
          PREVIEW

     GROUP ON Test->State ;
           FOOTER "Total State "+oReport:aGroups[1]:cValue+ ;
                  " ("+ltrim(str(oReport:aGroups[1]:nCounter))+")" ;
           FONT 2

     COLUMN TITLE "ST" ;
          DATA Test->State ;
          FONT 2  ;
          GRID 2

     COLUMN TITLE "City" ;
          DATA Test->City ;
          GRID 2

     COLUMN TITLE "First Name","Last Name" ;
          DATA Test->First , Test->Last ;
          GRID 2

     COLUMN TITLE "   Salary" ;
          DATA Test->Salary ;
          PICTURE "9,999,999" ;
          SIZE 9 ;
          TOTAL ;
          SHADOW ;
          GRID

     END REPORT

     IF oReport:lCreated

          /*
          First line of title bold
          */

          oReport:oTitle:aFont[1] := {|| 2 }

          /*
          Total descriptors
          */

          oReport:cGrandTotal := "Grand Total..."
          oReport:cPageTotal := "Page Total..."

          /*
          Italic when salary greater than 100,000
          */

          oReport:aColumns[4]:bDataFont := {|| iif(Test->Salary>100000,3 ,1 ) }

          /*
          Change some colors
          */

          oReport:SetTxtColor(CLR_HBLUE,1)
          oReport:SetTxtColor(CLR_HRED,2)
          oReport:SetTxtColor(CLR_YELLOW,3)
          oReport:SetPenColor(CLR_HCYAN)
          oReport:SetShdColor(CLR_GREEN)

     ENDIF

     ACTIVATE REPORT oReport ON STARTGROUP oReport:NewLine() ;
                             ON STARTPAGE StartPage( oReport )

     /*
     Close and release
     */

     oFont1:End()
     oFont2:End()
     oFont3:End()
     oPen1:End()
     oPen2:End()

     CLOSE TEST

RETURN oReport


STATIC Function StartPage( oReport )

     oReport:Box(0.1,                            ;
                 0.1,                            ;
                 oReport:PhyHeight()-0.1,        ;
                 oReport:PhyWidth() -0.1         )

     oReport:Line(0.9, 0.55, 2, 0.55, 2 )
     oReport:Line(0.55, 0.9, 0.55, 2, 2 )
     oReport:SayBitmap(.3,.3,"ICO.BMP",.5,.5)
     oReport:SayBitmap(3,2,"CONFIDEN.BMP",4,4)

RETURN NIL

