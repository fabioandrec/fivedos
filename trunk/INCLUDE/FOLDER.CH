

#command @ <nTop>, <nLeft> TO <nBottom>, <nRight> FOLDER <oFOLDER> OF <oWnd> ;
        => ;
        <oFOLDER> := TFOLDER():New( <nTop>, <nLeft>, <nBottom>, <nRight>, <oWnd> )

#command BEGIN FOLDER [ <oCtlList> ] OF <oFOLDER> ;
            [ ON PAINT <bPaint> ] ;
            [ COLOR    <cColor> ] ;
            [ PROMPT <cPrompt> ] ;
            => ;
            [ <oCtlList> := ] TFDIALOG():New( <oFOLDER>, [ <{bPaint}> ],;
             [ <(cColor)> ], [<cPrompt>] )

