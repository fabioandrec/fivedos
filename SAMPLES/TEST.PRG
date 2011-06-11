// #include "FiveOS2.ch"
#include "FiveDos.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   local oBar, ctext := Date() // "Dime porque"

   DEFINE WINDOW oWnd TITLE "Hello world!" ;
      MENU BuildMenu()

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar FILENAME "..\bitmaps\info.bmp" ;
      ACTION MsgBeep() MESSAGE "Any action from here"

   SET MESSAGE OF oWnd TO "FiveOS2 - CA-Clipper for IBM-OS2 library"

   @ 2, 2 GET cText OF oWnd VALID .F.

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Confirm exit" )

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "&Information"
      MENU
         MENUITEM "&About..."
         SEPARATOR
         MENUITEM "&Exit..." ACTION oWnd:End()
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//
