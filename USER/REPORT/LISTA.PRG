
//----------------------------------------------------------------------------//
//  FiveDos - Tutorial                                                        //
//  (c) FiveDos Team 1995 y Manuel Exp¢sito                                   //
//                                                                            //
//  Uso de la clase TReport, TRColumn, TRBrw y TDataBase de FiveDOS           //
//                                                                            //
//  Contruir con BUILD Lista                                                  //
//----------------------------------------------------------------------------//

#include "FiveDos.ch"
#include "SysStr.ch"    // Usa SysLanguage()
#include "Report.ch"

REQUEST VEXTENDED
static oWnd             // Ventana principal
static oHnos, ;
       oCalle           // Objetos DataBase

static nGrp             // Contador de grupos

//---------------------------------------------------------------------------//

function Main()

   SysLanguage( SLG_SPANISH ) // Lenguaje de sistema de FiveDos.

   DEFINE WINDOW oWnd FROM 08, 21 TO 22, 69 ;
      TITLE OemToAnsi( "Utilizaci¢n de Listados" ) ;
      MENU PreparaMenu()

        SET MESSAGE OF oWnd ;
            TO OemToAnsi( "FiveDos - La revoluci¢n xBase" )

        SetDeskWallPaper( "fondo.bmp", "GR+/RB" )

   ACTIVATE WINDOW oWnd VALID lMsgEnd() ;
        ON INIT UsaDbf() ;
        CENTERED

   SetColor( "W/N" )
   cls

   CLOSE DATABASES

return nil

//----------------------------------------------------------------------------//

static function PreparaMenu()

   local oMenu
   local fichero

   MENU oMenu
      MENUITEM OemToAnsi( "&Informaci¢n" )
      MENU
         MENUITEM "&Acerca de..." ;
            ACTION MsgInfo( "Generador de informes" + CRLF + ;
                            "para FiveDOS" + CRLF + ;
                            "(c) Manuel Exposito - FiveTech" + CRLF + ;
                            CRLF + "Memoria disponible: " + ;
                            AllTrim( Str( Memory( 0 ) ) ) ) ;
            MESSAGE OemToAnsi( "Informaci¢n acerca de este programa" )
         SEPARATOR
         MENUITEM "&Terminar..."  ;
            ACTION oWnd:End() ;
            MESSAGE OemToAnsi( "Terminar la ejecuci¢n de este programa" )
      ENDMENU

      MENUITEM "&Ficheros"
      MENU
         MENUITEM   "&Listado general"           ;
            ACTION  ListadoPrueba() ;
            MESSAGE OemToAnsi( "Genera listado" )

         MENUITEM   "L&istado AutoColumna"           ;
            ACTION  LAutoPrueba() ;
            MESSAGE OemToAnsi( "Genera listado" )

         MENUITEM   "Li&stado de browse"           ;
            ACTION  LBrwPrueba() ;
            MESSAGE OemToAnsi( "Genera listado" )

         MENUITEM   "Lis&tado browse array"           ;
            ACTION  LbxBrwArr() ;
            MESSAGE OemToAnsi( "Genera listado" )

         MENUITEM   "List&ado Mailing"           ;
            ACTION  Mail() ;
            MESSAGE OemToAnsi( "Genera listado" )

         MENUITEM   "Lista&do Formatos"           ;
            ACTION  Form() ;
            MESSAGE OemToAnsi( "Genera listado" )

         MENUITEM   OemToAnsi( "&Ver Listados" ) ;
            ACTION  TextBrowse( if( empty( Fichero := ;
                    cGetFile( "Fichero PRN | *.PRN |", "Elija fichero" ) ), ;
                    "listGen.Prn", fichero ) ) ;
            MESSAGE OemToAnsi( "Control de listados" )
      ENDMENU

      MENUITEM "&Utilidades"
      MENU
         MENUITEM "&Calculadora..." ;
            ACTION Calc() ;
            MESSAGE "Llamar a la calculadora de FiveDOS"

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

static function ListadoPrueba()

   local oDlg

   nGrp := 0        // Inicia el contador de grupos

   oHnos:GoTop()
   oCalle:GoTop()

   DEFINE DIALOG oDlg FROM 3, 3 TO 16, 50 ;
      TITLE "Control de Listado"

    SET MESSAGE OF oDlg TO "(c) MesSoft '95"

   ACTIVATE DIALOG oDlg CENTERED;
    ON INIT ( Fondo( oDlg ), PaListado( oDlg ) )

return nil

//----------------------------------------------------------------------------//

static function PaListado( oDlg )

    local oRpt, oColu
    local cFecha := DToC( Date() )
    local aHead  := { { || "Fecha: " + cFecha }, ;
                      "LISTADO DE DEUDAS POR CALLES", ;
                      { || "Pagina: " + Str( oRpt:nPage, 3 ) }, ;
                      "" }
    local nTimeIni := 0
    local nTimeFin := 0
    local nTiempo  := 0
    local bLine    := { || FuncLine( oRpt, oDlg ) }

    nTimeIni := seconds()

// Definimos el listado, empieza con un DEFINE REPORT o simplemente REPORT
// y acaba con un END REPORT o ENDREPORT:

    DEFINE REPORT oRpt          ;
        CANAL "ListCol.prn"     ;
        HEADER aHead            ;
        MARGIN UP    1          ;
        MARGIN LEFT  2          ;
        SEP HOR  "Í"            ;
        SEP HEAD "Ø"            ;
        SEP COL  "³"            ;
        PAGE POSITION R_CENTER  ;
        TOTAL PG                ;
        TOTAL END               ;
        IN ALIAS oHnos:cAlias

// Definici¢n del GRUPO:

    GROUP VAL { || oCalle:Nombre }          ;
        ON START { || FGrupo( oRpt, oDlg ) };
        HEADER "-> Calle: "                 ;
        FOOTER "Totales de este grupo > "   ;
        EJECT                               ;
        TOTAL

// Diferentes formas de definir las columnas:

    ADDRCOLUMN TITLE "Apellido y nombre"         ;
            DATA { || oHnos:Apellido1 + " " +   ;
                      oHnos:Apellido2 + " " +   ;
                      oHnos:NombreHno }         ;
            SIZE 45

    ADD RCOLUMN TITLE "F.Nacimiento" ;
        DATA { || oHnos:FNac }      ;
        SIZE 10

    RCOLUMN TITLE "C.Calle"          ;
        DATA { || oHnos:CodCalle }  ;
        SIZE 6

    ADD RCOLUMN TITLE "Calle"        ;
        DATA { || oCalle:Nombre }   ;
        SIZE 30

    ADD RCOLUMN TITLE "Num."         ;
        DATA { || oHnos:NumCalle }  ;
        SIZE 4

    ADD RCOLUMN TITLE "Deuda"        ;
        DATA { || oHnos:Deuda }     ;
        SIZE 11                     ;
        PICTURE "@E 999,999,999"    ;
        TOTAL

    END REPORT

//---------------------------------------------------------------------------//
// Aqu¡ podr¡a ir m s c¢digo de programa o incluso que la activaci¢n
// se hiciera en otra funci¢n a la que se le pase el objeto TReport como
// argumeto, con esto se cosiguir¡a que una £nica funci¢n pusiera en marcha
// todos los listados, tal que as¡:
//
// function ActList( oList )
//
//      [...C¢digo...]
//    ACTIVATE REPORT oList ;
//        ON ...            ;
//        ON ...            ;
//        ON ...            ;
//      [...M s c¢digo...]
//
// return nil
//---------------------------------------------------------------------------//

// Actvaci¢n y generaci¢n del Listado

    ACTIVATE REPORT oRpt        ;
        ON LINE bLine

//---------------------------------------------------------------------------//
// ­­ Atenci¢n!!
// Por defecto el listado empieza desde el principio de una DBF hasta el final
// si se quiere un rango utilice el ON INIT del ACTIVATE para el rango superior
// y WHILE para la inferior
// Esto sirve para todos los tipos de listados de la Gerarqu¡a
//---------------------------------------------------------------------------//

    nTimeFin := seconds()

    nTiempo := nTimeFin - nTimeIni

    oRpt:Eject()        // Salto de p gina

    MsgInfo( "Listado terminado" + CRLF + ;
             "Se han empleado: " + AllTrim(  Str( nTiempo ) ) + ;
             " segundos" + CRLF + ;
             "para " + AllTrim( Str( oRpt:nPage ) ) + " p ginas" )

return nil

//----------------------------------------------------------

static function FuncLine( oRpt, oDlg )

    oDlg:BeginPaint()

        oDlg:Say( 02, 31, ;
            oRpt:aColumns[ 6 ]:SetForm( oRpt:aColumns[ 6 ]:nTotal ), "GR+/R+" )
        oDlg:Say( 05, 32, Str( oRpt:nPage ), "GR+/R+" )
        oDlg:Say( 06, 32, Str( oRpt:nLines ), "GR+/R+" )

    oDlg:EndPaint()

return nil

//---------------------------------------------------------------------------//

static function FGrupo( oRpt, oDlg )

    oDlg:BeginPaint()

        oDlg:Say( 4, 32, Str( ++nGrp ), "GR+/R+" )

    oDlg:EndPaint()

return nil

//---------------------------------------------------------------------------//

static function UsaDbf()

    SET DELETED ON      // Para que no se tenga en cuenta los borrados

// Fuerzo la generaci¢n de los ¡ndices SI NO EXISTEN:

    USE Hnos NEW
    if !file( "Hnos1.ntx" )
        INDEX ON Hnos->CodCalle+Str( Hnos->NumCalle, 4 ) TO Hnos1
    endif

    USE Calle NEW
    if !file( "cCalle.ntx" )
        INDEX ON Calle->CodCalle TO cCalle
    endif

    CLOSE DATABASES

// Utilizaci¢n de TDataBase:

    USE DATABASE oHnos FILE "Hnos" ;
    INDEX "Hnos1.ntx"

    USE DATABASE oCalle FILE "Calle" ;
    INDEX "cCalle.ntx"

    SET RELATION TO oHnos:CodCalle INTO Calle

return nil

//---------------------------------------------------------------------------//
// Compatible con FiveWin
static function SetDeskWallPaper( cFile, cColor )

    local n       := 0
    local cLine   := Replicate( ReadBitMap( cFile ), MaxCol()/2 + 1 )

    DEFAULT cColor := "N*/N"

    for n := 0 to MaxRow()
        @ n, 0 SAY cLine COLOR cColor
    next

retur nil

//----------------------------------------------------------------------------//

static function Fondo( oDlg )

    local n       := 0
    local oBtn
    local cLine   := Replicate( ReadBitMap( "lupa.bmp" ), ScrMaxCol()/2 + 1 )

    oDlg:BeginPaint()

        for n := 0 to ScrMaxRow()
            oDlg:Say( n, 0, cLine, "B/BG" )
        next

        oDlg:Say( 02, 04, " Total deuda.............:  " )
        oDlg:Say( 04, 04, " Grupo n£mero............:  " )
        oDlg:Say( 05, 04, " P gina n£mero...........:  " )
        oDlg:Say( 06, 04, " L¡nea de detalle n£mero.:  " )

        @ 09, 18 BUTTON oBtn LABEL "  &Salir  " OF oDlg ACTION oDlg:End()

        oBtn:Refresh() // <---- Ojo Tano al definir un bot¢n no lo refresca |:-)
                       //       por eso lo fuerzo aqu¡ ¨?
    oDlg:EndPaint()

return nil

//----------------------------------------------------------------------------//

function LBrwPrueba()

   static oDlg, oLbx

   local oBrw, oRpt

   SetMCursor( IDC_CLOCK )

   DbSelectArea( oCalle:cAlias )

   if oDlg == nil

       BEGIN BROWSE oBrw COLOR "W+/W, W+/N" ;
            AUTOCOLUMNS 
       ENDBROWSE

       DEFINE DIALOG oDlg FROM 4, 4 TO 22, 75 ;
          TITLE "Uso de ListBox Browse con listado"

       @  1,  2 LISTBOX oLbx BROWSE oBrw ;
          SIZE 67, 12                    ;
          LOGICLEN oCalle:KeyCount()       ;
          OF oDlg

//  Esta linea tambie vale
//       @ 15, 20 BUTTON "  &Listado  " OF oDlg ACTION ReportPru( oBrw )
///////////////////////////////////
       @ 15, 20 BUTTON "  &Listado  " OF oDlg ACTION ReportPru( oLbx:TBrowse )
       @ 15, 40 BUTTON "   &Salir   " OF oDlg ACTION oDlg:Close()

   endif

   ACTIVATE DIALOG oDlg WHEN ( oLbx:Reset(), .t. )

return nil

//----------------------------------------------------------------------------//

static function LbxBrwArr()

   static oDlg, oLbx

   local oBrw
   local aMonth := { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",;
                     "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre",;
                     "Diciembre", "+-----------------+", "Enero", "Febrero", ;
                     "Marzo", "Abril", "Mayo", "Junio","Julio", "Agosto", ;
                     "Septiembre", "Octubre", "Noviembre", "Diciembre" }

   SetMCursor( IDC_CLOCK )

   if oDlg == nil

       /* Este ejemplo tambien funciona.
          BEGIN BROWSE oBrw COLOR "W+/W, W+/N" ALIAS aMonth ;
             AUTOCOLUMNS
          ENDBROWSE
       */

       BEGIN BROWSE oBrw COLOR "W+/W, W+/N" ALIAS aMonth
          COLUMN TITLE "Meses" SHOWBLOCK bFieldArr( oBrw, aMonth ) WIDTH 12
       ENDBROWSE

       DEFINE DIALOG oDlg       ;
          FROM 4, 4 TO 21, 56   ;
          TITLE "Uso de ListBox Browse con Array Monodimensional"

       @  1, 14 LISTBOX oLbx BROWSE oBrw ;
          LABEL "Meses del A¤o"    ;
          SIZE 20, 10              ;
          LOGICLEN len( aMonth )    ;
          COLOR "n/bg, w+/bg"      ;        // Label Colors
          OF oDlg

       @ 14, 11 BUTTON " &Listado "  OF oDlg ACTION ReportPru( oLbx:TBrowse )
       @ 14, 28 BUTTON "  &Salir  "  OF oDlg ACTION oDlg:End()

   endif

   ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//
// Ejemplo de impresion de un listado
// Si no se a¤ade ninguna columna se supone que se quiere hacer AUTOCOLUMN
// Facil hacer un listado ¨¨ NO ??
//
function ReportPru( Brw )

    local oRpt

    REPORT oRpt BROWSE Brw      ;
        TO FILE "ListBrw1.prn"    ;
        MARGIN UP    1          ;
        MARGIN LEFT  2          ;
        SEP HOR  "Í"            ;
        SEP HEAD "Ø"            ;
        SEP COL  "³"            ;
        PAGE POSITION R_CENTER

    LINES PAGE 15 OF oRpt

    ACTIVATE REPORT oRpt

    MsgInfo( "Fin del Listado" )

return nil

//----------------------------------------------------------------------------//
// Ejemplo de un "auto Listado"
// Si no se a¤ade ninguna columna se supone que se quiere hacer AUTOCOLUMN
// Facil hacer un listado ¨¨ NO ??
//
function LAutoPrueba( )

    local oRpt

    if MsgYesNo( "¨Quieres continuar?" )

        REPORT oRpt                 ;
            TO FILE "ListAut.prn"    ;
            MARGIN UP    1          ;
            MARGIN LEFT  2          ;
            SEP HOR  "Ä"            ;
            SEP HEAD "×"            ;
            SEP COL  "º"            ;
            IN ALIAS oCalle:cAlias  ;
            PAGE POSITION R_CENTER

        ACTIVATE REPORT oRpt

        MsgInfo( "Fin del Listado" )

    endif

return nil

//----------------------------------------------------------------------------//

Function Mail()

   local oDlg

   nGrp := 0        // Inicia el contador de grupos

   oHnos:GoTop()
   oCalle:GoTop()

   DEFINE DIALOG oDlg FROM 3, 3 TO 16, 50 ;
      TITLE "Control de Listado"

    SET MESSAGE OF oDlg TO "(c) MesSoft '95"

   ACTIVATE DIALOG oDlg CENTERED;
    ON INIT ( Fondo( oDlg ), PaMail( oDlg ) )

return nil

//---------------------------------------------------------------------------//

function PaMail( oDlg )

    local oRpt
    local cFecha := DToC( Date() )
    local cHora  := time()
    local bLine    := { || FuncLn( oRpt, oDlg ) }
    local aHead := { "Ejemplo de Cabecera com£n", ;
                     { || "Fecha: " + cFecha + " Hora: " + cHora }, ;
                     "LISTADO DE FICHAS DE HERMANOS", ;
                     { || "Pagina: " + Str( oRpt:nPage, 3 ) }, ;
                     "" ;
                   }
    local nTimeIni := 0
    local nTimeFin := 0
    local nTiempo  := 0

    nTimeIni := seconds()

// Definici¢n del listado:

    DEFINE REPORT MERGE oRpt     ;
        TO FILE "Mail.prn"       ;
        MODEL "Ficha.txt"        ;
        WIDTH     80             ;
        UP        2              ;
        LEFT      2              ;
        IN ALIAS "Hnos"          ;
        HEADER aHead             ;
        EJECT PAGE POSITION R_CENTER

// Fin de las definiciones, el end report no tiene utilidad pero clarifica
// el codigo un montonazo

    END REPORT

// Aqu¡ se podr¡a poner m s c¢digo de programa, incluso que la activaci¢n
// estubiera en otro procedimiento o funci¢n pas ndole el objeto TReport ¢
// declar ndolo static global al principio del PRG y antes de la 1¦ funcion

    ACTIVATE REPORT oRpt      ;
        ON LINE bLine

    nTimeFin := seconds()

    nTiempo := nTimeFin - nTimeIni

    oRpt:Eject()        // Salto de p gina

    MsgInfo( "Listado terminado" + CRLF + ;
             "Se han empleado: " + AllTrim(  Str( nTiempo ) ) + ;
             " segundos" + CRLF + ;
             "para " + AllTrim( Str( oRpt:nPage ) ) + " p ginas" )

return nil

//----------------------------------------------------------------------------//

Function Form()

   local oDlg

   oHnos:GoTop()
   oCalle:GoTop()

   DEFINE DIALOG oDlg FROM 3, 3 TO 16, 50 ;
      TITLE "Control de Listado"

    SET MESSAGE OF oDlg TO "(c) MesSoft '95"

   ACTIVATE DIALOG oDlg CENTERED;
    ON INIT ( Fondo( oDlg ), PaForm( oDlg ) )

return nil

//---------------------------------------------------------------------------//

function PaForm( oDlg )

    local oRpt
    local cFecha := DToC( Date() )
    local cHora  := time()
    local bLine    := { || FuncLn( oRpt, oDlg ) }
    local aHead := { "Ejemplo de Cabecera com£n", ;
                     { || "Fecha: " + cFecha + " Hora: " + cHora }, ;
                     "LISTADO DE FICHAS DE HERMANOS EN FORMATO PREIMPRESO", ;
                     { || "Pagina: " + Str( oRpt:nPage, 3 ) }, ;
                     "" ;
                   }
    local nTimeIni := 0
    local nTimeFin := 0
    local nTiempo  := 0

    nTimeIni := seconds()

// Definici¢n del listado:

    DEFINE REPORT FORM oRpt     ;
        TO FILE "Form.prn"      ;
        HEADER aHead            ;
        WIDTH     80            ;
        UP        1             ;
        LEFT      1             ;
        LINES    10             ;
        IN ALIAS "Hnos"         ;
        EJECT PAGE POSITION R_CENTER

// Diferentes maneras de declarar los datos y sus posiciones en el PreImpreso:

        ADDFDATA EVAL { || Hnos->Apellido1 + " " +   ;
            Hnos->Apellido2 + " " +   ;
            Hnos->NombreHno }         ;
            LINE 1 POSITION 10 ;
            SIZE 45 ;
            OF oRpt     // Cuando hay m s de uno es bueno
                        // decir el listado al que pertenece

        FDATA BLOCK { || Hnos->FNac } X 2 Y 10

//  Si se declara la posici¢n de esta manera, las coordenadas tienen que ir
//  immediatamente despu‚s de FDATA as¡:

        FDATA @ 3, 10 EVAL { || Hnos->CodCalle } SIZE 6

        ADD FDATA EVAL { || Hnos->NumCalle };
            PICTURE "@E 99,999";
            ROW 4 COL 10 ;
            SIZE 6

        ADD FDATA EVAL { || Calle->Nombre };
            ROW 6 COL 10 ;
            SIZE 30

        ADD FDATA EVAL { || Hnos->Deuda };
            PICTURE "@E 999,999,999";
            ROW 8 COL 50
//          SIZE 11   // Si no se pone size se elige entre el mayor tama¤o
                        // entre el dato y la picture


// Fin de las definiciones, el end report no tiene utilidad pero clarifica
// el codigo un montonazo

    END REPORT

// Aqu¡ se podr¡a poner m s c¢digo de programa, incluso que la activaci¢n
// estubiera en otro procedimiento o funci¢n pas ndole el objeto TReport ¢
// declar ndolo static global al principio del PRG y antes de la 1¦ funcion

    ACTIVATE REPORT oRpt      ;
        ON LINE bLine

    nTimeFin := seconds()

    nTiempo := nTimeFin - nTimeIni

    oRpt:Eject()        // Salto de p gina

    MsgInfo( "Listado terminado" + CRLF + ;
             "Se han empleado: " + AllTrim(  Str( nTiempo ) ) + ;
             " segundos" + CRLF + ;
             "para " + AllTrim( Str( oRpt:nPage ) ) + " p ginas" )

return nil

//----------------------------------------------------------

static function FuncLn( oRpt, oDlg )

    oDlg:BeginPaint()

        oDlg:Say( 05, 32, Str( oRpt:nPage ), "GR+/R+" )
        oDlg:Say( 06, 32, Str( oRpt:nLines ), "GR+/R+" )

    oDlg:EndPaint()

return nil

//---------------------------------------------------------------------------//

