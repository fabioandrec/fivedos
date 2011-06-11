

#command @ <nTop>, <nLeft> TO <nBottom>, <nRight> NOTEBOOK <oBook> OF <oWnd> ;
        [ COLOR <cColors> ] ;
        => ;
        <oBook> := TNBook():New( <nTop>, <nLeft>, <nBottom>, <nRight>, <oWnd>, <(cColors)> )

#command DEFINE NOTEBOOK <oBook> FROM <nTop>, <nLeft> TO <nBottom>, <nRight> OF <oWnd> ;
        [ COLOR <cColors> ] ;
        => ;
        <oBook> := TNBook():New( <nTop>, <nLeft>, <nBottom>, <nRight>, <oWnd>, <(cColors)> )

#command BEGIN PAGE [ <oPage> ] OF <oBook> ;
            [ ON PAINT <bPaint,...>  ] ;
            [ COLOR    <cColor>  ] ;
            [ <act: ON FOCUS, ACTION> <bAction,...> ] ;
            => ;
            [ <oPage> := ] TPage():New( <oBook>, [ \{|| <{bPaint}> \} ],;
                [ <(cColor)> ], [ \{|| <bAction> \} ] )

#xcommand @ <nRow>, <nCol> TABMENU [ <oTabMenu> VAR ] <nVar> ;
             [ ITEMS <cItems,...> ] [ LIST <uList,...> ] [ ARRAY <aList> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange,...> ] ;
             [ <color: COLOR, > <cColors> ] ;
             [ WHEN <uWhen,...> ] ;
             [ VALID <uValid,...> ] ;
             [ <lAtBottom: AT BOTTOM> ] ;
       => ;
          [ <oTabMenu> := ] TTabMenu():New( <nRow>, <nCol>, ;
             [ \{ <(cItems)> \} ] [ \{ <uList> \} ] [ <aList> ],;
             [bSETGET(<nVar>)], <oWnd>, <cColors>,;
             [ \{|| <uWhen> \} ], [ \{|| <uValid> \} ], [ \{|| <uChange> \} ], ;
             <.lAtBottom.> )
