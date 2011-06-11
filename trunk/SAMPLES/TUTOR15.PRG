//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Contruir con BUILD Tutor15
//----------------------------------------------------------------------------//

// Ejemplos de utilizaci¢n de LISTBOX BROWSE de array multidimensional.

#include "FiveDos.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   DEFINE WINDOW oWnd FROM 1, 1 TO 22, 75 ;
      TITLE OemToAnsi( "ListBox Browse para Arrays Multidimensionales" ) ;
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
   local aList := { { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",;
                      "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre",;
                      "Diciembre" },;
                    { "January", "February", "March", "April", "May", "June",;
                      "July", "August", "September", "Octuber", "November",;
                      "December" },;
                    { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 } ;
                  }

   BEGIN BROWSE oBrw COLOR "W+/W, W+/N" ALIAS aList
      COLUMN TITLE "Espa¤ol" SHOWBLOCK bFieldArr( oBrw, aList, 1 ) WIDTH 12
      COLUMN TITLE "English" SHOWBLOCK bFieldArr( oBrw, aList, 2 ) WIDTH 14
      COLUMN TITLE "Valor"   SHOWBLOCK bFieldArr( oBrw, aList, 3 )
   ENDBROWSE

   DEFINE DIALOG oDlg FROM 3, 10 TO 20, 66 TITLE "Browse de Array"

   SET MESSAGE OF oDlg TO "Control de Arrays"

   @  1, 2 LISTBOX BROWSE oBrw ;
      LABEL "Traductor" ;
      SIZE 47, 12 ;
      LOGICLEN len( aList[1] ) ;
      COLOR "n/bg, w+/bg" ;
      OF oDlg

   @ 14,  2 BUTTON " &New " OF oDlg
   @ 14, 10 BUTTON " &Edit "  OF oDlg // ACTION CliEdit()
   @ 14, 18 BUTTON " &Seek "  OF oDlg // ACTION CliSeek()
   @ 14, 27 BUTTON " &Records " OF oDlg ACTION ;
     Alert( 'Registro = ' + allTrim( Str( len( aList[1] ) ) ) )
   @ 14, 40 BUTTON "  E&xit  "  OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//
