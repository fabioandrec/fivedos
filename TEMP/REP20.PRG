#include "FiveWin.ch"
#include "report.ch"


Function Rep20()

     LOCAL oReport, nRecno, oFont


     DEFINE FONT oFont NAME "ARIAL" SIZE 0,-10

     SELECT REPDEMO

     nRecno := Recno()

     GO TOP

     REPORT oReport ;
          TITLE  "*** Fivewin Report ***"  ;
          FONT oFont ;
          PREVIEW

     COLUMN TITLE "Level" DATA Repdemo->Level SIZE 5
     COLUMN TITLE "Source" DATA Repdemo->Prg

     COLUMN TITLE "Comments" DATA " " SIZE 50     // * Trick *

     END REPORT

     ACTIVATE REPORT oReport ;
          ON CHANGE SayMemo( oReport )

     GOTO nRecno

     oFont:End()

RETURN oReport

STATIC Function SayMemo( oReport )

     LOCAL cText, cLine
     LOCAL nFor, nLines

     cText := Repdemo->Comments

     nLines := MlCount(cText,50)

     oReport:BackLine(1)

     FOR nFor := 1 TO nLines

          //cLine := Alltrim(MemoLine(cText, 50, nFor))
          cLine := MemoLine(cText, 50, nFor)

          oReport:StartLine()
          oReport:Say(3,cLine)
          oReport:EndLine()

     NEXT

     oReport:Newline()

RETURN NIL

