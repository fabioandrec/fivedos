#include "FiveDos.ch"
#include "Profiler.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   local oBar, ctext := Date() // "Dime porque"

   _Profiler( _PROF_BEGIN, ;    // Profiler command
              .f.,;             // See Var Msgs also. Default: .f.
              )
             // TWindow() )      // See only messages of class TWindow

   DEFINE WINDOW oWnd TITLE "Hello world!" ;
      MENU BuildMenu()

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON OF oBar FILENAME "..\bitmaps\info.bmp" ;
      ACTION MsgBeep() MESSAGE "Any action from here"

   SET MESSAGE OF oWnd TO "FiveOS2 - CA-Clipper for IBM-OS2 library"

   @ 2, 2 GET cText OF oWnd VALID .F.

   ACTIVATE WINDOW oWnd ;
      ON INIT _Profiler( _PROF_END ) ; 
      VALID MsgYesNo( "Confirm exit" )

   _Profiler( _PROF_OUTPUT )   // _Profiler( _PROF_OUTPUT [ , cOutputFile ] )
                               // default output file is: "profiler.log"

   ProfStats() // ( cIputFile, cOutputFile, lVerbose )
               // Defaults are ( "Profiler.log", "ProfStat.log", .t. )
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


