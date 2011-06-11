// -------------------------------------------------------------------------- //
// Fichero para mantenimiento de clientes.
// -------------------------------------------------------------------------- //

#include "MegaReco.ch"
#include "Icons.ch"

Static oWndCli                      // Ventana de clientes.
Static oClientes                    // Referencia al objeto clientes

// -------------------------------------------------------------------------- //
// Caja de Edicion de Clientes.
Function Clientes()
    Local oBar,;
          cVar  := IMG_VARNAME  // Nombre del array de recursos Bitmaps

    CursorWait()

    If oWndCli == NIL

        // Da valores por defecto.
        DEFAULT oClientes := GetClientes()

        // Creamos la ventana de clientes
        DEFINE WINDOW oWndCli ;
            FROM  3,  5 TO 18, 72 ;
            TITLE " Clientes " ;
            NOMAXIMIZE ;
            NORESIZE ;
            MENU MenuCli()

        SET MESSAGE OF oWndCli TO "Ventana de Clientes"

        DEFINE BUTTONBAR oBar OF oWndCli

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_TOP ;
            MESSAGE "Va al primer cliente." ;
            TIPS "Va al primer cliente." ;
            ACTION oClientes:GoTop(), PonCli()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_LEFT ;
            MESSAGE "Va al anterior cliente." ;
            TIPS "Va al anterior cliente." ;
            ACTION oClientes:Skip( -1 ), ;
                   If( oClientes:Bof(), Tone( 800 ), PonCli() )

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_RIGHT ;
            MESSAGE "Va al siguiente cliente." ;
            TIPS "Va al siguiente cliente." ;
            ACTION oClientes:Skip( 1 ), ;
                   If( oClientes:Eof(), ;
                   ( oClientes:Skip( -1 ), Tone( 800 ) ), PonCli() )

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_BOTTOM ;
            MESSAGE "Va al £ltimo cliente." ;
            TIPS "Va al £ltimo cliente." ;
            ACTION oClientes:GoBottom(), PonCli()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_EDIT ;
            GROUP ;
            MESSAGE "Edita el cliente." ;
            TIPS "Edita el cliente." ;
            ACTION EdiCli()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_ADD ;
            MESSAGE "A¤ade un cliente." ;
            TIPS "A¤ade un cliente." ;
            ACTION EdiCli( .T. )

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_TRASH ;
            MESSAGE "Borra el cliente." ;
            TIPS "Borra el cliente." ;
            ACTION DelCli()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_SEEK ;
            LABEL "Nombre" ;
            GROUP ;
            MESSAGE "Buscar un cliente por Nombre." ;
            TIPS "Buscar un cliente por Nombre." ;
            ACTION ScanName()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_SEEK ;
            LABEL "C¢digo" ;
            MESSAGE "Buscar un cliente por C¢digo." ;
            TIPS "Buscar un cliente por C¢digo." ;
            ACTION ScanCodigo()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_SEEK ;
            LABEL "NIF" ;
            MESSAGE "Buscar un cliente por NIF." ;
            TIPS "Buscar un cliente por NIF." ;
            ACTION ScanNIF()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_PRINTER ;
            GROUP ;
            MESSAGE "Imprimir clientes" ;
            TIPS "Imprimir clientes" ;
            ACTION NIL

        // Ponemos la pantalla
        PanCli( oWndCli )

        // Ponemos los datos.
        PonCli()

        ACTIVATE WINDOW oWndCli ;
            NOWAIT ;
            CENTERED ;
            VALID oWndCli := NIL, .T.

    Else

        oWndCli:SetCurrent()
        if oWndCli:lMinimized
            oWndCli:Normal()
        EndIf

    EndIf

    CursorArrow()

Return NIL

// -------------------------------------------------------------------------- //
Static Function MenuCli()
    Local oMenu

    // Definimos el menu de Clientes
    MENU oMenu

        MENUITEM "&Editar" ;
            MESSAGE "Crear, borrar, modificar cliente"
        MENU
            MENUITEM "&A¤adir     Alt-Ins" ;
                SHORTCUT K_ALT_INS ;
                MESSAGE "Crear un nuevo cliente" ;
                ACTION EdiCli( .T. )

            MENUITEM "&Modificar  Alt-F2" ;
                SHORTCUT K_ALT_F2 ;
                MESSAGE "Modificar el cliente" ;
                ACTION EdiCli()

            MENUITEM "&Borrar     Alt-Supr" ;
                SHORTCUT K_ALT_DEL ;
                MESSAGE "Borrar el cliente" ;
                ACTION DelCli()

        ENDMENU

        MENUITEM "&Desplazar" ;
            MESSAGE "Ir al cliente siguiente, anterior, primero, £ltimo, ..."
        MENU
            MENUITEM "&Siguiente        Alt-S";
                SHORTCUT K_ALT_S ;
                MESSAGE "Ir al siguiente cliente" ;
                ACTION oClientes:Skip( 1 ), ;
                        If( oClientes:Eof(), ( oClientes:Skip( -1 ), ;
                            Tone( 800 ) ), PonCli() )

            MENUITEM "&Anterior         Alt-A" ;
                SHORTCUT K_ALT_A ;
                MESSAGE "Ir al anterior cliente" ;
                ACTION oClientes:Skip( -1 ), ;
                       If( oClientes:Bof(), Tone( 800 ), PonCli() )

            MENUITEM "&Registro n£mero  Alt-R" ;
                SHORTCUT K_ALT_R ;
                MESSAGE "Ir al cliente del registro n£mero..." ;
                ACTION GetReg()

            MENUITEM "&Primero          Alt-P" ;
                SHORTCUT K_ALT_P ;
                MESSAGE "Ir al primer cliente" ;
                ACTION oClientes:GoTop(), PonCli()

            MENUITEM "&Ultimo           Alt-U" ;
                SHORTCUT K_ALT_U ;
                MESSAGE "Ir al £ltimo cliente" ;
                ACTION oClientes:GoBottom(), PonCli()

        ENDMENU

        MENUITEM "&Buscar" ;
            MESSAGE "Localizar un cliente por Nombre, NIF, C¢digo"
        MENU

            MENUITEM "Por &C¢digo" ;
                MESSAGE "Buscar un cliente por el c¢digo" ;
                ACTION ScanCodigo()

            MENUITEM "Por &Nombre" ;
                MESSAGE "Buscar un cliente por su nombre" ;
                ACTION ScanName()

            MENUITEM "Por N&IF" ;
                MESSAGE "Buscar un cliente por su NIF" ;
                ACTION ScanNIF()

        ENDMENU

    ENDMENU

Return oMenu

// -------------------------------------------------------------------------- //
Static Function GetReg()
    Static nReg := 1
    If lGetReg( @nReg, oClientes:RecCount() ) .And. nReg != oClientes:RecNo()
        oClientes:Goto( nReg )
        PonCli()
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function DelCli()
    If MsgYesNo( "Seguro de borrar el cliente", "Confirmaci¢n de borrado" )
        oClientes:Delete()
        oClientes:Skip( -1 )
        PonCli()
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function ScanNIF()
    Local nRecNo
    Static cNif

    DEFAULT cNif := Space( 10 )

    If lMsgGet( "Introduzca el NIF", "NIF: ", @cNif )
        oClientes:SetOrder( ORD_CLI_NIF )
        nRecNo := oClientes:RecNo()
        If oClientes:Seek( cNif )
            PonCli()
        Else
            MsgStop( "No encontrado el NIF: " + CRLF + ;
                     cNif, "Informaci¢n" )
            oClientes:GoTo( nRecNo )
        EndIf
        oClientes:SetOrder( ORD_CLI_CODIGO )
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function ScanCodigo()
    Local nRecNo
    Static cCodigo

    DEFAULT cCodigo := Space( 10 )

    If lMsgGet( "Introduzca el c¢digo", "C¢digo: ", @cCodigo )
        nRecNo := oClientes:RecNo()
        If oClientes:Seek( cCodigo )
            PonCli()
        Else
            MsgStop( "No encontrado el c¢digo: " + CRLF + ;
                     cCodigo, "Informaci¢n" )
            oClientes:GoTo( nRecNo )
        EndIf
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function ScanName()
    Local nRecNo
    Static cNombre

    DEFAULT cNombre := Space( 35 )

    If lMsgGet( "Introduzca el nombre", "Nombre: ", @cNombre )

        nRecNo := oClientes:RecNo()

        oClientes:SetOrder( ORD_CLI_NOMBRE )

        If oClientes:Seek( AllTrim( cNombre ) )

            PonCli()

        Else

            MsgStop( "No encontrado el Cliente: " + CRLF + ;
                AllTrim( cNombre ), "Informaci¢n" )

            oClientes:GoTo( nRecNo )

        EndIf

        oClientes:SetOrder( ORD_CLI_CODIGO )

    EndIf

Return NIL

// -------------------------------------------------------------------------- //
Static Function PanCli( oWnd )

    // Ponemos los controles en la ventana
    oWnd:Box3D(  0,  1,  2, 22, N_BG, BG__BG )
    oWnd:Box3D(  0, 39,  2, 64, N_BG, BG__BG )
    oWnd:Box3D(  3,  1, 11, 64, BG__BG, N_BG )

    // Pone las etiquetas
    oWnd:Say(  1,  3, "C¢digo:",       W__BG )
    oWnd:Say(  1, 41, "Ultima fecha:", W__BG )
    oWnd:Say(  4,  3, "Nombre:",       W__BG )
    oWnd:Say(  4, 48, "NIF:",          W__BG )
    oWnd:Say(  6,  3, "Domicilio:",    W__BG )
    oWnd:Say(  8,  3, "Poblaci¢n:",    W__BG )
    oWnd:Say(  8, 34, "Cod.Post.:",    W__BG )
    oWnd:Say( 10,  3, "Tel‚fono:",     W__BG )
    oWnd:Say( 10, 31, "Cantidad:",     W__BG )
    oWnd:Say( 10, 46, "Desc.:",        W__BG )

Return NIL

// -------------------------------------------------------------------------- //
// Pone los datos del paciente en la ventana de clientes
Static Function PonCli()

    oWndCli:Say(  1, 11, oClientes:Codigo,    GR__BG )
    oWndCli:Say(  1, 55, DToC( oClientes:UltFecha ),  GR__BG )
    oWndCli:Say(  4, 11, oClientes:Nombre,    GR__BG )
    oWndCli:Say(  4, 53, oClientes:NIF,       GR__BG )
    oWndCli:Say(  6, 14, oClientes:Domicilio, GR__BG )
    oWndCli:Say(  8, 14, oClientes:Poblacion, GR__BG )
    oWndCli:Say(  8, 45, oClientes:CodPost,   GR__BG )
    oWndCli:Say( 10, 13, oClientes:Telefono,  GR__BG )
    oWndCli:Say( 10, 41, Str( oClientes:Cantidad, 4 ),  GR__BG )
    oWndCli:Say( 10, 53, Str( oClientes:Descuento, 5 ), GR__BG )

Return NIL

// -------------------------------------------------------------------------- //
// Edita los datos del paciente en la ventana de clientes.
Static Function EdiCli( lAppend )
    Local oCliWnd
    Local lRetVal := .F.    // Valor para saber si se ha aceptado o no.

    DEFAULT lAppend := .F.

    // Se se va a a¤adir se inicializa el array de cliente.
    If lAppend
        oClientes:Blank()
        oClientes:UltFecha := Date()
        oClientes:Codigo := Str( aCont()[ CONT_CLI ], 10 )
    EndIf

    // Creamos la ventana de clientes.
    DEFINE WINDOW oCliWnd ;
        FROM  3,  5 TO 18, 72 ;
        TITLE If( lAppend, "Crear Cliente", "Edici¢n de Clientes" ) ;
        NOMAXIMIZE ;
        NOMINIMIZE ;
        NORESIZE

    SET MESSAGE OF oCliWnd TO "Ventana de Clientes"

    // Ponemos la pantalla de clientes.
    PanCli( oCliWnd )

    oCliWnd:Say(  1, 55, DToC( oClientes:UltFecha ), GR__BG )
    oCliWnd:Say(  1, 11, oClientes:Codigo, GR__BG )

    @  4, 11 GET oClientes:Nombre       OF oCliWnd
    @  4, 53 GET oClientes:NIF          OF oCliWnd PICTURE "@!"
    @  6, 14 GET oClientes:Domicilio    OF oCliWnd
    @  8, 14 GET oClientes:Poblacion    OF oCliWnd PICTURE "@!"
    @  8, 45 GET oClientes:CodPost      OF oCliWnd
    @ 10, 13 GET oClientes:Telefono     OF oCliWnd
    @ 10, 41 GET oClientes:Cantidad     OF oCliWnd PICTURE "@E 9999"
    @ 10, 53 GET oClientes:Descuento    OF oCliWnd PICTURE "@E 99.99"

    @ 12, 40 BUTTON " &Salvar " OF oCliWnd ;
        ACTION ( If( lAppend, ;
                   ( oClientes:Append(), ;
                     aCont()[ CONT_CLI ]++, ;
                     Array2F( aCont(), "MegaReco.Dat" ) ), ), ;
               oClientes:Save(), ;
               If( oWndCli != NIL, PonCli(), ), ;
               lRetVal := .T., ;
               oCliWnd:Close() )

    @ 12, 52 BUTTON " &Cancelar " OF oCliWnd ;
        ACTION oClientes:Load(), oCliWnd:Close()

    ACTIVATE WINDOW oCliWnd ;
        ON INIT If( oWndCli != NIL, oWndCli:Minimize(), ) ;
        ON CLOSE If( oWndCli != NIL, oWndCli:Normal(), )

Return lRetVal

// -------------------------------------------------------------------------- //
Function IsCliente( oFacturac )     // Se le pasa el array con la factura
    Local lValor                    // Valor de retorno
    Local nReg                      // Registro en la base de clientes.
    Local oWndBrow                  // Ventana en la que se hace el brow
    Local oLbx                      // Brow de clientes
    Local cName := Space( 35 ), nRecNo

    DEFAULT oClientes := GetClientes()

    nReg := oClientes:RecNo()

    If !( lValor := oClientes:Seek( oFacturac:CodCli ) )

        // Si no se ha encontrado
        If nMsgBox( "C¢digo de cliente no encontrado", ;
                   "Atenci¢n", { " &Cancelar ", " &Listar " },, ;
                   ICO_STOP, "GR+/B" ) == 2

            // Para que no este al final
            oClientes:GoTop()

            // Se hace un Browse de CLIENTES.
            DEFINE WINDOW oWndBrow ;
                FROM 4, 5 TO 22, 59 ;
                TITLE "Seleccione Cliente" ;
                NOMAXIMIZE ;
                NOMINIMIZE ;
                NORESIZE

            @  1,  1 LISTBOX oLbx ;
                FIELDS oClientes:Codigo, oClientes:Nombre  ;
                HEADERS "C¢digo", "Nombre" ;
                LABEL "C&lientes" ;
                ALIAS oClientes ;
                SIZE 51, 13 OF oWndBrow ;
                ON DBLCLICK lValor := .T., ;
                            oFacturac:CodCli := oClientes:Codigo, ;
                            oWndBrow:Close() ;
                LOGICLEN oClientes:RecCount()


            @ 15,  2 BUTTON " &Buscar " OF oWndBrow ;
                ACTION If( lMsgGet( "Introduzca el nombre", "Nombre: ", @cName ), ;
                            ( nRecNo := oClientes:RecNo(), ;
                              oClientes:SetOrder( ORD_CLI_NOMBRE ), ;
                              If( !oClientes:Seek( AllTrim( cName ) ), ;
                                  ( MsgStop( "No encontrado el Cliente: " + CRLF + ;
                                    AllTrim( cName ), "Informaci¢n" ) , ;
                                    oClientes:GoTo( nRecNo ) ), ), ;
                              oClientes:SetOrder( ORD_CLI_CODIGO ), ;
                              oLbx:Invalidate(), oLbx:Refresh() ), )
                              // oLbx:oBrowse:Invalidate(), oLbx:Refresh() ), )

            @ 15, 13 BUTTON " &A¤adir " OF oWndBrow ;
                ACTION  If( EdiCli( .T. ), ;
                            ( lValor := .T., ;
                                oFacturac:CodCli := oClientes:Codigo, ;
                                oWndBrow:Close() ), NIL )

            @ 15, 24 BUTTON " &Seleccionar " OF oWndBrow ;
                ACTION lValor := .T., ;
                       oFacturac:CodCli := oClientes:Codigo, ;
                       oWndBrow:Close()

            @ 15, 40 BUTTON " &Cancelar " OF oWndBrow ;
                ACTION oWndBrow:Close()

            ACTIVATE WINDOW oWndBrow

        EndIf

    EndIf

    // Si se ha encontrado o si se ha elegido.
    If lValor

        // Tomamos los datos del cliente actual.
        oFacturac:aCliente := { oClientes:Nombre, ;
                                oClientes:NIF, ;
                                oClientes:Domicilio, ;
                                oClientes:Poblacion, ;
                                oClientes:CodPost, ;
                                oClientes:Telefono, ;
                                oClientes:Cantidad, ;
                                oClientes:UltFecha }

    EndIf

    oClientes:GoTo( nReg )

Return lValor

// -------------------------------------------------------------------------- //
