// Programa para MegaRecords.
// By Juan Rios Olivares.

#include "MegaReco.ch"

Static oWndMain 		// Ventana Principal
Static cPath            // Path hacia los ficheros
Static aCont			// Array de Contadores

// Objetos TWorkArea para las areas de bases de datos.
Static oClientes
Static oFacturac
Static oProveedo
Static oAlmacen
Static oDescFact
Static aSvDAC

// REQUEST VEXTENDED

#define LIGHTBLUE  57

external GetImages  // Enalaza el m¢dulo de imagenes, para que se inicialize

// -------------------------------------------------------------------------- //

Function Main()

    Local cPant, ;              // Pantalla principal
          nRow, ;               // Fila donde comienza el programa.
          oBarMain,;
          cVar  := IMG_VARNAME  // Nombre del array de recursos Bitmaps

    Local bOld := ErrorBlock()

    aSvDAC := aGetDac( LIGHTBLUE )
    SetDac( LIGHTBLUE,  0, 32, 42 )

    ErrorBlock( { | e | SetDac( LIGHTBLUE, aSvDAC[ 1 ], aSvDAC[ 2 ], aSvDAC[ 3 ] ),;
                     Eval( bOld, e ) } )

    // Salvamos la pantalla inicial y la coordenana inicial
    cPant := SaveScreen( 0, 0, 24, 79 )
    nRow := Row() - 1

    // Se dan valores por defecto
	DEFAULT cPath := "Bases\"

	// Se configura el entorno
	SET DATE TO BRITISH 								// dd/mm/yy
	SET EXCLUSIVE ON
	SET DELETED ON
    Set( _SET_CANCEL, .F. )             // No Alt_C
    AltD( 0 )                           // No debugger y poder usar Alt_D

    // Redefinimos la clase TWorkArea
    // _TWrkArea()  // Ya redefinida en la clase.

    // Inicializamos el sistema.
    SET LANGUAGE TO SLG_SPANISH

    // Poner el temporizador para el SalvaPantallas.
    SET TIMEOUT TO 120 SECONDS
    ON TIMEOUT DO MouseWalk() // ProtectPant()

    // Iniciamos la ventana principal
    DEFINE WINDOW oWndMain ;
        FROM 0, 0 TO 24, 79 ;
        TITLE "M E G A   R E C O R D S  " + M_R_VERSION ;
        MENU MainMenu() ;               // Definimos el menu principal
        NOMINIMIZE ;
        NOMAXIMIZE ;
        NORESIZE ;
        NODRAG ;
        COLOR "N/B*, N/W*, W+/B*, N/W, W/B*"

    // Definimos el mensage por defecto de la ventana principal.
    SET MESSAGE OF oWndMain ;
        TO "Mega Records " + M_R_VERSION + " By Juan Rios Olivares."

//    @ 0, 0 BITMAP FILENAME "Mega.bin" OF oWndMain ;
//        SIZE 78, 17

    // Definiciones de la barra de botones
    DEFINE BUTTONBAR oBarMain OF oWndMain

    DEFINE BUTTON FILENAME cVar + IMG_EXIT OF oBarMain ;
        ACTION oWndMain:Close() ;
        MESSAGE "Terminar la ejecuci¢n de este programa" ;
        TIPS "Terminar la ejecuci¢n y salir al dos."

    DEFINE BUTTON FILENAME cVar + IMG_INFO OF oBarMain ;
        MESSAGE "Informaci¢n sobre este programa" ;
        TIPS "Informaci¢n sobre el programa" ;
        ACTION MsgInfo( "Programa: Mega Records " + M_R_VERSION + CRLF + ;
                       " Autor   : Juan Rios Olivares", ;
                       "Informaci¢n del Programa" )

    DEFINE BUTTON FILENAME cVar + IMG_CLOCK3 OF oBarMain ;
        GROUP ;
        ACTION OpenClock() ;
        MESSAGE "Visualizar la fecha y la hora" ;
        TIPS "Ver la fecha y la hora"

    DEFINE BUTTON FILENAME cVar + IMG_CALC OF oBarMain ;
        ACTION Calc( oWndMain ) ;
        MESSAGE "Calculadora" ;
        TIPS "Usar la calculadora"

    DEFINE BUTTON FILENAME cVar + IMG_CALEND OF oBarMain ;
        ACTION Calend() ;
        MESSAGE "Calendario" ;
        TIPS "Ver el calendario"

    /*
    DEFINE BUTTON FILENAME cVar + IMG_DISPLAY OF oBarMain ;
        ACTION AddCantPanel() ;
        MESSAGE "Panel de total" ;
        TIPS "Ver el panel de total"
    */

    // Recogemos los contadores del archivo
	If File( "MegaReco.Dat" )
		aCont := File2A( "MegaReco.Dat" )
	Else
        MsgAlert( "No se ha encontrado archivo de contadores", "Error" )
        Return NIL
	EndIf

    // Activamos las ventana
    ACTIVATE WINDOW oWndMain ;
        VALID lMsgEnd() ;
        ON INIT OpenDataBases()

    // Cerramos todas las bases de datos que pudieran estar abiertas
    CLOSE ALL

    // Restauramos la ventana inicial y la coordenada inicial
    RestScreen( 0, 0, 24, 79, cPant )
    SetColor( "GR+/N" )
    DevPos( nRow,  0 ); DevOut( PadR( "Fin del programa MegaRecords " + ;
                                M_R_VERSION + "   By Juan Rios", 80 ) )
    SetDac( LIGHTBLUE, aSvDAC[ 1 ], aSvDAC[ 2 ], aSvDAC[ 3 ] )

Return NIL

//---------------------------------------------------------------------------//

Static Function ProtectPant()
    Local nMRowAnt, nMColAnt
    VgaOff()
    nMRowAnt := nMRow()
    nMColAnt := nMCol()
    Do While nMKeyWait() == 0 .And. ;
             nMRow() == nMRowAnt .And. ;
             nMCol() == nMColAnt .And. ;
             !lMPressed()
    EndDo
    VgaOn()
Return NIL

// -------------------------------------------------------------------------- //
Static Function ConfigProtect()
    Static nProtTime := 60
    If lMsgGet( "Tiempo del protector", "&Segundos:", @nProtTime, "999" )
        SET TIMEOUT TO nProtTime
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function MainMenu()
    Local oMenu

    MENU oMenu
        MENUITEM "&Facturaci¢n" ;
            MESSAGE "Gesti¢n de la facturaci¢n." ;
            ACTION Facturacion()

        MENUITEM "&Almac‚n" ;
            MESSAGE "Gesti¢n del almac‚n." ;
            ACTION Almacen()

        MENUITEM "&Proveedores" ;
            MESSAGE "Gesti¢n de proveedores." ;
            ACTION Proveedores()

        MENUITEM "&Clientes" ;
            MESSAGE "Gesti¢n de clientes." ;
            ACTION Clientes()

        MENUITEM "&Utilidades" ;
            MESSAGE "Reloj, calculadora, calendario, reindexar,..."
            MENU
                MENUITEM "&Cascada" ;
                    MESSAGE "Pone las ventanas en cascada" ;
                    ACTION oWndMain:Cascade()

                MENUITEM "&Reloj" ;
                    MESSAGE "Abre una ventana que muestra la hora" ;
                    ACTION OpenClock()

                MENUITEM "&Calculadora" ;
                    MESSAGE "Abre una ventana con una calculadora" ;
                    ACTION Calc( oWndMain )

                MENUITEM "Ca&lendario" ;
                    MESSAGE "Abre una ventana que muestra un calendario" ;
                    ACTION Calend()

                MENUITEM "&Protector de pantalla" ;
                    MESSAGE "Configura el protector de pantalla" ;
                    ACTION ConfigProtect()

                /*
                MENUITEM "&Ventana de Total" ;
                    MESSAGE "Visualiza la ventana con el total" ;
                    ACTION AddCantPanel()
                */

                MENUITEM "&Reindexar" ;
                    MESSAGE "Reindexa las bases de datos." ;
                    ACTION If( MsgYesNo( "¨ Seguro de Reindexar las Bases ?", ;
                       "Confirmaci¢n" ), Reindexar(), )

                SEPARATOR

                MENUITEM "&Sobre el programa" ;
                    MESSAGE "Informaci¢n del programa" ;
                    ACTION MsgInfo( "Programa: Mega Records " + ;
                                     M_R_VERSION + CRLF + ;
                                    " Autor   : Juan Rios Olivares", ;
                                    "Informaci¢n del Programa" )

                MENUITEM "&Terminar el programa" ;
                    MESSAGE "Salir del programa" ;
                    SHORTCUT K_ALT_X ;
                    ACTION oWndMain:Close()

            ENDMENU
   ENDMENU

Return oMenu

// -------------------------------------------------------------------------- //
Static Function OpenDataBases()

	If File( cPath + "ALMACEN.DBF" )

        PushMsg( "Abriendo la base de datos Almacen." )

        USE ( cPath + "ALMACEN" ) ALIAS ALMACEN NEW

		If !File( cPath + "ALMCOD.NTX" )
            PushMsg( "Indexando la base Almacen por C¢digo." )
			INDEX ON ALMACEN->CODIGO TO ( cPath + "ALMCOD.NTX" )
            PopMsg()
		EndIf

		If !File( cPath + "ALMNOM.NTX" )
            PushMsg( "Indexando la base Almacen por Nombre." )
			INDEX ON ALMACEN->NOMBRE TO ( cPath + "ALMNOM.NTX" )
            PopMsg()
		EndIf

		If !File( cPath + "ALMTIP.NTX" )
            PushMsg( "Indexando la base Almacen por Tipo." )
			INDEX ON ALMACEN->TIPO TO ( cPath + "ALMTIP.NTX" )
            PopMsg()
		EndIf

        oAlmacen := TWorkArea():New()
        oAlmacen:CloseIndex()
        /*
        oAlmacen:AddIndex( ( cPath + "ALMCOD" ) )
        oAlmacen:AddIndex( ( cPath + "ALMNOM" ) )
        oAlmacen:AddIndex( ( cPath + "ALMTIP" ) )
        */
        oAlmacen:SetIndex( ( cPath + "ALMCOD" ) )
        oAlmacen:SetIndex( ( cPath + "ALMNOM" ) )
        oAlmacen:SetIndex( ( cPath + "ALMTIP" ) )

        oAlmacen:SetBuffer( .T. )

        PopMsg()

	EndIf

    If File( cPath + "DESCFACT.DBF" )

        PushMsg( "Abriendo la base de datos DescFact." )
        USE ( cPath + "DESCFACT" ) ALIAS DESCFACT NEW

        If !File( cPath + "DESCOD.NTX" )
            PushMsg( "Indexando la base DescFact por C¢digo." )
            INDEX ON DESCFACT->CODIGO TO ( cPath + "DESCOD.NTX" )
            PopMsg()
		EndIf

        If !File( cPath + "DESPRO.NTX" )
            PushMsg( "Indexando la base DescFact por C¢digo Producto." )
            INDEX ON DESCFACT->CODPRO TO ( cPath + "DESPRO.NTX" )
            PopMsg()
		EndIf

        oDescFact := TWorkArea():New()
        oDescFact:CloseIndex()
        /*
        oDescFact:AddIndex( ( cPath + "DESCOD" ) )
        oDescFact:AddIndex( ( cPath + "DESPRO" ) )
        */
        oDescFact:SetIndex( ( cPath + "DESCOD" ) )
        oDescFact:SetIndex( ( cPath + "DESPRO" ) )

        oDescFact:SetBuffer( .T. )

        PopMsg()

	EndIf

    If File( cPath + "CLIENTES.DBF" )

        PushMsg( "Abriendo la base de datos Clientes." )

        USE ( cPath + "CLIENTES" ) ALIAS CLIENTES NEW

		If !File( cPath + "CLICOD.NTX" )
            PushMsg( "Indexando la base Clientes por el C¢digo." )
			INDEX ON CLIENTES->CODIGO TO ( cPath + "CLICOD.NTX" )
            PopMsg()
		EndIf

		If !File( cPath + "CLINOM.NTX" )
            PushMsg( "Indexando la base Clientes por el Nombre." )
			INDEX ON CLIENTES->NOMBRE TO ( cPath + "CLINOM.NTX" )
            PopMsg()
		EndIf

		If !File( cPath + "CLINIF.NTX" )
            PushMsg( "Indexando la base Clientes por el NIF." )
			INDEX ON CLIENTES->NIF TO ( cPath + "CLINIF.NTX" )
            PopMsg()
		EndIf

		If !File( cPath + "CLIULT.NTX" )
            PushMsg( "Indexando la base Clientes por la Fecha." )
			INDEX ON CLIENTES->ULTFECHA TO ( cPath + "CLIULT.NTX" )
            PopMsg()
		EndIf

        oClientes := TWorkArea():New()
        oClientes:CloseIndex()
        /*
        oClientes:AddIndex( ( cPath + "CLICOD" ) )
        oClientes:AddIndex( ( cPath + "CLINOM" ) )
        oClientes:AddIndex( ( cPath + "CLINIF" ) )
        oClientes:AddIndex( ( cPath + "CLIULT" ) )
        */
        oClientes:SetIndex( ( cPath + "CLICOD" ) )
        oClientes:SetIndex( ( cPath + "CLINOM" ) )
        oClientes:SetIndex( ( cPath + "CLINIF" ) )
        oClientes:SetIndex( ( cPath + "CLIULT" ) )

        oClientes:SetBuffer( .T. )

        PopMsg()

	EndIf

	If File( cPath + "PROVEEDO.DBF" )

        PushMsg( "Abriendo la base de datos de Proveedores." )

        USE ( cPath + "PROVEEDO" ) ALIAS PROVEEDO NEW

		If !File( cPath + "PROCOD.NTX" )
            PushMsg( "Indexando la base Proveedo por el C¢digo." )
			INDEX ON PROVEEDO->CODIGO TO ( cPath + "PROCOD.NTX" )
            PopMsg()
		EndIf

		If !File( cPath + "PRONOM.NTX" )
            PushMsg( "Indexando la base Proveedo por el Nombre." )
			INDEX ON PROVEEDO->NOMBRE TO ( cPath + "PRONOM.NTX" )
            PopMsg()
		EndIf

		If !File( cPath + "PRONIF.NTX" )
            PushMsg( "Indexando la base Proveedo por el NIF." )
			INDEX ON PROVEEDO->NIF TO ( cPath + "PRONIF.NTX" )
            PopMsg()
		EndIf

        oProveedo := TWorkArea():New()
        oProveedo:CloseIndex()
        /*
        oProveedo:AddIndex( ( cPath + "PROCOD" ) )
        oProveedo:AddIndex( ( cPath + "PRONOM" ) )
        oProveedo:AddIndex( ( cPath + "PRONIF" ) )
        */
        oProveedo:SetIndex( ( cPath + "PROCOD" ) )
        oProveedo:SetIndex( ( cPath + "PRONOM" ) )
        oProveedo:SetIndex( ( cPath + "PRONIF" ) )

        oProveedo:SetBuffer( .T. )

        PopMsg()

	EndIf

    If File( cPath + "FACTURAC.DBF" )

        PushMsg( "Abriendo la base de datos de Facturaci¢n." )

        USE ( cPath + "FACTURAC" ) ALIAS FACTURAC NEW

        If !File( cPath + "FACCOD.NTX" )
            PushMsg( "Indexando la base Facturac por el C¢digo." )
            INDEX ON FACTURAC->CODIGO TO ( cPath + "FACCOD.NTX" )
            PopMsg()
        EndIf

        If !File( cPath + "FACCLI.NTX" )
            PushMsg( "Indexando la base Facturac por el C¢digo de Cliente." )
            INDEX ON FACTURAC->CODCLI TO ( cPath + "FACCLI.NTX" )
            PopMsg()
        EndIf

        If !File( cPath + "FACDIA.NTX" )
            PushMsg( "Indexando la base Facturac por la Fecha." )
            INDEX ON FACTURAC->FECHA TO ( cPath + "FACDIA.NTX" )
            PopMsg()
        EndIf

        oFacturac := TFacturac():New()
        oFacturac:CloseIndex()
        /*
        oFacturac:AddIndex( ( cPath + "FACCOD" ) )
        oFacturac:AddIndex( ( cPath + "FACCLI" ) )
        oFacturac:AddIndex( ( cPath + "FACDIA" ) )
        */
        oFacturac:SetIndex( ( cPath + "FACCOD" ) )
        oFacturac:SetIndex( ( cPath + "FACCLI" ) )
        oFacturac:SetIndex( ( cPath + "FACDIA" ) )

        oFacturac:SetBuffer( .T. )

        PopMsg()

    EndIf

Return NIL

// -------------------------------------------------------------------------- //
Static Function Reindexar()
    Local aIndices

    aIndices := { { "ALMACEN",  { { cPath + "ALMCOD.NTX", ;
                                 "ALMACEN->CODIGO",  ;
                                 {|| ALMACEN->CODIGO } }, ;
                                { cPath + "ALMNOM.NTX", ;
                                 "ALMACEN->NOMBRE", ;
                                 {|| ALMACEN->NOMBRE } }, ;
                                { cPath + "ALMTIP.NTX", ;
                                 "ALMACEN->TIPO", ;
                                 {|| ALMACEN->TIPO } } } }, ;
                  { "FACTURAC", { { cPath + "FACCOD.NTX", ;
                                  "FACTURAC->CODIGO", ;
                                  {|| FACTURAC->CODIGO} }, ;
                                { cPath + "FACCLI.NTX", ;
                                  "FACTURAC->CODCLI", ;
                                  {|| FACTURAC->CODCLI} }, ;
                                { cPath + "FACDIA.NTX", ;
                                  "FACTURAC->FECHA", ;
                                  {|| FACTURAC->FECHA} } } }, ;
                  { "DESCFACT", { { cPath + "DESCOD.NTX", ;
                                  "DESCFACT->CODIGO", ;
                                  {|| DESCFACT->CODIGO} }, ;
                                { cPath + "DESPRO.NTX", ;
                                  "DESCFACT->CODPRO", ;
                                  {|| DESCFACT->CODPRO} } } }, ;
                  { "CLIENTES", { { cPath + "CLICOD.NTX", ;
                                  "CLIENTES->CODIGO", ;
                                  {|| CLIENTES->CODIGO} }, ;
                                { cPath + "CLINOM.NTX", ;
                                  "CLIENTES->NOMBRE", ;
                                  {|| CLIENTES->NOMBRE} }, ;
                                { cPath + "CLINIF.NTX", ;
                                  "CLIENTES->NIF", ;
                                  {|| CLIENTES->NIF} }, ;
                                { cPath + "CLIULT.NTX", ;
                                  "CLIENTES->ULTFECHA", ;
                                  {|| CLIENTES->ULTFECHA} } } }, ;
                  { "PROVEEDO", { { cPath + "PROCOD.NTX", ;
                                  "PROVEEDO->CODIGO", ;
                                  {|| PROVEEDO->CODIGO} }, ;
                                { cPath + "PRONOM.NTX", ;
                                  "PROVEEDO->NOMBRE", ;
                                  {|| PROVEEDO->NOMBRE} }, ;
                                { cPath + "PRONIF.NTX", ;
                                  "PROVEEDO->NIF", ;
                                  {|| PROVEEDO->NIF} } } } }

    oWndReIndex( aIndices )

Return NIL

// -------------------------------------------------------------------------- //
Function aCont()
Return aCont

// -------------------------------------------------------------------------- //
Function GetClientes()
Return oClientes

// -------------------------------------------------------------------------- //
Function GetFacturac()
Return oFacturac

// -------------------------------------------------------------------------- //
Function GetProveedo()
Return oProveedo

// -------------------------------------------------------------------------- //
Function GetAlmacen()
Return oAlmacen

// -------------------------------------------------------------------------- //
Function GetDescFact()
Return oDescFact

// -------------------------------------------------------------------------- //

