//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Contruir con BUILD Tutor13
//----------------------------------------------------------------------------//

// Ejemplos de utilizaci¢n de BROWSE FIELDS

#include "FiveDos.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   DEFINE WINDOW oWnd FROM 1, 1 TO 22, 75 ;
      TITLE OemToAnsi( "Utilizaci¢n de Browse" ) ;
      MENU PreparaMenu()

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( "FiveDos - La revoluci¢n xBase" )

   ACTIVATE WINDOW oWnd MAXIMIZED

return nil

//----------------------------------------------------------------------------//

function PreparaMenu()

   local oMenu

   MENU oMenu
      MENUITEM OemToAnsi( "&Informaci¢n" )
      MENU
         MENUITEM "&Acerca de..." ;
            ACTION MsgInfo( "Tutorial de FiveDos"   + CRLF + ;
                                  F2VERSION         + CRLF + CRLF + ;
                            "Antonio Linares"       + CRLF + ;
                            "Francisco Pulp¢n"      + CRLF + ;
                            " Cayetano Gomez"       + CRLF + ;
                            "J. Mariano Rodr¡guez"  + CRLF + CRLF + ;
                            " (C) FiveDos Team 1994 " ) ;
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

         MENUITEM   OemToAnsi( "&Almac‚n" ) ;
            ACTION  MsgInfo( OemToAnsi( "Control del Almac‚n" ) ) ;
            MESSAGE OemToAnsi( "Control del Almac‚n" )
      ENDMENU

      MENUITEM "&Utilidades"
      MENU
         MENUITEM "&Calculadora..." ;
            ACTION WinExec( "Calc" ) ;
            MESSAGE "Llamar a la calculadora de Windows"

         MENUITEM "C&alendario..." ;
            ACTION WinExec( "Calendar" ) ;
            MESSAGE "Llamar al calendario de Windows"

         MENUITEM "&Jugar un poco..." ;
            ACTION WinExec( "Sol" ) ;
            MESSAGE "A las cartas..."
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

static function Clientes()

   local oLbx, oDlg
   local aEsp := { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",;
                   "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre",;
                   "Diciembre" }
   local aIng := { "January", "February", "March", "April", "May", "June",;
                   "July", "August", "September", "Octuber", "November",;
                   "December" }
   local aVal := { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 }
   local aList := { aEsp, aIng, aVal }

   DEFINE DIALOG oDlg FROM 3, 10 TO 20, 64 ;
      TITLE "Meses del A¤o."

   SET MESSAGE OF oDlg TO "ListBox Fields Array"
/*
// Esta funciona tambi‚n.
   @  1, 2 LISTBOX oLbx FIELDS aList  ;
      LABEL "Traductor"              ;
      SIZE 47, 12 ;
      HEADERS "Espa¤ol", "English", "Valor" ;
      LOGICLEN len( aList[1] )        ;
      OF oDlg
*/

// Esta funciona tambi‚n.
   @  1, 2 LISTBOX oLbx COLUMNS aEsp, aIng, aVal  ;
      LABEL "Traductor"              ;
      SIZE 47, 12 ;
      HEADERS "Espa¤ol", "English", "Valor" ;
      LOGICLEN len( aList[1] )        ;
      OF oDlg

   @ 14,  2 BUTTON " &New " OF oDlg
   @ 14, 10 BUTTON " &Edit "  OF oDlg // ACTION CliEdit()
   @ 14, 18 BUTTON " &Seek "  OF oDlg // ACTION CliSeek()
   @ 14, 26 BUTTON " &Records " OF oDlg ACTION ;
     Alert( 'Registro = ' + allTrim( Str( len( aList[1] ) ) ) )
   @ 14, 40 BUTTON "  E&xit  "  OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//
