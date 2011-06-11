

#command @ <nTop>, <nLeft> TO <nBottom>, <nRight> PAGE <oPage> OF <oWnd> ;
        => ;
        <oPage> := TPage():New( <nTop>, <nLeft>, <nBottom>, <nRight>, <oWnd> )

#command BEGIN PAGE OF <oPage> ;
            [ ON PAINT <bPaint> ] ;
            [ COLOR    <cColor> ] ;
            => ;
            TCtlList():New( <oPage>, [ <{bPaint}> ], [ <(cColor)> ] )

