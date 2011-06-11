#include "FiveDos.ch"
#include "SysStr.ch"
#include "ctlalign.ch"

static oWndMain
static cParams := "                                          "

#define MSG_QUIT        "Terminar la ejecuci¢n de este progranma"
#define MSG_INFO        "Informaci¢n sobre este programa"
#define MSG_BROWSE      "Hojear una Base de Datos"

//----------------------------------------------------------------------------//

function Main()
   local cBack := SaveScreen( 0, 0, MaxRow(), MaxCol() )
   local oBar, oBtn
   local hClockTimer

   MOff()
   SysLanguage( SLG_SPANISH )
   MOn()
   DEFINE WINDOW oWndMain ;
      FROM 0, 0 TO ScrMaxRow(), ScrMaxCol() ;
      TITLE IDETitle() ;
      NORESIZE NODRAG NOMINIMIZE ;
      MENU BuildMenu()
      // COLOR "N/ W, N/W*, W+/W, N/N*, N+/W" ;


   DEFINE TIMER hClockTimer INTERVAL 1000 ;
           ACTION ( oWndMain:cTitle := IDETitle(), ;
                    oWndMain:Refresh() )

   SET MESSAGE OF oWndMain ;
       TO "(C) FiveDos 1.0 Team 1994"

   DEFINE BUTTONBAR oBar OF oWndMain

   DEFINE BUTTON oBtn FILENAME "..\bitmaps\Exit.bmp" OF oBar ;
      ACTION oWndMain:Close()   ;
      MESSAGE MSG_QUIT          ;
      TIPS    MSG_QUIT


   DEFINE BUTTON FILENAME "..\bitmaps\Info.bmp" OF oBar ;
      GROUP                               ;
      ACTION AcercaDe( "La memoria..." ) ; //
      MESSAGE MSG_INFO ;
      TIPS    MSG_INFO

   DEFINE BUTTON FILENAME "..\bitmaps\Open.bmp" OF oBar ;
      ACTION DbfUse() ;
      MESSAGE MSG_BROWSE ;
      TIPS    MSG_BROWSE

   // @ 5, 30 BITMAP FILENAME "Ide1.bin" SIZE 10, 4 OF oWndMain
   @ 5, 30 BITMAP FILENAME "Ide.bin" SIZE 15, 5 OF oWndMain

   // Our Application BackGround
   SET COLOR TO "N/N*"
   CLS
   SetBlink( .f. )

   ACTIVATE TIMER hClockTimer

   ACTIVATE WINDOW oWndMain VALID lMsgEnd() ;
            ON KEYDOWN Tock()

   RELEASE TIMER hClockTimer

   RestScreen( 0, 0, MaxRow(), MaxCol(), cBack )
   SetBlink( .t. )

return nil

//----------------------------------------------------------------------------//

Function oWndMain()
return oWndMain

//---------------------------------------------------------------------------//

static function IDETitle()
return "FiveDos 1.0 - IDE - " + Time()

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu, oItem
   local oDesign

   MENU oMenu // COLOR "n/w, w+/gr, r/w, r+/gr, n+/w, w+/w, n+/w"
      MENUITEM " &Bases de Datos " MESSAGE "Mantenimiento de ficheros"
      MENU
         MENUITEM " &RegisterExe()... " ACTION RegisterExe()
         MENUITEM " &Lib Management... " ACTION LibOpen()
         MENUITEM " &Usar DBF... " ;
            MESSAGE "Visualizar los datos contenidos en un fichero DBF" ;
            ACTION DbfUse()
         MENUITEM " &Crear DBF... " ACTION Alert( cGetHotKey( "Hol&e" ) )
         MENUITEM " &Areas de Trabajo... "
         SEPARATOR
         MENUITEM " &Usar Indice... "
         MENUITEM " &Crear Indice... "
         SEPARATOR
         MENUITEM " &Relaciones... "
         MENU
            MENUITEM " &Revisar... "
            MENUITEM " &Establacer nueva... "
            MENUITEM " E&liminar... "
         ENDMENU
         MENUITEM " &Filtros... "
         MENUITEM " &RDDs... "
         SEPARATOR
         MENUITEM " &Terminar...  Alt-X " ;
            ACTION oWndMain:End() SHORTCUT K_ALT_X ;
            MESSAGE "Terminar de usar el IDE y regresar al DOS"
      ENDMENU

      MENUITEM " &Recursos " MESSAGE "Mantenimiento de Recursos"
      MENU
         MENUITEM " &Men£ Principal... "    ACTION DlgMenu()
         MENUITEM " Cajas de &Di logo...  " ACTION DlgNew()
         SEPARATOR
         MENUITEM " &Controles... "
         MENUITEM " &Iconos " ACTION IconDef( oWndMain )
         SEPARATOR
         MENUITEM " C&olores... "
         MENUITEM " &Paleta ... " ACTION PaletteDlg()
         SEPARATOR
         MENUITEM oItem PROMPT " &Listados... " CHECKED ;
                  ACTION ( oItem:lChecked := !oItem:lChecked, oItem:Refresh() )
         MENUITEM " &Etiquetas... "
         MENUITEM " Mai&lings... "
      ENDMENU

      MENUITEM " &Programa " MESSAGE "Mantenimiento de Fuentes"
      MENU
         MENUITEM " &Editar Programa... " ACTION PrgEdit()
         MENUITEM " &Nuevo Programa... "  ACTION PrgNew()
         SEPARATOR
         MENUITEM " &Compilar... "  ACTION Compile()
         MENUITEM " &Enlazar... "   ACTION Link()
         MENUITEM " &Construir... " ACTION Make()
         MENUITEM " &Ejecutar... "  ACTION Execute()
         SEPARATOR
         MENUITEM " &Especificar Par metros... " ;
            ACTION lMsgGet( "Par metros ejecuci¢n", "&Especificar", @cParams )
      ENDMENU

      MENUITEM " Proy&ecto " MESSAGE "Mantenimiento de Proyectos"
      MENU
         MENUITEM " &Usar Proyecto... " ;
            MESSAGE "Editar un proyecto en desarrollo" ;
            ACTION Project()

         MENUITEM " &Nuevo Proyecto... " ;
            MESSAGE "Comenzar un nuevo proyecto" ACTION PrjNew()
         SEPARATOR
         MENUITEM " &A¤adir Elemento...  " MESSAGE "A¤adir un nuevo elemento al proyecto"
         MENUITEM " &Modificar Elemento... " MESSAGE "Variar caracter¡sticas de un elemento"
         SEPARATOR
         MENUITEM " &Generar C¢digo... "
         MENU
            MENUITEM " &Plantillas... "
            MENUITEM " &Nuevas Clases... "
            MENUITEM " &Data-Driven... "
         ENDMENU
      ENDMENU

      MENUITEM " &Opciones "
      MENU
         MENUITEM " &Configuraci¢n IDE... "
         MENUITEM " &Directorios... " ;
            MESSAGE "Establecer los directorios de trabajo" ACTION Directories()
         SEPARATOR
         MENUITEM " &Personalizaci¢n...  "
         SEPARATOR
         MENUITEM " &Guardar opciones... " MESSAGE "Salvar a disco la configuraci¢n establecida"
      ENDMENU

      MENUITEM " &Utilidades "
      MENU
         MENUITEM " &Block de Notas... "
         MENUITEM " &Calculadora... " ACTION Calc( oWndMain ) ;
            MESSAGE "Utilizar la calculadora"
         MENUITEM " &Agenda... " // ACTION Calendar( Date() )
         SEPARATOR
         MENUITEM " &Mosaico Ventanas " // ACTION oWndMain:Tiled()
         MENUITEM " Ca&scada Ventanas " // ACTION oWndMain:Cascade()
      ENDMENU

      MENUITEM " &Ayuda " MESSAGE "Informaci¢n en general"
      MENU
         MENUITEM " &Indice... "
         MENUITEM " &Buscar por... " ACTION BuscarPor()
         MENUITEM " &Ultima consulta...  "
         SEPARATOR
         MENUITEM " &FiveDos Team " ACTION MsgInfo( "(C) FiveDos Team 1994" + CRLF + ;
                                        "Antonio Linares"       + CRLF + ;
                                        "Francisco Pulp¢n"      + CRLF + ;
                                        "Cayetano G¢mez"    + CRLF + ;
                                        "J.Mariano Rodriguez", "FiveDos 1.0" ) ;
            MESSAGE "Los autores de FiveDos 1.0"
         MENUITEM " &Acerca de... " ACTION AcercaDe() ;
            MESSAGE "Informaci¢n acerca de este programa"
      ENDMENU
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function DbfUse()

   static oDlg, oLbx, oDbf, oBrw, oBar

   SetMCursor( IDC_CLOCK )

   SET DELETE OFF

   if !File( "Dialog01.ntx" )
       USE Dialog NEW
       INDEX ON Upper( Dialog->Name ) TO Dialog01.ntx FOR !Deleted()
       CLOSE
    endif

   if oDlg == nil

       USE DATABASE oDbf FILE "Dialog"  ;
            INDEX "Dialog01.ntx"


       BEGIN BROWSE oBrw ALIAS oDbf // COLOR "W+/W, W+/N, W/N"
          COLUMN TITLE "Nombre"  SHOW oDbf:Name
          COLUMN TITLE "FiveDos" SHOW oDbf:FiveDos
          COLUMN TITLE "Dialog"  SHOW oDbf:Dialog
          COLUMN TITLE "Object"  SHOW oDbf:Objects
          COLUMN TITLE "Nivel"   SHOW oDbf:Level
       END BROWSE

       DEFINE WINDOW oDlg FROM 4, 4 TO 22, 75 ;
          TITLE "Uso de ListBox Browse con Scope"

       DEFINE BUTTONBAR oBar OF oDlg

       // A¤adimos los botones a la barra
       DEFINE BUTTON OF oBar ;
            FILENAME "..\bitmaps\add.bmp" ;
            ACTION DbfEdit( oLbx, oDbf, .t. )
       DEFINE BUTTON OF oBar ;
            FILENAME "..\bitmaps\edit.bmp" ;
            ACTION DbfEdit( oLbx, oDbf )
       DEFINE BUTTON OF oBar ;
            FILENAME "..\bitmaps\trash.bmp" ;
            ACTION DbfDel( oLbx, oDbf )
       DEFINE BUTTON OF oBar ;
            FILENAME "..\bitmaps\seek.bmp" ;
            ACTION DbfSeek( oLbx, oDbf )
       DEFINE BUTTON OF oBar ;
            FILENAME "..\bitmaps\fileseek.bmp" ;
            ACTION DbfMove( oLbx, oDbf )
       DEFINE BUTTON OF oBar ;
            FILENAME "..\bitmaps\exit.bmp" ;
            ACTION oDlg:Close()

       @  1,  2 LISTBOX oLbx BROWSE oBrw MULTISELECT ;
          SIZE 67, 12                    ;
          LOGICLEN oDbf:KeyCount()       ;
          ON DBLCLICK DbfEdit( oLbx, oDbf ) ;
          OF oDlg

       oLbx:nAlign := ALIGN_CLIENT
/*
       @ 15,  5 BUTTON "  &New  "  OF oDlg ACTION DbfEdit( oLbx, oDbf, .t. )
       @ 15, 15 BUTTON "  &Edit  " OF oDlg ACTION DbfEdit( oLbx, oDbf )
       @ 15, 26 BUTTON "  &Del  "  OF oDlg ACTION DbfDel( oLbx, oDbf )
       @ 15, 36 BUTTON "  &Seek  " OF oDlg ACTION DbfSeek( oLbx, oDbf )
       @ 15, 47 BUTTON "  &Move  " OF oDlg ACTION DbfMove( oLbx, oDlg )
       @ 15, 58 BUTTON "  E&xit  " OF oDlg ACTION oDlg:Close()
*/

       oDbf:SetBuffer( .t. )

   endif


   ACTIVATE DIALOG oDlg ;
                VALID MsgYesNo( "­ Hey Valid !" ) ;
                WHEN  ( oLbx:Reset(), MsgYesNo( "­ Hey When  !" ) )

   // CLOSE DATABASE oDbf

return nil

//---------------------------------------------------------------------------//

function DbfSeek( oLbx, oDbf )

   local nRecNo := oDbf:RecNo(),;
         cName  := oDbf:Name

   if lMsgGet( "Cliente a buscar", "&Nombre:", @cName )
      if oDbf:Seek( Upper( Trim( cName ) ) )
         oLbx:Refresh()
      else
         alert( "No Found" )
         oDbf:Goto( nRecNo )
      endif
   endif

return nil

//---------------------------------------------------------------------------//

#include "dbfedit.prg"

//---------------------------------------------------------------------------//

#include "dbfdel.prg"

//---------------------------------------------------------------------------//

#include "dbfmove.prg"

//---------------------------------------------------------------------------//

function PrgEdit()

   // TextBrowse( ".\*.prg" )
   TextBrowse( "*.prg" )

return nil

//----------------------------------------------------------------------------//

function Project()

   local oDlg
   local cItem

   DEFINE DIALOG oDlg FROM 7, 30 TO 17, 60 ;
      TITLE "Proyecto" OF oWndMain

   @  2,  2 LISTBOX cItem PROMPT "&Unidades" ;
      ITEMS "Uno", "Dos", "Tres" SIZE 10, 4 OF oDlg

   @  2, 14 BUTTON " &Hola  " OF oDlg ACTION Alert( "Hola" )
   @  4, 14 BUTTON " &Adios " OF oDlg

   ACTIVATE DIALOG oDlg NOWAIT

return nil

//----------------------------------------------------------------------------//

function AcercaDe( cText )

    DEFAULT cText := "IDE 1.0"

    nMsgBox( cText + "; ;" + Transform( Memory( 0 ),;
                               "    Memoria disponible: 99,999 KBytes    ;" ),;
             "Acerca De",, "W+/BR, N/W*, W+/BR, N/W, W/BR" )
return nil

//----------------------------------------------------------------------------//

function DlgMenu()

   local oWnd
   local oMenu

   MENU oMenu
      MENUITEM " &Popup1 "
      MENU
         MENUITEM " &First... "
         MENUITEM " &Second... "
         MENUITEM " &Third... "
      ENDMENU

      MENUITEM " &Popup2 "
      MENU
         MENUITEM " &First... "
         MENUITEM " &Second... "
         MENUITEM " &Third... "
      ENDMENU
   ENDMENU

   DEFINE WINDOW oWnd OF oWndMain FROM 2, 3 TO 18, 75 ;
      TITLE "Men£ Principal" ;
      COLOR "W+/G*, N/W*, W+/G*, N/W, W/G*" ;
      MENU oMenu

   ACTIVATE WINDOW oWnd NOWAIT

return nil

//----------------------------------------------------------------------------//

function Compile()

   MOff()
   SAVE SCREEN
   SET COLOR TO "W/N"
   CLS
   // SwpRunCmd( "IdeComp noname /n/w" )
   nMKeyWait( 0 )
   REST SCREEN
   MOn()

return nil

//----------------------------------------------------------------------------//

function Link()

   MOff()
   SAVE SCREEN
   SET COLOR TO "W/N"
   CLS
   // SwpRunCmd( "IdeLink noname" )
   nMKeyWait( 0 )
   REST SCREEN
   MOn()

return nil

//----------------------------------------------------------------------------//

function Make()

   local cClrOld := SetColor( "W/N" )

   MOff()
   SAVE SCREEN
   CLS
   // SwpRunCmd( "IdeMake noname" )
   SetCursor( 1 )
   SetCursor( 0 )
   SetColor( cClrOld )
   REST SCREEN
   MOn()

return nil

//----------------------------------------------------------------------------//

function Execute()

   MOff()
   MReset()

   // SwpRunCmd( "IdeExec noname" )

   MInit()

   SetCursor( 1 )
   SetCursor( 0 )
   MOn()

return nil

//----------------------------------------------------------------------------//

function BuscarPor()

   local cBusca := Space( 30 )

   if lMsgGet( "Buscar por", "&Expresi¢n", @cBusca )
   endif

return nil

//----------------------------------------------------------------------------//

function Directories()

   local oDlg
   local cInclude   := Space( 30 )
   local cLibraries := Space( 30 )
   local cBinary    := Space( 30 )

   DEFINE DIALOG oDlg FROM 6, 13 TO 16, 64 TITLE "Directorios"

   @ 1, 2 GET cInclude      LABEL "&Include    .CH:" OF oDlg
   @ 3, 2 GET cLibraries    LABEL "&Libraries .LIB:" OF oDlg
   @ 5, 2 GET cBinary       LABEL "&Binary    .EXE:" OF oDlg

   @ 7,  7 BUTTON " &Aceptar "  OF oDlg ACTION oDlg:End()
   @ 7, 20 BUTTON " &Cancelar " OF oDlg ACTION oDlg:End()
   @ 7, 34 BUTTON "  &Ayuda  "  OF oDlg

   ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//

function PrgNew()

   local oWnd
   local cPrg  := "NONAME"
   local nFile := 1
   local cName := "NONAME01.PRG"

   while File( cName )
      cName = cPrg + PadL( nFile++, 2, "0" ) + ".prg"
   end

   MemoWrit( cName, "// FiveDos 2.0" )

   DEFINE WINDOW oWnd FROM 2, 2 TO 12, 40 TITLE cName ;
     OF oWndMain

   ACTIVATE WINDOW oWnd NOWAIT

return nil

//----------------------------------------------------------------------------//

function PrjNew()

   local oDlg
   local oBrw

   USE Project

   BEGIN BROWSE oBrw COLOR "W+/BG, W+/N"
      COLUMN SHOW Project->Type TITLE "Tipo"
      COLUMN SHOW Project->Name TITLE "Nombre"
   END BROWSE

   DEFINE DIALOG oDlg FROM 2, 30 TO 18, 75 ;
      TITLE "Nuevo Projecto" OF oWndMain

   @  1,  2 LISTBOX BROWSE oBrw PROMPT "&Elementos" SIZE 32, 14 OF oDlg

   @  2, 37 BUTTON "&A¤adir" OF oDlg ACTION PrjAdd()

   @  4, 37 BUTTON "&Editar" OF oDlg ACTION ( oDlg:Minimize(), DlgNew() )

   ACTIVATE DIALOG oDlg NOWAIT

return nil

//----------------------------------------------------------------------------//

function PrjAdd()

   local oDlg
   local nElemento := 1

   DEFINE WINDOW oDlg FROM 8, 21 TO 16, 49 ;
      TITLE "Elemento a a¤adir"

   @  0,  0 RADIO nElemento ITEMS "&Menu", "&Di logo", "&Listado" ;
      LABEL "&Tipos" OF oDlg

   @  2, 18 BUTTON "&Button" OF oDlg

   @  4, 18 BUTTON "&Button" OF oDlg

   ACTIVATE WINDOW oDlg

return nil

//----------------------------------------------------------------------------//
