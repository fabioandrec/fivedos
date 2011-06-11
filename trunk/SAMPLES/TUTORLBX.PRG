//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Contruir con BUILD TutorLbx
//----------------------------------------------------------------------------//

// Ejemplos de utilizaci¢n de LISTBOX.

#include "FiveDos.ch"
#include "SysStr.ch"
#include "Tree.ch"

static oWnd
static aMonth, aDay

external indexord

//----------------------------------------------------------------------------//

function Main()

    local oBar

    DEFINE WINDOW oWnd AT 1, 1 SIZE 76, 22 ;
       TITLE "Bases de datos" ;
       MENU BuildMenu()

    SET MESSAGE OF oWnd TO "FiveDos - La revoluci¢n xBase"

    DEFINE BUTTONBAR oBar OF oWnd

    DEFINE MESSAGE BAR OF oWnd PROMPT F2VERSION + SPACE(5) + FDCOPYRIGHT

    DEFINE BUTTON FILE '..\bitmaps\exit.bmp' PROMPT 'Salir' OF oBar ;
                        ACTION oWnd:Close()

    DEFINE BUTTON FILE '..\bitmaps\info.bmp' GROUP OF oBar ;
                        ACTION MsgInfo( " (C) FiveDos Team 1994 " + CRLF + CRLF + ;
                                        "Antonio Linares"         + CRLF + ;
                                        "Francisco Pulp¢n"        + CRLF + ;
                                        " Cayetano G¢mez"         + CRLF + ;
                                        "J. Mariano Rodr¡guez"    + CRLF + CRLF + ;
                                                                  F2VERSION )
    DEFINE BUTTON FILE '..\bitmaps\floppy_a.bmp'   OF oBar ;
                        ACTION Alert( 'Puls¢ Floppy "A"' )

    DEFINE BUTTON FILE '..\bitmaps\open.bmp'       OF oBar ;
                        ACTION Alert( 'Puls¢ el Boton "OPEN"' )

    SET DELETE OFF

    USE Dialog NEW
    INDEX ON Upper( Dialog->Name ) TO Dialog01.ntx FOR !Deleted()
    CLOSE

    USE Clientes NEW
    INDEX ON Upper( Clientes->Nombre ) TO Client01.ntx FOR !Deleted()
    CLOSE

    USE Nivel NEW
    INDEX ON Nivel->Nivel TO Nivel01.ntx
    CLOSE

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
         MENUITEM   "&Use...con clausula ITEMS" ;
            ACTION  LbxItem() ;
            MESSAGE "Uso de ListBox Item"

         MENUITEM   "&Use...con clausula ARRAY" ;
            ACTION  LbxArray() ;
            MESSAGE "Uso de ListBox Item... con un Array"

      ENDMENU

      MENUITEM "&ListBox Browse"
      MENU
         MENUITEM   "&Use..."
         MENU
            MENUITEM "...con una Dbf" ;
               ACTION  LbxBrw() ;
               MESSAGE "Uso de ListBox Browse con una DBF"

            MENUITEM "...con un Array"
            MENU
               MENUITEM "...monodimensional" ;
                  ACTION  LbxBrwArr() ;
                  MESSAGE "Uso de ListBox Browse con un ARRAY"
               MENUITEM "...multidimensional" ;
                  ACTION  LbxBrwMArr() ;
                  MESSAGE "Uso de ListBox Browse con un ARRAY MULTIDIMENSIONAL"
            ENDMENU
            MENUITEM "...AutoFields" ;
               ACTION  LbxBrwAuto() ;
               MESSAGE "Uso de ListBox Browse con una DBF y AUTOFIELDS"
         ENDMENU
         MENUITEM   "&Scope..."
         MENU
            MENUITEM "...con una Dbf" ;
               ACTION  LbxBrwScp() ;
               MESSAGE "Uso de ListBox Browse con una DBF"

            MENUITEM "...con un Array" ;
               ACTION Alert( "Under Construction" ) ;
               MESSAGE "Uso de ListBox Browse con un ARRAY"

         ENDMENU
         MENUITEM   "&Multiselect..."
         MENU
            MENUITEM "...con una Dbf" ;
               ACTION  LbxBrwMSel() ;
               MESSAGE "Uso de ListBox Browse con una DBF en Multiselecci¢n"

            MENUITEM "...con un Array" ;
               ACTION Alert( "Under Construction" ) ;
               MESSAGE "Uso de ListBox Browse con un ARRAY en Multiselecci¢n"

         ENDMENU
         MENUITEM   "&Tree..."
         MENU
            MENUITEM "TREE..." ;
            ACTION  LbxBrwTree() ;
            MESSAGE "Uso de ListBox Browse con una objeto TREE"
            
         ENDMENU
      ENDMENU

      MENUITEM "&ListBox Fields"
      MENU
         MENUITEM   "&Use..."
         MENU
            MENUITEM "...con una Dbf" ;
               ACTION  LbxFld() ;
               MESSAGE "Uso de ListBox Fields con una DBF"

            MENUITEM "...con un Array"
            MENU
               MENUITEM "...monodimensional" ;
                  ACTION  LbxFldArr() ;
                  MESSAGE "Uso de ListBox Fields con un ARRAY"
               MENUITEM "...multidimensional" ;
                  ACTION  LbxFldMArr() ;
                  MESSAGE "Uso de ListBox Fields con un ARRAY MULTIDIMENSIONAL"
            ENDMENU
         ENDMENU

         MENUITEM   "&Scope..."
         MENU
            MENUITEM "...con una Dbf" ;
               ACTION  LbxFldScp() ;
               MESSAGE "Uso de ListBox Fields... con Scope"

            MENUITEM "...con un Array" ;
               ACTION Alert( "Under Construction" ) ;
               MESSAGE "Uso de ListBox Fields con un ARRAY"

         ENDMENU
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

static function LbxItem()

   local oDlg, oLbx, nItem := 1

   DEFINE DIALOG oDlg FROM 5, 20 TO 18, 52 TITLE "ListBox de Array"

   SET MESSAGE OF oDlg TO "Control de Arrays"

   @ 1, 8 LISTBOX oLbx VAR nItem ;
        ITEMS "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado", "Domingo" ;
        SIZE 15, 6 ;
        LABEL '&Dia Semana' ;
        ON CHANGE Tock() ;
        ON DBLCLICK  Tone( 1000, 1 ) ;
        OF oDlg

   @  9,  4 BUTTON "  &Up  "  OF oDlg ACTION oLbx:GoUp()
   @  9, 12 BUTTON " &Down "  OF oDlg ACTION oLbx:GoDown()
   @  9, 20 BUTTON " E&xit "  OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//

static function LbxArray()

   local oLbx, oDlg, nItem := 1

   DEFINE DIALOG oDlg FROM 4, 10 TO 22, 66 TITLE "ListBox de Array"

   SET MESSAGE OF oDlg TO "Control de Arrays"

   @ 2, 18 LISTBOX oLbx VAR nItem ;
        ARRAY aMonth ;
        SIZE 15, 9 ;
        LABEL '&Dia Semana' ;
        ON CHANGE Tock()     ;
        ON DBLCLICK Alert( 'Registro : ' + Str( nItem ) ) ;
        OF oDlg

   @ 14,  2 BUTTON "  &Up  "  OF oDlg ACTION oLbx:GoUp()
   @ 14, 10 BUTTON " &Down "  OF oDlg ACTION oLbx:GoDown()
   @ 14, 18 BUTTON " &PgUp "  OF oDlg ACTION oLbx:GoPgUp()
   @ 14, 26 BUTTON " &PgDn "  OF oDlg ACTION oLbx:GoPgDown()
   @ 14, 34 BUTTON " &Records " OF oDlg ACTION ;
     Alert( 'Registros = ' + allTrim( Str( len( aMonth ) ) ) )
   @ 14, 44 BUTTON "  E&xit  "  OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//

static function LbxBrw()

   static oDlg, oLbx

   local oDbf, oBrw

   SetMCursor( IDC_CLOCK )

   USE DATABASE oDbf FILE "Dialog"  ;
       INDEX "Dialog01.ntx"

   if oDlg == nil

       BEGIN BROWSE oBrw ALIAS oDbf COLOR "W+/W, W+/N"
          COLUMN TITLE "Nombre"  SHOW oDbf:Name
          COLUMN TITLE "FiveDos" SHOW oDbf:FiveDos
          COLUMN TITLE "Dialog"  SHOW oDbf:Dialog
          COLUMN TITLE "Object"  SHOW oDbf:Objects
          COLUMN TITLE "Nivel"   SHOW oDbf:Level
       ENDBROWSE

       DEFINE DIALOG oDlg FROM 4, 4 TO 22, 75 ;
          TITLE "Uso de ListBox Browse"

       @  1,  2 LISTBOX oLbx BROWSE oBrw ;
          LABEL "CLIENTES" ;
          SIZE 67, 12                    ;
          LOGICLEN oDbf:KeyCount()       ;
          ON DBLCLICK DbfEdit( oLbx, oDbf ) ;
          OF oDlg

       @ 15,  5 BUTTON "  &New  "  OF oDlg ACTION DbfEdit( oLbx, oDbf, .t. )
       @ 15, 15 BUTTON "  &Edit  " OF oDlg ACTION DbfEdit( oLbx, oDbf )
       @ 15, 26 BUTTON "  &Del  "  OF oDlg ACTION DbfDel( oLbx, oDbf )
       @ 15, 36 BUTTON "  &Seek  " OF oDlg ACTION DbfSeek( oLbx, oDbf )
       @ 15, 47 BUTTON "  &Move  " OF oDlg ACTION DbfMove( oLbx, oDlg )
       @ 15, 58 BUTTON "  E&xit  " OF oDlg ACTION oDlg:Close()

   endif

   ACTIVATE DIALOG oDlg WHEN ( oLbx:Reset(), .t. )

   CLOSE DATABASE oDbf

return nil

//----------------------------------------------------------------------------//

static function LbxBrwScp()

   static oDlg, oLbx

   local oDbf, oBrw

   SetMCursor( IDC_CLOCK )

   USE DATABASE oDbf FILE "Dialog"  ;
       INDEX "Dialog01.ntx"

   if oDlg == nil

       BEGIN BROWSE oBrw ALIAS oDbf COLOR "W+/W, W+/N" FOR "GARCIA" TO "HERNANDEZ"
          COLUMN TITLE "Nombre"  SHOW oDbf:Name
          COLUMN TITLE "FiveDos" SHOW oDbf:FiveDos
          COLUMN TITLE "Nivel"   SHOW oDbf:Level
       ENDBROWSE

       DEFINE DIALOG oDlg FROM 4, 4 TO 22, 75 ;
          TITLE "Uso de ListBox Browse con Scope"

       @  1,  2 LISTBOX oLbx BROWSE oBrw ;
          LABEL "CLIENTES" ;
          SIZE 67, 12                    ;
          LOGICLEN oDbf:KeyCount()       ;
          ON DBLCLICK DbfEdit( oLbx, oDbf ) ;
          OF oDlg

       @ 15,  5 BUTTON "  &New  "  OF oDlg ACTION DbfEdit( oLbx, oDbf, .t. )
       @ 15, 15 BUTTON "  &Edit  " OF oDlg ACTION DbfEdit( oLbx, oDbf )
       @ 15, 26 BUTTON "  &Del  "  OF oDlg ACTION DbfDel( oLbx, oDbf )
       @ 15, 36 BUTTON "  &Seek  " OF oDlg ACTION DbfSeek( oLbx, oDbf )
       @ 15, 47 BUTTON "  &Move  " OF oDlg ACTION DbfMove( oLbx, oDlg )
       @ 15, 58 BUTTON "  E&xit  " OF oDlg ACTION oDlg:Close()

   endif

   ACTIVATE DIALOG oDlg WHEN ( oLbx:Reset(), .t. )

   CLOSE DATABASE oDbf

return nil

//----------------------------------------------------------------------------//

static function LbxBrwAuto()

   static oDlg, oLbx

   local oDbf, oBrw

   SetMCursor( IDC_CLOCK )

   USE DATABASE oDbf FILE "Dialog"  ;
       INDEX "Dialog01.ntx"

   if oDlg == nil

       BEGIN BROWSE oBrw COLOR "W+/W, W+/N" FOR "GARCIA" TO "HERNANDEZ" ;
          AUTOCOLUMNS
       ENDBROWSE

       DEFINE DIALOG oDlg FROM 4, 4 TO 22, 75 ;
          TITLE "Uso de ListBox Browse con Scope y AutoFields"

       @  1,  2 LISTBOX oLbx BROWSE oBrw ;
          SIZE 67, 12                    ;
          LOGICLEN oDbf:KeyCount()       ;
          ON DBLCLICK DbfEdit( oLbx, oDbf ) ;
          OF oDlg

       @ 15,  5 BUTTON "  &New  "  OF oDlg ACTION DbfEdit( oLbx, oDbf, .t. )
       @ 15, 15 BUTTON "  &Edit  " OF oDlg ACTION DbfEdit( oLbx, oDbf )
       @ 15, 26 BUTTON "  &Del  "  OF oDlg ACTION DbfDel( oLbx, oDbf )
       @ 15, 36 BUTTON "  &Seek  " OF oDlg ACTION DbfSeek( oLbx, oDbf )
       @ 15, 47 BUTTON "  &Move  " OF oDlg ACTION DbfMove( oLbx, oDlg )
       @ 15, 58 BUTTON "  E&xit  " OF oDlg ACTION oDlg:Close()

   endif

   ACTIVATE DIALOG oDlg WHEN ( oLbx:Reset(), .t. )

   CLOSE DATABASE oDbf

return nil

//----------------------------------------------------------------------------//

static function LbxBrwMSel()

   static oDlg, oLbx

   local oDbf, oBrw

   SetMCursor( IDC_CLOCK )

   USE DATABASE oDbf FILE "Dialog"  ;
       INDEX "Dialog01.ntx"

   if oDlg == nil

       BEGIN BROWSE oBrw ALIAS oDbf COLOR "W+/W, W+/N"
          COLUMN TITLE "Nombre"  SHOW oDbf:Name
          COLUMN TITLE "FiveDos" SHOW oDbf:FiveDos
       ENDBROWSE

       DEFINE DIALOG oDlg FROM 4, 4 TO 22, 75 ;
          TITLE "Uso de ListBox Browse con Multiselect"

       @  1,  2 LISTBOX oLbx BROWSE oBrw MULTISELECT ;
          LABEL "CLIENTES" ;
          SIZE 67, 12                    ;
          LOGICLEN oDbf:KeyCount()       ;
          OF oDlg

       @ 15,  5 BUTTON "  &New  "  OF oDlg ACTION DbfEdit( oLbx, oDbf, .t. )
       @ 15, 15 BUTTON "  &Edit  " OF oDlg ACTION DbfEdit( oLbx, oDbf )
       @ 15, 26 BUTTON "  &Del  "  OF oDlg ACTION DbfDel( oLbx, oDbf )
       @ 15, 36 BUTTON "  &Seek  " OF oDlg ACTION DbfSeek( oLbx, oDbf )
       @ 15, 47 BUTTON "  &Move  " OF oDlg ACTION DbfMove( oLbx, oDlg )
       @ 15, 58 BUTTON "  E&xit  " OF oDlg ACTION oDlg:Close()

   endif

   ACTIVATE DIALOG oDlg WHEN ( oLbx:Reset(), .t. )

   CLOSE DATABASE oDbf

return nil

//----------------------------------------------------------------------------//
static function LbxFld()

   local oLbx, oDlg, oDbf, nSeg

   DEFINE DIALOG oDlg FROM 3, 10 TO 20, 66 TITLE "Uso de ListBox Field con Scope"

   SET MESSAGE OF oDlg TO "Control de base de datos"

   DEFINE DIALOG oDlg FROM 4, 4 TO 22, 75 ;
      TITLE "Control de Clientes"

   SET MESSAGE OF oDlg TO "Control de Clientes"

   USE DATABASE oDbf FILE "Dialog" ;
       INDEX "Dialog01.ntx"

   @  1, 2 LISTBOX oLbx FIELDS oDbf:Name,;
                               oDbf:Fivedos,;
                               oDbf:Dialog,;
                               oDbf:Objects,;
                               oDbf:Level ;
      HEADERS "Nombre", "FivePro", "Dialog", "Objects", "Nivel" ;
      ALIAS oDbf ;
      ON DBLCLICK DbfEdit( oLbx, oDbf ) ;
      SIZE 67, 12 ;
      OF oDlg

   @ 15,  3 BUTTON " &New "  OF oDlg ACTION DbfEdit( oLbx, oDbf, .t. )
   @ 15, 10 BUTTON " &Del "  OF oDlg ACTION DbfDel( oLbx, oDbf )
   @ 15, 17 BUTTON " &NumKey "  OF oDlg ;
            ACTION Alert( 'Num. Key = ' + allTrim( Str( oDbf:KeyNum() ) ) )
   @ 15, 27 BUTTON " &KeyGoto "  OF oDlg ACTION GoToKeyNum( oLbx, oDbf )
   @ 15, 38 BUTTON " &KeyCount "  OF oDlg ;
            ACTION Alert( 'Claves = ' + allTrim( Str( oDbf:KeyCount() ) ) )
   @ 15, 50 BUTTON " &Records " OF oDlg ;
            ACTION Alert( 'Registros = ' + allTrim( Str( oDbf:RecCount() ) ) )
   @ 15, 61 BUTTON " E&xit " OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

   CLOSE DATABASE oDbf

return nil

//----------------------------------------------------------------------------//

static function LbxFldScp()

   local oLbx, oDlg, oDbf, nSeg

   DEFINE DIALOG oDlg FROM 3, 10 TO 20, 66 TITLE "Uso de ListBox Field con Scope"

   SET MESSAGE OF oDlg TO "Control de base de datos"

   DEFINE DIALOG oDlg FROM 4, 4 TO 22, 75 ;
      TITLE "Control de Clientes"

   SET MESSAGE OF oDlg TO "Control de Clientes"

   USE DATABASE oDbf FILE "Dialog" ;
       INDEX "Dialog01.ntx"

   @  1, 2 LISTBOX oLbx FIELDS oDbf:Name,;
                               oDbf:Fivedos,;
                               oDbf:Dialog,;
                               oDbf:Objects,;
                               oDbf:Level ;
      HEADERS "Nombre", "FivePro", "Dialog", "Objects", "Nivel" ;
      FOR "GARCIA" TO "HERNANDEZ" ;
      ON DBLCLICK DbfEdit( oLbx, oDbf ) ;
      ALIAS oDbf ;
      SIZE 67, 12 ;
      OF oDlg

   @ 15,  3 BUTTON " &New "  OF oDlg ACTION DbfEdit( oLbx, oDbf, .t. )
   @ 15, 10 BUTTON " &Del "  OF oDlg ACTION DbfDel( oLbx, oDbf )
   @ 15, 17 BUTTON " &NumKey "  OF oDlg ;
            ACTION Alert( 'Num. Key = ' + allTrim( Str( oDbf:KeyNum() ) ) )
   @ 15, 27 BUTTON " &KeyGoto "  OF oDlg ACTION GoToKeyNum( oLbx, oDbf )
   @ 15, 38 BUTTON " &KeyCount "  OF oDlg ;
            ACTION Alert( 'Claves = ' + allTrim( Str( oDbf:KeyCount() ) ) )
   @ 15, 50 BUTTON " &Records " OF oDlg ;
            ACTION Alert( 'Registros = ' + allTrim( Str( oDbf:RecCount() ) ) )
   @ 15, 61 BUTTON " E&xit " OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

   CLOSE DATABASE oDbf

return nil

//----------------------------------------------------------------------------//

static function LbxBrwArr()

   static oDlg, oLbx

   local oBrw

   SetMCursor( IDC_CLOCK )

   if oDlg == nil

       /* Este ejemplo tambien funciona.
          BEGIN BROWSE oBrw COLOR "W+/W, W+/N" ALIAS aMonth ;
             AUTOCOLUMNS
          ENDBROWSE
       */

       BEGIN BROWSE oBrw COLOR "W+/W, W+/N" ALIAS aMonth
        * COLUMN TITLE "Meses" SHOW aMonth[ oBrw:Cargo ] WIDTH 12
          COLUMN TITLE "Meses" SHOWBLOCK bFieldArr( oBrw, aMonth ) WIDTH 12
       ENDBROWSE

       DEFINE DIALOG oDlg       ;
          FROM 4, 4 TO 21, 58   ;
          TITLE "Uso de ListBox Browse con Array Monodimensional"

       @  1, 14 LISTBOX oLbx BROWSE oBrw ;
          LABEL "Meses del A¤o"    ;
          SIZE 20, 10              ;
          ON DBLCLICK EditArr( oLbx, aMonth ) ;
          LOGICLEN len( aMonth )    ;
          COLOR "n/bg, w+/bg"      ;        // Label Colors
          OF oDlg

       @ 14,  4 BUTTON " &New "   OF oDlg ACTION EditArr( oLbx, aMonth, .t. )
       @ 14, 14 BUTTON " &Edit "  OF oDlg ACTION EditArr( oLbx, aMonth )
       @ 14, 24 BUTTON " &Seek "  OF oDlg ACTION SeekArr( oLbx, aMonth )
       @ 14, 34 BUTTON " E&xit "  OF oDlg ACTION oDlg:End()
       @  6, 40 BUTTON " &N.Reg " OF oDlg ACTION ;
                Alert( 'N. Reg. = ' + allTrim( Str( oLbx:tBrowse:Cargo ) ) )
       @  8, 39 BUTTON " &Records " OF oDlg ACTION ;
                Alert( 'Registro = ' + allTrim( Str( len( aMonth ) ) ) )

   endif

   ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//

static function LbxBrwMArr()

   local oBrw, oDlg, oLbx
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

   @  1, 2 LISTBOX oLbx BROWSE oBrw ;
      LABEL "Traductor" ;
      SIZE 51, 12 ;
      LOGICLEN len( aList[1] ) ;
      ON DBLCLICK EditMArr( oLbx, aList ) ;
      COLOR "n/bg, w+/bg" ;
      OF oDlg

   @ 14,  3 BUTTON " &New "   OF oDlg ACTION EditMArr( oLbx, aList, .t. )
   @ 14, 10 BUTTON " &Edit "  OF oDlg ACTION EditMArr( oLbx, aList )
   @ 14, 18 BUTTON " &Seek "  OF oDlg ACTION SeekMArr( oLbx, aList )
   @ 14, 26 BUTTON " &N.Reg " OF oDlg ACTION ;
                   Alert( 'N. Reg. = ' + allTrim( Str( oLbx:tBrowse:Cargo ) ) )
   @ 14, 35 BUTTON " &Records " OF oDlg ACTION ;
                   Alert( 'Registro = ' + allTrim( Str( len( aList[1] ) ) ) )
   @ 14, 46 BUTTON " E&xit "  OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//

static function LbxFldArr()

   local oLbx, oDlg

   DEFINE DIALOG oDlg FROM 3, 10 TO 20, 66 ;
      TITLE "Meses del A¤o."

   SET MESSAGE OF oDlg TO "ListBox Fields Mono-Array"


// Esta funciona tambi‚n.
   @  1, 2 LISTBOX oLbx FIELDS aMonth  ;
      LABEL "Meses del A¤o"            ;
      SIZE 37, 12                      ;
      HEADERS "Meses"                  ;
      ON DBLCLICK EditArr( oLbx, aMonth ) ;
      LOGICLEN len( aMonth )            ;
      OF oDlg

   @ 14,  3 BUTTON " &New "   OF oDlg ACTION EditArr( oLbx, aMonth, .t. )
   @ 14, 10 BUTTON " &Edit "  OF oDlg ACTION EditArr( oLbx, aMonth )
   @ 14, 17 BUTTON " &Seek "  OF oDlg ACTION SeekArr( oLbx, aMonth )
   @ 14, 25 BUTTON " N. &Reg " OF oDlg ACTION ;
                   Alert( 'N. Reg. = ' + allTrim( Str( oLbx:tBrowse:Cargo ) ) )
   @ 14, 35 BUTTON " &Records " OF oDlg ACTION ;
                   Alert( 'Registro = ' + allTrim( Str( len( aMonth ) ) ) )
   @ 14, 46 BUTTON " E&xit "  OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//

static function LbxFldMArr()

   local oLbx, oDlg
   local aEsp := { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",;
                   "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre",;
                   "Diciembre" }
   local aIng := { "January", "February", "March", "April", "May", "June",;
                   "July", "August", "September", "Octuber", "November",;
                   "December" }
   local aVal := { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 }
   local aList := { aEsp, aIng, aVal }

   DEFINE DIALOG oDlg FROM 3, 10 TO 20, 66 ;
      TITLE "Meses del A¤o."

   SET MESSAGE OF oDlg TO "ListBox Fields Multi-Array"

/*
// Esta funciona tambi‚n.
   @  1, 3 LISTBOX oLbx FIELDS aList ;
      LABEL "Traductor"               ;
      SIZE 47, 12                     ;
      HEADERS "Espa¤ol", "English", "Valor" ;
      LOGICLEN len( aList[1] )        ;
      OF oDlg
*/

// Esta funciona tambi‚n.
   @  1, 3 LISTBOX oLbx FIELDS aEsp, aIng, aVal  ;
      LABEL "Traductor"              ;
      SIZE 47, 12 ;
      ON DBLCLICK EditMArr( oLbx, aList ) ;
      HEADERS "Espa¤ol", "English", "Valor" ;
      LOGICLEN len( aList[1] )        ;
      OF oDlg

   @ 14,  3 BUTTON " &New "   OF oDlg ACTION EditMArr( oLbx, aList, .t. )
   @ 14, 10 BUTTON " &Edit "  OF oDlg ACTION EditMArr( oLbx, aList )
   @ 14, 17 BUTTON " &Seek "  OF oDlg ACTION SeekMArr( oLbx, aList )
   @ 14, 25 BUTTON " &N. Reg " OF oDlg ACTION ;
     Alert( 'N. Reg. = ' + allTrim( Str( oLbx:tBrowse:Cargo ) ) )
   @ 14, 35 BUTTON " &Records " OF oDlg ACTION ;
     Alert( 'Registro = ' + allTrim( Str( len( aList[1] ) ) ) )
   @ 14, 45 BUTTON " E&xit "  OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//

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

function EditMArr( oLbx, aList, lNew )

   local oDlg, n
   local cEsp, cIng, nMes

   if !Empty( lNew )
      aAdd( aList[1], space( 12 ) )
      aAdd( aList[2], space( 12 ) )
      aAdd( aList[3], space( 12 ) )
      oLbx:GoEnd()
   end

   n    = oLbx:tBrowse:Cargo

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

   local oDlg, n := oLbx:tBrowse:Cargo

   local cEsp := Pad( aList[ 1, n ], 12 )

   DEFINE DIALOG oDlg FROM 6, 12 TO 19, 70 TITLE "Seek Multi Array"

   @  2,  2 SAY "Espa¤ol:" OF oDlg
   @  2, 12 GET cEsp       OF oDlg

   @ 10, 15 BUTTON " &Aceptar "  OF oDlg ;
            ACTION ( n:= aScan( aList[1], {|e| Upper( Trim( cEsp ) ) == Upper( Trim( e ) ) } ),;
                     oLbx:tBrowse:Cargo := n,;
                     oLbx:Reset(), oDlg:End() )
   @ 10, 28 BUTTON " &Cancelar " OF oDlg ACTION oDlg:End()

   ACTIVATE WINDOW oDlg

return nil

//---------------------------------------------------------------------------//

function SeekArr( oLbx, aList )

   local oDlg, n := oLbx:tBrowse:cargo

   local cName := Pad( aList[ n ], 12 )

   DEFINE DIALOG oDlg FROM 6, 12 TO 19, 70 TITLE "Seek Array"

   @  2,  2 SAY "Nombre:" OF oDlg
   @  2, 12 GET cName     OF oDlg

   @ 10, 15 BUTTON " &Aceptar "  OF oDlg ;
            ACTION ( n:= aScan( aList, {|e| Upper( Trim( cName ) ) == Upper( Trim ( e ) ) } ),;
                     oLbx:tBrowse:cargo := n,;
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

   n     = oLbx:tBrowse:Cargo
   cName = Pad( aList[ n ], 12 )

   DEFINE DIALOG oDlg FROM 6, 22 TO 14, 54 TITLE "Edit Array"

   @  2,  4 SAY "Nombre:" OF oDlg
   @  2, 14 GET cName     OF oDlg

   @  5,  4 BUTTON " &Aceptar "  OF oDlg ;
            ACTION ( aList[ n ] := Trim( cName ), oLbx:Refresh(), oDlg:End() )
   @  5, 15 BUTTON " &Cancelar " OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

return nil

//---------------------------------------------------------------------------//

static function GoToKeyNum( oLbx, oDbf )

    local oDlg, nKey:= 999

    DEFINE DIALOG oDlg ;
           AT 10, 20 SIZE 36, 6 ;
           TITLE "Saltar a la Clave Numero..." // OF oDlg

    @ 2,  2 SAY "Clave:" OF oDlg
    @ 2, 10 GET nKey     OF oDlg


    @ 2, 18 BUTTON " &Go "  ACTION ( oDbf:KeyGoto( nKey ),;
                                     oLbx:Refresh() )    OF oDlg

    @ 2, 26 BUTTON " &Ok "  ACTION ( oDbf:KeyGoto( nKey ),;
                                     oLbx:Refresh(),;
                                     oDlg:Close() )      OF oDlg

    ACTIVATE DIALOG oDlg     // NOWAIT

return nil

//---------------------------------------------------------------------------//

static function LbxBrwTree()

   local oWnd, oLbx, oTree, oItem

   TREE oTree BITMAPS "Open.bmp", "Open2.bmp"

      TREEITEM oItem PROMPT "First" BITMAP "Open.bmp", "Open2.bmp"
      TREE
         TREEITEM "One"
         TREE
            TREEITEM "One"
            TREEITEM "Two"
            TREEITEM "Three"
         ENDTREE
         TREEITEM "Two"
         TREEITEM "Three"
      ENDTREE

      TREEITEM "Second"
      TREE
         TREEITEM "One"
         TREEITEM "Two"
         TREEITEM "Three"
      ENDTREE

      TREEITEM "Third"
      TREE
         TREEITEM "One"
         TREEITEM "Two"
         TREEITEM "Three"
      ENDTREE
      TREEITEM "pr1"
      TREEITEM "pr1"
      TREEITEM "pr1"
      TREEITEM "Final"
   ENDTREE

   DEFINE WINDOW oWnd FROM 5, 5 to 20, 54 TITLE 'Tree working'

    @ 1, 4 LISTBOX oLbx TREE oTree ;
            OF oWnd ;
            SIZE 40, 10 ;
            PROMPT '&A Menu Design System ??'


    @ 12, 18 BUTTON '  &Exit  ' OF oWnd ;
        ACTION oWnd:End()

    ACTIVATE WINDOW oWnd CENTERED

return nil

