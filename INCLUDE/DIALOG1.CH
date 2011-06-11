#ifndef _DIALOG_CH
#define _DIALOG_CH

                                                                                                    /*
!Short:^BBUTTON^B               Botones
 ^BComandos para Buttons                                                                            */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> BUTTON [ <oBtn> <etiq: PROMPT, LABEL> ] <cText> ;
             [ SIZE <nWidth>, <nHeight>         ]           ;
             [ <color: COLOR, COLORS> <cColors> ]           ;
             [ MESSAGE <cMsg>       ]                       ;
             [ ACTION <uAction,...> ]                       ;
             [ <design: DESIGN>     ]                       ;
             [ <update: UPDATE>     ]                       ;
             [ <default: DEFAULT>   ]                       ;
             [ <help:HELP, HELPID, HELP ID> <nHelpId> ]     ;
             [ FONT <oFont>   ]                             ;
             [ <pixel: PIXEL> ]                             ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd>  ]          ;
             [ FILE <cBmp> [, <cBmp2> ]          ]          ;
             [ WHILE PRESSED <bWhilePressed,...> ]          ;
             [ WHEN    <uWhen,...>  ]                       ;
             [ VALID   <uValid,...> ]                       ;
       => ;
          [ <oBtn> := ] TButton():New( <nRow>, <nCol>, <cText>, <cColors>,  ;
                        <nWidth>, <nHeight>, <oWnd>, [ \{|| <uAction> \} ], <cMsg>, ;
                        <cBmp>, <cBmp2>, [ \{|| <bWhilePressed> \} ], [ \{|| <uWhen> \} ],;
                        [ \{|| <uValid> \} ] )

                                                                                                    /*
!Short:^BBUTTONBAR^B            Button Bar
 ^BComandos para Button Bar                                                                         */
//--------------------------------------------------------------------------//
#xcommand DEFINE BUTTON [ <oBtn> ] ;
             [ <bar: OF, BUTTONBAR > <oBar> ] ;
             [ <resource: NAME, RESNAME, RESOURCE> <cResName> [,<cResName2>] ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> [,<cBmpFile2>] ] ;
             [ <action: ACTION, EXEC> <uAction,...> ] ;
             [ <lGroup:  GROUP > ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <etiq: LABEL, PROMPT> <cCars> ] ;
             [ WHILE PRESSED <bWhilePressed,...> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <adjust: ADJUST > ] ;
             [ <Toolstips: TIPS, TOOLTIPS> <cTips> ];
             [ <ColorTip: TIPCOLOR, COLORTIP> <cColorTips>];
      => ;
         [ <oBtn> := ] TBtnBmp():New( <oBar>, <cBmpFile>, <cBmpFile2>, <cCars>,;
                 [ \{|| <uAction> \} ], <.lGroup.>, <cColors>, <cMsg>,;
                  [ \{|| <bWhilePressed> \} ], <cTips>, <cColorTips> )

#xcommand DEFINE BUTTONBAR [ <oBar> ]          ;
          [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
      => ;
         [ <oBar> := ] TBtnBar():New( <oWnd> )
         
                                                                                                    /*
!Short:^BCHECKBOX^B             Check Boxes
 ^BComandos para CheckBox                                                                           */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> CHECKBOX [ <oCbx> VAR ] <lVar> ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ WHEN <uWhen,...> ] ;
             [ VALID <uValid,...> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ; 
             [ FONT <oFont> ] ;
             [ ON CLICK <uClick> ] ;
             [ <design: DESIGN> ] ;
             [ <pixel: PIXEL> ] ;
             [ <update: UPDATE> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> [,<cBmpFile2>] ] ;
       => ;
          [ <oCbx> := ] TCheckBox():New( <nRow>, <nCol>, <cLabel>,;
              <cMsg>, <cColors>, <oWnd>, [\{|| <uWhen> \}], [\{|| <uValid> \}], bSETGET(<lVar>) ,;
              <cBmpFile> [,<cBmpFile2>]  )

                                                                                                    /*
!Short:^BRADIOBUTTON^B          Button on Radio
 ^BComandos para RadioButtons                                                                       */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> RADIOBUTTON [ <oRbt> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ WHEN <uWhen,...> ] ;
             [ VALID <uValid,...> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ; 
             [ FONT <oFont> ] ;
             [ ON CLICK <uClick> ] ;
             [ <design: DESIGN> ] ;
             [ <pixel: PIXEL> ] ;
             [ <update: UPDATE> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> [,<cBmpFile2>] ] ;
       => ;
          [ <oRbt> := ] TRadio():New( <nRow>, <nCol>, <cLabel>,;
              <cMsg>, <cColors>, <oWnd>, [ \{|| <uWhen> \}], [ \{|| <uValid> \} ], ;
              <cBmpFile> [,<cBmpFile2>]  )

                                                                                                    /*
!Short:^BRADIOMENU^B            Menu of Radio Selectors
 ^BComandos para RadioMenu                                                                          */
//----------------------------------------------------------------------------//

#xtranslate @ <nRow>, <nCol> RADIO <*txt*> => @ <nRow>, <nCol> RADIOMENU <txt>

#xcommand @ <nRow>, <nCol> RADIOMENU [ <oRadMenu> VAR ] <nVar> ;
             [ ITEMS <cItems,...> ] [ LIST <uList,...> ] [ ARRAY <aList> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange,...> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ WHEN <uWhen,...> ] ;
             [ VALID <uValid,...> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> [,<cBmpFile2>] ] ;
       => ;
          [ <oRadMenu> := ] TRadMenu():New( <nRow>, <nCol>, ;
             [ \{ <(cItems)> \} ] [ \{ <uList> \} ] [ <aList> ],;
             [bSETGET(<nVar>)], <oWnd>, <cLabel>, <cMsg>, <cColors>,;
             [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], [ \{|| <uChange> \} ],;
             <cBmpFile> [,<cBmpFile2>]  )

                                                                                                    /*
!Short:^BCHECKMENU^B            Menu of Checkers
 ^BComandos para CheckMenu                                                                          */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> CHECKMENU [ <oChkMenu> VARS ] <lVar1> [,<lVarN>] ;
             [ ITEMS <cItems,...> ] [ LIST <uList,...> ] [ ARRAY <aList> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange,...> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen,...> ] ;
             [ VALID <uValid,...> ] ;
             [ <update: UPDATE> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> [,<cBmpFile2>] ] ;
       => ;
          [ <oChkMenu> := ] TChkMenu():New( <nRow>, <nCol>,;
             [ \{ <(cItems)> \} ] [ \{ <uList> \} ] [ <aList> ],;
             \{ bSETGET( <lVar1> ) [, bSETGET( <lVarN> ) ]\}, <oWnd>, <cLabel>,;
              <cMsg>, <cColors>, [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], ;
              [ \{|| <uChange> \} ], <cBmpFile> [,<cBmpFile2>]  )
                                                                                                    /*
!Short:^BCOMBOBOX^B             Objeto ComboBox
 ^BComandos para ComboBox                                                                           */
//---------------------------------------------------------------------------

#xcommand @ <nRow>, <nCol> COMBOBOX [ <oCbx> VAR ] <cVar> ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ ITEMS <cItems,...> ] [ LIST <uList,...> ] [ ARRAY <aList> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ VALID <uValid,...> ] ;
             [ WHEN <uWhen,...> ] ;
             [ PICTURE <cPicture> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ MESSAGE <cMsg> ];
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange,...> ] ;
             [ <pixel: PIXEL> ] ;
             [ FONT <oFont> ] ;
             [ <update: UPDATE> ] ;
       => ;
          [ <oCbx> := ] TComboBox():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             bSETGET(<cVar>), [ \{ <(cItems)> \} ] [ \{ <uList> \} ] [<aList>],;
             <cLabel>, <cMsg>, <cColors>, <cPicture>, <oWnd>,;
             [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], [ \{|| <uChange> \} ] )

                                                                                                    /*
!Short:^BLABEL^B                Objeto Label
 ^BComandos para Label                                                                              */
//---------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> LABEL [ <oLabel> PROMPT ] <cText> ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <lCenter: CENTERED > ]  ;
             [ FONT <oFont> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ MESSAGE <cMsg> ] ;
       => ;
          [ <oLabel> := ] TLabel():New( <nRow>, <nCol>, <cText>, <cColors>,;
                                        <nWidth>, <nHeight>, <oWnd>, <cMsg>,;
                                        if( <.lCenter.>, 0, -1 ) )

                                                                                                    /*
!Short:^BSAY^B                  Objeto Say
 ^BComandos para Say                                                                                */
//---------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> SAY [ <cls,...> ] OF <oWnd> [ <*mascls*> ]  ;
      => ;
          @ <nRow>, <nCol> SAY [ <cls>  ] [ <mascls> ] OF <oWnd>

#xcommand @ <nRow>, <nCol> SAY [ <cls,...> ] WINDOW <oWnd> [ <*mascls*> ]  ;
      => ;
          @ <nRow>, <nCol> SAY [ <cls>  ] [ <mascls> ] OF <oWnd>

#xcommand @ <nRow>, <nCol> SAY [ <cls,...> ] DIALOG <oWnd> [ <*mascls*> ]  ;
      => ;
          @ <nRow>, <nCol> SAY [ <cls>  ] [ <mascls> ] OF <oWnd>

#xcommand @ <nRow>, <nCol> SAY [ <oSay> <etiq: PROMPT, LABEL, VAR> ] <bText> ;
             [ PICTURE <cPict> ] ;
             [ FONT <oFont> ]  ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <lCenter: CENTERED > ]  ;
             [ <lBorder: BORDER> ]  ;
             [ <lPixel: PIXEL, PIXELS> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <design: DESIGN> ] ;
             [ <update: UPDATE> ] ;
             <wnd: OF, WINDOW, DIALOG> <oWnd> ;
      => ;
       [ <oSay> := ] TSay():New( <nRow>, <nCol>, <{bText}>, <cColors>, <oWnd>,;
                       if( <.lCenter.>, 0, -1 ), <cPict>, <nWidth>, <nHeight> )

                                                                                                    /*
!Short:^BGET^B                  Objetos Get
 ^BComandos para Get                                                                                */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ MESSAGE <cMessage> ] ;
             [ <memo: MULTILINE, MEMO, TEXT> ] ;
             [ WHEN <uWhen,...> ] ;
             [ VALID <uValid,...> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ FILE <cBmp> [ , <cBmp2> ] ] ;
       => ;
//          [ <oGet> := ] TMGet():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
//             bSETGET(<uVar>), <cColors>, <cLabel>, <cMessage>, <oWnd>, ;
//                     [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ] )


#xcommand @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
             [ <color: COLOR, COLORS> <cColors> ]    ;
             [ <etiq: LABEL, PROMPT> <cLabel> ]      ;
             [ PICTURE <cPicture> ]                  ;
             [ MESSAGE <cMessage> ]                  ;
             [ WHEN <uWhen,...> ]                        ;
             [ VALID <uValid,...> ]                      ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ]    ;
             [ FILE <cBmp> [ , <cBmp2> ] ] ;
       => ;
          [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             <cColors>, <cLabel>, <cMessage>, <cPicture>, <oWnd>,;
             [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], <cBmp>, <cBmp2> )

                                                                                                    /*
!Short:^BBITMAPS^B              ­ Mapas de Bits en MsDos !
 ^BComandos para BitMaps                                                                            */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> BITMAP [<oBmp>] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <resource: RESOURCE, NAME, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [<oBmp>:=] TBitmap():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             <{cResName}>, <cBmpFile>, <oWnd> )

                                                                                                    /*
!Short:^BSCROLLBAR^B            Barras de Scroll
 ^BComandos para ScrollBar                                                                          */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> SCROLLBAR [ <oSbr> ] ;
             [ <horizontal:HORIZONTAL> ] [ <vertical:VERTICAL> ] ;
             [ RANGE <nRANGE> ] ;
             [ PAGESTEP <nPgStep> ] ;
             [ SIZE <nLen> ] ;
             [ ON UP <uUp,...> ] ;
             [ ON DOWN <uDown,...> ] ;
             [ ON PAGEUP <uPgUp,...> ] ;
             [ ON PAGEDOWN <uPgDown,...> ] ;
             [ ON THUMBPOS <uThumbPos,...> ] ;
             [ WHEN    <uWhen,...> ]  ;
             [ VALID   <uValid,...> ] ;
             [ MESSAGE  <cMsg> ]  ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [ <oSbr> := ] TScrollBar():New( <nRow>, <nCol>, <.horizontal.>, ;
                                          <nLen>, <nRANGE>, <nPgStep>,;
                                          [ \{|| <uUp>     \} ] ,;
                                          [ \{|| <uDown>   \} ] ,;
                                          [ \{|| <uPgUp>   \} ] ,;
                                          [ \{|| <uPgDown> \} ] ,;
                                          [ \{| nPos | <uThumbPos> \} ]  ,;
                                          [ \{|| <uValid>  \} ] ,;
                                          [ \{|| <uWhen>   \} ] ,;
                                          <cColors>, <cMsg>, <oWnd> )


                                                                                                    /*
!Short:^BLISTBOX FIELDS^B
 ^BComandos para ListBox                                                                            */
//----------------------------------------------------------------------------//

#xcommand @ <nTop>, <nLeft> LISTBOX [ <oLbx> ] FIELDS [ <Flds,...> ] ;
            [ SIZE <nWidth>, <nHeight> ] ;
            [ ALIAS <cAlias> ] ;
            [ SELECT <nInd> ] ;
            [ FOR <uValTop> [ TO <uValBottom> ] ] ;
            [ <sizes:SIZES, FIELDSIZES, COLSIZES> <aColSizes,...> ] ;
            [ <head: HEAD, HEADER, HEADERS> <aHeaders,...> ] ;
            [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
            [ <change: ON CHANGE, ON CLICK> <uChange,...> ] ;
            [ ON [ LEFT ] DBLCLICK <uLDblClick,...> ] ;
            [ ON RIGHT CLICK <uRClick,...> ] ;
            [ FONT <oFont> ] ;
            [ CURSOR <oCursor> ] ;
            [ <color: COLOR, COLORS> <cColors> ] ;
            [ <etiq: LABEL, PROMPT> <cLabel> ] ;
            [ MESSAGE <cMsg> ] ;
            [ <update: UPDATE> ] ;
            [ LOGICLEN <uLen> ] ;
            [ FREEZE <nColFreeze> ] ;
      => ;
       <oLbx> := oWBrowse( <nTop>, <nLeft>, <nWidth>, <nHeight>, ;
                              \{ [ <{Flds}> ] \} , ;
                              [ \{ <aHeaders> \} ], [ \{ <aColSizes> \} ],;
                              <oWnd>, <cColors>, <cMsg>, <nInd>, <uValTop>, ;
                              <uValBottom>, <cAlias>, <nColFreeze>, ;
                              <cLabel>, <{uLen}>, [ \{|| <uChange> \} ], ;
                              [ \{|| <uLDblClick> \} ] )
//                            [ \{|| <uRClick> \} ] )

                                                                                                    /*
!Short:^BLISTBOX BROWSE^B
 ^BComandos para ListBox Browse                                                                     */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> LISTBOX [ <oLbx> ]  BROWSE <oBrowse>  ;
             [ SIZE <nWidth>, <nHeight> ]       ;
             [ LOGICLEN <uLen> ]                ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ MESSAGE <cMsg> ]                 ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <change: ON CHANGE, ON CLICK> <uChange,...> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick,...> ] ;
             [ ON RIGHT CLICK <uRClick,...> ] ;
             [ WHEN    <uWhen,...> ]          ;
             [ VALID   <uValid,...> ]         ;
       => ;
          [ <oLbx> := ] TCtlBrowse():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
                                          <oBrowse>, <cLabel>, <cMsg>, <cColors>, ;
                                          <oWnd>, [<{uLen}>], ;
                                          [ \{|| <uChange>    \} ],;
                                          [ \{|| <uLDblClick> \} ],;
                                          [ \{|| <uWhen>      \} ],;
                                          [ \{|| <uValid>     \} ] )

                                                                                                    /*
!Short:^BLISTBOX ARRAY^B
 ^BComandos para ListBox Array                                                                      */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> LISTBOX [ <oLbx> VAR ] <nVar> ;
             [ ITEMS <cItems,...> ] [ LIST <uList,...> ] [ ARRAY <aList> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ ON RIGHT CLICK <uRClick> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <pixel: PIXEL> ] ;
             [ <design: DESIGN> ] ;
             [ FONT <oFont> ] ;
             [ <update: UPDATE> ] ;
       => ;
          [ <oLbx> := ] TListBox():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
                            bSETGET(<nVar>), ;
                            [ \{ <(cItems)> \} ] [ \{ <uList> \} ] [ <aList> ],;
                            <cLabel>, <cMsg>, <cColors>, <oWnd>, ;
                            [ \{|| <uWhen>     \} ],;
                            [ \{|| <uValid>    \} ],;
                            [ \{|| <uChange>   \} ],;
                            [ \{|| <uLDblClick> \} ] )
                            //, [ \{|| <uRClick> \} ] )

                                                                                                    /*
!Short:^BMETERS^B               Barras de Progreso
 ^BComandos para Meters                                                                             */
//---------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> METER [ <oMeter> VAR ] <nActual> ;
           [ TOTAL <nTotal> ] ;
           [ SIZE <nWidth> ];
           [ OF <oWnd> ] ;
           [ <update: UPDATE > ] ;
           [ <lPixel: PIXEL > ] ;
           [ FONT <oFont> ] ;
           [ PROMPT <cPrompt> ] ;
           [ <lNoPorcentage: NOPORCENTAGE > ] ;
           [ <color: COLOR, COLORS> <nClrPane> [, <nClrText> ] ] ;
           [ BARCOLOR <cClrBar> [, <nClrBText> ] ] ;
     => ;
        [ <oMeter> := ] TMeter():New( <nRow>, <nCol>, bSETGET(<nActual>),;
           <nTotal>, <oWnd>, <nWidth>, <cPrompt>, <.lNoPorcentage.>,;
           <cClrBar> )


#endif

