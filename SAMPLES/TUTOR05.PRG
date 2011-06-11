//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Contruir con BUILD Tutor05
//  Build with:  BUILD Tutor05
//----------------------------------------------------------------------------//

// Este es el mismo ejercicio que hemos realizado en Tutor04, pero ahora
// vamos a a¤adir l¡neas de mensaje a las opciones del Men£ y vamos a
// comenzar la ejecuci¢n del programa con la ventana 'maximizada'.

// This is the same exercise we have done at Tutor04, but now
// we are going to add it messages to Menu options and we are going
// to start program execution with the Window maximized.

#include "FiveDos.ch"
#include "SysStr.ch"  // Usa SysLanguage()

static oWnd

//----------------------------------------------------------------------------//

function Main()

   SysLanguage( SLG_SPANISH ) // Lenguaje de sistema de FiveDos.

   DEFINE WINDOW oWnd FROM 1, 1 TO 22, 75 ;
      TITLE OemToAnsi( "Ejemplo de construcci¢n del Men£ Principal" ) ;
      MENU  BuildMenu()

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT ) ;
      CENTERED

   ACTIVATE WINDOW oWnd MAXIMIZED

return nil

//----------------------------------------------------------------------------//

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

      MENUITEM "&Clientes"
      MENU
         MENUITEM "&Altas..."           ;
            ACTION MsgStop( "Nuevos Clientes" ) ;
            MESSAGE OemToAnsi( "A¤adir nuevos Clientes" )

         MENUITEM "&Modificaciones..."  ;
            ACTION MsgInfo( "Modif. Clientes" ) ;
            MESSAGE "Modificar los datos de un Cliente"

         MENUITEM "&Bajas..." ;
            ACTION MsgAlert( "Bajas Clientes" ) ;
            MESSAGE OemToAnsi( "Borrar la informaci¢n de un Cliente" )
      ENDMENU

      MENUITEM "&Utilidades"
      MENU
         MENUITEM "&Calculadora..." ;
            ACTION Calc() ;
            MESSAGE "Llamar a la calculadora de Windows"

         MENUITEM "C&alendario..." ;
            ACTION WinExec( "Calendar" ) ;
            MESSAGE "Llamar al calendario de Windows"

         MENUITEM "Escribir..." ;
            ACTION WinExec( "Write" ) ;
            MESSAGE "Llamar a Write de Windows"
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//
