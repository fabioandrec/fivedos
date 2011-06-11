/*
CLASS TWindow

    DATA   nStyle, nNode, nOldWndRect, nWndIcon AS Numeric

    DATA   oClient, oMenu, oSysMenu, oBar, oVScroll, oHScroll

    DATA   nClrNormal, nClrHiBox, nClrHiTitle,;
           nClrLoBox, nClrLoTitle           AS Numeric

    DATA   cTitle                           AS Character

    DATA   lEnd, lModal, lDrag, lMinimized, ;
           lMaximized                       AS Logical

   //.......

*/


#include "cView.h"

#ifndef _CWINDOW_H_
#define _CWINDOW_H_

// Cuando TWindow hereda de TView este define debe ser el len de un Objeto
// TView: Debe definirse en cView.h
#ifndef TVIEW_LEN
#define TVIEW_LEN         0
#endif

// InstVars Indexes

#define INS_nSTYLE        TVIEW_LEN + 1
#define INS_nNODE         TVIEW_LEN + 2
#define INS_nOLDWNDRECT   TVIEW_LEN + 3    // nRect
#define INS_nWNDICON      TVIEW_LEN + 4    // nRect

#define INS_oCLIENT       TVIEW_LEN + 5    // Objetos Portados
#define INS_oMENU         TVIEW_LEN + 6
#define INS_oSYSMENU      TVIEW_LEN + 7
#define INS_oBAR          TVIEW_LEN + 8
#define INS_oVSCROLL      TVIEW_LEN + 9
#define INS_oHSCROLL     TVIEW_LEN + 10

#define INS_nCLRNORMAL   TVIEW_LEN + 11    // nColors
#define INS_nCLRHIBOX    TVIEW_LEN + 12
#define INS_nCLRHITITLE  TVIEW_LEN + 13
#define INS_nCLRLOBOX    TVIEW_LEN + 14
#define INS_nCLRLOTITLE  TVIEW_LEN + 15

#define INS_cTITLE       TVIEW_LEN + 16
#define INS_lEND         TVIEW_LEN + 17
#define INS_lMODAL       TVIEW_LEN + 18
#define INS_lDRAG        TVIEW_LEN + 19
#define INS_lMINIMIZED   TVIEW_LEN + 20
#define INS_lMAXIMIZED   TVIEW_LEN + 21

//---------------------------------------------------------------------------//

#include <WndStyls.h>

//---------------------------------------------------------------------------//

#endif

