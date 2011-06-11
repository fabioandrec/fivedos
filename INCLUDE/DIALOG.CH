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
             [ <lUpdate: UPDATE>     ]                       ;
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
                        [ \{|| <uValid> \} ], <.lUpdate.> )

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
          [ SIZE <x>, <y> ]                    ;
          [ 3D ]                               ;
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
             [ <lUpdate: UPDATE> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> [,<cBmpFile2>] ] ;
             [ <lUpdate: UPDATE >]                          ;
       => ;
          [ <oCbx> := ] TCheckBox():New( <nRow>, <nCol>, <cLabel>,;
              <cMsg>, <cColors>, <oWnd>, [\{|| <uWhen> \}], [\{|| <uValid> \}], bSETGET(<lVar>) ,;
              <cBmpFile>, [<cBmpFile2>], <.lUpdate.>  )

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
             [ <file: FILE, FILENAME, DISK> <cBmpFile> [,<cBmpFile2>] ] ;
             [ <lUpdate: UPDATE >]                          ;
       => ;
          [ <oRbt> := ] TRadio():New( <nRow>, <nCol>, <cLabel>,;
              <cMsg>, <cColors>, <oWnd>, [ \{|| <uWhen> \}], [ \{|| <uValid> \} ], ;
              <cBmpFile> [,<cBmpFile2>], <.lUpdate.>  )

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
             [ WHEN <uWhen,...> ] ;
             [ VALID <uValid,...> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> [,<cBmpFile2>] ] ;
             [ <lUpdate: UPDATE >]                          ;
       => ;
          [ <oRadMenu> := ] TRadMenu():New( <nRow>, <nCol>, ;
             [ \{ <(cItems)> \} ] [ \{ <uList> \} ] [ <aList> ],;
             [bSETGET(<nVar>)], <oWnd>, <cLabel>, <cMsg>, <cColors>,;
             [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], [ \{|| <uChange> \} ],;
             <cBmpFile> [,<cBmpFile2>], <.lUpdate.>  )

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
             [ <lUpdate: UPDATE> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> [,<cBmpFile2>] ] ;
       => ;
          [ <oChkMenu> := ] TChkMenu():New( <nRow>, <nCol>,;
             [ \{ <(cItems)> \} ] [ \{ <uList> \} ] [ <aList> ],;
             \{ bSETGET( <lVar1> ) [, bSETGET( <lVarN> ) ]\}, <oWnd>, <cLabel>,;
              <cMsg>, <cColors>, [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], ;
              [ \{|| <uChange> \} ], <cBmpFile> [,<cBmpFile2>], <.lUpdate.>  )
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
             [ <lUpdate: UPDATE> ] ;
             [ <lEdit: NOEDIT> ];
       => ;
          [ <oCbx> := ] TComboBox():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             bSETGET(<cVar>), [ \{ <(cItems)> \} ] [ \{ <uList> \} ] [<aList>],;
             <cLabel>, <cMsg>, <cColors>, <cPicture>, <oWnd>,;
             [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], [ \{|| <uChange> \} ],;
             !<.lEdit.>, <.lUpdate.>  )

                                                                                                    /*
!Short:^BCOMBOBRW^B             Objeto ComboBrw
 ^BComandos para ComboBrw                                                                           */
//---------------------------------------------------------------------------

#xcommand @ <nRow>, <nCol> COMBOBOX [ <oCbx> VAR ] <cVar> [ BROWSE <oBrowse> ];
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ VALID <uValid,...> ] ;
             [ WHEN <uWhen,...> ] ;
             [ PICTURE <cPicture> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ MESSAGE <cMsg> ];
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange,...> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick,...> ] ;
             [ ON RIGHT CLICK <uRClick,...> ] ;
             [ <pixel: PIXEL> ] ;
             [ FONT <oFont> ] ;
             [ <lUpdate: UPDATE> ] ;
             [ <lEdit: NOEDIT> ];
             [ LOGICLEN <uLen> ] ;
       => ;
          [ <oCbx> := ] TComboBrw():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             bSETGET(<cVar>), <cPicture>, !<.lEdit.>, <oBrowse>,;
             <cLabel>, <cMsg>, <cColors>, <oWnd>, [<{uLen}>],;
             [ \{|| <uChange> \} ], [ \{|| <uLDblClick> \} ],;
             [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], [ \{|| <uRClick>  \} ],;
              <.lUpdate.>)

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
             [ <lUpdate: UPDATE >]                          ;
       => ;
          [ <oLabel> := ] TLabel():New( <nRow>, <nCol>, <cText>, <cColors>,;
                                        <nWidth>, <nHeight>, <oWnd>, <cMsg>,;
                                        if( <.lCenter.>, 0, -1 ), <.lUpdate.> )

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
             [ <lUpdate: UPDATE >]                          ;
             <wnd: OF, WINDOW, DIALOG> <oWnd> ;
      => ;
       [ <oSay> := ] TSay():New( <nRow>, <nCol>, <{bText}>, <cColors>, <oWnd>,;
                       if( <.lCenter.>, 0, -1 ), <cPict>, <nWidth>, <nHeight>,;
                       <.lUpdate.> )

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
             [ FILE <cBmp> [, <cBmp2> ] ] ;
             [ <lUpdate: UPDATE >]                          ;
       => ;
          [ <oGet> := ] TMemo():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             bSETGET(<uVar>), <cLabel>, <cMessage>, <cColors>, <oWnd>, ;
                     [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], <.lUpdate.> )


#xcommand @ <nRow>, <nCol> GET [ <oGet> VAR ] <uVar> ;
             [ <color: COLOR, COLORS> <cColors> ]    ;
             [ <etiq: LABEL, PROMPT> <cLabel> ]      ;
             [ PICTURE <cPicture> ]                  ;
             [ MESSAGE <cMessage> ]                  ;
             [ WHEN <uWhen,...> ]                        ;
             [ VALID <uValid,...> ]                      ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ]    ;
             [ FILE <cBmp> [, <cBmp2> ] ] ;
             [ <lEdit: NOEDIT > ];
             [ <passw: PASSWORD> ] ;
             [ <lUpdate: UPDATE >]                          ;
       => ;
          [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             <cColors>, <cLabel>, <cMessage>, <cPicture>, <oWnd>,;
             [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], <cBmp>, <cBmp2>, ;
             !<.lEdit.>, <.passw.>, <.lUpdate.> )
/*
!Short:^BSPIN^B                  Objetos Spin
 ^BComandos para Spin                                                                               */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> SPIN [ <oGet> VAR ] <uVar> ;
             [ <color: COLOR, COLORS> <cColors> ]    ;
             [ <etiq: LABEL, PROMPT> <cLabel> ]      ;
             [ PICTURE <cPicture> ]                  ;
             [ MESSAGE <cMessage> ]                  ;
             [ WHEN <uWhen,...> ]                        ;
             [ VALID <uValid,...> ]                      ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ]    ;
             [ FILE <cBmp> [, <cBmp2> ] ] ;
             [ RANGE <nBottom>, <nTop>] ;
             [ STEP <nStep> ];
             [ ACTION <bAction,...> ] ;
             [ <lEdit: EDITABLE > ];
             [ <lUpdate: UPDATE >]                          ;
       => ;
          [ <oGet> := ] TSpin():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             <cColors>, <cLabel>, <cMessage>, <cPicture>, <oWnd>,;
             [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], <cBmp>, <cBmp2>,;
             <nTop>, <nBottom>, <nStep>, [ \{|| <bAction> \} ], ;
             <.lEdit.>,, <.lUpdate.> )

/*
!Short:^BBITMAPS^B              ­ Mapas de Bits en MsDos !
 ^BComandos para BitMaps                                                                            */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> BITMAP [<oBmp>] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <resource: RESOURCE, NAME, RESNAME> <cResName> ] ;
             [ <file: FILE, FILENAME, DISK> <cBmpFile> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <lUpdate: UPDATE >]                          ;
       => ;
          [<oBmp>:=] TBitmap():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             <{cResName}>, <cBmpFile>, <oWnd>, <.lUpdate.> )

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
             [ WHEN <uWhen,...> ]  ;
             [ VALID <uValid,...> ] ;
             [ MESSAGE <cMsg> ]  ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <lUpdate: UPDATE >]                          ;
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
                                          <cColors>, <cMsg>, <oWnd>,;
                                           <.lUpdate.> )

                                                                                                    /*
!Short:^BLISTBOX ARRAY^B
 ^BComandos para ListBox Array                                                                      */
//----------------------------------------------------------------------------//
// begin mod
#xcommand @ <nRow>, <nCol> LISTBOX [ <oLbx> VAR ] <nVar> ;
             [ ITEMS <cItems,...> ] [ LIST <uList,...> ] [ ARRAY <aList> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange,...> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick,...> ] ;
             [ ON RIGHT CLICK <uRClick,...> ] ;
             [ WHEN <uWhen,...> ] ;
             [ VALID <uValid,...> ] ;
             [ <pixel: PIXEL> ] ;
             [ <design: DESIGN> ] ;
             [ FONT <oFont> ] ;
             [ <multi: MULTISELECT> ] ;
             [ <lUpdate: UPDATE >]                          ;
       => ;
          [ <oLbx> := ] TListBox():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
                            bSETGET(<nVar>), ;
                            [ \{ <(cItems)> \} ] [ \{ <uList> \} ] [ <aList> ],;
                            <cLabel>, <cMsg>, <cColors>, <oWnd>, ;
                            [ \{|| <uWhen> \} ],;
                            [ \{|| <uValid> \} ],;
                            [ \{|| <uChange> \} ],;
                            [ \{|| <uLDblClick> \} ],;
                            [ \{|| <uRClick>  \} ],;
                            [ <.multi.> ], <.lUpdate.> )
// end mod
                                                                                                    /*
!Short:^BLISTBOX FIELDS^B
 ^BComandos para ListBox Fields                                                                     */
//----------------------------------------------------------------------------//

#xcommand @ <nTop>, <nLeft> LISTBOX [ <oLbx> ] FIELDS [ <Flds,...> ] ;
            [ SIZE <nWidth>, <nHeight> ] ;
            [ ALIAS <cAlias> ] ;
            [ SELECT <nInd> ] ;
            [ FOR <uValTop> [ TO <uValBottom> ] ] ;
            [ <sizes:FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
            [ <head: HEAD, HEADER, HEADERS> <aHeaders,...> ] ;
            [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
            [ <change: ON CHANGE, ON CLICK> <uChange,...> ] ;
            [ ON [ LEFT ] DBLCLICK <uLDblClick,...> ] ;
            [ ON RIGHT CLICK <uRClick,...> ] ;
            [ <color: COLOR, COLORS> <cColors> ] ;
            [ <etiq: LABEL, PROMPT> <cLabel> ] ;
            [ MESSAGE <cMsg> ] ;
            [ LOGICLEN <uLen> ] ;
            [ FREEZE <nColFreeze> ] ;
            [ WHEN <uWhen,...> ] ;
            [ VALID <uValid,...> ] ;
            [ <multi: MULTISELECT> ] ;
      => ;
       <oLbx> := oWBrowse( <nTop>, <nLeft>, <nWidth>, <nHeight>, ;
                              \{ [ <{Flds}> ] \},;
                              [ \{ <aHeaders> \} ], [ \{ <aColSizes> \} ],;
                              <oWnd>, <cColors>, <cMsg>, <nInd>, <uValTop>,;
                              <uValBottom>, <cAlias>, <nColFreeze>,; 
                              <cLabel>, [<{uLen}>], [ \{|| <uChange> \} ],;
                              [ \{|| <uLDblClick> \} ],;
                              [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ],;
                              [ \{|| <uRClick> \} ], [ <.multi.> ] )

/*
            ; \\[ FONT <oFont> ] ;
            ; \\[ CURSOR <oCursor> ] ;
            ; \\[ <lUpdate: UPDATE> ] ; */
                                                                                                   /*
!Short:^BLISTBOX BROWSE^B
 ^BComandos para ListBox Browse                                                                     */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> LISTBOX [ <oLbx> ] BROWSE <oBrowse>  ;
             [ SIZE <nWidth>, <nHeight> ]       ;
             [ LOGICLEN <uLen> ]                ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ MESSAGE <cMsg> ]                 ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <change: ON CHANGE, ON CLICK> <uChange,...> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick,...> ] ;
             [ ON RIGHT CLICK <uRClick,...> ] ;
             [ WHEN <uWhen,...> ]          ;
             [ VALID <uValid,...> ]         ;
       => ;
          [ <oLbx> := ] TCtlBrowse():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
                                          <oBrowse>, <cLabel>, <cMsg>, <cColors>,;
                                          <oWnd>, [<{uLen}>],;
                                          [ \{|| <uChange> \} ],;
                                          [ \{|| <uLDblClick> \} ],;
                                          [ \{|| <uWhen> \} ],;
                                          [ \{|| <uValid> \} ],;
                                          [ \{|| <uRClick> \} ] )

/*
!Short:^BLISTBOX TREE^B
 ^BComandos para ListBox Tree                                                                       */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> LISTBOX [ <oLbx> ] TREE <oTree> ;
            [ SIZE <nWidth>, <nHeight> ] ;
            [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
            [ <change: ON CHANGE, ON CLICK> <uChange,...> ] ;
            [ ON [ LEFT ] DBLCLICK <uLDblClick,...> ] ;
            [ ON RIGHT CLICK <uRClick,...> ] ;
            [ <color: COLOR, COLORS> <cColors> ] ;
            [ <etiq: LABEL, PROMPT> <cLabel> ] ;
            [ MESSAGE <cMsg> ] ;
            [ WHEN <uWhen,...> ] ;
            [ VALID <uValid,...> ] ;
      => ;
    <oLbx> := oTreeBrowse( <nRow>, <nCol>, <nWidth>, <nHeight>, <oTree>, <oWnd>,;
                           <cLabel>, <cMsg>, <cColors>,;
                           [ \{|| <uChange> \} ],;
                           [ \{|| <uWhen> \} ],;
                           [ \{|| <uValid> \} ],;
                           [ \{|| <uRClick> \} ] )

/*
!Short:^BLISTBOX MULTISELECT^B
 ^BComandos para ListBox Multiselect                                                                */
//----------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> LISTBOX [ <oLbx> ] BROWSE <oBrowse> MULTISELECT ;
             [ SIZE <nWidth>, <nHeight> ]       ;
             [ LOGICLEN <uLen> ]                ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ MESSAGE <cMsg> ]                 ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <change: ON CHANGE, ON CLICK> <uChange,...> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick,...> ] ;
             [ ON RIGHT CLICK <uRClick,...> ] ;
             [ WHEN <uWhen,...> ] ;
             [ VALID <uValid,...> ] ;
      => ;
    <oLbx> := oMSelBrowse( <nRow>, <nCol>, <nWidth>, <nHeight>, <oBrowse>,;
                           <oWnd>, <cLabel>, <cMsg>, <cColors>,;
                           [ \{|| <uLen> \} ],;
                           [ \{|| <uChange> \} ],;
                           [ \{|| <uWhen> \} ],;
                           [ \{|| <uValid> \} ],;
                           [ \{|| <uRClick> \} ] )
                                                                                                    /*
!Short:^BMETERS^B               Barras de Progreso
 ^BComandos para Meters                                                                             */
//---------------------------------------------------------------------------//

#xcommand @ <nRow>, <nCol> METER [ <oMeter> VAR ] <nActual> ;
           [ TOTAL <nTotal> ] ;
           [ SIZE <nWidth> ];
           [ OF <oWnd> ] ;
           [ <lUpdate: UPDATE > ] ;
           [ <lPixel: PIXEL > ] ;
           [ FONT <oFont> ] ;
           [ PROMPT <cPrompt> ] ;
           [ <lNoPorcentage: NOPORCENTAGE > ] ;
           [ <color: COLOR, COLORS> <nClrPane> [, <nClrText> ] ] ;
           [ BARCOLOR <cClrBar> [, <nClrBText> ] ] ;
     => ;
        [ <oMeter> := ] TMeter():New( <nRow>, <nCol>, bSETGET(<nActual>),;
           <nTotal>, <oWnd>, <nWidth>, <cPrompt>, <.lNoPorcentage.>,;
           <cClrBar>, <.lUpdate.> )


#endif

