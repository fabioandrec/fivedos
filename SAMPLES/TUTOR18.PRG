//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Contruir con BUILD Tutor18
//----------------------------------------------------------------------------//

// Ejemplos de utilizaci¢n de LISTBOX ITEMS.

#include "FiveDos.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   DEFINE WINDOW oWnd FROM 1, 1 TO 22, 75 ;
      TITLE OemToAnsi( "ListBox items" ) ;
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

   local oLbx, oDlg, nItem := 1
   local aList := { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",;
                    "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre",;
                    "Diciembre" }

   DEFINE DIALOG oDlg FROM 3, 10 TO 20, 60 TITLE "ListBox de Array"

   SET MESSAGE OF oDlg TO "Control de Arrays"

/* Este funciona.
   @ 2, 2 LISTBOX nItem ;
        ITEMS "Lunes", "Martes", Miercoles, Jueves, Viernes, Sabado, Domingo ;
        SIZE 15, 5 ;
        LABEL '&Dia Semana' ;
        ON CHANGE Tock()     ;
        ON DBLCLICK  Tone(1000,1) ;
        OF oDlg
*/
   @ 2, 10 LISTBOX nItem ;
        ARRAY aList ;
        SIZE 15, 10 ;
        LABEL '&Dia Semana' ;
        ON CHANGE Tock()     ;
        ON DBLCLICK  Tone(1000,1) ;
        OF oDlg

   @  4, 32 BUTTON " &New " OF oDlg
   @  6, 32 BUTTON " &Edit "  OF oDlg // ACTION CliEdit()
   @  8, 32 BUTTON " &Seek "  OF oDlg // ACTION CliSeek()
   @ 10, 32 BUTTON " E&xit "  OF oDlg ACTION oDlg:End()
   @ 13, 12 BUTTON " &Records " OF oDlg ACTION ;
     Alert( 'Registro = ' + allTrim( Str( len( aList ) ) ) )

   ACTIVATE DIALOG oDlg

   USE

return nil

//----------------------------------------------------------------------------//
