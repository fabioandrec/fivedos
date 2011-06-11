#define BOXX "********."

#include "fivedos.ch"
#include "SysStr.ch"
#include "FontDef.h"

//external _dbginit1
function main()

    local a    := Memory( 0 )
    local oWnd1
    local oWnd2
    local oWnd3
    local oWnd
    local cBack := SaveScreen( 0, 0, MaxRow(), MaxCol() )
    local oGet, cVar := "A get object in the Limb.....oooooo........oooooooo"
    local oMeter
    local cVar2 := Date()
    local oBar 
    local nListBox := 1
    local cCombo :='pruebas    '
    local aMonth, aDay, acNumber:= array( 4096 )
    local lEnero, lFebrero, lMarzo, lAbril, lMayo, lJunio, lJulio,;
          lAgosto, lSeptiembre, lOctubre, lNoviembre, lDiciembre
    local n, nCtrl
    local oBtn1, oBtn2

    Store .f. to lEnero, lFebrero, lMarzo, lAbril, lMayo, lJunio, lJulio,;
          lAgosto, lSeptiembre, lOctubre, lNoviembre, lDiciembre
    //altd()
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

    for n = 1 to len( acNumber )
        acNumber[ n ] = padr( ltrim( Str( n ) ), 40 )
    next

    DEFINE WINDOW oWnd1 FROM 1, 1 TO 24, 79 VSCROLL HSCROLL SIZE 200, 100 ;
		     TITLE "Our First Window" ;
		     MENU BuildMenu()

    DEFINE BUTTONBAR oBar OF oWnd1

    DEFINE MESSAGE BAR OF oWnd1 ;
	   PROMPT F2VERSION + FDCOPYRIGHT

    DEFINE BUTTON FILE "..\bitmaps\exit.bmp", "..\bitmaps\exit2.bmp";
            PROMPT 'Salir' OF oBar ;
            ACTION oWnd1:Close() ;
            TIPS "Abandonar"

    DEFINE BUTTON FILE "..\bitmaps\info.bmp", "..\bitmaps\info2.bmp";
                    GROUP OF oBar ;
                    ACTION MsgInfo( "(C) FiveDos Team 1994" + CRLF + CRLF + ;
                                    "Antonio Linares"       + CRLF + ;
                                    "Francisco Pulp¢n"      + CRLF + ;
                                    "Cayetano G¢mez"        + CRLF + ;
                                    "J. Mariano Rodr¡guez", "FiveDos 1.0" );
                    Tips 'CopyRight' COLORTIP 'N/RB*'

    DEFINE BUTTON FILE "..\bitmaps\floppy_a.bmp", "..\bitmaps\floppy_2.bmp";
            OF oBar ACTION MsgStop( 'Puls¢ Floppy "A"' ) ;
            tips 'Floppy' colortip 'R+/N'

    DEFINE BUTTON FILE "..\bitmaps\open.bmp", "..\bitmaps\open2.bmp";
            PROMPT 'Open' ;
            OF oBar MESSAGE "View sources. P.e.: 'wdemo.prg'" ;
            ACTION TextBrowse( "\*.prg" ) ;
            tips 'View Source' ColorTip 'N/BG*'

    DEFINE BUTTON FILE "..\bitmaps\clock.bmp", "..\bitmaps\clock2.bmp";
            OF oBar ACTION MsgInfo( "Son las:;" + Time() + " Horas")

    DEFINE BUTTON PROMPT "Up" GROUP OF oBar ;
            WHILE PRESSED oWnd1:GoDown()

    DEFINE BUTTON PROMPT "Down" OF oBar ;
            WHILE PRESSED oWnd1:GoUp()

    DEFINE BUTTON PROMPT "Left" OF oBar ;
            WHILE PRESSED oWnd1:GoRight()

    DEFINE BUTTON PROMPT "Right" OF oBar ;
            WHILE PRESSED oWnd1:GoLeft()

    DEFINE BUTTON PROMPT "PgUp" OF oBar ;
            WHILE PRESSED oWnd1:GoPgDown()

    DEFINE BUTTON PROMPT "PgDn" OF oBar ;
            WHILE PRESSED oWnd1:GoPgUp()

    DEFINE BUTTON PROMPT "PgLeft" OF oBar ;
            WHILE PRESSED oWnd1:GoPgRight()

    DEFINE BUTTON PROMPT "PgRight" OF oBar ;
            WHILE PRESSED oWnd1:GoPgLeft()

    DEFINE BUTTON PROMPT "Home" OF oBar ;
            WHILE PRESSED oWnd1:GoEnd()

    DEFINE BUTTON PROMPT "End" OF oBar ;
            WHILE PRESSED oWnd1:GoHome()

    DEFINE BUTTON PROMPT "PlayWav" GROUP OF oBar ;
            ACTION PlayWav()

    DEFINE BUTTON PROMPT "Spin" GROUP OF oBar ;
            ACTION testspin()

    @ 1, 50 BUTTON oBtn1 Prompt "Hojear;el;&Fichero" ;
		   SIZE 16, 3               ;
		   ACTION RunAModal()       ;
		   MESSAGE "Hojear una base de Datos" ;
           FILE "..\bitmaps\floppy_a.bmp"      ;
		   OF oWnd1

    oBtn1:bRight:={||rindex()}

    DEFINE DIALOG oWnd2 AT 6, 30 SIZE 70, 16    ;
		     TITLE "Our First Dialog"   ;
		     OF oWnd1

    DEFINE MESSAGE BAR OF oWnd2 ;
       PROMPT F2VERSION + " The Right choice !"

    TRadio():New( 1, 2, "&Radio Button","Esto es un Radio Button",,oWnd2;
         ,,,'..\bitmaps\vaso1.bmp','..\bitmaps\vaso.bmp' )
//		  "N/BG, W+/BG, BG+/BG, N+/BG", oWnd2 )

    @ 1, 2 METER oMeter VAR nListBox ;
           TOTAL len( acNumber ) ;
           PROMPT "Testing &Meter" ;
           SIZE 19               ;
           OF oWnd1

    @ 3, 10 LISTBOX nListBox LABEL "N£meros" ARRAY acNumber MULTISELECT ;
		    SIZE 8, 15 ;
            ON CHANGE oMeter:Refresh() ;
            OF oWnd1



    @ 8, 60 RADIO nCtrl PROMPT "Con&troles" OF oWnd1 ;
                 ITEMS "&ComboBox", "&Get", "&ListBox", "Scroll&Bar",;
                       "C&heckBox", "&PushButton", "&Say", "&Radio", "L&abel"

    @ 3, 30 CHECKMENU lEnero, lFebrero, lMarzo, lAbril, lMayo, lJunio, lJulio,;
                      lAgosto, lSeptiembre, lOctubre, lNoviembre, lDiciembre ;
            ARRAY aMonth OF oWnd1 ;
            LABEL "&Meses" ;
            MESSAGE "Meses del A¤o" ;
            FILE 'BOTLE2.BMP','BOTLE.BMP'

    @ 2, 2 SAY "Esto es un TSay" ;
           COLOR "n/bg"          ;
           OF oWnd2

    @ 1, 30 BUTTON oBtn2 Prompt "Hojear;el;&Fichero" ;
		   SIZE 16, 3               ;
		   ACTION RunAModal()       ;
           MESSAGE "Hojear una base de Datos" ;
                   FILE "..\bitmaps\floppy_a.bmp", "..\bitmaps\floppy_2.bmp"      ;
		   OF oWnd2

    oBtn2:bRight:={||rIndex()}

    @ 1, 50 BUTTON "&V;e;r;t;i;c;a;l" ;
            SIZE 3, 10 ;
            MESSAGE "Puede hacer botones de cualquier tama¤o y forma" ;
            OF oWnd2

    @ 6, 2 GET oGet VAR cVar  PROMPT "&Este Get" MESSAGE "Esto Es un Get" ;
                        PICTURE "@S30"  FILE "..\bitmaps\open.bmp", ;
                                             "..\bitmaps\open2.bmp" ;
                        OF oWnd2

    @ 8, 2 GET oGet VAR cVar2  PROMPT "&Fecha:   " ;
                        MESSAGE "Teclee una fecha cualquiera..." ;
                        PICTURE "@D" ;
                        OF oWnd2
    DEFINE WINDOW oWnd3 FROM 10, 12 TO 20, 66    ;
		     MENU BuildMenu2()          ;
             TITLE "ListBox & ComboBox" ;
             COLOR "N/ G, N/W*, W+/G, N/G*, G+/G" ;
             OF oWnd1

    @ 2, 2 LISTBOX nListBox ARRAY aMonth MULTISELECT ;
		    SIZE 15, 5 ;
            PROMPT "&Month Day" ;
		    ON CHANGE Tock()     ;
		    ON DBLCLICK  Tone(1000,1) ;
            VALID MsgYesNo( "1-VALID" ) ;
            WHEN  MsgYesNo( "1-WHEN" ) ;
            OF oWnd3

    @ 2, 25 COMBOBOX cCombo ;
            LABEL "&Select Day" ARRAY aDay ;
		    SIZE 15, 5 ;
            VALID MsgYesNo( "2-VALID" ) ;
            WHEN  MsgYesNo( "2-WHEN" ) ;
		    OF oWnd3

    // Our Application BackGround
    SET COLOR TO "N/N*"
    CLS

    oWnd3:bSized = {|| MsgInfo( "­ Resized !" ) }

    oWnd1:Cargo = acNumber

    ACTIVATE WINDOW oWnd1 VALID lMsgEnd() ON PAINT Fondo( oWnd1 )  MAXIMIZED ;
        ON INIT GO( oWnd1  )

    RestScreen( 0, 0, MaxRow(), MaxCol(), cBack )

    PlayWav( "adios.wav" )
    
    cls

    Alert( "Array de Meses;;" + ;
            aMonth[1]  + " = " + cValToChar( lEnero ) + ";" + ;
            aMonth[2]  + " = " + cValToChar( lFebrero ) + ";" + ;
            aMonth[3]  + " = " + cValToChar( lMarzo ) + ";" + ;
            aMonth[4]  + " = " + cValToChar( lAbril ) + ";" + ;
            aMonth[5]  + " = " + cValToChar( lMayo ) + ";" + ;
            aMonth[6]  + " = " + cValToChar( lJunio ) + ";" + ;
            aMonth[7]  + " = " + cValToChar( lJulio ) + ";" + ;
            aMonth[8]  + " = " + cValToChar( lAgosto ) + ";" + ;
            aMonth[9]  + " = " + cValToChar( lSeptiembre ) + ";" + ;
            aMonth[10] + " = " + cValToChar( lOctubre ) + ";" + ;
            aMonth[11] + " = " + cValToChar( lNoviembre ) + ";" + ;
            aMonth[12] + " = " + cValToChar( lDiciembre ) )

return nil

//---------------------------------------------------------------------------//

static function BuildMenu()

    local oMenu, oItem

    MENU oMenu
	MENUITEM "Item &Uno"      MESSAGE "Mensaje de UNO"
	MENU
	    MENUITEM "Item &Uno"      MESSAGE "Mensaje de UNO-UNO" ;
                      ACTION Calc() // ALERT( "UNO-UNO" )
	    MENUITEM "Item &Dos"      MESSAGE "Mensaje de UNO-DOS" ;
				      ACTION ALERT( "UNO-DOS" )
	    SEPARATOR
	    MENUITEM "Item &Tres"     MESSAGE "Mensaje de UNO-TRES" ;
				      ACTION ALERT( "UNO-TRES" )
	ENDMENU
	MENUITEM "Item &Dos"      MESSAGE "Mensaje de DOS"
	MENU
	    MENUITEM "Item &Uno"      MESSAGE "Mensaje de DOS-UNO"
	    MENU
		MENUITEM "Item &Uno"      MESSAGE "Mensaje de DOS-UNO-UNO" ;
				      ACTION ALERT( "DOS-UNO-UNO" )
		MENUITEM "Item &Dos"      MESSAGE "Mensaje de DOS-UNO-DOS" ;
				      ACTION ALERT( "DOS-UNO-DOS" )
		SEPARATOR
		MENUITEM "Item &Tres"     MESSAGE "Mensaje de DOS-UNO-TRES" ;
				      ACTION ALERT( "DOS-UNO-TRES" )
	    ENDMENU
	    MENUITEM "Item &Dos"      MESSAGE "Mensaje de DOS-DOS" ;
				      ACTION ALERT( "DOS-DOS" )
	    MENUITEM "Item &Tres"     MESSAGE "Mensaje de DOS-TRES"
	    MENU
		MENUITEM "Item &Uno"      MESSAGE "Mensaje de DOS-TRES-UNO" ;
				      ACTION ALERT( "DOS-TRES-UNO" )
		MENUITEM "Item &Dos"      MESSAGE "Mensaje de DOS-TRES-DOS" ;
				      ACTION ALERT( "DOS-TRES-DOS" )
		SEPARATOR
		MENUITEM "Item &Tres"     MESSAGE "Mensaje de DOS-TRES-TRES"
		MENU
		    MENUITEM "Item &Uno"      MESSAGE "Mensaje de DOS-TRES-TRES-UNO" ;
				      ACTION ALERT( "DOS-TRES-TRES-UNO" )
		    MENUITEM "Item &Dos"      MESSAGE "Mensaje de DOS-TRES-TRES-DOS" ;
				      ACTION ALERT( "DOS-TRES-TRES-DOS" )
		    SEPARATOR
		    MENUITEM "Item &Tres"     MESSAGE "Mensaje de DOS-TRES-TRES-TRES" ;
                      ACTION ALERT( "DOS-TRES-TRES-TRES" )
		ENDMENU
	    ENDMENU
	ENDMENU
	MENUITEM "Item &Tres"     MESSAGE "Mensaje de TRES"
	MENU
	    MENUITEM oItem PROMPT "Item &Uno"      MESSAGE "Mensaje de TRES-UNO" ;
				      ACTION RunAModal()
	    MENUITEM "Item &Dos"      MESSAGE "Mensaje de TRES-DOS" ;
                      ACTION if( oItem:lActive, oItem:Disable(), oItem:Enable() )

        MENUITEM "Item &Tres"     MESSAGE "Mensaje de TRES-TRES" ;
                      ACTION ALERT( "­ Vale !", ;
                               { " &Dos ", " &Tres ", " T&res ", " Tr&es " } )
	ENDMENU
	MENUITEM "Item &Cuatro"   MESSAGE "Mensaje de CUATRO"
	MENU
	    MENUITEM "Item &Uno"      MESSAGE "Mensaje de CUATRO-UNO"
	    MENUITEM "Item &Dos"      MESSAGE "Mensaje de CUATRO-DOS"
	    MENUITEM "Item &Tres"     MESSAGE "Mensaje de CUATRO-TRES"
	ENDMENU
	MENUITEM "Item &Cinco"    MESSAGE "Mensaje de CINCO"
	MENU
	    MENUITEM "Item &Uno"      MESSAGE "Mensaje de CINCO-UNO"
	    MENUITEM "Item &Dos"      MESSAGE "Mensaje de CINCO-DOS"
	    MENUITEM "Item &Tres"     MESSAGE "Mensaje de CINCO-TRES"
	ENDMENU

    MENUITEM "Text &Viewer"    MESSAGE "View this source file...: wdemo.prg" ;
                  ACTION TextBrowse( "wdemo.prg" )
    ENDMENU

return oMenu

//---------------------------------------------------------------------------//

function BuildMenu2()

   local oMenu

   // MENU oMenu COLOR "n/w, w+/b, r/w, r+/b, n+/w, w+/w, n+/w"
   MENU oMenu COLOR "n/w, w+/N*, r/w, r+/N*, n+/w, w+/w, n+/w"
	MENUITEM "Item &Uno"      MESSAGE "Mensaje de UNO"
	MENU
	    MENUITEM "Item &Uno"      MESSAGE "Mensaje de UNO-UNO" ;
				      ACTION ALERT( "UNO-UNO" )
	    MENUITEM "Item &Dos"      MESSAGE "Mensaje de UNO-DOS" ;
				      ACTION ALERT( "UNO-DOS" )
	    MENUITEM "Item &Tres"     MESSAGE "Mensaje de UNO-TRES" ;
				      ACTION ALERT( "UNO-TRES" )
	ENDMENU
	MENUITEM "Item &Dos"      MESSAGE "Mensaje de DOS"
	MENU
	    MENUITEM "Item &Uno"      MESSAGE "Mensaje de DOS-UNO"
	    MENU
		MENUITEM "Item &Uno"      MESSAGE "Mensaje de DOS-UNO-UNO" ;
				      ACTION ALERT( "DOS-UNO-UNO" )
		MENUITEM "Item &Dos"      MESSAGE "Mensaje de DOS-UNO-DOS" ;
				      ACTION ALERT( "DOS-UNO-DOS" )
		MENUITEM "Item &Tres"     MESSAGE "Mensaje de DOS-UNO-TRES" ;
				      ACTION ALERT( "DOS-UNO-TRES" )
	    ENDMENU
	    MENUITEM "Item &Dos"      MESSAGE "Mensaje de DOS-DOS" ;
				      ACTION ALERT( "DOS-DOS" )
	    MENUITEM "Item &Tres"     MESSAGE "Mensaje de DOS-TRES"
	    MENU
		MENUITEM "Item &Uno"      MESSAGE "Mensaje de DOS-TRES-UNO" ;
				      ACTION ALERT( "DOS-TRES-UNO" )
		MENUITEM "Item &Dos"      MESSAGE "Mensaje de DOS-TRES-DOS" ;
				      ACTION ALERT( "DOS-TRES-DOS" )
		MENUITEM "Item &Tres"     MESSAGE "Mensaje de DOS-TRES-TRES"
		MENU
		    MENUITEM "Item &Uno"      MESSAGE "Mensaje de DOS-TRES-TRES-UNO" ;
				      ACTION ALERT( "DOS-TRES-TRES-UNO" )
		    MENUITEM "Item &Dos"      MESSAGE "Mensaje de DOS-TRES-TRES-DOS" ;
				      ACTION ALERT( "DOS-TRES-TRES-DOS" )
		    MENUITEM "Item &Tres"     MESSAGE "Mensaje de DOS-TRES-TRES-TRES" ;
				      ACTION ALERT( "DOS-TRES-TRES-TRES" )
		ENDMENU
	    ENDMENU
	ENDMENU
	MENUITEM "Item &Tres"     MESSAGE "Mensaje de TRES"
	MENU
	    MENUITEM "Item &Uno"      MESSAGE "Mensaje de TRES-UNO"
	    MENUITEM "Item &Dos"      MESSAGE "Mensaje de TRES-DOS"
	    MENUITEM "Item &Tres"     MESSAGE "Mensaje de TRES-TRES"
	ENDMENU
    ENDMENU

return oMenu

//---------------------------------------------------------------------------//

static function PlayWav( cFile )

    local nOldMouseCur

    if empty( cFile )
        cFile := cGetFile( "\windows\*.wav" )
    endif

    if file( cFile )

        if lIsCua()
            nOldMouseCur = SetMCursor( IDC_CLOCK )
        endif

        PlayPCWav( MemoRead( cFile ) )

        if nOldMouseCur != nil
            SetMCursor( nOldMouseCur )
        endif

    endif

return nil

//---------------------------------------------------------------------------//

function RunAModal(lMode)

    static oDlg, oLbx

    local oBrw, oDbf

    DEFAULT lMode := .f.

    SetMCursor( IDC_CLOCK )

   if !File( "Dialog01.ntx" )
      USE Dialog NEW
      INDEX ON Upper( Dialog->Name ) TO Dialog01.ntx FOR !Deleted()
      CLOSE
    endif

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

        DEFINE DIALOG oDlg          ;
            FROM 4, 4 TO 22, 75     ;
            COLOR "N/ RB, N/W*, W+/RB, N/RB*, RB+/RB" ;
            TITLE "Dialog Users"

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

    if lMode

        ACTIVATE DIALOG oDlg VALID oDbf:Close(),.t. NOWAIT

    else

        ACTIVATE DIALOG oDlg VALID MsgYesNo( "­ Hey Valid !" ) ;
                         WHEN  ( oLbx:Reset(), MsgYesNo( "­ Hey When  !" ) )

       CLOSE DATABASE oDbf
   endif
return if(lMode, { oDlg, oLbx }, nil )

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

function Fondo( oWnd )

    local   n, ;
            nHeight := oWnd:oClient:nHeight + 1,;
            nWidth  := 1 + oWnd:oClient:nWidth / 3

    local cStr := replicate( chr( LEFTRADIO ) + chr( CENTERRADIO1 ) + ;
                             chr( RIGHTRADIO ), nWidth )
    local cStr1:= replicate( chr( CENTERRADIO1 ) + chr( RIGHTRADIO ) + ;
                             chr( LEFTRADIO ),  nWidth )
    local cStr2:= replicate( chr( RIGHTRADIO ) + chr( LEFTRADIO ) + ;
                             chr( CENTERRADIO1 ), nWidth )

    oWnd:oClient:BeginPaint()

    for n = 0 to nHeight step 3
        oWnd:say( n  , 0,  cStr, 48 + 4 )
        oWnd:say( n+1, 0, cStr1, 48 + 4 )
        oWnd:say( n+2, 0, cStr2, 48 + 4 )
    next

    oWnd:oClient:EndPaint()

return nil

//---------------------------------------------------------------------------//

#include "FileIO.ch"

//---------------------------------------------------------------------------//

function TextBrowse( cFile )

    local oDlg, oLbx
    local oBrw, oFile

    DEFAULT cFile := "*.*"

    cFile := cGetFile( cFile )

    if !File( cFile )
        return nil
    endif

    SetMCursor( IDC_CLOCK )

    if ! File( cFile )
        Alert( "­ El fichero:;" + cFile + ";no existe !" )
        return nil
    endif

    oFile := TFile():New( cFile )

    if oFile:Open( FO_READ + FO_DENYWRITE ) == -1 // Solo lectura y Sin compartir escritura.
        Alert( "­ El fichero:;" + cFile + ";no se puede abrir !" + ;
               ";Error DOS N§: " + str( FERROR(), 3 ) )
        return nil
    endif

    DEFINE DIALOG oDlg          ;
        FROM 0, 0 TO 24, 79     ;
        NOMOVE                  ;
        TITLE "Text Browser: " + cFile

    BEGIN BROWSE oBrw COLOR "n/w, w+/b, w/b" ALIAS oFile      // Browse Colors
        COLUMN TITLE "Line:" + str( 1 ) ;
               SHOW oFile:ReadLn( TABSIZE ) ;
               WIDTH oDlg:nWidth - 6
    ENDBROWSE

    @  0, 0 LISTBOX oLbx BROWSE oBrw                ;
            SIZE oDlg:nWidth - 2, oDlg:nHeight - 2  ;
            LOGICLEN oFile:LastRec()                ;
            ON DBLCLICK MsgInfo( "Doble Click.;Viendo:;"+ cFile + ;
                                 ";Linea:" + str( oFile:Recno() ) + ;
                                 ";Texto: " + left( oFile:ReadLn( TABSIZE ), 30 ) ) ;
            ON CHANGE  if( oLbx != nil, oLbx:Say( 1, 0, " Line:" + ;
                            str( oFile:RecNo() ), 127 ), ) ;
            OF oDlg

    ACTIVATE DIALOG oDlg

    oFile:Close()

return nil

//---------------------------------------------------------------------------//
FUNCTION GO( oMain )
    local oWnd
    local oMeter, nActual := 0

    Alert( cValToChar( lSaveObject( oMain:Cargo, "Test.dsk" ) ) )
    Alert( ValType( uLoadObject( "Test.dsk" ) ) )

    define dialog oWnd size 30, 5

    @ 0,0 METER oMeter VAR nActual TOTAL 300 size 27 prompt 'Prueba' of oWnd

    activate Dialog oWnd on init pausa(@oMeter, @oWnd)
return nil
//---------------------------------------------------------------------------//
Function pausa( oMeter, oWnd )
    local n,m

    for n:=0 to 300
        for m:=0 to 300
        next
        oMeter:SetaCTUAL( n )
    next
    oWnd:end()
return nil

//---------------------------------------------------------------------------//
// creacion del indice
Function rIndex()
    Local oWnd, oMeter, nActual := 0, aoDlg

    If MsgYesNo( "¨ Seguro que quiere Reindexar ?", "Reindexar" )

        aoDlg := RunAmodal( .t. )

        DEFINE DIALOG oWnd ;
            FROM 0, 0 TO 12, 55 ;
            TITLE "Reindexando"

        @  2,  2 SAY "Area :" COLOR "W+/BG" OF oWnd
        @  2, 23 SAY "Nombre ¡ndice :" COLOR "W+/BG"  OF oWnd
        @  4,  2 SAY "Condici¢n :" COLOR "W+/BG" OF oWnd
        @  6,  2 SAY "Registro:" COLOR "W+/BG" OF oWnd

        @  8,  2 METER oMeter VAR nActual OF oWnd;
            TOTAL 100 ;
            SIZE 50 ;
            BARCOLOR "B/W" ;
            PROMPT "Porcentaje Realizado : "

        ACTIVATE DIALOG oWnd CENTERED NOWAIT

        SetMCursor( IDC_CLOCK )

        // Creamos los Indices
        CrearIndice( "DIALOG", "(NAME)", {|| (DIALOG->NAME) }, ;
                     "DIALOG01.NTX", oWnd, oMeter, aoDlg[2] )

        SetMCursor( IDC_ARROW )

        // Muestra Mensaje de Fin.
        MsgInfo( "Fin de la reindexaci¢n" )

        // Cerramos la ventana de Indexaci¢n
        oWnd:Close()
        aoDlg[1]:Close()

    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Function CrearIndice( cArea, cCond, bCond, cFile, oWnd, oMeter, oLbx )

    Local nActual, nLastRec, nPorcent, nSalto, nTotAnt, nConst

    @  2,  9 SAY PadR( cArea, 10 ) OF oWnd

    @  2, 39 SAY PadR( cFile, 13 ) OF oWnd

    @  4, 14 SAY PadR( cCond, 30 ) OF oWnd

    nLastRec := (cArea)->( LastRec() )
    @  6, 19 SAY "/ " + Str( nLastRec, 6 ) OF oWnd

    nSalto   := 1 + Int( nLastRec / ( 50 * 8 ) )   // Cuantas veces hay que actualizar
    nTotAnt  := 0
    nActual  := 0
    nConst   := 100 / nLastRec

    oLbx:GoTop()

    // Se crea el indice
    (cArea)->( DbCreateIndex( cFile, cCond, ;
                    {|| nActual++, ;
                        ( If( ( nActual > nTotAnt + nSalto ) .Or. ;
                                nActual == nLastRec, ;
                            ( nPorcent := Int( nActual * nConst ), ;
                              oWnd:BeginPaint(),;
                              oWnd:Say( 6, 12, Str( nActual, 6 ) ), ;
                              oMeter:SetActual( nPorcent ), ;
                              oWnd:EndPaint(),;
                              nTotAnt := nActual ), ) ;
                        ), ;
                        oLbx:GoDown(),;
                        if( ! oLbx:tBrowse:HitBottom, ( cArea)->( dbSkip( -1 ) ), ),;
                        Eval( bCond ) }, .F. ) )

    // Resetea el indice creado
    (cArea)->( DbClearIndex() )
    (cArea)->( DbSetIndex( cFile ) )
    oLbx:Reset()

Return NIL

// -------------------------------------------------------------------------- //
// testing tSpin class

function testspin()
    local oWnd, oWnd1
    local nVar := 5

    define dialog oWnd from 5,5 to 20,74 title 'SpinText'

    @ 2,2 spin nVar of oWnd prompt "Testing Spin" ;
    action oWnd1:ChangeSize(10, nVar+2),oWnd:Update() UPDATE


    @ 5,5 get nVar of oWnd Prompt "Get Confirmation" UPDATE ;
        valid oWnd:Update(),.t.

    define dialog oWnd1 from 5,40 to 10,70 title 'Resizable'

    activate dialog oWnd1 nowait

    activate dialog oWnd valid oWnd1:close() on init gg(oWnd1)
return nil
function gg(oWnd1)
    activate dialog oWnd1 nowait
return nil

