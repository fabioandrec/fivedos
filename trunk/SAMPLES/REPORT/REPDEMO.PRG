#include "FiveWin.ch"

Static oWnd, oCurRep

#define EXIT_BMP   "..\..\BITMAPS\EXIT.BMP"
#define INFO_BMP   "..\..\BITMAPS\INFO.BMP"
#define PREVIEW_BMP "..\..\BITMAPS\SEEK.BMP"
#define PRG_BMP    "..\..\BITMAPS\PRG.BMP"
#define HELP_BMP   "..\..\BITMAPS\QUESTION.BMP"

FUNCTION Main()

     Local oBar, ;
           oBrowse

     CursorWait()

     USE REPDEMO NEW SHARED

     DEFINE WINDOW oWnd FROM 0, 0 TO ScrMaxRow(), ScrMaxCol()   ;
          TITLE "FiveWin Report Engine DEMO"            ;
          MENU  BuildMenu()                             ;
          NORESIZE                                      ;
          NOMINIMIZE                                    ;
          NODRAG

     DEFINE BUTTONBAR oBar OF oWnd

     DEFINE BUTTON FILENAME EXIT_BMP OF oBar ACTION oWnd:End() ;
          MESSAGE "Exit from DEMO"

     DEFINE BUTTON FILENAME INFO_BMP OF oBar                 ;
          MESSAGE "About..."                               ;
          ACTION MsgInfo( "FiveWin Report Engine DEMO", ;
                           OemtoAnsi("Developed by Ignacio Ortiz de Z£¤iga (1994)") )

     DEFINE BUTTON FILENAME PREVIEW_BMP OF oBar GROUP        ;
          MESSAGE "Preview the current Report"             ;
          ACTION Report()

     DEFINE BUTTON FILENAME PRG_BMP OF oBar             ;
          MESSAGE "Show source code from the current Report"   ;
          ACTION Source()

     DEFINE BUTTON FILENAME HELP_BMP OF oBar             ;
          MESSAGE "Show some comments from the current Report"   ;
          ACTION Comment()

     SET MESSAGE OF oWnd TO ;
          OemToAnsi("Designed and developed by Ignacio Ortiz de Z£¤iga   (1994)") ;
          CENTERED

     @ 1,0 LISTBOX oBrowse                ;
          FIELDS Strzero(Repdemo->Level,2) ,;
                 Repdemo->Prg            ,;
                 Repdemo->Descrip        ,;
                 ""                       ;
          HEADERS "Level"                ,;
                  "Source File"          ,;
                  "Description"          ,;
                  ""                      ;
          SIZE 78,20                      ;
          ON DBLCLICK Report()            ;
          OF oWnd
          // FIELDSIZES 45,110,410,1         ;

     CursorArrow()

     ACTIVATE WINDOW oWnd ;
          VALID  MsgYesNo("Exit from FiveWin Report DEMO?", "Select" )


     CLOSE ALL

RETURN (NIL)

//----------------------------------------------------------------------------//

STATIC FUNCTION BuildMenu()

     LOCAL oMenu

     MENU oMenu

          MENUITEM "&File"

               MENU

               MENUITEM "&Exit..."  ;
                    MESSAGE "Exit from FiveWin Report DEMO" ;
                    ACTION oWnd:End()

               SEPARATOR

               MENUITEM "&About..." ;
                    MESSAGE "About FiveWin Reports" ;
                    ACTION MsgInfo("FiveWin Report Engine",;
                                      OemtoAnsi("Developed by Ignacio Ortiz de Z£¤iga (1994)") )
               ENDMENU

          MENUITEM "&Report"

               MENU

               MENUITEM "&Preview"      ;
                    ACTION Report()     ;
                    MESSAGE "Preview current Report"

               MENUITEM "&Source" ;
                    ACTION Source()     ;
                    MESSAGE "Show source code from current Report"

               MENUITEM "&Comment" ;
                    ACTION Comment()     ;
                    MESSAGE "Show some comments from current Report"

               ENDMENU

     ENDMENU

RETURN oMenu

//----------------------------------------------------------------------------//

STATIC FUNCTION EditBrowse(nRow, nCol, oBrowse)

     LOCAL nColPos  := 0 ,;
           nColInit := 0 ,;
           nColGet  := 0

     LOCAL xVar

     IF nCol != NIL
          nColGet := AScan(oBrowse:GetColSizes(),;
                           { | nColumn | nColPos += nColumn,;
                            nCol <= nColPos },oBrowse:nColPos)
     ENDIF

     IF nColGet == 0
          nColGet := oBrowse:nColPos
     ENDIF

     xVar := RepDemo->(FieldGet(nColGet))

     oBrowse:lEditCol(nColGet, @xVar,"@K")

     IF xVar != RepDemo->(FieldGet(nColGet))
          Repdemo->(FieldPut(nColGet,xVar))
          oBrowse:DrawSelect()
     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION Comment()
/****
     LOCAL oDlg, oGet

     LOCAL cComment := Repdemo->Comments


     DEFINE DIALOG oDlg RESOURCE "COMMENTS"

     oDlg:cCaption := "Comments ["+trim(Repdemo->Prg)+"]"

     REDEFINE GET oGet VAR cComment ID 102 MEMO OF oDlg

     REDEFINE BUTTON ID 101 OF oDlg ACTION oDlg:End()

     ACTIVATE DIALOG oDlg CENTERED

     IF !(cComment == Repdemo->Comments)
          REPLACE Repdemo->Comments WITH cComment
     ENDIF

RETURN NIL
***/
//----------------------------------------------------------------------------//

STATIC FUNCTION Source()
/****
     LOCAL oDlg, oGet

     LOCAL cSource := MemoRead(Repdemo->Prg)

     DEFINE DIALOG oDlg RESOURCE "SOURCE"

     oDlg:cCaption := "Source ["+trim(Repdemo->Prg)+"]"

     REDEFINE GET oGet VAR cSource ID 102 MEMO OF oDlg

     REDEFINE BUTTON ID 101 OF oDlg ACTION oDlg:End()

     ACTIVATE DIALOG oDlg CENTERED

RETURN NIL
***/
//----------------------------------------------------------------------------//

STATIC FUNCTION Report()

     LOCAL cMacReport :=  Trim(SubStr( Repdemo->prg,;
                                    1,;
                                    RAt( ".", Repdemo->prg ) - 1 ))+"()"

     IF cMacReport = "REP"
          oCurRep = Eval(&("{||" + cMacReport + "}"))
     ELSE
          MsgBeep()
     ENDIF

     SELECT REPDEMO


RETURN NIL
