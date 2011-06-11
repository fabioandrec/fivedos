// Trees for FiveDos !!!  Incredible powerfull !!!

#ifndef _TREE_CH
#define _TREE_CH

#xcommand BEGIN TREE <*Tree*>] => TREE <Tree>

#xcommand TREE [<oTree>] ;
             [ BITMAPS <cBmpOpen>, <cBmpClose> ] ;
       => ;
          [<oTree>:=] TreeBegin( <cBmpOpen>, <cBmpClose> )

#xcommand TREEITEM [<oItem> PROMPT ] <cLabel> ;
             [ <oBmp: RESOURCE, FILENAME, BITMAP > <cResName1> [, <cResName2> ] ] ;
             [ <lOpened: OPENED, OPEN> ] ;
       => ;
          [<oItem> :=] _TreeItem( <cLabel>, <cResName1>, <cResName2>,;
                                   <.lOpened.> )

#xcommand ENDTREE => TreeEnd()
#xcommand END TREE => ENDTREE

#endif
