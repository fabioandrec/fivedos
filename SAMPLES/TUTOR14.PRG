//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Contruir con BUILD Tutor14
//----------------------------------------------------------------------------//

// Ejemplos de utilizaci¢n de LISTBOX BROWSE de array.

#include "FiveDos.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   DEFINE WINDOW oWnd FROM 1, 1 TO 22, 75 ;
      TITLE OemToAnsi( "Emulaci¢n de un ListBox Array con un ListBox Browse" ) ;
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

   local oBrw, oDlg
   local aList := { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",;
                    "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre",;
                    "Diciembre" }

/* Este ejemplo tambien funciona.
   BEGIN BROWSE oBrw COLOR "W+/W, W+/N" ARRAY aList ;
      AUTOCOLUMNS
   ENDBROWSE
*/   
   BEGIN BROWSE oBrw COLOR "W+/W, W+/N" ALIAS aList
*     COLUMN TITLE "Meses" SHOW aList[ oBrw:Cargo ] WIDTH 10
      COLUMN TITLE "Meses" SHOWBLOCK bFieldArr( oBrw, aList ) WIDTH 10
   ENDBROWSE


   DEFINE DIALOG oDlg FROM 4, 13 TO 20, 41 ;
      TITLE "ListBox Browse"

   SET MESSAGE OF oDlg TO "Control de Arrays"

   @  1, 2 LISTBOX BROWSE oBrw ;
      LABEL "Meses del A¤o"    ;
      SIZE 20, 10              ;
      LOGICLEN len( aList )    ;
      COLOR "n/bg, w+/bg"      ;        // Label Colors
      OF oDlg

   @ 12, 2 BUTTON " &New " OF oDlg
   @ 12, 8 BUTTON " &Records " OF oDlg ACTION ;
     Alert( 'Registro = ' + allTrim( Str( len( aList ) ) ) )
   @ 12, 19 BUTTON " E&xit "  OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

   USE

return nil

//----------------------------------------------------------------------------//
