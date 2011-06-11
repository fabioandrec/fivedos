// tree example

#include "fivedos.ch"
#include "tree.ch"

function main()

   local oWnd, oLbx, oTree, oItem

   TREE oTree BITMAPS "Open.bmp", "Open2.bmp"

      TREEITEM oItem PROMPT "First" BITMAP "Open.bmp", "Open2.bmp"
      TREE
         TREEITEM "One"
         TREE
            TREEITEM "One"
            TREEITEM "Two"
            TREEITEM "Three"
         ENDTREE
         TREEITEM "Two"
         TREEITEM "Three"
      ENDTREE

      TREEITEM "Second"
      TREE
         TREEITEM "One"
         TREEITEM "Two"
         TREEITEM "Three"
      ENDTREE

      TREEITEM "Third"
      TREE
         TREEITEM "One"
         TREEITEM "Two"
         TREEITEM "Three"
      ENDTREE
      TREEITEM "pr1"
      TREEITEM "pr1"
      TREEITEM "pr1"
      TREEITEM "Final"
   ENDTREE

   DEFINE WINDOW oWnd FROM 5, 5 to 20, 54 TITLE 'Tree working'

    @ 1, 4 LISTBOX oLbx TREE oTree ;
            OF oWnd ;
            SIZE 40, 10 ;
            PROMPT '&A Menu Design System ??'


    @ 12, 18 BUTTON '  &Exit  ' OF oWnd ;
        ACTION oWnd:End()

    ACTIVATE WINDOW oWnd CENTERED

return nil

