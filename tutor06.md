tutor06   (dialog boxes)

![http://img851.imageshack.us/img851/1443/capturedyk.png](http://img851.imageshack.us/img851/1443/capturedyk.png)

```
#include "FiveDos.ch"
#include "SysStr.ch"  // Usa SysLanguage()

static oWnd

function Main()

   SysLanguage( SLG_SPANISH ) // Lenguaje de sistema de FiveDos.

   DEFINE WINDOW oWnd FROM 1, 1 TO 22, 75 ;
      TITLE OemToAnsi( "Construyendo una Caja de Di logo" ) ;
      MENU  BuildMenu()

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT )

   ACTIVATE WINDOW oWnd MAXIMIZED

return nil

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM OemToAnsi( "&Informaci¢n" )
      MENU
         MENUITEM "&Acerca de..." ;
            ACTION MsgInfo( OemToAnsi( "Tutorial de FiveWin" + CRLF + CRLF + ;
                            FDCOPYRIGHT ) ) ;
            MESSAGE OemToAnsi( "Informaci¢n acerca de este programa" )
         SEPARATOR
         MENUITEM "&Terminar..."  ;
            ACTION If( MsgYesNo( OemToAnsi( "¨ Desea terminar ?" ) ),;
                       oWnd:End(),) ;
            MESSAGE OemToAnsi( "Terminar la ejecuci¢n de este programa" )
      ENDMENU

      MENUITEM "&Ficheros"
      MENU
         MENUITEM   "&Clientes..."           ;
            ACTION  Clientes() ;
            MESSAGE OemToAnsi( "Mantenimiento de Clientes" )

         MENUITEM   OemToAnsi( "&Almacn" ) ;
            ACTION  MsgInfo( OemToAnsi( "Control del Almacn" ) ) ;
            MESSAGE OemToAnsi( "Control del Almacn" )
      ENDMENU

      MENUITEM "&Utilidades"
      MENU
         MENUITEM "&Calculadora..." ;
            ACTION Calc() ;
            MESSAGE "Llamar a la calculadora de Windows"

         MENUITEM "C&alendario..." ;
            ACTION WinExec( "Calendar" ) ;
            MESSAGE "Llamar al calendario de Windows"

         MENUITEM "&Fichero..." ;
            ACTION WinExec( "CardFile" ) ;
            MESSAGE "Llamar al gestor de ficheros de Windows"
      ENDMENU
   ENDMENU

return oMenu

function Clientes()

   local oDlg
   local cNombre := "Este es el nombre de mi Cliente       "
                    
   local lUsaFiveWin := .t., oGet

   DEFINE DIALOG oDlg FROM 7, 14 TO 16, 65 TITLE "Mantenimiento de Clientes"

   @ 1,  2 GET oGet VAR cNombre PROMPT "&Nombre:" OF oDlg ;
        VALID oGet:cText := "Este YA NO es el nombre de mi Cliente ", .t.

   @ 3,  2 CHECKBOX lUsaFiveWin PROMPT "Usa Clipper y FiveWin" OF oDlg

   // Quitado el Size de los botones.
   @ 6,  4 BUTTON " &Anterior "  OF oDlg ACTION MsgInfo( "Anterior" )
   @ 6, 19 BUTTON " &Siguiente " OF oDlg ACTION MsgInfo( "Siguiente" )
   @ 6, 35 BUTTON " &Terminar "  OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

return nil
```