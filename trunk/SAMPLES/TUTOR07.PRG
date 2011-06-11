//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Contruir con BUILD Tutor07
//----------------------------------------------------------------------------//

// Vamos a continuar utilizando el anterior ejemplo, Tutor06, y a¤adiremos
// algunos controles m s a la Caja de Di logo y utilizaremos por primera
// vez una base de datos, desde esa Caja de Di logo

#include "FiveDos.ch"
#include "SysStr.ch"  // Usa SysLanguage()

static oWnd

//----------------------------------------------------------------------------//

function Main()

   SysLanguage( SLG_SPANISH ) // Lenguaje de sistema de FiveDos.

   DEFINE WINDOW oWnd FROM 1, 1 TO 22, 75 ;
      TITLE OemToAnsi( "Editando nuestra primera Base de Datos" ) ;
      MENU PreparaMenu()

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT )

   ACTIVATE WINDOW oWnd MAXIMIZED

return nil

//----------------------------------------------------------------------------//

function PreparaMenu()

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

         MENUITEM   OemToAnsi( "&Almac‚n" ) ;
            ACTION  MsgInfo( OemToAnsi( "Control del Almac‚n" ) ) ;
            MESSAGE OemToAnsi( "Control del Almac‚n" )
      ENDMENU

      MENUITEM "&Utilidades"
      MENU
         MENUITEM "&Calculadora..." ;
            ACTION Calc() ;
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

function Clientes()

   local oDlg
   local cNombre    := ""
   local cDireccion := ""
   local getNombre, getDireccion

   if ! File( "clientes.dbf" )
      DbCreate( "Clientes.dbf", { { "Nombre",    "C", 40, 0 },;
                                  { "Direccion", "C", 50, 0 },;
                                  { "Telefono",  "C", 12, 0 },;
                                  { "Edad",      "N",  2, 0 },;
                                  { "Productos", "C", 10, 0 },;
                                  { "Nivel",     "N",  2, 0 } } )
   endif
   
   USE Clientes
   if RecCount() == 0
      APPEND BLANK
   endif
   INDEX ON Clientes->Nombre TO CliNombr
   SET INDEX TO CliNombr
   GO TOP

   cNombre    := Clientes->Nombre
   cDireccion := Clientes->Direccion

   DEFINE DIALOG oDlg FROM 7, 6 TO 16, 72 TITLE "Mantenimiento de Clientes"

   @ 1,  2 GET getNombre VAR cNombre PROMPT "&Nombre:   " OF oDlg ;
               VALID NoEmptyField( cNombre )

   @ 3,  2 GET getDireccion VAR cDireccion PROMPT "&Direcci¢n:" OF oDlg

   @ 6,  7 BUTTON " &Anterior "  OF oDlg ;
                    ACTION ( DbSkip( -1 ),;
                            If( BoF(), MsgInfo( "Principio de Fichero" ),),;
                            oDlg:DispBegin() ,;
                            getNombre:cText    := Clientes->Nombre,;
                            getDireccion:cText := Clientes->Direccion ,;
                            oDlg:DispEnd() )

   @ 6, 27 BUTTON " &Siguiente " OF oDlg ;
                    ACTION ( DbSkip( 1 ),;
                        If( EoF(), MsgInfo( OemToAnsi( "F¡n de Fichero" ) ),),;
                        If( EoF(), DbGoBottom(),),;
                        oDlg:DispBegin() ,;
                        getNombre:cText    := Clientes->Nombre,;
                        getDireccion:cText := Clientes->Direccion,;
                        oDlg:DispEnd() )

   @ 6, 48 BUTTON " &Terminar "  OF oDlg ACTION oDlg:End()


   ACTIVATE DIALOG oDlg

   USE

return nil

//----------------------------------------------------------------------------//

static func NoEmptyField( cField )

    if empty( cField )
        Alert( "Este campo no puede estar vacio" )
        return .f.
    endif

return .t.

//---------------------------------------------------------------------------//
