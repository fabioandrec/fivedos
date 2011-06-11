#include "FiveWin.ch"
#include "report.ch"
#include "dbstruct.ch"

Function Rep15()

    local oReport, nField

     LOCAL aStructure := DbStruct("Test.dbf")

     IF len(aStructure) == 0
          MsgStop("Could not read Test.dbf structure")
          RETU NIL
     ENDIF

     nField := 1

     REPORT oReport TITLE  "*** TEST.DBF STRUCTURE ***","" PREVIEW

     COLUMN TITLE "Name" DATA aStructure[nField][DBS_NAME] SIZE 15

     COLUMN TITLE "Type" DATA aStructure[nField][DBS_TYPE] SIZE 6

     COLUMN TITLE "Len" DATA aStructure[nField][DBS_LEN] SIZE 3 TOTAL

     COLUMN TITLE "Decimals" DATA aStructure[nField][DBS_DEC] SIZE 8


     END REPORT

     /*
     Just the following
     */

     oReport:bSkip := {|| nField++}


     ACTIVATE REPORT oReport WHILE nField <= len(aStructure)

RETURN oReport
