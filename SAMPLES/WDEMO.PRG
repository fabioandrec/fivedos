#define BOXX "********."

#include "fivedos.ch"
#include "FontDef.h"
#include "Eval.ch"
#include "CtlAlign.ch"
#include "Colores.ch"

function main()

    local a    := Memory( 0 )
    local oWnd1
    local oWnd2
    local oWnd3
    local oWnd
    local cBack := SaveScreen( 0, 0, MaxRow(), MaxCol() )
    local oGet, cVar := "A get object in the Limb.....oooooo........oooooooo"
    local cVar1, cVar2 := Date()
    local oBar, oMenu
    local nListBox := 1
    local cCombo :='pruebas    '
    local aList := { "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",;
                    "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre",;
                    "Diciembre" }
    local aList1 := { "Lunes", "Martes", "Miercoles", "Jueves", ;
                      "Viernes", "Sabado" ,"Domingo" }

    DEFINE WINDOW oWnd1 SIZE 70, 18     ;
		     TITLE "Our First Window"   ;
             VSCROLL HSCROLL ;
		     MENU BuildMenu()

    DEFINE BUTTONBAR oBar OF oWnd1

    DEFINE MESSAGE BAR OF oWnd1 ;
	   PROMPT F2VERSION + FDCOPYRIGHT

    DEFINE BUTTON FILE "..\bitmaps\exit.bmp" PROMPT 'Salir' OF oBar ;
            ACTION oWnd1:Close() ;
            TIPS "Abandonar la aplicaci¢n"

    DEFINE BUTTON FILE "..\bitmaps\info.bmp" GROUP OF oBar ;
                    ACTION MsgInfo( "(C) FiveDos Team 1994" + CRLF + CRLF + ;
                                    "Antonio Linares"       + CRLF + ;
                                    "Francisco Pulp¢n"      + CRLF + ;
                                    "Cayetano G¢mez"    + CRLF + ;
                                    "J.Mariano Rodriguez", "FiveDos 1.0" ) ;
                    TIPS "Info about FiveDos developers"

    DEFINE BUTTON FILE "..\bitmaps\floppy_a.bmp"  OF oBar ;
            ACTION MsgStop( 'Puls¢ Floppy "A"' ),;
                   DO PlayWav( "Originar.wav" ) FOR n := 1 TO 3,;
                   MsgStop( 'Puls¢ Floppy "A"' )


    DEFINE BUTTON FILE "..\bitmaps\open.bmp"  OF oBar ;
            MESSAGE "View sources. P.e.: 'wdemo.prg'" ;
            ACTION TextBrowse( "*.prg" )

    DEFINE BUTTON FILE "..\bitmaps\clock.bmp"  OF oBar ;
            ACTION MsgInfo( "Son las:;" + Time() + " Horas")

    DEFINE BUTTON PROMPT "PlayWav" GROUP OF oBar ;
            ACTION PlayWav()

    DEFINE BUTTON PROMPT "ScreenSaver" OF oBar ;
            ACTION MouseWalk()

    @ 1, 50 BUTTON "Hojear;el;&Fichero" ;
		   SIZE 16, 3               ;
		   ACTION RunAModal()       ;
		   MESSAGE "Hojear una base de Datos" ;
           FILE "..\bitmaps\floppy_a.bmp"      ;
		   OF oWnd1

    @ 5, 10 LISTBOX nListBox ARRAY aList ;
		    SIZE 15, 5 ;
		    OF oWnd1

    DEFINE DIALOG oWnd2 AT 6, 30 SIZE 70, 16    ;
		     TITLE "Our First Dialog"   ;
		     OF oWnd1

    DEFINE MESSAGE BAR OF oWnd2 ;
       PROMPT F2VERSION + " The Right choice !"

    TRadio():New( 1, 2, "&Radio Button","Esto es un Radio Button", ;
		  "N/BG, W+/BG, BG+/BG, N+/BG", oWnd2 )

    @ 2, 2 SAY "Esto es un TSay" ;
           COLOR "n/bg"          ;
           OF oWnd2

    @ 1, 30 BUTTON "Hojear;el;&Fichero" ;
		   SIZE 16, 3               ;
		   ACTION RunAModal()       ;
           MESSAGE "Hojear una base de Datos" ;
           FILE  "floppy_a.bmp"      ;
           WHEN  (TONE(200,1),.T. )  ;
           VALID (TONE(600,1),.T. )  ;
		   OF oWnd2

    @ 1, 50 BUTTON "&V;e;r;t;i;c;a;l" ;
            SIZE 3, 10 ;
            MESSAGE "Puede hacer botones de cualquier tama¤o y forma" ;
            OF oWnd2

    @ 6, 2 GET oGet VAR cVar  PROMPT "&Este Get" MESSAGE "Esto Es un Get" ;
                        PICTURE "@S30" ;
                        OF oWnd2

    @ 8, 2 GET oGet VAR cVar2  PROMPT "&Fecha:   " ;
                        MESSAGE "Teclee una fecha cualquiera..." ;
                        OF oWnd2
                        // PICTURE "@D" ;
    cVar1 = 33

    @ 10, 2 GET oGet VAR cVar1  PROMPT "&Numero:   " ;
                        MESSAGE "Teclee un n£mero cualquiera..." ;
                        OF oWnd2


    DEFINE WINDOW oWnd3 FROM 10, 12 TO 20, 66    ;
		     MENU BuildMenu2()          ;
             TITLE "ListBox & ComboBox" ;
             COLOR "N/ G, N/W*, W+/G, N/G*, G+/G" ;
             OF oWnd1

    @ 2, 2 LISTBOX nListBox ARRAY aList ;
		    SIZE 15, 5 ;
            PROMPT "&Month Day" ;
		    ON CHANGE Tock()     ;
		    ON DBLCLICK  Tone(1000,1) ;
            VALID MsgYesNo( "1-VALID" ) ;
            WHEN  MsgYesNo( "1-WHEN" ) ;
            OF oWnd3

    @ 2, 25 COMBOBOX cCombo ;
            LABEL "&Select Day" ARRAY aList1 ;
		    SIZE 15, 5 ;
            VALID MsgYesNo( "2-VALID" ) ;
            WHEN  MsgYesNo( "2-WHEN" ) ;
		    OF oWnd3

    oWnd3:bSized = {|| MsgInfo( "­ Resized !" ) }

    // Our Application BackGround
    SET COLOR TO "N/N*"
    CLS

    nTimeOut( 60 )       // Seconds
    bTimeOutAction( {|| MouseWalk() } )

    ACTIVATE WINDOW oWnd1 VALID lMsgEnd() ON PAINT Fondo( oWnd1 ) MAXIMIZED ;
            ON INIT Alert( "Init " )

    RestScreen( 0, 0, MaxRow(), MaxCol(), cBack )

    PlayWav( "adios.wav" )

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
                  ACTION TextBrowse( "*.prg" )
    ENDMENU

return oMenu

//---------------------------------------------------------------------------//

function BuildMenu2()

   local oMenu

    MENU oMenu COLOR "n/w, w+/b, r/w, r+/b, n+/w, w+/w, n+/w"
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

    static cCurDir

    local nOldMouseCur

    if empty( cCurDir )
        cCurDir = cDrive() + ":\" + curdir() + "\"
    endif

    if empty( cFile )
        cFile := cGetFile( cCurDir + "*.wav" )
    endif

    if file( cFile )

        cCurDir = cFAcceso( cFile )

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

function RunAModal()
    static oDlg, oLbx
    local oBrw

    USE Dialog

    SetMCursor( IDC_CLOCK )

    if oDlg == nil

        BEGIN BROWSE oBrw COLOR "W+/W, W+/N, W/N"                  // Browse Colors
            COLUMN TITLE "Nombre"  SHOW Dialog->Name
            COLUMN TITLE "FiveDos" SHOW Dialog->FiveDos
            COLUMN TITLE "Dialog"  SHOW Dialog->Dialog
            COLUMN TITLE "Objects" SHOW Dialog->Objects
            COLUMN TITLE "Level"   SHOW Dialog->Level
        ENDBROWSE

        oBrw:SkipBlock := { | n | Dialog->( _DbSkipper( n ) ) }

        DEFINE DIALOG oDlg          ;
            FROM 3, 3 TO 20, 74     ;
            COLOR "N/ RB, N/W*, W+/RB, N/RB*, RB+/RB" ;
            TITLE "Dialog Users"

        @  1,  2 LISTBOX oLbx BROWSE oBrw           ;
                SIZE 67, 12                         ;
                LOGICLEN Dialog->( RecCount() )     ;
                ON DBLCLICK Alert( "DblClick" )     ;
                WHEN ( TONE( 1000, 1 ), .T. ) ;
                OF oDlg

        Alert( Valtype( oLbx:bChanged ) )

        @ 14,  2 BUTTON "   &New   " OF oDlg
        @ 14, 14 BUTTON "  &Edit  "  OF oDlg // ACTION CliEdit
        @ 14, 25 BUTTON "   &Del   " OF oDlg
        @ 14, 37 BUTTON "  &Seek  "  OF oDlg ACTION CliSeek()
        @ 14, 48 BUTTON "  &Print  " OF oDlg ACTION CliMove( oDlg, oLbx )
        @ 14, 60 BUTTON "  E&xit  "  OF oDlg ACTION oDlg:Close()

    endif

    ACTIVATE DIALOG oDlg VALID ( oLbx:bWhen := bTrue(), ;
                                 MsgYesNo( "­ Hey Valid !" ) ) ;
                         WHEN  ( oLbx:Reset(), MsgYesNo( "­ Hey When  !" ) )

    USE

return nil

//---------------------------------------------------------------------------//

function CliSeek()

   local cName := Dialog->Name

   if lMsgGet( "Cliente a buscar", "&Nombre:", @cName )
   endif

return nil

//---------------------------------------------------------------------------//

static function CliMove( oWnd, oLbx )

    local oDlg

    DEFINE DIALOG oDlg ;
	   AT 10, 20 SIZE 38, 5 ;
	   TITLE "Mueve el Browse" // OF oWnd

    @ 1, 3  BUTTON " &Arriba " WHILE PRESSED oLbx:GoUp()   OF oDlg
    @ 1, 14 BUTTON " A&bajo "  WHILE PRESSED oLbx:GoDown() OF oDlg
    @ 1, 24 BUTTON " &Salir "  ACTION oDlg:Close()   OF oDlg

    ACTIVATE DIALOG oDlg          // NOWAIT

return nil

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

function Fondo( oWnd )
    local n 
    for n := 0 TO MaxRow() step 3
        oWnd:say( n, 0, replicate(chr(LEFTRADIO) + chr(CENTERRADIO1)+;
                    chr(RIGHTRADIO) , 30), BG_B )
        oWnd:say( n+1, 0, replicate( chr(CENTERRADIO1)+ chr(RIGHTRADIO) + ;
                    chr(LEFTRADIO) , 30), BG_B )
        oWnd:say( n+2, 0, replicate( chr(RIGHTRADIO)  + chr(LEFTRADIO) + ;
                    chr(CENTERRADIO1) , 30), BG_B )
    next
return nil

//---------------------------------------------------------------------------//

#include "FileIO.ch"

//---------------------------------------------------------------------------//

function TextBrowse( cFile )

    local oWndBrw, oLbx
    local oBrw, oFile

    cFile := cGetFile( if( empty( cFile ), "*.*", cFile ) )

    if !File( cFile )
        return nil
    endif

    SetMCursor( IDC_CLOCK )

    if ! File( cFile )
        Alert( "­ El fichero:;" + cFile + ";no existe !" )
        return nil
    endif

    oFile := TTxtFile():New( cFile )

    if oFile:Open( FO_READ + FO_DENYWRITE ) == -1 // Solo lectura y Sin compartir escritura.
        Alert( "­ El fichero:;" + cFile + ";no se puede abrir !" + ;
               ";Error DOS N§: " + str( FERROR(), 3 ) )
        return nil
    endif

    DEFINE DIALOG oWndBrw          ;
        FROM 0, 0 TO 24, 79     ;
        NOMOVE                  ;
        TITLE "Text Browser: " + cFile


    BEGIN BROWSE oBrw COLOR "n/w, w+/b, w/b"                  // Browse Colors
        COLUMN TITLE "Line:" + str( 1 ) ;
               SHOW oFile:ReadLn( TABSIZE ) ;
               WIDTH oWndBrw:nWidth - 6
    ENDBROWSE

    oBrw:SkipBlock     = { | nSkip, nRec | nRec := oFile:RecNo(),;
                                           oFile:Skip( nSkip ),;
                                           oFile:RecNo() - nRec }
    oBrw:goTopBlock    = {|| oFile:GoTop() }
    oBrw:goBottomBlock = {|| oFile:GoBottom() }

    @  0, 0 LISTBOX oLbx BROWSE oBrw                ;
            SIZE oWndBrw:nWidth - 2, oWndBrw:nHeight - 2  ;
            LOGICLEN oFile:LastRec()                ;
            ON DBLCLICK MsgInfo( "Doble Click.;Viendo:;"+ cFile + ;
                                 ";Linea:" + str( oFile:Recno() ) + ;
                                 ";Texto: " + left( oFile:ReadLn( TABSIZE ), 30 ) ) ;
            ON CHANGE oLbx:Say( 0, 0, " Line:" + str( oFile:RecNo() ), N_W ) ;
            OF oWndBrw

    oLbx:nAlign = ALIGN_CLIENT

    ACTIVATE WINDOW oWndBrw

    oFile:Close()

return nil

//---------------------------------------------------------------------------//
