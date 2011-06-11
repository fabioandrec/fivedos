// -------------------------------------------------------------------------- //
//                         Test para indexar con Meter                        //
// -------------------------------------------------------------------------- //

#include "FiveDos.ch"
#include "SysStr.ch"


static oWnd, oLbx

// -------------------------------------------------------------------------- //
Function Main()

    SysLanguage( SLG_SPANISH )

    DEFINE WINDOW oWnd ;
        FROM 1, 1 TO 22, 75 ;
        TITLE "Utilizaci¢n de Meters al Indexar" ;
        MENU MainMenu()

    SET MESSAGE OF oWnd ;
        TO "FiveDos - La revoluci¢n xBase"

    ACTIVATE WINDOW oWnd ;
        MAXIMIZED ;
        VALID lMsgEnd()

Return NIL

// -------------------------------------------------------------------------- //
Function MainMenu()
    Local oMenu
    MENU oMenu
        MENUITEM "&Informaci¢n"
        MENU
            MENUITEM "&Acerca de..." ;
                ACTION MsgInfo( "Ejemplo de FiveDos"   + CRLF + ;
                                F2VERSION       + CRLF + CRLF + ;
                                "Antonio Linares"      + CRLF + ;
                                "Francisco Pulp¢n"     + CRLF + ;
                                "Cayetano Gomez"       + CRLF + ;
                                "J. Mariano Rodr¡guez" + CRLF + CRLF + ;
                                " (C) FiveDos Team 1994 " ) ;
                MESSAGE "Informaci¢n acerca de este programa"

            SEPARATOR

            MENUITEM "&Terminar..."  ;
                ACTION oWnd:Close() ;
                MESSAGE "Terminar la ejecuci¢n de este programa"

        ENDMENU

        MENUITEM "&Ficheros"
        MENU
            MENUITEM   "&Clientes..." ;
                ACTION  Clientes() ;
                MESSAGE "Mantenimiento de Clientes"

            MENUITEM   "&Almac‚n";
                ACTION  MsgInfo( "Control del Almac‚n" ) ;
                MESSAGE "Control del Almac‚n"

        ENDMENU

    ENDMENU

Return oMenu

// -------------------------------------------------------------------------- //

Static Function Clientes()
    Local oDlg, oBrw // , oLbx

    PushMsg( "Abriendo Base DIALOG" )

    USE DIALOG

    If DIALOG->( RecCount() ) == 0
        APPEND BLANK
    EndIf

nMKeyWait( 4 )

    PushMsg( "Creando ¡ndice : Dialog01.NTX" )

    INDEX ON DIALOG->NAME TO DIALOG01.NTX

    SET INDEX TO DIALOG01.NTX

    GO TOP

nMKeyWait( 4 )

    PopMsg()
    PopMsg()

    DEFINE DIALOG oDlg ;
        FROM 3, 3 TO 20, 74 ;
        TITLE "Control de Clientes"

    SET MESSAGE OF oDlg TO "Control de Clientes"

    BEGIN BROWSE oBrw COLOR "W+/W, W+/N, W/N" ALIAS Dialog     // Browse Colors
        COLUMN TITLE "Nombre"  SHOW DIALOG->NAME
        COLUMN TITLE "FiveDos" SHOW DIALOG->FIVEDOS
        COLUMN TITLE "Dialog"  SHOW DIALOG->DIALOG
        COLUMN TITLE "Objects" SHOW DIALOG->OBJECTS
        COLUMN TITLE "Level"   SHOW DIALOG->LEVEL
    ENDBROWSE

*    oBrw:SkipBlock := { |n| DIALOG->( _DbSkipper( n ) ) }

    @  1,  2 LISTBOX oLbx BROWSE oBrw           ;
            SIZE 67, 12                         ;
            LOGICLEN DIALOG->( RecCount() )     ;
            OF oDlg

    @ 14,  2 BUTTON "   &New   " OF oDlg

    @ 14, 14 BUTTON "  &Edit  "  OF oDlg

    @ 14, 25 BUTTON "  &Index  " OF oDlg ;
        ACTION DlgIndex()

    @ 14, 37 BUTTON "  &Seek  "  OF oDlg

    @ 14, 48 BUTTON " &Records " OF oDlg ;
        ACTION MsgInfo( "Record : " + Str( ( DIALOG->( RecNo() ) ), 5 ) + ;
                        " / " + Str( ( DIALOG->( LastRec() ) ), 5 ) )

    @ 14, 60 BUTTON "  E&xit  "  OF oDlg ;
        ACTION oDlg:End()

    ACTIVATE DIALOG oDlg

    USE

Return NIL

// -------------------------------------------------------------------------- //
Function DlgIndex()
    Local oWnd, oMeter, nActual := 0

    If MsgYesNo( "¨ Seguro que quiere Reindexar ?", "Reindexar" )

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
                     "DIALOG01.NTX", oWnd, oMeter )

        SetMCursor( IDC_ARROW )

        // Muestra Mensaje de Fin.
        MsgInfo( "Fin de la reindexaci¢n" )

        // Cerramos la ventana de Indexaci¢n
        oWnd:Close()

    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Function CrearIndice( cArea, cCond, bCond, cFile, oWnd, oMeter )

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
                        if( ! oLbx:HitBottom, ( cArea)->( dbSkip( -1 ) ), ),;
                        Eval( bCond ) }, .F. ) )

    // Resetea el indice creado
    (cArea)->( DbClearIndex() )
    (cArea)->( DbSetIndex( cFile ) )
    oLbx:Reset()

Return NIL

// -------------------------------------------------------------------------- //
