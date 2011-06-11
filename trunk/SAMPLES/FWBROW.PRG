//----------------------------------------------------------------------------//
//  FiveDos 1.0 - Ejemplos
//  (c) A.Linares, F.Pulp¢n 1993 -1994
//
//  Construir con BUILD FdBrow
//  To build: BUILD FDBrow
//----------------------------------------------------------------------------//

// Una t¡pica aplicaci¢n de gesti¢n
// Typical bussiness application

// A partir del ejemplo FwBrow.prg de FiveWin
// From FiveWin sample FwBrow.prg

#include "FiveDos.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   local oBrush, oBar, oBmp

   // Windows API : Not supported
   // local cOldBmp := GetProfString( "Desktop", "WallPaper" )
   // SetDeskWallPaper( "..\bitmaps\fivewin.bmp" )

   // Preprocesor skip it
   DEFINE BRUSH oBrush STYLE TILED       // FiveWin new predefined Brushes

   DEFINE WINDOW oWnd FROM 1, 4 TO 23, 75 ;
      TITLE F2VERSION + " - Browsing power" ;
      MENU BuildMenu() ;
      BRUSH oBrush

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON FILENAME "..\bitmaps\Projects.bmp" OF oBar ;
      ACTION OpenDbf() MESSAGE "Browse any DBF..."

   DEFINE BUTTON FILENAME "..\bitmaps\Exit.bmp" OF oBar ;
      ACTION If( MsgYesNo( "Do you want to End ?", "Please, Select" ), oWnd:End(), ) ;
      MESSAGE "End this session"

   DEFINE BUTTON FILENAME "..\bitmaps\Load.bmp" OF oBar GROUP ;
      MESSAGE "Using a Browse with dynamic Bitmap selection" ;
      ACTION Clients()

   DEFINE BUTTON FILENAME "..\bitmaps\Info.bmp" OF oBar ;
        ACTION MsgInfo( "(C) FiveDos Team 1994" + CRLF + CRLF + ;
                                    "Antonio Linares"       + CRLF + ;
                                    "Francisco Pulp¢n"      + CRLF + ;
                                    "Cayetano G¢mez"    + CRLF + ;
                                    "J.Mariano Rodriguez", "FiveDos 1.0" )

   SET MESSAGE OF oWnd TO F2VERSION + FDCOPYRIGHT

   // Not supported yet...
/*
   @ 4, 16 BITMAP oBmp FILENAME "..\bitmaps\Tutanka1.bmp" ADJUST SIZE 280, 200 OF oWnd ;
                       ON CLICK ( oBmp:lStretch := ! oBmp:lStretch, oBmp:Refresh( .t. ) )
*/
   ACTIVATE WINDOW oWnd

// Windows API : Not supported
//   SetDeskWallPaper( cOldBmp )              // We restore old WallPaper...

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu
   
   MENU oMenu
      
      MENUITEM OemToAnsi( "&Information" )
      MENU
         MENUITEM "&About..." ;
            ACTION MsgInfo( "(C) A.Linares, F.Pulp¢n 1993", "FiveWin 1.2" ) ;
            MESSAGE OemToAnsi( "Some information about this demo" )
         SEPARATOR
         MENUITEM "&Exit demo..." ACTION ;
            If( MsgYesNo( "Do you want to end ?", "Please, Select" ), oWnd:End,) ;
            MESSAGE "End the execution of this demo"
      ENDMENU
      
      MENUITEM "&Clients Control" ACTION Clients()
      
      MENUITEM "&Utilities"
      MENU
         MENUITEM "&Calculator..." ACTION WinExec( "Calc" ) ;
            MESSAGE "Calling Windows Calculator"

         MENUITEM "C&alendar..."  ACTION WinExec( "Calendar" ) ;
            MESSAGE "Calling Windows Calendar"

         SEPARATOR

         MENUITEM "&Writing..."    ACTION WinExec( "Write" ) ;
            MESSAGE "Calling Windows Write"
      ENDMENU

   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function Clients()
   local oWK
   local oDlg
   local oLbx
   local aHBitMaps:= { ReadBitmap( "..\bitmaps\level1.bmp" ), ;
                       ReadBitmap( "..\bitmaps\level2.bmp" ), ;
                       ReadBitmap( "..\bitmaps\level3.bmp" ), ;
                       ReadBitmap( "..\bitmaps\level4.bmp" ), ;
                       ReadBitmap( "..\bitmaps\level5.bmp" )  ;
                     }

   if ! File( "clientes.dbf" )
      DbCreate( "Clientes.dbf", { { "Nombre",    "C", 40, 0 },;
                                  { "Direccion", "C", 50, 0 },;
                                  { "Telefono",  "C", 12, 0 },;
                                  { "Edad",      "N",  2, 0 },;
                                  { "Productos", "C", 10, 0 },;
                                  { "Nivel",     "N",  2, 0 } } )
   endif


   // USE CLIENTES ALIAS Clients shared
   // select 2
   USE Clientes // shared
   if RecCount() == 0
      APPEND BLANK
   endif
   INDEX ON Clientes->Nombre TO CliName
   SET INDEX TO CliName
   GO TOP

   oWK := TWorkArea():New( Select() )

   oWK:SetBuffer( .F. )

   // You must change All pixel sizes to TextScreen sizes in Dialog
   // and controls clausules.


   DEFINE DIALOG oDlg FROM 3, 3 TO 22, 76 TITLE "Clients Management"

   @ 1, 1 LISTBOX oLbx FIELDS aHBitmaps[ Max( 1, min( 5, oWK:Nivel ) ) ],;
                              oWK:Nombre,;
                              oWK:Direccion,;
                              oWK:Telefono, ;
                              Str( oWK:Edad, 3 ) ;
          PROMPT " &Clients List"   ;
          HEADERS    "L", "Name", "Address", "Phone", "Age" ;
          SIZE 70, 14 OF oDlg ;
          LOGICLEN oWK:RecCount()

   oLbx:skipBlock := { |n| oWK:Skipper( n ) }
   oLbx:Reset()

   @ 16,  4 BUTTON "&New"    OF oDlg SIZE 8, 1 ACTION EditClient( oLbx, .t., oWK )
   @ 16, 15 BUTTON "&Modify" OF oDlg SIZE 8, 1 ACTION EditClient( oLbx, .f., oWK )
   @ 16, 26 BUTTON "&Delete" OF oDlg SIZE 8, 1 ACTION DelClient( oLbx, oWK )
   @ 16, 37 BUTTON "&Search" OF oDlg SIZE 8, 1 // ACTION SeekClient( oLbx )
   @ 16, 48 BUTTON "&Print"  OF oDlg SIZE 8, 1 // ACTION Listar( oLbx )
   @ 16, 59 BUTTON "&Exit"   OF oDlg SIZE 8, 1 ACTION oDlg:End()

   ACTIVATE DIALOG oDlg

   USE

   ReleaseChars( "..\bitmaps\open.bmp" )
   ReleaseChars( "..\bitmaps\info.bmp" )
   ReleaseChars( "..\bitmaps\floppy_a.bmp" )
   ReleaseChars( "..\bitmaps\exit.bmp" )

   
return nil

//----------------------------------------------------------------------------//

static function EditClient( oLbx, lAppend, oWK )

   local oDlg
   local lFivePro
   local lDialog
   local lObjects
   local lSave := .f.
   local nOldRec := RecNo()

   if lAppend == nil
        lAppend := .f.
   endif

   oWK:SetBuffer( .t. ) // Load Autom tico si no estaba

   if lAppend
      oWK:Blank()
   else
      oWK:Load()
   endif

   lFivePro  = "F" $ oWK:Productos
   lDialog   = "D" $ oWK:Productos
   lObjects  = "O" $ oWK:Productos
   oWK:Nivel = max( 1, oWK:Nivel )

   DEFINE DIALOG oDlg FROM 8, 2 TO 22, 55 ;
      TITLE If( lAppend, "Nuevo Cliente", "Modifique Cliente" )

   @ 1,  1 GET oWK:Nombre ;
         PROMPT "&Nombre:" ;
         OF oDlg


   @ 3,  1 GET oWK:Direccion ;
           PROMPT OemToAnsi( "&Direcci¢n:" ) ;
           OF oDlg


/* Under construction....

   @ 3,  1 TO 7, 8 LABEL "&Productos" OF oDlg
   @ 4,  1 CHECKBOX lFivePro PROMPT "&FivePro" OF oDlg
   @ 5,  1 CHECKBOX lDialog  PROMPT "&Dialog"  OF oDlg
   @ 6,  1 CHECKBOX lObjects PROMPT "&Objects" OF oDlg
*/

/*
   @ 3,  9 TO 7, 17 LABEL "&Nivel" OF oDlg
   @ 4,  9 RADIO oWK:Nivel PROMPT "&Inicial", "A&vanzado", "&Experto" OF oDlg
*/
   @ 5,  1 RADIO oWK:Nivel PROMPT "&Nivel" ;
           ITEMS "&Inicial", "A&vanzado", "&Experto" OF oDlg

   @ 6, 20 GET oWK:Telefono ;
           PROMPT OemToAnsi( "&Tel‚fono:" ) ;
           OF oDlg PICTURE "@R 99-999-9999999"

   @ 8, 20 GET oWK:Edad PICTURE "99" ;
           PROMPT OemToAnsi( "&Edad:" ) ;
           OF oDlg

   @ 11,  12 BUTTON " &Aceptar "  OF oDlg ACTION ( lSave := .t. , oDlg:End() )
   @ 11, 25  BUTTON " &Cancelar " OF oDlg ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

   /* oClone Test
        oDlg := oClone( oDlg )
        ACTIVATE DIALOG oDlg CENTERED
   */

   if lSave .and. !empty( oWK:Nombre )

      if !oWK:Lock()
         MessageBeep( 1 )
         return nil
      endif

      if lAppend
         oWK:Append()
      endif

      oWK:Productos := if( lFivePro, "F", "" ) + ;
                       if( lDialog,  "D", "" ) + ;
                       if( lObjects, "O", "" )

      oWK:Save()
      oWK:UnLock()

      oWK:SetBuffer( .f. )
      oLbx:Reset()          // We want the ListBox to be repainted

   else

      if empty( oWK:Nombre ) .and. lSave
         nMsgBox( "Debe entrar un Nombre para que el registro se valide" )
      endif

      oWK:SetBuffer( .f. )
      GOTO nOldRec

   endif

   

return nil

//---------------------------------------------------------------------------//

static function DelClient( oLbx, oWK )

   if MsgYesNo( OemToAnsi( "Atenci¢n:" ) + CRLF + ;
                OemToAnsi( "¨ Est  seguro de " + ;
                "querer borrar este registro ?" ) + CRLF + CRLF + ;
                OemToAnsi( oWK:Nombre ) )
      DELETE
      PACK

      oLbx:Reset()  // Repintamos el ListBox

   endif

return nil

//----------------------------------------------------------------------------//

static function SeekClient( oLbx )

   local cNombre := Space( 30 )
   local nRecNo  := RecNo()

   SET SOFTSEEK ON
   SET EXACT OFF
/**********
   if MsgGet( "Buscar por", "Nombre del Cliente", @cNombre,;
              "..\bitmaps\lupa.bmp" )
    */  /*
      if ! DbSeek( rtrim( cNombre ) )
         nMsgBox( "No encuentro ese Cliente", OemToAnsi( "Atenci¢n" ) )
         GO nRecNo
      else
         oLbx:UpStable()           // Corrects same page stabilizing Bug
         oLbx:Refresh()            // Repintamos el ListBox
      endif
    */ /*
      DbSeek( AllTrim( cNombre ) )
      if Eof()
         nMsgBox( "No encuentro ese Cliente, ni nada parecido", OemToAnsi( "Atenci¢n" ) )
         GO nRecNo
      else
         oLbx:Reset()            // Repintamos el ListBox
      endif

   endif
*****************/
return nil

//----------------------------------------------------------------------------//

function OpenDbf()

   local cFile := cGetFile( "*.dbf", "Select a DBF" )


   MsgInfo( "Your selection:;" + cFile )

return nil

//---------------------------------------------------------------------------//

