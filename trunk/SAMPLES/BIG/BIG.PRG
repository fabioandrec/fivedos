// Checks the Clipper memory values from inside FiveWin

#include "FiveWin.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   DEFINE WINDOW oWnd FROM 0, 0 TO 22, 78 ;
      TITLE "Memory Status" MENU BuildMenu()
      
   SET MESSAGE OF oWnd ;
      TO "FiveWin - Checking MemStat() function"

   ACTIVATE WINDOW oWnd ;
      VALID MsgYesNo( "Do you want to end ?" )
   
return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu

      MENUITEM "&Check"
      MENU
         MENUITEM "&Memory values " ;
            ACTION ( MsgInfo( "Some of these values are larger," + ;
                     " as we report them here," + ;
                     " but we can not let Clipper know that! <g>" ) ) ;
            MESSAGE "Clipper-VMM has been totally re-written!"
         MENUITEM "UseDbf" ACTION OpenDbf()
         SEPARATOR
         MENUITEM "End" ACTION oWnd:End() ;
            MESSAGE "Windows is finally controlling the memory. Free finally!"
      ENDMENU

   ENDMENU
   
return oMenu

//----------------------------------------------------------------------------//

function OpenDbf()

   local cFile := cGetFile( "Clipper DataBase (*.dbf) | *.dbf", "Select a DBF" )

   if ! Empty( cFile )
      USE ( cFile )

      // Quick and easy browses!
      // Fully integrated into a Dialog Box !!!

      Brw( "FiveWin Automatic Browse Power",;
              "Easy Browses without pain...",;
              { || MsgInfo( "This will be executed from first button...", "Info1" ) },;
              { || MsgInfo( "You can atach any action to the buttons...", "Info2" ) },;
              { || MsgInfo( "We also provide full source code of this...", "Info3" ) },;
              { || MsgInfo( "So you can adapt it to your necesities", "Info4" ) } )
      USE
   endif

return nil

//----------------------------------------------------------------------------//

static PROC BIG01()
    big02()
    big03()
    big04()
    big05()
    big06()
    big07()
    big08()
    big09()
    big10()
    big11()
    big12()
    big13()
    big14()
    big15()
    big16()
    big17()
    big18()
    big19()
    big20()
return

//---------------------------------------------------------------------------//

#include "bigbig.prg"

//---------------------------------------------------------------------------//

STATIC PROCEDURE  A_10 () ; RETURN
STATIC PROCEDURE  A_11 () ; RETURN
STATIC PROCEDURE  A_12 () ; RETURN
STATIC PROCEDURE  A_13 () ; RETURN
STATIC PROCEDURE  A_14 () ; RETURN
STATIC PROCEDURE  A_15 () ; RETURN
STATIC PROCEDURE  A_16 () ; RETURN
STATIC PROCEDURE  A_17 () ; RETURN
/***
STATIC PROCEDURE  A_18 () ; RETURN
STATIC PROCEDURE  A_19 () ; RETURN

STATIC PROCEDURE  B_10 () ; RETURN
STATIC PROCEDURE  B_11 () ; RETURN
STATIC PROCEDURE  B_12 () ; RETURN
STATIC PROCEDURE  B_13 () ; RETURN
STATIC PROCEDURE  B_14 () ; RETURN
STATIC PROCEDURE  B_15 () ; RETURN
STATIC PROCEDURE  B_16 () ; RETURN
STATIC PROCEDURE  B_17 () ; RETURN
STATIC PROCEDURE  B_18 () ; RETURN
STATIC PROCEDURE  B_19 () ; RETURN
***/
