#ifndef _BROWSE_CH
#define _BROWSE_CH

#xcommand DEFINE BROWSE <*text*> => BEGINBROWSE <text>
#xcommand BEGIN BROWSE <*text*> => BEGINBROWSE <text>
#xcommand BEGINBROWSE <oBrw> ;
            [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ] ;
            [ COLOR <cColors> ] ;
            [ HEADSEP <cHeadSep> ] ;
            [ SEPARATOR <cSeparator> ] ;
            [ FREEZE <nColFreeze> ] ;
            [ SELECT <nInd> ] ;
            [ FOR <uValTop> [ TO <uValBottom> ] ] ;
            [ ALIAS <cAlias> ] ;
            [ <auto: AUTOFIELDS, AUTOCOLUMNS, AUTO FIELDS, AUTO COLUMNS> ] ;
            [ <group: GROUP> ] ;
          => ;
         <oBrw> := oBrwBegin( <nTop>, <nLeft>, <nBottom>, <nRight>, <cColors>,;
                              <cHeadSep>, <cSeparator>, <nColFreeze>,;
                              <nInd>, <uValTop>, <uValBottom>, <cAlias>,;
                              <.auto.>, <.group.> )


#xcommand COLUMN [ <oCol> ] ;
            [ <show: SHOW, DATA> <uData> ] ;
            [ SHOWBLOCK <bData> ] ;
            [ <tit: TITLE, HEAD, HEADER> <cTitle> ] ;
            [ FOOTER <cFooter> ] ;
            [ COLOR <anColors> ] ;
            [ COLORSEL <bColor> ] ;
            [ FOOTSEP <cFootSep> ] ;
            [ WIDTH <nWidth> ] ;
            [ PICTURE <cPicture> ] ;
            [ FONT    <oFont> ] ;
            [ SIZE <nWidth>, <nHeight> ] ;
            [ <style: BITMAP> ] ;
      => ;
         [<oCol> :=] oBrwColumn( [<{uData}>] [<bData>], [<cTitle>], [<nWidth>] ,;
                       [<cFooter>], [{<anColors>}], [<{bColor}>], [<cFootSep>] ,;
                       [<cPicture>] )

#xcommand ENDBROWSE  => BrowseEnd()

#xcommand END BROWSE => ENDBROWSE
