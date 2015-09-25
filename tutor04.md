tutor04

![http://img848.imageshack.us/img848/1382/capturezcy.png](http://img848.imageshack.us/img848/1382/capturezcy.png)

![http://img137.imageshack.us/img137/3886/captureqc.png](http://img137.imageshack.us/img137/3886/captureqc.png)

![http://img17.imageshack.us/img17/6113/capturetbn.png](http://img17.imageshack.us/img17/6113/capturetbn.png)

```
#include "FiveDos.ch"
#include "SysStr.ch"  // Usa SysLanguage()

static oWnd

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
```