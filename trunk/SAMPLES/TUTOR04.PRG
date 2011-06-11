//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Contruir con BUILD Tutor04
//  To Build:    BUILD Tutor04
//----------------------------------------------------------------------------//

// Vamos a construir ahora un men£ de persiana y se lo vamos a asignar
// a nuestra ventana principal.

// Este ejemplo es la forma t¡pica de empezar a construir un programa

// We are going to build a PullDown menu and we are going to assign it
// to our main Dos

// This example is the typical way of start building a FiveDos program

#include "FiveDos.ch"
#include "SysStr.ch"  // Usa SysLanguage()

static oWnd

//----------------------------------------------------------------------------//

function Main()

   local oIco

   SysLanguage( SLG_SPANISH ) // Lenguaje de sistema de FiveDos.

   DEFINE ICON oIco FILE "..\icons\fax.ico"

   DEFINE WINDOW oWnd FROM 1, 1 TO 22, 75 ;
      TITLE OemToAnsi( "Ejemplo de construcci¢n del Men£ Principal" ) ;
      MENU  BuildMenu() ;
      ICON oIco

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT ) ;
      CENTERED

   ACTIVATE WINDOW oWnd

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM OemToAnsi( "&Informaci¢n" )
      MENU
         MENUITEM "&Acerca de..." ;
            ACTION ( MsgInfo( "Mi primer programa ;" + ;
                              "Puedes poner varias l¡neas" ),;
                     oWnd:Say( 2, 2, "Mi primer programa con FiveDos..." ) )
         SEPARATOR
         MENUITEM "&Terminar..."  ;
            ACTION If( MsgYesNo( OemToAnsi( "¨ Desea terminar ?" ) ),;
                       oWnd:End(),)
      ENDMENU

      MENUITEM "&Clientes"
      MENU
         MENUITEM "&Altas..."           ;
            ACTION ( MsgStop( "Nuevos Clientes" ),;
                     oWnd:Say( 5, 5, "New Clients...", "GR+/G" ) )

         MENUITEM "&Modificaciones..."  ACTION MsgInfo( "Modif. Clientes" )
         MENUITEM "&Bajas..."           ACTION MsgAlert( "Bajas Clientes" )
      ENDMENU

      MENUITEM "&Utilidades"
      MENU
         MENUITEM "&Calculadora..." ACTION Calc() // WinExec( "Calc" )
         MENUITEM "C&alendario..."  ACTION WinExec( "Calendar" )
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//
