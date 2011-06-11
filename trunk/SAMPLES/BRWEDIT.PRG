//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1995
//
//  Contruir con BUILD BrwEdit
//----------------------------------------------------------------------------//

// Ejemplos de utilizaci¢n de tablas y test del metodo lEditCol de CtrlBrowse

#include "FiveDos.ch"
#include "SysStr.ch"  // Usa SysLanguage()

static oWnd

//----------------------------------------------------------------------------//

function Main()

   SysLanguage( SLG_SPANISH ) // Lenguaje de sistema de FiveDos.

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
            ACTION MsgInfo( OemToAnsi( "Tutorial de FiveDos" + CRLF + CRLF + ;
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

static function Clientes()

   local oLbx, oBrw, oDlg

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

   BEGIN BROWSE oBrw COLOR "N/W, W+/N, W+/W"
      COLUMN TITLE "Nombre"    SHOW Clientes->Nombre
      COLUMN TITLE "Direccion" SHOW Clientes->Direccion
      COLUMN TITLE "Telefono"  SHOW Clientes->Telefono
      COLUMN TITLE "Edad"      SHOW Clientes->Edad
      COLUMN TITLE "Productos" SHOW Clientes->Productos
      COLUMN TITLE "Nivel"     SHOW Clientes->Nivel
   ENDBROWSE

   DEFINE DIALOG oDlg FROM 3, 3 TO 20, 74 ;
      TITLE "Control de Clientes"

   SET MESSAGE OF oDlg TO "Control de Clientes"

   @  1, 2 LISTBOX oLbx BROWSE oBrw       ;
      SIZE 67, 12                         ;
      LOGICLEN Clientes->( RecCount() )   ;
      ON DBLCLICK CliEdit( oLbx, .F. )    ;
      COLOR 'n/bg, w+/bg, bg+/bg, bg+/bg' ;        // Label colors
      OF oDlg

   oBrw:AutoLite = .t.

   @ 14,  2 BUTTON "   &New   " OF oDlg ACTION CliEdit( oLbx, .T. )
   @ 14, 14 BUTTON "  &Edit  "  OF oDlg ACTION CliEdit( oLbx, .F. )
   @ 14, 25 BUTTON "   &Del   " OF oDlg
   @ 14, 37 BUTTON "  &Seek  "  OF oDlg // ACTION CliSeek()
   @ 14, 48 BUTTON "  &Print  " OF oDlg
   @ 14, 60 BUTTON "  E&xit  "  OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

   USE

return nil

//---------------------------------------------------------------------------//
/* Esta funci¢n entra en accion con un DobleClick, por tanto, da por hecho
   que el controlBrowse tiene focus en ese momento y por tanto lo volvera a
   tener cuando se valide el get
*/
static function CliEdit( oLbx, lNew )

    local oBrw   := oLbx:TBrowse
    local uVal

    if lNew
        LineAppend( oLbx )
    else
        while oBrw:ColPos > 1 ; oLbx:GoLeft() ; end
    endif

    uVal   := FieldGet( oBrw:ColPos )

    while oLbx:lEditCol( oBrw:ColPos, @uVal,,, "n/w, w+/b" )

        FieldPut( oBrw:ColPos, uVal )

        if oBrw:ColPos < oBrw:ColCount
            oLbx:GoRight()
        else
            LineAppend( oLbx )
        endif

        oLbx:UpStable()

        uVal := FieldGet( oBrw:ColPos )

    end

return nil

//---------------------------------------------------------------------------//

static function LineAppend( oLbx )
    local oBrw := oLbx:TBrowse

    while oBrw:ColPos > 1
        oLbx:GoLeft()
    end

    APPEND BLANK
    oLbx:Reset()

return nil

//----------------------------------------------------------------------------//
