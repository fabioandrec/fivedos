#include "FiveDos.ch"

Static oWnd

FUNCTION Main()

     Local oBrush ,;
           oBar   ,;
           oIcon  ,;
           oBrowse

     // StartMonitor()

     // SET 3DLOOK ON

     //CursorWait()

     USE REPDEMO NEW

     DEFINE BRUSH oBrush STYLE TILED

     DEFINE ICON oIcon RESOURCE "FIVEREP"

     DEFINE WINDOW oWnd FROM 0, 0 TO 24, 78             ;
          TITLE "FiveWin Report Engine DEMO"            ;
          MENU  BuildMenu()                             ;
          BORDER NONE  NOZOOM                           ;
          ICON oIcon                                    ;
          BRUSH oBrush

//     DEFINE BUTTONBAR oBar 3D SIZE 33, 33 OF oWnd
     DEFINE BUTTONBAR oBar OF oWnd

     DEFINE BUTTON RESOURCE "EXIT" OF oBar ACTION oWnd:End() ;
          MESSAGE "Exit from DEMO"

     DEFINE BUTTON RESOURCE "INFO" OF oBar                 ;
          MESSAGE "About..."                               ;
          ACTION ShellAbout( "FiveWin Report Engine DEMO", ;
                             OemtoAnsi("Developed by Ignacio Ortiz de Z£¤iga (1994)"),;
                             oIcon:hIcon )

     DEFINE BUTTON RESOURCE "PREVIEW" OF oBar GROUP        ;
          MESSAGE "Preview the current Report"             ;
          ACTION Report()

     DEFINE BUTTON RESOURCE "PRG" OF oBar             ;
          MESSAGE "Show source code from the current Report"   ;
          ACTION Source()

     DEFINE BUTTON RESOURCE "HELP" OF oBar             ;
          MESSAGE "Show some comments from the current Report"   ;
          ACTION Comment()

     SET MESSAGE OF oWnd TO ;
          OemToAnsi("Designed and developed by Ignacio Ortiz de Z£¤iga   (1994)") ;
          CENTERED

     @ 3.3,2 LISTBOX oBrowse                ;
          FIELDS Strzero(Repdemo->Level,2) ,;
                 Repdemo->Prg            ,;
                 Repdemo->Descrip        ,;
                 ""                       ;
          HEADERS "Level"                ,;
                  "Source File"          ,;
                  "Description"          ,;
                  ""                      ;
          SIZE 592,258                    ;
          FIELDSIZES 45,110,410,1         ;
          OF oWnd

//     oBrowse:bKeyDown   := {|nKey| iif(nKey=K_ENTER,EditBrowse(,,oBrowse), )}
//   No need in FiveDos
     oBrowse:bLDblClick := {|nRow,nCol| EditBrowse(nRow,nCol,oBrowse) }

     WndCenter(oWnd:hWnd)

     CursorArrow()

     ACTIVATE WINDOW oWnd ;
          VALID  MsgYesNo("Exit from FiveWin Report DEMO?", "Select" ) ;


//     SET 3DLOOK OFF

     CLOSE ALL

     //EndMonitor()

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
                    ACTION ShellAbout("FiveWin Report Engine",;
                                      OemtoAnsi("Developed by Ignacio Ortiz de Z£¤iga (1994)"),;
                                      oWnd:oIcon:hIcon )
               ENDMENU

          MENUITEM "&Report"

               MENU

               MENUITEM "&Preview" ;
                    ACTION NIL     ;
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

     LOCAL oDlg, oGet

     LOCAL cComment := Repdemo->Comments


     DEFINE DIALOG oDlg from 5,5 to 20,60 title "Comments ["+trim(Repdemo->Prg)+"]"

     @ 1,1 GET oGet VAR cComment   OF oDlg

     @ 12,50  BUTTON ' &Exit ' OF oDlg ACTION oDlg:End()

     ACTIVATE DIALOG oDlg CENTERED

//     IF !(cComment == Repdemo->Comments)
//          REPLACE Repdemo->Comments WITH cComment
//     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION Source()
/*
     LOCAL oDlg, oGet

     LOCAL cSource := MemoRead(Repdemo->Prg)

     DEFINE DIALOG oDlg RESOURCE "SOURCE"

     oDlg:cCaption := "Source ["+trim(Repdemo->Prg)+"]"

     REDEFINE GET oGet VAR cSource ID 102 MEMO OF oDlg

     REDEFINE BUTTON ID 101 OF oDlg ACTION oDlg:End()

     ACTIVATE DIALOG oDlg CENTERED
  */
     alert(' No yet Implemented' )
RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION Report()

     LOCAL cMacReport :=  Trim(SubStr( Repdemo->prg,;
                                    1,;
                                    RAt( ".", Repdemo->prg ) - 1 ))+"()"

     IF cMacReport = "REP"
          Eval(&("{||" + cMacReport + "}"))
     ELSE
          Messagebeep()
     ENDIF

     SELECT REPDEMO


RETURN NIL
