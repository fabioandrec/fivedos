// Mantenimiento de Facturaci¢n.

#include "MegaReco.ch"                  // Fichero con definiciones para el programa.
#include "SysColor.ch"

Static oWndFac                          // Ventana de facturas.
Static oLbx
Static nSelect                          // N§ seleccionado
Static oFacturac                        // Objeto Facturac
Static oDescFact                        // Objeto DescFact

#define aClte   oFacturac:aCliente      // Datos del cliente
#define aDsFct  oFacturac:aDescFact     // Descripci¢n de la factura.

// -------------------------------------------------------------------------- //
Function Facturacion()
    Local oBar, oBrw,;
          cVar  := IMG_VARNAME  // Nombre del array de recursos Bitmaps

    CursorWait()

    If oWndFac == NIL

        DEFAULT oFacturac := GetFacturac(), ;
                oDescFact := GetDescFact(), ;
                nSelect   := 1

        // Creamos la ventana de facturaci¢n.
        DEFINE WINDOW oWndFac ;
            FROM  1,  7 TO 23, 72 ;
            TITLE " Facturaci¢n " ;
            NOMAXIMIZE ;
            NORESIZE ;
            MENU FactMenu()

        SET MESSAGE OF oWndFac TO "Ventana de facturaci¢n"

        DEFINE BUTTONBAR oBar OF oWndFac

        // A¤adimos los botones a la barra
        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_TOP ;
            MESSAGE "Va a la primera factura." ;
            TIPS "Va a la primera factura." ;
            ACTION oFacturac:GoTop(), PonFac()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_LEFT ;
            MESSAGE "Va a la anterior factura." ;
            TIPS "Va a la anterior factura." ;
            ACTION oFacturac:Skip( -1 ), ;
                   If( oFacturac:Bof(), Tone( 800 ), PonFac() )

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_RIGHT ;
            MESSAGE "Va a la siguiente factura." ;
            TIPS "Va a la siguiente factura." ;
            ACTION oFacturac:Skip( 1 ), ;
                   If( oFacturac:Eof(), ;
                   ( oFacturac:Skip( -1 ), Tone( 800 ) ), PonFac() )

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_BOTTOM ;
            MESSAGE "Va a la £ltima factura." ;
            TIPS "Va a la £ltima factura." ;
            ACTION oFacturac:GoBottom(), PonFac()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_EDIT ;
            GROUP ;
            MESSAGE "Edita la factura." ;
            TIPS "Edita la factura." ;
            ACTION EdiFac()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_ADD ;
            MESSAGE "A¤ade una factura." ;
            TIPS "A¤ade una factura." ;
            ACTION EdiFac( .T. )

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_TRASH ;
            MESSAGE "Borra la factura." ;
            TIPS "Borra la factura." ;
            ACTION BorFac()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_SEEK ;
            LABEL "Cod." ;
            GROUP ;
            MESSAGE "Buscar una factura por el c¢digo." ;
            TIPS "Buscar una factura por el c¢digo." ;
            ACTION ScanCodigo()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_SEEK ;
            LABEL "C¢dCli" ;
            MESSAGE "Buscar una factura por el c¢dogo del cliente." ;
            TIPS "Buscar una factura por el c¢dogo del cliente." ;
            ACTION ScanCodCli()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_SEEK ;
            LABEL "Fecha" ;
            MESSAGE "Buscar una factura por la fecha." ;
            TIPS "Buscar una factura por la fecha." ;
            ACTION ScanFecha()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_PRINTER ;
            GROUP ;
            MESSAGE "Imprimir facturas" ;
            TIPS "Imprimir facturas" ;
            ACTION NIL

        // Ponemos la pantalla
        PanFac( oWndFac )

        // Ponemos el Browse a ventana completa.
        BEGIN BROWSE oBrw ALIAS aDsFct ; //
            COLOR "W+/BG,GR+/B,W+/B"

            // Algunas correcciones para los browses de arrays.
            oBrw:GoTopBlock    := {|| nSelect := 1 }
            oBrw:GoBottomBlock := {|| nSelect := Len( aDsFct ) }
            oBrw:SkipBlock     := { | nSkip, nDo | ;
                                ( nSelect := Min( Max( ( nDo := nSelect ) + ;
                                  nSkip, 1 ), len( aDsFct ) ) ) - nDo }

            COLUMN TITLE "C¢digo" ;
                SHOW aDsFct[ nSelect ][ DES_CODPRO ] ;
                WIDTH 10 ;
                PICTURE "9999999999"

            COLUMN TITLE "Nombre" ;
                SHOW aDsFct[ nSelect ][ DES_NOMBRE ] ;
                WIDTH 24

            COLUMN TITLE "Cant" ;
                SHOW aDsFct[ nSelect ][ DES_CANT ] ;
                PICTURE "9999" ;
                WIDTH 4

            COLUMN TITLE "Unidad" ;
                SHOW aDsFct[ nSelect ][ DES_PVP ] ;
                PICTURE "999999" ;
                WIDTH 6

            COLUMN TITLE "D." ;
                SHOW aDsFct[ nSelect ][ DES_DESCU ] ;
                PICTURE "99" ;
                WIDTH 2

            COLUMN TITLE "Parcial" ;
                SHOW Transform( aDsFct[ nSelect ][ DES_PARCIAL ], "9999999" ) ; // PICTURE "9999999" ;
                WIDTH 7

        ENDBROWSE

        @ 10,  1 LISTBOX oLbx BROWSE oBrw OF oWndFac ;
            LABEL "&Descripci¢n:" ;
            SIZE 62, 8 ;
            LOGICLEN Len( aDsFct ) // ; WHEN .F.

        // Ponemos el filtro de teclas de la ventana
        oWndFac:bKey := {|nKey| FactKey( nKey ) }

        // Ponemos los datos.
        PonFac()

        // Abrimos las ventanas de facturaci¢n y descripci¢n.
        ACTIVATE WINDOW oWndFac ;
            NOWAIT ;
            CENTERED ;
            VALID oWndFac := NIL, .T.

    Else

        oWndFac:SetCurrent()
        If oWndFac:lMinimized()
            oWndFac:Normal()
        EndIf

    EndIf

    CursorArrow()

Return NIL

// -------------------------------------------------------------------------- //
Static Function FactKey( nKey )
    Do Case
        Case nKey == K_PGUP
            nKey := K_ALT_A
        Case nKey == K_PGDN
            nKey := K_ALT_S
        Case nKey == K_INS
            nKey := K_ALT_INS
        Case nKey == K_DEL
            nKey := K_ALT_DEL
    EndCase
Return nKey

// -------------------------------------------------------------------------- //
Static Function FactMenu()
    Local oMenu

    // Definimos el menu de Facturas
    MENU oMenu

        MENUITEM "&Editar" ;
            MESSAGE "Crear, borrar, modificar facturas"
        MENU
            MENUITEM "&A¤adir     Alt-Ins" ;
                SHORTCUT K_ALT_INS ;
                MESSAGE "Crear una nueva factura" ;
                ACTION EdiFac( .T. )

            MENUITEM "&Modificar  Alt-F2" ;
                SHORTCUT K_ALT_F2 ;
                MESSAGE "Modificar la factura" ;
                ACTION EdiFac()

            MENUITEM "&Borrar     Alt-Del" ;
                SHORTCUT K_ALT_DEL ;
                MESSAGE "Borrar la factura" ;
                ACTION BorFac()

        ENDMENU

        MENUITEM "&Desplazar" ;
            MESSAGE "Ir a la factura siguiente, anterior, primera, £ltima, ..."
        MENU
            MENUITEM "&Siguiente        Alt-S" ;
                SHORTCUT K_ALT_S ;
                MESSAGE "Ir a la siguiente factura" ;
                ACTION oFacturac:Skip( 1 ), ;
                       If( oFacturac:Eof(), ;
                       ( oFacturac:Skip( -1 ), Tone( 800 ) ), PonFac() )

            MENUITEM "&Anterior         Alt-A" ;
                SHORTCUT K_ALT_A ;
                MESSAGE "Ir a la factura anterior" ;
                ACTION oFacturac:Skip( -1 ), ;
                       If( oFacturac:Bof(), Tone( 800 ), PonFac() )

            MENUITEM "&Registro n£mero  Alt-R" ;
                SHORTCUT K_ALT_R ;
                MESSAGE "Ir a la factura del registro n£mero..." ;
                ACTION GetReg()


            MENUITEM "&Primero          Alt-P" ;
                SHORTCUT K_ALT_P ;
                MESSAGE "Ir a la primera factura" ;
                ACTION oFacturac:GoTop(), PonFac()

            MENUITEM "&Ultimo           Alt-U" ;
                SHORTCUT K_ALT_U ;
                MESSAGE "Ir a la £ltima factura" ;
                ACTION oFacturac:GoBottom(), PonFac()

        ENDMENU

        MENUITEM "&Buscar" ;
            MESSAGE "Localizar una factura por C¢digo, C¢digo de cliente, Fecha"
        MENU

            MENUITEM "Por &C¢digo" ;
                MESSAGE "Buscar una factura por el c¢digo" ;
                ACTION ScanCodigo()

            MENUITEM "Por C¢digo C&liente" ;
                MESSAGE "Buscar una factura por el c¢digo de cliente" ;
                ACTION ScanCodCli()

            MENUITEM "Por &Fecha" ;
                MESSAGE "Buscar una factura por su fecha" ;
                ACTION ScanFecha()

        ENDMENU
    ENDMENU

Return oMenu

// -------------------------------------------------------------------------- //
Static Function ScanFecha()
    Static dFecha
    Local nRecNo

    DEFAULT dFecha := Date()

    If lMsgGet( "Introduzca Fecha", "&Fecha: ", @dFecha )
        nRecNo := oFacturac:RecNo()
        oFacturac:SetOrder( ORD_FAC_CODDIA )
        If oFacturac:Seek( dFecha )
            PonFac()
        Else
            MsgStop( "No encontrada la fecha: " + CRLF + ;
                     DToC( dFecha ), "Informaci¢n" )
            oFacturac:GoTo( nRecNo )
        EndIf
        oFacturac:SetOrder( ORD_FAC_CODIGO )
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function ScanCodCli()
    Static cCodigo
    Local nRecNo

    DEFAULT cCodigo := Space( 10 )

    If lMsgGet( "Introduzca C¢digo Cliente", "&C¢digo Cliente: ", @cCodigo )
        nRecNo := oFacturac:RecNo()
        oFacturac:SetOrder( ORD_FAC_CODCLI )
        If oFacturac:Seek( cCodigo )
            PonFac()
        Else
            MsgStop( "No encontrado el c¢digo de cliente: " + CRLF + ;
                     cCodigo, "Informaci¢n" )
            oFacturac:GoTo( nRecNo )
        EndIf
        oFacturac:SetOrder( ORD_FAC_CODIGO )
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function ScanCodigo()
    Static cCodigo
    Local nRecNo

    DEFAULT cCodigo := Space( 10 )

    If lMsgGet( "Introduzca c¢digo", "&C¢digo: ", @cCodigo )
        nRecNo := oFacturac:RecNo()
        If oFacturac:Seek( cCodigo )
            PonFac()
        Else
            MsgStop( "No encontrado el c¢digo: " + CRLF + ;
                     cCodigo, "Informaci¢n" )
            oFacturac:GoTo( nRecNo )
        EndIf
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function GetReg()
    Static nReg := 1
    If lGetReg( @nReg, oFacturac:RecCount() ) .And. nReg != oFacturac:RecNo()
        oFacturac:Goto( nReg )
        PonFac()
    EndIf
Return NIL


// -------------------------------------------------------------------------- //
Static Function BorFac()

    If MsgYesNo( "Seguro de borrar la factura: " + oFacturac:Codigo, ;
                 "Confirmaci¢n de borrado" )

        // Busca la factura en la base de facturac
        If oDescFact:Seek( oFacturac:Codigo )
            // Mientras pertenezca a la misma factura
            Do While oDescFact:Codigo == oFacturac:Codigo
                oDescFact:Delete()
                oDescFact:Skip( 1 )
            EndDo
        EndIf

        // Borra la factura en la base de facturas
        oFacturac:Delete()

        // Vamos al siguiente registro
        oFacturac:Skip( -1 )

        // Actualizamos la ventana de facturas
        PonFac()

    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function PonFac()

    oWndFac:BeginPaint()
    // Ponemos los datos
    oWndFac:Say(  1, 10, oFacturac:Codigo,          W__BG )
    oWndFac:Say(  1, 38, DToC( oFacturac:Fecha ),   W__BG )
    oWndFac:Say(  1, 53, oFacturac:Hora,            W__BG )
    oWndFac:Say(  4, 12, oFacturac:CodCli,          W__BG )

    // Los datos del cliente
    PonCliDat( oWndFac )

    // Actualizamos la ventana de Descripcion de factura.
    // oLbx:acItems := aDsFct
    oLbx:Reset()

    oWndFac:EndPaint()

Return NIL

// -------------------------------------------------------------------------- //
// Pone los datos del cliente
Static Function PonCliDat( oWndFac )

    oWndFac:BeginPaint()

    oWndFac:Say(  4, 29, aClte[ FAC_CLI_NIF ],           W__BG )
    oWndFac:Say(  4, 54, aClte[ FAC_CLI_COD ],           W__BG )
    oWndFac:Say(  5, 10, aClte[ FAC_CLI_NOM ],           W__BG )
    oWndFac:Say(  5, 54, Str( aClte[ FAC_CLI_CAN ], 4 ), W__BG )
    oWndFac:Say(  6, 13, aClte[ FAC_CLI_DOM ],           W__BG )
    oWndFac:Say(  7, 13, aClte[ FAC_CLI_POB ],           W__BG )
    oWndFac:Say(  7, 38, aClte[ FAC_CLI_TEL ],           W__BG )

    oWndFac:EndPaint()

Return .T.

// -------------------------------------------------------------------------- //
Static Function PanFac( oWndFac )

    oWndFac:BeginPaint()

    oWndFac:Box3D(  0,  0,  2, 21, N_BG, BG__BG )
    oWndFac:Box3D(  0, 29,  2, 60, N_BG, BG__BG )
    oWndFac:Box3D(  3,  0,  8, 60, BG__BG, N_BG )
    oWndFac:Box3D(  9,  0, 18, 63, BG__BG, N_BG )

    oWndFac:Say(  1,  2, "C¢digo:",     GR__BG )
    oWndFac:Say(  1, 31, "Fecha:",      GR__BG )
    oWndFac:Say(  1, 47, "Hora:",       GR__BG )
    oWndFac:Say(  4,  2, "Cod.Cli.:",   GR__BG )
    oWndFac:Say(  4, 24, "NIF:",        GR__BG )
    oWndFac:Say(  5, 47, "Cant.:",      GR__BG )
    oWndFac:Say(  5,  2, "Nombre:",     GR__BG )
    oWndFac:Say(  7, 32, "Tel.:",       GR__BG )
    oWndFac:Say(  6,  2, "Domicilio:",  GR__BG )
    oWndFac:Say(  7,  2, "Poblaci¢n:",  GR__BG )
    oWndFac:Say(  4, 42, "Cod.Post.:",  GR__BG )

    oWndFac:EndPaint()

Return NIL

// -------------------------------------------------------------------------- //
Static Function EdiFac( lAppend )
    Local oFacWindow    // Ventana de Edici¢n
    Local oBrw, oLbx    // Browse y ListBox para edici¢n de descripci¢n
    Local oGetCodCli    // Get de c¢digo de cliente
    Local aDatosAnt     // Array con los datos anteriores de la factura

    DEFAULT lAppend := .F.

    // Se se va a a¤adir se inicializa el array de cliente
    If lAppend
        oFacturac:Blank()
        oFacturac:Codigo := Str( aCont()[ CONT_FAC ], 10 )
        oFacturac:Fecha  := Date()
        oFacturac:Hora   := Left( Time(), 5 )
    Else
        // Salvamos el array para actualizar el almacen.
        aDatosAnt := aClone( aDsFct )
    EndIf

    // Creamos la ventana de facturaci¢n.
    DEFINE WINDOW oFacWindow ;
        FROM  1,  7 TO 23, 72 ;
        TITLE " Facturaci¢n " ;
        NOMAXIMIZE ;
        NOMINIMIZE ;
        NORESIZE

    SET MESSAGE OF oFacWindow TO "Ventana de facturaci¢n"

    // Ponemos la pantalla.
    PanFac( oFacWindow )

    // Ponemos el codigo
    oFacWindow:Say( 1, 10, oFacturac:Codigo, GR__BG )

    // Ponemos los datos del actual cliente.
    PonCliDat( oFacWindow )

    // A¤adimos los Gets
    @  1, 38 GET oFacturac:Fecha ;
        OF oFacWindow

    @  1, 53 GET oFacturac:Hora ;
        PICTURE "99:99" ;
        OF oFacWindow

    @  4, 12 GET oGetCodCli VAR oFacturac:CodCli OF oFacWindow ;
        VALID !Empty( oFacturac:CodCli ) .And. ;
              ( IsCliente( oFacturac ) .And. ;
                ( oGetCodCli:oGet:UpdateBuffer(), ;
                  PonCliDat( oFacWindow ) ) )

    // Ponemos el Browse.
    BEGIN BROWSE oBrw ALIAS aDsFct ; //
        COLOR "W+/BG,GR+/B,W+/B"

        // Algunas correcciones para los browses de arrays.
        oBrw:GoTopBlock    := {|| nSelect := 1 }
        oBrw:GoBottomBlock := {|| nSelect := Len( aDsFct ) }
        oBrw:SkipBlock     := { | nSkip, nDo | ;
                            ( nSelect := Min( Max( ( nDo := nSelect ) + ;
                              nSkip, 1 ), len( aDsFct ) ) ) - nDo }

        COLUMN TITLE "C¢digo" ;
            SHOW aDsFct[ nSelect ][ DES_CODPRO ] ;
            WIDTH 10 ;
            PICTURE "9999999999"

        COLUMN TITLE "Nombre" ;
            SHOW aDsFct[ nSelect ][ DES_NOMBRE ] ;
            WIDTH 24

        COLUMN TITLE "Cant" ;
            SHOW aDsFct[ nSelect ][ DES_CANT ] ;
            PICTURE "9999" ;
            WIDTH 4

        COLUMN TITLE "Unidad" ;
            SHOW aDsFct[ nSelect ][ DES_PVP ] ;
            PICTURE "999999" ;
            WIDTH 6

        COLUMN TITLE "D." ;
            SHOW aDsFct[ nSelect ][ DES_DESCU ] ;
            PICTURE "99" ;
            WIDTH 2

        COLUMN TITLE "Parcial" ;
            SHOW Transform( aDsFct[ nSelect ][ DES_PARCIAL ], "9999999" ) ; // PICTURE "9999999" ;
            WIDTH 7

    ENDBROWSE

    @ 10,  1 LISTBOX oLbx BROWSE oBrw OF oFacWindow ;
        LABEL "&Descripci¢n:" ;
        SIZE 62, 8 ;
        ON DBLCLICK If( nSelect < Len( aDsFct ), ; //ON DBLCLICK If( oLbx:oBrowse:Cargo < Len( aDsFct ), ;
                        EditDes( oLbx ), )  ;
        LOGICLEN Len( aDsFct ) // ; WHEN .F.

    // Ponemos el procesador de teclas por defecto.
    oLbx:bKey := {|nKey| EditBrow( nKey, oLbx ) }

    @ 19, 35 BUTTON " &Salvar " OF oFacWindow ;
        WHEN Len( aDsFct ) > 1 ;
        ACTION SaveFact( lAppend, aDatosAnt, oFacWindow, oLbx )

    @ 19, 47 BUTTON " &Cancelar " OF oFacWindow ;
        ACTION oFacturac:Load(), oFacWindow:Close()

    // Abrimos la ventana de edici¢n
    ACTIVATE WINDOW oFacWindow ;
        ON INIT oWndFac:Minimize() ;
        ON CLOSE oWndFac:Normal() ;

Return NIL

// -------------------------------------------------------------------------- //
Static Function lCobro()
    Local lValor := .F.
    Local oWndCob
    Local oGet
    Local nCantidad, nEntregado, nDevolver

    nCantidad  := aTail( aDsFct )[ DES_PARCIAL ]
    nEntregado := 0
    nDevolver  := 0

    DEFINE WINDOW oWndCob ;
        FROM  8, 29 TO 17, 55 ;
        TITLE "Cobro" ;
        NOMINIMIZE ;
        NOMAXIMIZE ;
        NORESIZE

    // Ponemos los marcos
    oWndCob:Box3D(  0,  0,  4, 24 )

    @  1,  3 GET nCantidad  ;
        LABEL "A &cobrar  : " ;
        PICTURE "9999999" ;
        OF oWndCob

    @  2,  3 GET nEntregado OF oWndCob ;
        LABEL "&Entregado : " ;
        PICTURE "9999999" ;
        VALID nEntregado >= nCantidad .And. ;
              ( nDevolver := nEntregado - nCantidad, ;
                oGet:Refresh(), .T. )

    @  3,  3 GET oGet VAR nDevolver  ;
        LABEL "A &devolver: " ;
        WHEN .F. ;
        PICTURE "9999999" ;
        OF oWndCob

    @  6,  1 BUTTON " &Aceptar "  OF oWndCob ;
        ACTION lValor := .T., oWndCob:Close()

    @  6, 13 BUTTON " &Cancelar " OF oWndCob ;
        ACTION oWndCob:Close()

    ACTIVATE WINDOW oWndCob

Return lValor

// -------------------------------------------------------------------------- //
Static Function SaveFact( lAppend, aDatosAnt, oFacWindow, oLbx )
    // Solo cuando se crea
    If lAppend
        /*
        // Ponemos la cantidad en el display de cantidad.
        SetTotalCant( aTail( aDsFct )[ DES_PARCIAL ] )
        */
        // Si se ha abortado el cobro
        If !lCobro()
            Return NIL
        EndIf
        oFacturac:Append()
        aCont()[ CONT_FAC ]++
        Array2F( aCont(), "MegaReco.Dat" )
    Else
        // Actualiza la base almacen.
        ActAlm( aDatosAnt, .T. )
    EndIf
    // Actualiza los datos del almacen.
    ActAlm( aDsFct )
    // Salva los datos de la factura.
    oFacturac:Save()
    PonFac()
    oFacWindow:Close()
Return NIL

// -------------------------------------------------------------------------- //
Static Function EditBrow( nKey, oLbx )      // Tecla a procesar y el browse.
    Local nPtr, aDatos
    Do Case
        Case nKey == K_INS          // Insertar un nuevo elemento
            EditDes( oLbx, .T. )

        Case nKey == K_DEL          // Borrar el elmento actual

            nPtr := nSelect // nPtr := oLbx:oBrowse:Cargo

            aDatos := aDsFct

            // Si hay mas de un elemento
            If nPtr < Len( aDatos )

                If MsgYesNo( "Seguro de borrar el c¢digo: " + ;
                                  aDatos[ nPtr ][ DES_CODPRO ], ;
                            "Confirmaci¢n de borrado" )

                    aTail( aDatos )[ DES_PARCIAL ] := ;
                          aTail( aDatos )[ DES_PARCIAL ] - ;
                          aDatos[ nPtr ][ DES_PARCIAL ]

                    aDel( aDatos, nPtr )

                    aSize( aDatos, Len( aDatos ) - 1 )

                    oLbx:Refresh()

                EndIf

            EndIf

        /*
        Case nKey == K_ENTER        // Editar el elemento actual
            // Si no es el £ltimo elemento.
            If oLbx:oBrowse:Cargo < Len( aDsFct )
                EditDes( oLbx ) // Edita el elmento actual
            EndIf
        */

        OtherWise
            Return nKey

    EndCase

Return 0

// -------------------------------------------------------------------------- //
Static Function EditDes( oLbx, lAppend )
    Local oWndEdit
    Local aEdit
    Local oGetCodPro    // Get del codigo del producto
    Local oGetCant      // Get de la cantidad
    Local oGetPVP       // Get del precio
    Local nAntParcial   // Parcial antes de la edici¢n.

    DEFAULT lAppend := .F.

    If lAppend
        aEdit := { Space( 10 ), Space( 24 ), 0, 0, 0, 0 }
    Else
        aEdit := aClone( aDsFct[ nSelect ] ) // aEdit := aClone( aDsFct[ oLbx:oBrowse:Cargo ] )
    EndIf

    nAntParcial := aEdit[ DES_PARCIAL ]

    DEFINE WINDOW oWndEdit ;
        FROM  4, 18 TO 17, 53 ;
        TITLE If( lAppend, "A¤adir producto", "Edici¢n de producto" ) ;
        NOMINIMIZE ;
        NOMAXIMIZE ;
        NORESIZE

    // Ponemos los marcos
    oWndEdit:Box3D(  0,  0,  8, 33 )

    // Ponemos las etiquetas.
    oWndEdit:Say(  3,  1, "Nombre:", GR__BG )
    oWndEdit:Say(  3,  9,  Left( aEdit[ DES_NOMBRE ], 24 ), BG__BG )

    @  1,  1 GET oGetCodPro VAR aEdit[ DES_CODPRO ] OF oWndEdit ;
        LABEL "&C¢digo: " ;
        VALID !Empty( aEdit[ DES_CODPRO ] ) .And. ;
               IsProducto( aEdit ) .And. ;
               ( oGetCodPro:oGet:UpdateBuffer(), ;
                 oWndEdit:Say(  3,  9,  Left( aEdit[ DES_NOMBRE ], 24 ), BG__BG ), ;
                 oGetCant:Refresh(), oGetPVP:Refresh(), ;
                 .T. )

    @  5,  1 GET oGetCant VAR aEdit[ DES_CANT   ] OF oWndEdit ;
        LABEL "C&antidad: " ;
        VALID aEdit[ DES_CANT ] > 0 .And. ( !lAppend .Or. IsCantidad( aEdit ) ) ;
        PICTURE "9999"

    @  5, 17 GET aEdit[ DES_DESCU   ] OF oWndEdit ;
        LABEL "&Descuento: " ;
        PICTURE "@E 99"

    @  7,  1 GET oGetPVP VAR aEdit[ DES_PVP    ] OF oWndEdit ;
        LABEL "&P.V.P.: " ;
        PICTURE "999999"

    @ 10,  6 BUTTON " &Aceptar " OF oWndEdit ;
        ACTION ( oWndEdit:Close(), ;
                If( lAppend, ( aSize( aDsFct, Len( aDsFct ) + 1 ), ;
                               aIns( aDsFct, nSelect ) ), ; // aIns( aDsFct, oLbx:oBrowse:Cargo ) ), ;
                             NIL ), ;
                aEdit[ DES_PARCIAL ] := aEdit[ DES_CANT ] * aEdit[ DES_PVP  ], ;
                If( aEdit[ DES_DESCU ] > 0, ;
                    aEdit[ DES_PARCIAL ] -= Int( aEdit[ DES_PARCIAL ] * ;
                                        ( aEdit[ DES_DESCU ] / 100 ) ), ), ;
                aDsFct[ nSelect ] := aEdit, ; // aDsFct[ oLbx:oBrowse:Cargo ] := aEdit, ;
                ( aTail( aDsFct )[ DES_PARCIAL ] := ;
                aTail( aDsFct )[ DES_PARCIAL ] - ;
                nAntParcial + aEdit[ DES_PARCIAL ] ), ;
                oLbx:Refresh() )

    @ 10, 19 BUTTON " &Cancelar " OF oWndEdit ;
        ACTION oWndEdit:Close()

    ACTIVATE WINDOW oWndEdit

Return NIL

// -------------------------------------------------------------------------- //
