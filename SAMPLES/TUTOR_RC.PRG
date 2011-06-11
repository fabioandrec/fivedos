//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Contruir con BUILD Tutor_rc
//----------------------------------------------------------------------------//

// Ejemplos de utilizaci¢n de Tutor_rc

#include "FiveDos.ch"
#include "SysStr.ch"

static oWnd
static aMonth, aDay

function Main()

    DEFINE WINDOW oWnd AT 1, 1 SIZE 76, 22 ;
       TITLE "Bases de datos" ;
       MENU BuildMenu()

    SET MESSAGE OF oWnd TO "FiveDos - La revoluci¢n xBase"

    // Change the lenguage.                         By default == SLG_ENGLISH
    SysLanguage( SLG_ENGLISH ) // SLG_SPANISH

    if SysLanguage() == SLG_SPANISH

       aMonth = { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",;
                 "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre",;
                 "Diciembre" }
       aDay   = { "Lunes", "Martes", "Miercoles", "Jueves", ;
                  "Viernes", "Sabado", "Domingo" }
    else
       aMonth =  { "January", "February", "March", "April", "May", "June",;
                  "July", "August", "September", "Octuber", "November",;
                  "December" }
       aDay   = { "Monday", "Tuesday", "Wednesday", "Thursday", ;
                  "Friday", "Saturday", "Sunday" }
    endif

    ACTIVATE WINDOW oWnd MAXIMIZED VALID lMsgEnd()

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "&Informaci¢n"
      MENU
         MENUITEM "&Acerca de..." ;
            ACTION MsgInfo( "Tutorial de FiveDos"   + CRLF + ;
                                  F2VERSION         + CRLF + CRLF + ;
                            "Antonio Linares"       + CRLF + ;
                            "Francisco Pulp¢n"      + CRLF + ;
                            " Cayetano Gomez"       + CRLF + ;
                            "J. Mariano Rodr¡guez"  + CRLF + CRLF + ;
                            " (C) FiveDos Team 1994 " ) ;
            MESSAGE "Informaci¢n acerca de este programa"
         SEPARATOR
         MENUITEM "&Terminar..."  ;
            ACTION oWnd:Close() ;
            MESSAGE "Terminar la ejecuci¢n de este programa"
      ENDMENU

      MENUITEM "&ListBox Item"
      MENU
         MENUITEM   "&Use...con clausula ARRAY" ;
            ACTION  LbxArray() ;
            MESSAGE "Uso de ListBox Item... con un Array"
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

function LbxArray()

    local oLbx, oDlg, nItem := 1

    DEFINE DIALOG oDlg RESOURCE "listbox" FILE "Tutor_Rc.rc"

    SET MESSAGE OF oDlg TO "Control de Arrays"

    REDEFINE LISTBOX oLbx VAR nItem ID 70 ;
        ARRAY aMonth ;
        LABEL '&Day of Week' ;
        ON CHANGE Tock()     ;
        ON DBLCLICK Alert( 'Registro : ' + Str( nItem ) ) ;
        OF oDlg

    REDEFINE BUTTON ID 10 OF oDlg ACTION oLbx:GoUp()
    REDEFINE BUTTON ID 20 OF oDlg ACTION oLbx:GoDown()
    REDEFINE BUTTON ID 30 OF oDlg ACTION oLbx:GoPgUp()
    REDEFINE BUTTON ID 40 OF oDlg ACTION oLbx:GoPgDown()
    REDEFINE BUTTON ID 50 OF oDlg ACTION Alert( 'Registros = ' + ;
                                        allTrim( Str( len( aMonth ) ) ) )
    REDEFINE BUTTON ID 60 OF oDlg ACTION oDlg:End()

    ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//

function EditMArr( oLbx, aList, lNew )

   local oDlg, n
   local cEsp, cIng, nMes

   if !Empty( lNew )
      aAdd( aList[1], space( 12 ) )
      aAdd( aList[2], space( 12 ) )
      aAdd( aList[3], space( 12 ) )
      oLbx:GoEnd()
   end

   n    = oLbx:TBrowse:Cargo

   cEsp = aList[ 1, n ]
   cIng = aList[ 2, n ]
   nMes = aList[ 3, n ]

   DEFINE DIALOG oDlg FROM 6, 12 TO 19, 70 TITLE "Edit Multi Array"

   @  2,  2 SAY "Espa¤ol:" OF oDlg
   @  2, 12 GET cEsp       OF oDlg

   @  4,  2 SAY "Ingles:"  OF oDlg
   @  4, 12 GET cIng       OF oDlg

   @  6,  2 SAY "Numero:"  OF oDlg
   @  6, 12 GET nMes       OF oDlg

   @ 10, 15 BUTTON " &Aceptar "  OF oDlg ;
            ACTION ( aList[ 1, n ]:= cEsp,;
                     aLIst[ 2, n ]:= cIng,;
                     aList[ 3, n ]:= nMes, oLbx:Refresh(), oDlg:End() )
   @ 10, 28 BUTTON " &Cancelar " OF oDlg ACTION oDlg:End()

   ACTIVATE WINDOW oDlg

return nil

//---------------------------------------------------------------------------//

function SeekMArr( oLbx, aList )

   local oDlg, n := oLbx:TBrowse:Cargo

   local cEsp := Pad( aList[ 1, n ], 12 )

   DEFINE DIALOG oDlg FROM 6, 12 TO 19, 70 TITLE "Seek Multi Array"

   @  2,  2 SAY "Espa¤ol:" OF oDlg
   @  2, 12 GET cEsp       OF oDlg

   @ 10, 15 BUTTON " &Aceptar "  OF oDlg ;
            ACTION ( n:= aScan( aList[1], {|e| Upper( Trim( cEsp ) ) == Upper( Trim( e ) ) } ),;
                     oLbx:TBrowse:Cargo := n,;
                     oLbx:Reset(), oDlg:End() )
   @ 10, 28 BUTTON " &Cancelar " OF oDlg ACTION oDlg:End()

   ACTIVATE WINDOW oDlg

return nil

//---------------------------------------------------------------------------//

function SeekArr( oLbx, aList )

   local oDlg, n := oLbx:TBrowse:cargo

   local cName := Pad( aList[ n ], 12 )

   DEFINE DIALOG oDlg FROM 6, 12 TO 19, 70 TITLE "Seek Array"

   @  2,  2 SAY "Nombre:" OF oDlg
   @  2, 12 GET cName     OF oDlg

   @ 10, 15 BUTTON " &Aceptar "  OF oDlg ;
            ACTION ( n:= aScan( aList, {|e| Upper( Trim( cName ) ) == Upper( Trim ( e ) ) } ),;
                     oLbx:TBrowse:cargo := n,;
                     oLbx:Reset(), oDlg:End() )
   @ 10, 28 BUTTON " &Cancelar " OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

return nil

//---------------------------------------------------------------------------//

function EditArr( oLbx, aList, lNew )

   local oDlg, n, cName

   if !Empty( lNew )
      aAdd( aList, space( 12 ) )
      oLbx:GoEnd()
   end

   n     = oLbx:TBrowse:Cargo
   cName = Pad( aList[ n ], 12 )

   DEFINE DIALOG oDlg FROM 6, 22 TO 14, 54 TITLE "Edit Array"

   @  2,  4 SAY "Nombre:" OF oDlg
   @  2, 14 GET cName     OF oDlg

   @  5,  4 BUTTON " &Aceptar "  OF oDlg ;
            ACTION ( aList[ n ] := Trim( cName ), oLbx:Refresh(), oDlg:End() )
   @  5, 15 BUTTON " &Cancelar " OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//

