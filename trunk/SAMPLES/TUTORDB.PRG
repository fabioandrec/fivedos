//----------------------------------------------------------------------------//
//  FiveDos - Tutorial
//  (c) FiveDos Team 1994
//
//  Contruir con BUILD TutorDb
//----------------------------------------------------------------------------//

// Ejemplos de utilizaci¢n de DATABASE.

#include "FiveDos.ch"

static oWnd

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

    ACTIVATE WINDOW oWnd MAXIMIZED VALID lMsgEnd()

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

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
            MESSAGE "Informaci¢n acerca de este programa"
         SEPARATOR
         MENUITEM "&Terminar..."  ;
            ACTION oWnd:Close() ;
            MESSAGE "Terminar la ejecuci¢n de este programa"
      ENDMENU

      MENUITEM "&Databases"
      MENU
         MENUITEM   "&Use..." ;
            ACTION  DbfUse() ;
            MESSAGE "Uso de la Bases de Datos"

         MENUITEM   "&Scope..." ;
            ACTION  DbfScope() ;
            MESSAGE "Activar un Scope en la Base de Datos"

         MENUITEM   "&Scope2..." ;
            ACTION  DbfScope2() ;
            MESSAGE "Activar un Scope en la Base de Datos"

         MENUITEM   "&Relation..." ;
            ACTION  DbfRelation() ;
            MESSAGE "Relaci¢n entre dos Bases de Datos"
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

//---------------------------------------------------------------------------//

static function DbfUse()

   local oLbx, oDlg, oDbf, nSeg

   USE DATABASE oDbf FILE "Dialog"

   DEFINE DIALOG oDlg FROM 4, 4 TO 22, 75 TITLE "Uso de la base de datos"

   SET MESSAGE OF oDlg TO "Control de Clientes"

   @  1, 2 LISTBOX oLbx FIELDS (Dialog->Name),        ;
                               (Dialog->Fivedos),     ;
                               (Dialog->Dialog),      ;
                               (Dialog->Objects),     ;
                               (Dialog->Level)        ;
        HEADERS "Nombre", "FivePro", "Dialog", "Objects", "Nivel" ;
        ALIAS oDbf                                                ;
        ON DBLCLICK DbfEdit( oLbx, oDbf )                         ;
        OF oDlg

   @ 15,  2 BUTTON " &New " OF oDlg ACTION DbfEdit( oLbx, oDbf, .t. )
   @ 15,  9 BUTTON " &Del "  OF oDlg ACTION DbfDel( oLbx, oDbf )
   @ 15, 16 BUTTON " &NumKey "  OF oDlg ;
            ACTION Alert( 'Num. Key = ' + allTrim( Str( oDbf:KeyNum() ) ) )
   @ 15, 26 BUTTON " &KeyCount "  OF oDlg ;
            ACTION Alert( 'Claves = ' + allTrim( Str( oDbf:KeyCount() ) ) )
   @ 15, 38 BUTTON "  &Edit  " OF oDlg ACTION DbfEdit( oLbx, oDbf )
   @ 15, 48 BUTTON " &Records " OF oDlg ;
            ACTION Alert( 'Registros = ' + allTrim( Str( oDbf:RecCount() ) ) )
   @ 15, 59 BUTTON "  E&xit  " OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

   CLOSE DATABASE oDbf

return nil

//----------------------------------------------------------------------------//

static function DbfScope()

   local oLbx, oDlg, oDbf, nSeg

   DEFINE DIALOG oDlg FROM 4, 4 TO 22, 75 TITLE "Uso de la base de datos"

   SET MESSAGE OF oDlg TO "Control de Clientes con Scope en Listbox Fields"

   USE DATABASE oDbf FILE "Dialog" ;
       INDEX "Dialog01.ntx"
       
   SET SCOPE FOR "GARCIA" TO "HERNANDEZ" OF oDbf 
   
   @  1, 2 LISTBOX oLbx FIELDS oDbf:Name,;
                               oDbf:Fivedos,;
                               oDbf:Dialog,;
                               oDbf:Objects,;
                               oDbf:Level ;                          
      HEADERS "Nombre", "FivePro", "Dialog", "Objects", "Nivel" ;                    
      ALIAS oDbf ;
      ON DBLCLICK DbfEdit( oLbx, oDbf ) ;
      OF oDlg
//      SIZE 67, 12 ;

   @ 15,  2 BUTTON " &New " OF oDlg ACTION DbfEdit( oLbx, oDbf, .t. )
   @ 15,  9 BUTTON " &Del "  OF oDlg ACTION DbfDel( oLbx, oDbf )
   @ 15, 16 BUTTON " &NumKey "  OF oDlg ;
            ACTION Alert( 'Num. Key = ' + allTrim( Str( oDbf:KeyNum() ) ) )
   @ 15, 26 BUTTON " &KeyGoto "  OF oDlg ACTION GoToKeyNum( oLbx, oDbf )
   @ 15, 37 BUTTON " &KeyCount "  OF oDlg ;
            ACTION Alert( 'Claves = ' + allTrim( Str( oDbf:KeyCount() ) ) )
   @ 15, 49 BUTTON " &Records " OF oDlg ;
            ACTION Alert( 'Registros = ' + allTrim( Str( oDbf:RecCount() ) ) )
   @ 15, 60 BUTTON " E&xit " OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

   CLOSE DATABASE oDbf

return nil

//----------------------------------------------------------------------------//

static function DbfScope2

   static oDlg, oLbx
   
   local oDbf, oBrw

   SetMCursor( IDC_CLOCK )

   USE DATABASE oDbf FILE "Dialog"  ;
       INDEX "Dialog01.ntx"

   SET SCOPE OF oDbf FOR "GARCIA" TO "HERNANDEZ" ;

   if oDlg == nil

       BEGIN BROWSE oBrw ALIAS oDbf COLOR "W+/W, W+/N"             // Browse Colors
          COLUMN TITLE "Nombre"  SHOW oDbf:Name
          COLUMN TITLE "FiveDos" SHOW oDbf:FiveDos
          COLUMN TITLE "Dialog"  SHOW oDbf:Dialog
          COLUMN TITLE "Object"  SHOW oDbf:Objects
          COLUMN TITLE "Nivel"   SHOW oDbf:Level 
       ENDBROWSE

       DEFINE DIALOG oDlg       ;
          FROM 4, 4 TO 22, 75   ;
          TITLE "Dialog Users"

       SET MESSAGE OF oDlg TO "Control de Clientes con Scope en ListBox Browse."
       
       @  1,  2 LISTBOX oLbx BROWSE oBrw ;
          SIZE 67, 12                    ;
          ON DBLCLICK DbfEdit( oLbx, oDbf ) ;
          LOGICLEN oDbf:RecCount()       ;
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

//---------------------------------------------------------------------------//

static function DbfRelation()

   local oLbx, oDlg, oClientes, oNivel

   DEFINE DIALOG oDlg FROM 3, 10 TO 20, 66 TITLE "Relacci¢n de las base de datos"

   SET MESSAGE OF oDlg TO "Control de base de datos"

   USE DATABASE oClientes FILE "Clientes" ;
       INDEX "Client01.ntx"

   USE DATABASE oNivel FILE "Nivel"
      
   Select Clientes
   Set Relation to Clientes->Nivel Into Nivel

   DEFINE DIALOG oDlg FROM 3, 3 TO 20, 74 ;
      TITLE "Control de Clientes"

   SET MESSAGE OF oDlg TO "Control de Clientes"

   @  1, 2 LISTBOX oLbx FIELDS Clientes->Nombre ,;
                                Clientes->Nivel,;
                                Nivel->Categoria ;
      SIZE 67, 12 ;
      HEADERS "Nombre", "Nivel", "Categoria" ;
      ALIAS oClientes ;
      OF oDlg

   @ 14,  2 BUTTON " &New "     OF oDlg
   @ 14, 10 BUTTON " &Edit "    OF oDlg // ACTION DbfEdit()
   @ 14, 18 BUTTON " &Seek "    OF oDlg // ACTION DbfSeek()
   @ 14, 26 BUTTON " &Records " OF oDlg ACTION ;
     Alert( 'Registro = ' + allTrim( Str( Clientes->( RecCount() ) ) ) )
   @ 14, 40 BUTTON " E&xit "  OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

   CLOSE DATABASE oClientes
   CLOSE DATABASE oNivel

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

static function BrowMove( oLbx, nCount )

    SetMCursor( IDC_CLOCK )

    if nCount > 0
       while nCount-- > 0
             oLbx:GoDown()
       end
    elseif nCount < 0
       while nCount++ < 0
             oLbx:GoUp()
       end
    endif

    SetMCursor( IDC_ARROW )

return nil

//---------------------------------------------------------------------------//

static function GoToKeyNum( oLbx, oDbf )

    local oDlg, nKey:= oDbf:KeyNum()

    DEFINE DIALOG oDlg ;
           AT 10, 20 SIZE 36, 6 ;
           TITLE "Saltar a la Clave Numero..." // OF oWnd

    @ 2, 2 GET nKey PROMPT "Clave : " PICTURE "999"   OF oDlg

    @ 2, 18 BUTTON " &Go "  ACTION ( oDbf:KeyGoto( nKey ),;
                                     oLbx:Refresh() )    OF oDlg

    @ 2, 26 BUTTON " &Ok "  ACTION ( oDbf:KeyGoto( nKey ),;
                                     oLbx:Refresh(),;
                                     oDlg:Close() )      OF oDlg

    ACTIVATE DIALOG oDlg     // NOWAIT

return nil

//----------------------------------------------------------------------------//

