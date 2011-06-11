
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
       => ;
          [ <oGet> := ] TMemo():New( <nRow>, <nCol>, <nWidth>, <nHeight>,;
             bSETGET(<uVar>), <cLabel>, <cMessage>, <cColors>, <oWnd>, ;
                     [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ] )


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
       => ;
          [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>),;
             <cColors>, <cLabel>, <cMessage>, <cPicture>, <oWnd>,;
             [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], <cBmp>, <cBmp2>, ;
             !<.lEdit.>, <.passw.> )
