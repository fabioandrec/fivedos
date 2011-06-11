#ifndef _WINDOW_CH
#define _WINDOW_CH

#xcommand DEFINE WINDOW <oWnd> ;
             [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
             [ AT <nTop>, <nLeft> ]                         ;
             [ SIZE <nWidth>, <nHeight> ]                   ;
             [ TITLE <cTitle> ]                             ;
             [ COLOR <cColorSpec> ]                         ;
             [ OF <oParent> ]                               ;
             [ BRUSH <cBrush> ] ;                     // Char to erase Client BackGround
             [ CURSOR <oCursor> ]                           ;
             [ ICON  <oIcon> ]                              ;
             [ MENU <oMenu> ]                               ;
             [ BORDER <border: NONE, SINGLE> ] ;      // FiveWin Compatibility only
             [ STYLE <nStyle> ] ;                     // Styles
             [ <NoSysMenu:  NOSYSMENU, NO SYSMENU> ] ;
             [ <NoCaption:  NOCAPTION, NO CAPTION, NO TITLE> ] ;
             [ <NoMinimize: NOICONIZE, NOMINIMIZE> ] ;
             [ <NoMaximize: NOZOOM, NO ZOOM, NOMAXIMIZE, NO MAXIMIZE> ] ;
             [ <NoResize:   NORESIZE> ] ;
             [ <NoDrag:     NODRAG, NOMOVE> ] ;
             [ <NoShadow:   NOSHADOW> ] ;
             [ <vScroll:    VSCROLL, VERTICAL SCROLL> ] ;
             [ <hScroll:    HSCROLL, HORIZONTAL SCROLL> ] ;
             [ LABEL COLORS <cColorLabels> ] ;
        => ;
          ( <oWnd> := TWindow() ):New( <nTop>, <nLeft>, <nBottom>, <nRight>, ;
                       <nWidth>, <nHeight>, <cTitle>, <cColorSpec>, ;
                       <.NoSysMenu.>, <.NoDrag.>, <.NoResize.>, ;
                       <.NoMinimize.>, <.NoMaximize.>, ;
                       <.vScroll.>, <.hScroll.>, <oMenu>, <.NoShadow.>,;
                       <oParent>, <nStyle>, <cBrush>, <cColorLabels> )

#xcommand DEFINE DIALOG <oWnd> ;
             [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
             [ AT <nTop>, <nLeft> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ TITLE <cTitle> ] ;
             [ COLOR <cColorSpec> ] ;
             [ <NoSysMenu: NOSYSMENU, NO SYSMENU> ] ;
             [ <NoShadow: NOSHADOW> ] ;
             [ <NoDrag:     NODRAG, NOMOVE> ] ;
             [ OF <oParent> ] ;
             [ BRUSH <cBrush> ] ;                     // Char to erase Client BackGround
             [ STYLE <nStyle> ] ;                     // Styles
             [ LABEL COLORS <cColorLabels> ] ;
        => ;
          ( <oWnd> := TWindow() ):New( <nTop>, <nLeft>, <nBottom>, <nRight>, ;
                       <nWidth>, <nHeight>, <cTitle>,  ;
                       <cColorSpec>, <.NoSysMenu.>, <.NoDrag.>, ;
                       .t., .t., .t. , ;
                       .f., .f., , <.NoShadow.>,;
                       <oParent>, <nStyle>, <cBrush>, <cColorLabels> )

#xcommand ACTIVATE <wnd:WINDOW,DIALOG> <oWnd> ;
             [ <show: ICONIZED, NORMAL, MAXIMIZED> ] ;
             [ <center:CENTERED> ] ;
             [ WHEN <uWhen,...> ] ;
             [ VALID <uValid,...> ] ;
             [ ON [ LEFT ] CLICK <uClick,...> ] ;
             [ ON RIGHT CLICK <uRClick,...> ] ;
             [ ON DBLCLICK <uDblClick,...> ] ;
             [ ON MOVE <uMove,...> ] ;
             [ ON PAINT <uPaint,...> ] ;
             [ ON RESIZE <uResize,...> ] ;
             [ ON KEYDOWN <uKeyDown,...> ] ;
             [ ON INIT <uInit,...> ] ;
             [ ON CLOSE <uClosed,...> ] ;
             [ ON UP <uUp,...> ] ;
             [ ON DOWN <uDown,...> ] ;
             [ ON PAGEUP <uPgUp,...> ] ;
             [ ON PAGEDOWN <uPgDn,...> ] ;
             [ ON LEFT <uLeft,...> ] ;
             [ ON RIGHT <uRight,...> ] ;
             [ ON PAGELEFT <uPgLeft,...> ] ;
             [ ON PAGERIGHT <uPgRight,...> ] ;
             [ ON SCROLL UP    <uScrollUp,...> ] ;
             [ ON SCROLL DOWN  <uScrollDown,...> ] ;
             [ ON SCROLL LEFT  <uScrollLeft,...> ] ;
             [ ON SCROLL RIGHT <uScrollRight,...> ] ;
             [ <nowait: NOWAIT> ] ;
        => ;
          <oWnd>:Activate( #<show>, <.nowait.>, ;
                           [ \{|| <uWhen> \} ], ;
                           [ \{|| <uValid> \} ], ;
                           [ \{|| <uClick> \} ], ;
                           [ \{|| <uMove> \} ], ;
                           [ \{|| <uPaint> \} ], ;
                           [ \{|| <uResize> \} ], ;
                           [ \{|| <uScrollUp> \} ], ;
                           [ \{|| <uScrollDown> \} ], ;
                           [ \{|| <uScrollLeft> \} ], ;
                           [ \{|| <uScrollRight> \} ], ;
                           <.center.>, ;
                           [ \{|| <uInit> \} ],;
                           [ \{|| <uClosed> \} ],;
                           [ \{|nKey| <uKeyDown> \} ] )

//---------------------------------------------------------------------------//
// MESSAGE BAR

#xcommand SET MESSAGE OF <oWnd> ;
             [ TO <cMsg> ] ;
             [ <center: CENTERED> ] ;
       => ;
          [ <oWnd>:cMessage := <oWnd>:cDftMsg := if( !empty( <cMsg> ), <cMsg>, "" ) ]

#xcommand DEFINE MESSAGE BAR [<oMsg>] OF <oWnd> ;
             [ PROMPT <cMsg> ] ;
             [ <center: CENTERED> ] ;
       => ;
          SET MESSAGE OF <oWnd> [ TO <cMsg> ]

//---------------------------------------------------------------------------//
// Brushes

#xcommand DEFINE BRUSH [ <oBrush> ] ;
             [ STYLE <cStyle> ] ;
             [ COLOR <nRGBColor> ] ;
             [ <file:FILE,FILENAME,DISK> <cBmpFile> ] ;
             [ <resource:RESOURCE,NAME,RESNAME> <cBmpRes> ] ;
       =>
*          [ <oBrush> := ] TBrush():New( [ Upper(<(cStyle)>) ], <nRGBColor>,;
*             <cBmpFile>, <cBmpRes> )

#xcommand RELEASE BRUSH <oBrush> => //<oBrush>:Release()

#xcommand SET BRUSH ;
             [ OF <oWnd> ] ;
             [ TO <oBrush> ] ;
       =>
*          <oWnd>:SetBrush( <oBrush> )

//----------------------------------------------------------------------------//
// Icons

#xcommand @ <nRow>, <nCol> ICON [ <oIcon> ] ;
             [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cIcoFile> ] ;
             [ <border:BORDER> ] ;
             [ ON CLICK <uClick,...> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <update: UPDATE> ] ;
       =>
*          [ <oIcon> := ] TIcon():New( <nRow>, <nCol>, <cResName>,;
*             <cIcoFile>, <.border.>, [ \{|| <uClick> \} ], <oWnd>, <.update.> )

#xcommand DEFINE ICON <oIcon> ;
             [ <resource: NAME, RESOURCE, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cIcoFile> ] ;
       =>
*          <oIcon> := TIcon():New( ,, <cResName>, <cIcoFile> )

//---------------------------------------------------------------------------//

/*----------------------------------------------------------------------------//
!short: Timer  */

#xcommand DEFINE TIMER <nTimerHandle> ;
             [ INTERVAL <nInterval> ] ;
             [ ACTION <uAction,...> ]     ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          <nTimerHandle> := TimerNew( int( MAX( 54.945, <nInterval> ) / 54.945 ) [, \{|| <uAction> \} ] )

#xcommand ACTIVATE TIMER <nTimerHandle> => TimerActivate( <nTimerHandle> )

#xcommand DEACTIVATE TIMER <nTimerHandle> => TimerDeActivate( <nTimerHandle> )

#xcommand RELEASE TIMER <nTimerHandle> => TimerRelease( <nTimerHandle> )

//---------------------------------------------------------------------------//

/*----------------------------------------------------------------------------//
!short: TimeOut control ( Screen-savers ) */

#xcommand SET TIMEOUT TO <nSeconds> [ SECONDS ] => nTimeOut( <nSeconds> )

#xcommand ON TIMEOUT DO <uAction,...> => bTimeOutAction( \{|| <uAction> \} )

//---------------------------------------------------------------------------//

#endif


