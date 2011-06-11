//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Contruir con BUILD Tutor10
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

   USE Dialog
   if RecCount() == 0
      APPEND BLANK
   endif
   INDEX ON Dialog->Name TO Dialog01.ntx
   SET INDEX TO Dialog01.ntx
   GO TOP

   DEFINE DIALOG oDlg FROM 3, 3 TO 20, 74 ;
      TITLE "Control de Clientes"

   SET MESSAGE OF oDlg TO "Control de Clientes"

   @  1, 2 LISTBOX oLbx FIELDS Dialog->Name,;
                          Dialog->Fivedos,;
                          Dialog->Dialog,;
                          Dialog->Objects,;
                          Dialog->Level ;                          
      HEADERS "Nombre", "FivePro", "Dialog", "Objects", "Nivel" ;                    
      SIZE 67, 12                 ;
      OF oDlg

   @ 14,  2 BUTTON "   &New   " OF oDlg
   @ 14, 14 BUTTON "  &Edit  "  OF oDlg // ACTION CliEdit()
   @ 14, 25 BUTTON "   &Del   " OF oDlg
   @ 14, 37 BUTTON "  &Seek  "  OF oDlg // ACTION CliSeek()
   @ 14, 48 BUTTON " &Records " OF oDlg ACTION ;
     Alert( 'Registro = ' + allTrim( Str( Dialog->( DbCountKey( oLbx:TBrowse ) ) ) ) )
   @ 14, 60 BUTTON "  E&xit  "  OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

   USE

return nil

//----------------------------------------------------------------------------//
