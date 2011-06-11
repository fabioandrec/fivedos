/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Preview for class TReport                                  ³
³         File: RPREVIEW.PRG                                               ³
³       Author: Ignacio Ortiz de Z£¤iga Echeverr¡a                         ³
³          CIS: Ignacio Ortiz (100042,3051)                                ³
³         Date: 09/28/94                                                   ³
³         Time: 20:20:07                                                   ³
³    Copyright: 1994 by Ortiz de Zu¤iga, S.L.                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

#include "FiveWin.ch"

#define DEVICE      oWnd:cargo

#define GO_UP       1
#define GO_DOWN     2
#define GO_LEFT     1
#define GO_RIGHT    2
#define GO_PAGE    .T.

#define LANGUAJE     iif(lSpanish,2 ,1 )

#define TXT_FIRST    {"&First","&Primera"} [LANGUAJE]
#define TXT_PREVIOUS {"&Previous","&Anterior"} [LANGUAJE]
#define TXT_NEXT     {"&Next","&Siguiente"} [LANGUAJE]
#define TXT_LAST     {"&Last","&Ultima"} [LANGUAJE]
#define TXT_ZOOM     {"&Zoom","&Zoom"} [LANGUAJE]
#define TXT_UNZOOM   {"Un&zoom","&Normal"} [LANGUAJE]
#define TXT_TWOPAGES {"Two pa&ges",OemtoAnsi("Dos p &ginas")} [LANGUAJE]
#define TXT_ONEPAGE  {"One pa&ge",OemtoAnsi("Una p &gina")} [LANGUAJE]
#define TXT_PRINT    {"&Print","&Imprimir"} [LANGUAJE]
#define TXT_EXIT     {"&Exit","&Salir"} [LANGUAJE]
#define TXT_FILE     {"&File","&Fichero"} [LANGUAJE]
#define TXT_PAGE     {"&Page",OemtoAnsi("&P gina")} [LANGUAJE]
#define TXT_PREVIEW  {"Preview",OemtoAnsi("Previsualizaci¢n")} [LANGUAJE]
#define TXT_PAGENUM  {"Page Number: ",OemtoAnsi("N£mero de P gina: ")} ;
                     [LANGUAJE]

#define TXT_A_WINDOW_PREVIEW_IS_ALLREADY_RUNNING ;
            {"A Window Preview is allready running",;
             OemtoAnsi("Ya existe una Ventana de Previsualizaci¢n")};
            [LANGUAJE]


#define TXT_GOTO_FIRST_PAGE ;
            {"Goto first page",OemtoAnsi("Ir a la primera p gina")} ;
            [LANGUAJE]

#define TXT_GOTO_PREVIOUS_PAGE ;
            {"Goto previous page",OemtoAnsi("Ir a la anterior p gina")} ;
            [LANGUAJE]

#define TXT_GOTO_NEXT_PAGE ;
            {"Goto next page",OemtoAnsi("Ir a la siguiente p gina")} ;
            [LANGUAJE]

#define TXT_GOTO_LAST_PAGE ;
            {"Goto last page",OemtoAnsi("Ir a la £ltima p gina")} ;
            [LANGUAJE]

#define TXT_ZOOM_THE_PREVIEW ;
            {"Zoom the preview",OemtoAnsi("Zoom de la p gina")} ;
            [LANGUAJE]

#define TXT_UNZOOM_THE_PREVIEW ;
            {"Unzoom the preview",OemtoAnsi("Deshacer Zoom de la p gina")} ;
            [LANGUAJE]

#define TXT_PREVIEW_ON_TWO_PAGES ;
            {"Preview on two pages",OemtoAnsi("Previsualizaci¢n en dos p ginas")} ;
            [LANGUAJE]

#define TXT_PREVIEW_ON_ONE_PAGE ;
            {"Preview on one page",OemtoAnsi("Previsualizaci¢n en una p gina")} ;
            [LANGUAJE]

#define TXT_PRINT_CURRENT_PAGE ;
            {"Print current page",OemtoAnsi("Imprimir la p gina actual")} ;
            [LANGUAJE]

#define TXT_EXIT_PREVIEW ;
            {"Exit Preview",OemtoAnsi("Salir de la previsualizaci¢n")} ;
            [LANGUAJE]


STATIC oWnd, oBrush, oIcon, oBar, oFont, oCursor, oMeta1, oMeta2,;
       oPage, oMenu, oTwoPages, oZoom, oMenuZoom, oMenuTwoPages,;
       oMenuUnZoom, oMenuOnePage

STATIC nPage

STATIC lTwoPages, lZoom, lSpanish


//----------------------------------------------------------------------------//

FUNCTION RPreview(oDevice)

     LOCAL aFiles := oDevice:aMeta

     LOCAL hOldRes := GetResources()

     IF oWnd != NIL
          MsgStop(TXT_A_WINDOW_PREVIEW_IS_ALLREADY_RUNNING)
          RETU NIL
     ENDIF

     lSpanish := (GetProfStr("intl", "sLanguage") == "esp")

     SET RESOURCES TO "Preview.dll"

     DEFINE BRUSH oBrush STYLE TILED

     DEFINE ICON oIcon RESOURCE "Preview"

     DEFINE FONT oFont SIZE 0,-12 BOLD

     DEFINE CURSOR oCursor RESOURCE "Lupa"

     BuildMenu()

     DEFINE WINDOW oWnd FROM 0, 0 TO 24, 80  ;
          TITLE oDevice:cDocument            ;
          MENU oMenu                         ;
          BRUSH oBrush                       ;
          ICON  oIcon                        ;
          VSCROLL HSCROLL

     oWnd:oVScroll:SetRange(0,0)
     oWnd:oHScroll:SetRange(0,0)
     oWnd:oVScroll:nPgStep := 2.5
     oWnd:oHScroll:nPgStep := 2.5

     DEFINE BUTTONBAR oBar 3D SIZE 33, 33 OF oWnd

     DEFINE BUTTON RESOURCE "Top" OF oBar ;
          MESSAGE TXT_GOTO_FIRST_PAGE     ;
          ACTION TopPage()

     DEFINE BUTTON RESOURCE "Previous" OF oBar ;
          MESSAGE TXT_GOTO_PREVIOUS_PAGE       ;
          ACTION PrevPage()

     DEFINE BUTTON RESOURCE "Next" OF oBar ;
          MESSAGE TXT_GOTO_NEXT_PAGE       ;
          ACTION NextPage()

     DEFINE BUTTON RESOURCE "Bottom" OF oBar ;
          MESSAGE TXT_GOTO_LAST_PAGE          ;
          ACTION BottomPage()

     DEFINE BUTTON oZoom RESOURCE "Zoom" OF oBar GROUP ;
          MESSAGE TXT_ZOOM_THE_PREVIEW                 ;
          ACTION Zoom()

     DEFINE BUTTON oTwoPages RESOURCE "Two_Pages" OF oBar  ;
          MESSAGE TXT_PREVIEW_ON_TWO_PAGES       ;
          ACTION TwoPages()

     DEFINE BUTTON RESOURCE "Printer" OF oBar GROUP ;
          MESSAGE TXT_PRINT_CURRENT_PAGE            ;
          ACTION PrintPage()

     DEFINE BUTTON RESOURCE "Printer" OF oBar ;
          MESSAGE "Printer Setup"             ;
          ACTION PrinterSetup()

     DEFINE BUTTON RESOURCE "Exit" OF oBar GROUP ;
          MESSAGE TXT_EXIT_PREVIEW               ;
          ACTION oWnd:End()

     SET MESSAGE OF oWnd TO TXT_PREVIEW CENTERED

     oMeta1 := TMetaFile():New(0,0,0,0,;
                              aFiles[1],;
                              oWnd,;
                              CLR_BLACK,;
                              CLR_WHITE,;
                              oDevice:nHorzRes(),;
                              oDevice:nVertRes())

     oMeta1:oCursor := oCursor
     oMeta1:blDblClicked := {|nRow, nCol, nKeyFlags| ;
                            SetOrg1(nRow, nCol, nKeyFlags)}

     oMeta2 := TMetaFile():New(0,0,0,0,;
                              "",;
                              oWnd,;
                              CLR_BLACK,;
                              CLR_WHITE,;
                              oDevice:nHorzRes(),;
                              oDevice:nVertRes())

     oMeta2:oCursor := oCursor
     oMeta2:blDblClicked := {|nRow, nCol, nKeyFlags| ;
                            SetOrg2(nRow, nCol, nKeyFlags)}

     oMeta2:hide()

     nPage     := 1
     lTwoPages := .F.
     lZoom     := .F.

     @ 9, 350 SAY oPAGE PROMPT TXT_PAGENUM+ltrim(str(nPage,4)) ;
          SIZE 160, 15 PIXEL OF oBar FONT oFont

     oWnd:cargo := oDevice

     oWnd:bGotFocus  := {|| SetResources("Preview.dll")}
     oWnd:bLostFocus := {|| SetResources(hOldRes)}

     WndCenter(oWnd:hWnd)

     ACTIVATE WINDOW   oWnd ;
          ON RESIZE    PaintMeta() ;
          ON UP        vScroll(GO_UP) ;
          ON DOWN      vScroll(GO_DOWN) ;
          ON PAGEUP    vScroll(GO_UP,GO_PAGE) ;
          ON PAGEDOWN  vScroll(GO_DOWN,GO_PAGE) ;
          ON LEFT      hScroll(GO_LEFT) ;
          ON RIGHT     hScroll(GO_RIGHT) ;
          ON PAGELEFT  hScroll(GO_LEFT,GO_PAGE) ;
          ON PAGERIGHT hScroll(GO_RIGHT,GO_PAGE) ;
          VALID        (Aeval(aFiles,{|val| ferase(val) }),;
                        oDevice:End()                     ,;
                        SetResources(hOldRes)             ,;
                        oWnd := NIL, .T.)

Return (NIL)


//----------------------------------------------------------------------------//


STATIC FUNCTION BuildMenu()

     MENU oMenu
          MENUITEM TXT_FILE
          MENU
               MENUITEM TXT_PRINT ACTION PrintPage() ;
                    MESSAGE TXT_PRINT_CURRENT_PAGE

               SEPARATOR

               MENUITEM TXT_EXIT ACTION oWnd:End() ;
                    MESSAGE TXT_EXIT_PREVIEW
          ENDMENU

          MENUITEM TXT_PAGE
          MENU
               MENUITEM TXT_FIRST ACTION TopPage() ;
                    MESSAGE TXT_GOTO_FIRST_PAGE

               MENUITEM TXT_PREVIOUS ACTION BottomPage() ;
                    MESSAGE TXT_GOTO_PREVIOUS_PAGE

               MENUITEM TXT_NEXT ACTION NextPage() ;
                    MESSAGE TXT_GOTO_NEXT_PAGE

               MENUITEM TXT_LAST ACTION PrevPage() ;
                    MESSAGE TXT_GOTO_LAST_PAGE

               SEPARATOR

               MENUITEM  oMenuZoom PROMPT TXT_ZOOM ACTION Zoom(.T.) ;
                    ENABLED ;
                    MESSAGE TXT_ZOOM_THE_PREVIEW
               MENUITEM  oMenuUnZoom PROMPT TXT_UNZOOM ACTION Zoom(.T.) ;
                    DISABLED ;
                    MESSAGE TXT_UNZOOM_THE_PREVIEW

               SEPARATOR

               MENUITEM oMenuTwoPages PROMPT TXT_TWOPAGES ACTION TwoPages(.T.) ;
                    ENABLED ;
                    MESSAGE TXT_PREVIEW_ON_TWO_PAGES
               MENUITEM oMenuOnePage PROMPT TXT_ONEPAGE ACTION TwoPages(.T.) ;
                    DISABLED ;
                    MESSAGE TXT_PREVIEW_ON_ONE_PAGE
          ENDMENU
   ENDMENU

return NIL

//----------------------------------------------------------------------------//

STATIC Function PaintMeta()

     LOCAL oCoors1, oCoors2
     LOCAL aFiles := DEVICE:aMeta
     LOCAL nWidth, nHeight, nFactor

     IF IsIconic(oWnd:hWnd)
          RETU NIL
     ENDIF

     DO CASE
     CASE !lTwoPages

          IF !lZoom

               IF DEVICE:nHorzSize() >= ;        // Apaisado
                  DEVICE:nVertSize()
                    nFactor := .4
               ELSE
                    nFactor := .25
               ENDIF

          ELSE
               nFactor := .47
          ENDIF


          nWidth  := oWnd:nRight-oWnd:nLeft+1 - iif(lZoom,20 ,0 )
          nHeight := oWnd:nBottom-oWnd:nTop+1 - iif(lZoom,20 ,0 )

          oCoors1 := TRect():New(50,;
                                nWidth/2-(nWidth*nFactor),;
                                nHeight-80,;
                                nWidth/2+(nWidth*nFactor))

          oMeta1:SetCoors(oCoors1)
          oMeta2:Hide()

     CASE lTwoPages

          nFactor := .4
          aFiles  := DEVICE:aMeta

          nWidth  := oWnd:nRight-oWnd:nLeft+1
          nHeight := oWnd:nBottom-oWnd:nTop+1

          oCoors1 := TRect():New(50,;
                                (nWidth/4)-((nWidth/2)*nFactor),;
                                nHeight-80,;
                                (nWidth/4)+((nWidth/2)*nFactor))
          oCoors2 := TRect():New(50,;
                                (nWidth/4)-((nWidth/2)*nFactor)+(nWidth/2),;
                                nHeight-80,;
                                (nWidth/4)+((nWidth/2)*nFactor)+(nWidth/2))

          IF nPage == Len(aFiles)
               oMeta2:SetFile("")
          ELSE
               oMeta2:SetFile(aFiles[nPage+1])
          ENDIF

          oMeta1:SetCoors(oCoors1)
          oMeta2:SetCoors(oCoors2)
          oMeta2:Show()

     ENDCASE


RETURN NIL

//----------------------------------------------------------------------------//

STATIC Function NextPage()


     LOCAL aFiles := DEVICE:aMeta

     IF nPage == len(aFiles)
          MessageBeep()
          RETU NIL
     ENDIF

     nPage++

     oMeta1:SetFile(aFiles[nPage])
     oPage:SetText(TXT_PAGENUM+ltrim(str(nPage,4)))

     oMeta1:Refresh()

     IF lTwoPages
          IF len(aFiles) >= (nPage+1)
               oMeta2:SetFile(aFiles[nPage+1])
          ELSE
               oMeta2:SetFile("")
          ENDIF
          oMeta2:Refresh()
     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC Function PrevPage()


     LOCAL aFiles := DEVICE:aMeta

     IF nPage == 1
          MessageBeep()
          RETU NIL
     ENDIF

     nPage--

     oMeta1:SetFile(aFiles[nPage])
     oPage:SetText(TXT_PAGENUM+ltrim(str(nPage,4)))
     oMeta1:Refresh()

     IF lTwoPages
          IF len(aFiles) >= nPage+1
               oMeta2:SetFile(aFiles[nPage+1])
          ELSE
               oMeta2:SetFile("")
          ENDIF
          oMeta2:Refresh()
     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC Function TopPage()


     LOCAL aFiles := DEVICE:aMeta

     IF nPage == 1
          MessageBeep()
          RETU NIL
     ENDIF

     nPage := 1

     oMeta1:SetFile(aFiles[nPage])
     oPage:SetText(TXT_PAGENUM+ltrim(str(nPage,4)))

     oMeta1:Refresh()

     IF lTwoPages
          IF len(aFiles) >= nPage+1
               oMeta2:SetFile(aFiles[nPage+1])
          ELSE
               oMeta2:SetFile("")
          ENDIF
          oMeta2:Refresh()
     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC Function BottomPage()


     LOCAL aFiles := DEVICE:aMeta

     IF nPage == len(aFiles)
          MessageBeep()
          RETU NIL
     ENDIF

     nPage := len(aFiles)

     oMeta1:SetFile(aFiles[nPage])
     oPage:SetText(TXT_PAGENUM+ltrim(str(nPage,4)))

     oMeta1:Refresh()

     IF lTwoPages
          oMeta2:SetFile("")
          oMeta2:Refresh()
     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION TwoPages(lMenu)


     DEFAULT lMenu := .F.

     lTwoPages := !lTwoPages

     IF lTwoPages

          IF len(DEVICE:aMeta) == 1 // solo hay una pagina
               lTwoPages := !lTwoPages
               MessageBeep()
               RETU NIL
          ENDIF

          IF DEVICE:nHorzSize() >= ;        // Apaisado
             DEVICE:nVertSize()
               lTwoPages := !lTwoPages
               MessageBeep()
               RETU NIL
          ENDIF

          IF lZoom
               Zoom(.T.)
          ENDIF

          oTwoPages:FreeBitmaps()
          oTwoPages:LoadBitmaps("One_Page")
          oTwoPages:cMsg := TXT_PREVIEW_ON_ONE_PAGE
          oMenuTwoPages:disable()
          oMenuOnePage:enable()

     ELSE

          oTwoPages:FreeBitmaps()
          oTwoPages:LoadBitmaps("Two_Pages")
          oTwoPages:cMsg := TXT_PREVIEW_ON_TWO_PAGES
          oMenuTwoPages:enable()
          oMenuOnePage:disable()

     ENDIF

     IF lMenu
          oTwoPages:Refresh()
     ENDIF

     PaintMeta()

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION Zoom(lMenu)

     DEFAULT lMenu := .F.

     lZoom := !lZoom

     IF lZoom

          IF lTwoPages
               TwoPages(.T.)
          ENDIF

          oZoom:FreeBitmaps()
          oZoom:LoadBitmaps("Unzoom")
          oZoom:cMsg := TXT_UNZOOM_THE_PREVIEW
          oMenuZoom:disable()
          oMenuUnZoom:enable()

          oWnd:oVScroll:SetRange(1,10)
          oWnd:oHScroll:SetRange(1,10)

          oMeta1:oCursor := NIL
          oMeta1:ZoomIn()

     ELSE

          oZoom:FreeBitmaps()
          oZoom:LoadBitmaps("Zoom")
          oZoom:cMsg := TXT_ZOOM_THE_PREVIEW
          oMenuZoom:enable()
          oMenuUnZoom:disable()

          oWnd:oVScroll:SetRange(0,0)
          oWnd:oHScroll:SetRange(0,0)

          oMeta1:oCursor := oCursor
          oMeta1:ZoomOut()

     ENDIF

     IF lMenu
          oZoom:Refresh()
     ENDIF

     PaintMeta()

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION VScroll(nType,lPage)

     LOCAL nYfactor, nYorig, nStep

     DEFAULT lPage := .F.

     nYfactor := Int(DEVICE:nVertRes()/oWnd:oVScroll:nMax)

     IF lPage
          nStep := oWnd:oVScroll:nPgStep
     ELSE
          nStep := 1
     ENDIF

     IF nType == GO_UP
          nStep := -(nStep)
     ENDIF

     nYorig := nYfactor * (oWnd:oVScroll:GetPos() + nStep)

     IF nYorig > DEVICE:nVertRes()
          nYorig := DEVICE:nVertRes()
     ENDIF

     IF nYorig < 0
          nYorig := 0
     ENDIF

     oMeta1:SetOrg(NIL,nYorig)

     oMeta1:Refresh()

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION HScroll(nType,lPage)

     LOCAL nXfactor, nXorig, nStep

     DEFAULT lPage := .F.

     nXfactor := Int(DEVICE:nHorzRes()/oWnd:oHScroll:nMax)

     IF lPage
          nStep := oWnd:oHScroll:nPgStep
     ELSE
          nStep := 1
     ENDIF

     IF nType == GO_LEFT
          nStep := -(nStep)
     ENDIF

     nXorig := nXfactor * (oWnd:oHScroll:GetPos() + nStep)

     IF nXorig > DEVICE:nHorzRes()
          nXorig := DEVICE:nHorzRes()
     ENDIF

     IF nXorig < 0
          nXorig := 0
     ENDIF

     oMeta1:SetOrg(nXorig,NIL)

     oMeta1:Refresh()

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION SetOrg1(nX, nY)

     LOCAL oCoors := oMeta1:GetRect()

     LOCAL nXStep, nYStep, nXFactor, nYFactor

     IF lZoom
          Zoom(.T.)
          RETU NIL
     ENDIF

     nXstep   := Max(Int(nX * 10 / (oCoors:nBottom - oCoors:nTop))-1,0)
     nYstep   := Max(Int(nY * 10 / (oCoors:nRight - oCoors:nLeft))-3,0)

     nXfactor := Int(DEVICE:nVertRes()/10)
     nYfactor := Int(DEVICE:nHorzRes()/10)

     oMeta1:SetOrg(nYstep*nYfactor,nXstep*nXfactor)

     Zoom(.T.)

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION SetOrg2(nX, nY)

     LOCAL oCoors := oMeta2:GetRect()
     LOCAL aFiles
     LOCAL nXStep, nYStep, nXFactor, nYFactor


     IF oMeta2:cCaption == ""
          RETU NIL
     ENDIF

     IF lZoom
          Zoom(.T.)
          RETU NIL
     ENDIF

     nXstep   := Max(Int(nX * 10 / (oCoors:nBottom - oCoors:nTop))-1,0)
     nYstep   := Max(Int(nY * 10 / (oCoors:nRight - oCoors:nLeft))-3,0)

     nXfactor := Int(DEVICE:nVertRes()/10)
     nYfactor := Int(DEVICE:nHorzRes()/10)

     oMeta1:SetOrg(nYstep*nYfactor,nXstep*nXfactor)
     oMeta1:SetFile(oMeta2:cCaption)

     aFiles := DEVICE:aMeta

     IF nPage = len(aFiles)
          oMeta2:SetFile("")
     ELSE
          oMeta2:SetFile(aFiles[++nPage])
     ENDIF

     oPage:Refresh()
     Zoom(.T.)

RETURN NIL

//----------------------------------------------------------------------------//

STATIC Function PrintPage()

     LOCAL hMeta := oMeta1:hMeta

     LOCAL oDlg, oRad, oPageIni, oPageFin

     LOCAL nOption := 1 ,;
           nFirst  := 1 ,;
           nLast   := len(DEVICE:aMeta)


     IF lSpanish
          DEFINE DIALOG oDlg RESOURCE "DLG_ESP"
     ELSE
          DEFINE DIALOG oDlg RESOURCE "DLG_ENG"
     ENDIF

     REDEFINE BUTTON ID 101 OF oDlg ;
          ACTION PrintPrv(oDlg, nOption, nFirst, nLast)

     REDEFINE BUTTON ID 102 OF oDlg ACTION oDlg:End()

     REDEFINE RADIO oRad VAR nOption ID 103,104,105 OF oDlg

     REDEFINE GET oPageIni ;
          VAR nFirst ;
          ID 106 ;
          PICTURE "@K 99999" ;
          WHEN nOption == 3 ;
          VALID iif(nFirst<1 .OR. nFirst>nLast,(MessageBeep(),.F.),.T.) ;
          OF oDlg
     REDEFINE GET oPageFin ;
          VAR nLast ;
          ID 107 ;
          PICTURE "@K 99999" ;
          WHEN nOption == 3 ;
          VALID iif(nLast<nFirst .OR. nLast>len(DEVICE:aMeta), ;
                    (MessageBeep(),.F.),.T.) ;
          OF oDlg

     ACTIVATE DIALOG oDlg CENTERED

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION PrintPrv(oDlg, nOption, nPageIni, nPageEnd)


     LOCAL aFiles := DEVICE:aMeta

     LOCAL hMeta := oMeta1:hMeta

     LOCAL nFor

     CursorWait()

     StartDoc(DEVICE:hDC, DEVICE:cDocument )

     DO CASE

     CASE nOption == 1                           // All

          FOR nFor := 1 TO len(aFiles)
               StartPage(DEVICE:hDC)
               hMeta := GetMetaFile(aFiles[nFor])
               PlayMetaFile( DEVICE:hDC, hMeta )
               DeleteMetafile(hMeta)
               EndPage(DEVICE:hDC)
          NEXT

     CASE nOption == 2                           // Current page

          StartPage(DEVICE:hDC)
          hMeta := oMeta1:hMeta
          PlayMetaFile( DEVICE:hDC, hMeta )
          EndPage(DEVICE:hDC)

     CASE nOption == 3                           // Range

          FOR nFor := nPageIni TO nPageEnd
               StartPage(DEVICE:hDC)
               hMeta := GetMetaFile(aFiles[nFor])
               PlayMetaFile( DEVICE:hDC, hMeta )
               DeleteMetafile(hMeta)
               EndPage(DEVICE:hDC)
          NEXT

     ENDCASE

     EndDoc(DEVICE:hDC)

     CursorArrow()

     oDlg:End()

RETURN NIL
