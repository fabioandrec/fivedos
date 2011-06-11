#ifndef _MENU_CH
#define _MENU_CH

#xcommand MENU [ <oMenu> ] ;
          [ COLOR <cColors> ] ;
       => ;
          [ <oMenu> := ] MenuBegin( [ <cColors> ] )

#xcommand MENUITEM [ <oMenuItem> <etiq: PROMPT, LABEL> ] [ <cItem> ] ;
             [ SHORTCUT <nKey> ] ;
             [ MESSAGE <cMsg> ] ;
             [ ACTION <uAction,...> ] ;
             [ <check:CHECKED> ] ;
             [ <disable:DISABLED> ] ;
        => ;
           [ <oMenuItem> := ] MnuItem( <cItem>, <cMsg>,;
             [ \{|| <uAction> \} ], <.disable.>, <.check.>, <nKey> )

#xcommand SEPARATOR => MnuItem()

#xcommand ENDMENU => MenuEnd()

#endif
