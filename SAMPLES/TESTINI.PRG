//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Construir con BUILD TestIni
//----------------------------------------------------------------------------//

// Ejemplos de utilizaci¢n de la clase TIniFile : ficheros *.ini

#include "FiveDos.ch"

//---------------------------------------------------------------------------//

function Main( cIniFile )
    local cBack := SaveScreen( 0, 0, MaxRow(), MaxCol() )
    local oIni, oWnd, cMain := "main"

    if empty( cIniFile )
        cIniFile := "TestIni"
    endif

    oIni := TIniFile():Use( cIniFile )

    if ! File( cIniFile + ".ini" )
       BuildIni( oIni )
    endif

    DEFINE WINDOW oWnd AT val( oIni:cGet( cMain, "rowpos" ) ),;
                          val( oIni:cGet( cMain, "colpos" ) ) ;
                SIZE 54, 11  ;
                MENU BuildMenu( oIni )          ;
                TITLE oIni:cGet( cMain, "title" ) ;
                COLOR oIni:cGet( cMain, "colors" )

    // Our Application BackGround
    SET COLOR TO "N/N*"
    CLS

    ACTIVATE WINDOW oWnd VALID lMsgEnd()

    RestScreen( 0, 0, MaxRow(), MaxCol(), cBack )

return nil

//---------------------------------------------------------------------------//

static function BuildMenu( oIni )

   local oMenu
   local cMenu := "mainmenu"

MENU oMenu COLOR oIni:cGet( cMenu, "colors" )
    MENUITEM oIni:cGet( cMenu, "Item1" )  MESSAGE "Mensaje de UNO"
	MENU
	    MENUITEM "Item &Uno"      MESSAGE "Mensaje de UNO-UNO" ;
				      ACTION ALERT( "UNO-UNO" )
	    MENUITEM "Item &Dos"      MESSAGE "Mensaje de UNO-DOS" ;
				      ACTION ALERT( "UNO-DOS" )
	    MENUITEM "Item &Tres"     MESSAGE "Mensaje de UNO-TRES" ;
				      ACTION ALERT( "UNO-TRES" )
	ENDMENU
    MENUITEM oIni:cGet( cMenu, "Item2" )      MESSAGE "Mensaje de DOS"
	MENU
        MENUITEM "Item &Uno"      MESSAGE "Mensaje de DOS-UNO" ;
                      ACTION ALERT( "DOS-UNO" )
	    MENUITEM "Item &Dos"      MESSAGE "Mensaje de DOS-DOS" ;
				      ACTION ALERT( "DOS-DOS" )
        MENUITEM "Item &Tres"     MESSAGE "Mensaje de DOS-TRES" ;
                      ACTION ALERT( "DOS-TRES" )
	ENDMENU
    MENUITEM oIni:cGet( cMenu, "Item3" )     MESSAGE "Mensaje de TRES"
	MENU
	    MENUITEM "Item &Uno"      MESSAGE "Mensaje de TRES-UNO"
	    MENUITEM "Item &Dos"      MESSAGE "Mensaje de TRES-DOS"
	    MENUITEM "Item &Tres"     MESSAGE "Mensaje de TRES-TRES"
	ENDMENU
ENDMENU

return oMenu

//---------------------------------------------------------------------------//

static function BuildIni( oIni )

   oIni:Set( "main", "title",   "The title of my program" )
   oIni:Set( "main", "colors",  "N/ BG, N/W*, W+/BG, N/BG*, BG+/BG" )
   oIni:Set( "main", "message", "Main message of my program" )
   oIni:Set( "main", "rowpos",  "8" )
   oIni:Set( "main", "colpos",  "12" )

   oIni:Set( "MainMenu", "colors", "n/w, w+/b, r/w, r+/b, n+/w, w+/w, n+/w" )
   oIni:Set( "MainMenu", "Item1",  "C&lients" )
   oIni:Set( "MainMenu", "Item2",  "&Accounts" )
   oIni:Set( "MainMenu", "Item3",  "&Evolution" )

   oIni:Save()

return nil

//----------------------------------------------------------------------------//
