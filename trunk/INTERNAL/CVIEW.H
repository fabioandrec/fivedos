/*
CLASS TView

    DATA cVPort, ;
         oWnd, ;
         aChilds, ;
         oFocussed,;
         nID, ;
         cVarName,;
         Cargo
         nColor, ;
         cChar, ;
         cMessage,;
         nClipRect

    DATA nFocussed, ; // Child con focus
         nPaintCount, ;
         nHelpId,;
         nHotKey,;
         nAlign    INIT 0

    DATA lPainted, ;
         lFocussed, ;
         lDesign    INIT .F.

    DATA lVisible               INIT .T.
    DATA bWhen, bValid          AS Block INIT bTrue()
    DATA bPaint, bClick, bRight AS Block INIT bNil()
    DATA bKey                   AS Block
    DATA nMouseCursor           INIT IDC_ARROW
    DATA lUpdate                INIT .f.
*/

#ifndef _CVIEW_H_
#define _CVIEW_H_

#define INS_cVPORT       1
#define INS_oWND         2
#define INS_aCHILDS      3
#define INS_oFOCUSSED    4
#define INS_nID          5
#define INS_cVARNAME     6
#define INS_CARGO        7
#define INS_nCOLOR       8
#define INS_cCHAR        9
#define INS_cMESSAGE    10
#define INS_nCLIPRECT   11
#define INS_nFOCUSSED   12      // Child con focus
#define INS_nPAINTCOUNT 13
#define INS_nHELPID     14
#define INS_nHOTKEY     15
#define INS_nALIGN      16
#define INS_lPAINTED    17
#define INS_lFOCUSSED   18
#define INS_lDESIGN     19
#define INS_lVISIBLE    20
#define INS_bWHEN       21
#define INS_bVALID      22
#define INS_bPAINT      23
#define INS_bCLICK      24
#define INS_bRIGHT      25
#define INS_bKEY        26
#define INS_nMSCURSOR   27
#define INS_lUPDATE     28

#define TVIEW_LEN       28

#endif
