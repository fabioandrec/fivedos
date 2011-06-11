// -------------------------------------------------------------------------- //
// Funciones para el mantenimiento del almac‚n
// -------------------------------------------------------------------------- //

#include "MegaReco.ch"
#include "Icons.ch"
#include "report.ch"

Static oWndAlm                          // Referencia a la ventana de almacen.
Static oAlmacen                         // Referencia al objeto Almacen.

// -------------------------------------------------------------------------- //
Function Almacen()
    Local oBar,;
          cVar  := IMG_VARNAME  // Nombre del array de recursos Bitmaps

    CursorWait()

    If oWndAlm == NIL


        // Da valores por defecto.
        DEFAULT oAlmacen := GetAlmacen()

        // Creamos la ventana de clientes
        DEFINE WINDOW oWndAlm ;
            FROM  2,  8 TO 15, 73 ;
            TITLE " Almac‚n " ;
            NOMAXIMIZE ;
            NORESIZE ;
            MENU MenuAlm()

        SET MESSAGE OF oWndAlm TO "Ventana de almac‚n"

        DEFINE BUTTONBAR oBar OF oWndAlm

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_TOP ;
            MESSAGE "Va al primer producto." ;
            TIPS "Va al primer producto." ;
            ACTION oAlmacen:GoTop(), PonAlm()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_LEFT ;
            MESSAGE "Va al anterior producto." ;
            TIPS "Va al anterior producto." ;
            ACTION oAlmacen:Skip( -1 ), ;
                   If( oAlmacen:Bof(), Tone( 800 ), PonAlm() )

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_RIGHT ;
            MESSAGE "Va al siguiente producto." ;
            TIPS "Va al siguiente producto." ;
            ACTION oAlmacen:Skip( 1 ), ;
                   If( oAlmacen:Eof(), ;
                   ( oAlmacen:Skip( -1 ), Tone( 800 ) ), PonAlm() )

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_BOTTOM ;
            MESSAGE "Va al £ltimo producto." ;
            TIPS "Va al £ltimo producto." ;
            ACTION oAlmacen:GoBottom(), PonAlm()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_EDIT ;
            MESSAGE "Edita el producto." ;
            TIPS "Edita el producto." ;
            ACTION EdiAlm()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_ADD ;
            MESSAGE "A¤ade un producto." ;
            TIPS "A¤ade un producto." ;
            ACTION EdiAlm( .T. )

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_TRASH ;
            MESSAGE "Borra el producto." ;
            TIPS "Borra el producto." ;
            ACTION DelAlm()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_SEEK ;
            LABEL "Nombre" ;
            GROUP ;
            MESSAGE "Buscar un producto por Nombre." ;
            TIPS "Buscar un producto por Nombre." ;
            ACTION ScanName()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_SEEK ;
            LABEL "C¢digo" ;
            MESSAGE "Buscar un producto por C¢digo." ;
            TIPS "Buscar un producto por C¢digo." ;
            ACTION ScanCodigo()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_SEEK ;
            LABEL "Tipo" ;
            MESSAGE "Buscar un producto por Tipo." ;
            TIPS "Buscar un producto por Tipo." ;
            ACTION ScanTipo()

        DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_PRINTER ;
            GROUP ;
            MESSAGE "Imprimir productos" ;
            TIPS "Imprimir productos" ;
            ACTION CliReport()

        // Ponemos la pantalla
        PanAlm( oWndAlm )

        // Ponemos los datos
        PonAlm()

        ACTIVATE WINDOW oWndAlm ;
            NOWAIT ;
            CENTERED ;
            VALID oWndAlm := NIL, .T.

    Else

        oWndAlm:SetCurrent()
        If oWndAlm:lMinimized
            oWndAlm:Normal()
        EndIf

    EndIf

    CursorArrow()

Return NIL

// -------------------------------------------------------------------------- //
Static Function MenuAlm()
    Local oMenu

    // Definimos el menu de Clientes
    MENU oMenu
        MENUITEM "&Editar" ;
            MESSAGE "Crear, borrar, modificar producto"
        MENU
            MENUITEM "&A¤adir     Alt-Ins" ;
                SHORTCUT K_ALT_INS ;
                MESSAGE "Crear un nuevo producto" ;
                ACTION EdiAlm( .T. )

            MENUITEM "&Modificar  Alt-F2" ;
                SHORTCUT K_ALT_F2 ;
                MESSAGE "Modificar el producto" ;
                ACTION EdiAlm()

            MENUITEM "&Borrar     Alt-Del" ;
                SHORTCUT K_ALT_DEL ;
                MESSAGE "Borrar el producto" ;
                ACTION DelAlm()

        ENDMENU

        MENUITEM "&Desplazar" ;
            MESSAGE "Ir al producto siguiente, anterior, primero, £ltimo, ..."
        MENU
            MENUITEM "&Siguiente        Alt-S" ;
                SHORTCUT K_ALT_S ;
                MESSAGE "Ir al siguiente producto" ;
                ACTION oAlmacen:Skip( 1 ), ;
                       If( oAlmacen:Eof(), ;
                       ( oAlmacen:Skip( -1 ), Tone( 800 ) ), PonAlm() )

            MENUITEM "&Anterior         Alt-A" ;
                SHORTCUT K_ALT_A ;
                MESSAGE "Ir al anterior producto" ;
                ACTION oAlmacen:Skip( -1 ), ;
                       If( oAlmacen:Bof(), Tone( 800 ), PonAlm() )

            MENUITEM "&Registro n£mero  Alt-R" ;
                SHORTCUT K_ALT_R ;
                MESSAGE "Ir al producto del registro n£mero...";
                ACTION GetReg()

            MENUITEM "&Primero          Alt-P" ;
                SHORTCUT K_ALT_P ;
                MESSAGE "Ir al primer producto" ;
                ACTION oAlmacen:GoTop(), PonAlm()

            MENUITEM "&Ultimo           Alt-U" ;
                SHORTCUT K_ALT_U ;
                MESSAGE "Ir al £ltimo producto" ;
                ACTION oAlmacen:GoBottom(), PonAlm()

        ENDMENU

        MENUITEM "&Buscar" ;
            MESSAGE "Localizar un producto por Nombre, NIF, C¢digo"
        MENU

            MENUITEM "Por &C¢digo" ;
                MESSAGE "Buscar un producto por el c¢digo" ;
                ACTION ScanCodigo()

            MENUITEM "Por &Nombre" ;
                MESSAGE "Buscar un producto por su nombre" ;
                ACTION ScanName()

            MENUITEM "Por &Tipo" ;
                MESSAGE "Buscar un producto por su tipo" ;
                ACTION ScanTipo()

        ENDMENU

    ENDMENU

Return oMenu

// -------------------------------------------------------------------------- //
Static Function GetReg()
    Static nReg := 1
    If lGetReg( @nReg, oAlmacen:RecCount() ) .And. nReg != oAlmacen:RecNo()
        oAlmacen:Goto( nReg )
        PonAlm()
    EndIf
Return NIL


// -------------------------------------------------------------------------- //
Static Function DelAlm()
    If MsgYesNo( "Seguro de borrar el producto", "Confirmaci¢n de borrado" )
        oAlmacen:Delete()
        oAlmacen:Skip( -1 )
        PonAlm()
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function ScanTipo()
    Local nRecNo
    Static cTipo

    DEFAULT cTipo := Space( 10 )

    If lMsgGet( "Introduzca el Tipo", "Tipo: ", @cTipo )
        oAlmacen:SetOrder( ORD_ALM_TIPO )
        nRecNo := oAlmacen:RecNo()
        If oAlmacen:Seek( cTipo )
            PonAlm()
        Else
            MsgStop( "No encontrado el Tipo: " + CRLF + ;
                     cTipo, "Informaci¢n" )
            oAlmacen:GoTo( nRecNo )
        EndIf
        oAlmacen:SetOrder( ORD_ALM_CODIGO )
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function ScanCodigo()
    Local nRecNo
    Static cCodigo

    DEFAULT cCodigo := Space( 10 )

    If lMsgGet( "Introduzca el c¢digo", "C¢digo: ", @cCodigo )
        nRecNo := oAlmacen:RecNo()
        If oAlmacen:Seek( cCodigo )
            PonAlm()
        Else
            MsgStop( "No encontrado el c¢digo: " + CRLF + ;
                     cCodigo, "Informaci¢n" )
            oAlmacen:GoTo( nRecNo )
        EndIf
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function ScanName()
    Local nRecNo
    Static cNombre

    DEFAULT cNombre := Space( 25 )

    If lMsgGet( "Introduzca el nombre", "Nombre: ", @cNombre )
        nRecNo := oAlmacen:RecNo()
        oAlmacen:SetOrder( ORD_ALM_NOMBRE )
        If oAlmacen:Seek( AllTrim( cNombre ) )
            PonAlm()
        Else
            MsgStop( "No encontrado el Producto: " + CRLF + ;
                AllTrim( cNombre ), "Informaci¢n" )
            oAlmacen:GoTo( nRecNo )
        EndIf
        oAlmacen:SetOrder( ORD_ALM_CODIGO )
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function PonAlm()
    oWndAlm:Say(  1, 11, oAlmacen:Codigo,            GR__BG )
    oWndAlm:Say(  1, 49, DToC( oAlmacen:Alta ),      GR__BG )
    oWndAlm:Say(  4, 11, oAlmacen:Nombre,            GR__BG )
    oWndAlm:Say(  4, 47, oAlmacen:Tipo,              GR__BG )
    oWndAlm:Say(  6, 14, oAlmacen:Ubicacion,         GR__BG )
    oWndAlm:Say(  6, 36, Str( oAlmacen:Cant, 4 ),    GR__BG )
    oWndAlm:Say(  6, 53, Str( oAlmacen:CantMin, 4 ), GR__BG )
    oWndAlm:Say(  8, 14, oAlmacen:CodProvee,         GR__BG )
    oWndAlm:Say(  8, 36, Str( oAlmacen:PCost, 6 ),   GR__BG )
    oWndAlm:Say(  8, 49, Str( oAlmacen:PVP, 6 ),     GR__BG )
Return NIL

// -------------------------------------------------------------------------- //
Static Function PanAlm( oWnd )

    // Ponemos los controles en la ventana
    oWnd:Box3D(  0,  1,  2, 22, N_BG, BG__BG )
    oWnd:Box3D(  0, 40,  2, 58, N_BG, BG__BG )
    oWnd:Box3D(  3,  1,  9, 58, BG__BG, N_BG )

    // Pone las etiquetas
    oWnd:Say(  1,  3, "C¢digo:",    W__BG )
    oWnd:Say(  4,  3, "Nombre:",    W__BG )
    oWnd:Say(  4, 41, "Tipo:",      W__BG )
    oWnd:Say(  6, 26, "Cantidad:",  W__BG )
    oWnd:Say(  6, 42, "Cant.Min.:", W__BG )
    oWnd:Say(  8, 44, "PVP:",       W__BG )
    oWnd:Say(  8, 27, "P.Cost.:",   W__BG )
    oWnd:Say(  1, 42, "Fecha:",     W__BG )
    oWnd:Say(  6,  3, "Ubicaci¢n:", W__BG )
    oWnd:Say(  8,  3, "Cod.Prov.:", W__BG )
Return NIL

// -------------------------------------------------------------------------- //
Static Function EdiAlm( lAppend )
    Local oAlmWindow
    Local oGetCodPro

    DEFAULT lAppend := .F.

    // Se se va a a¤adir se inicializa el array de almacen
    If lAppend
        oAlmacen:Blank()
        oAlmacen:Alta := Date()
        // oAlmacen:Codigo := Str( aCont()[ CONT_ALM ], 10 )
        oAlmacen:Codigo := Space( 10 )
    EndIf

    // Creamos la ventana de almacen.
    DEFINE WINDOW oAlmWindow ;
        FROM  2,  8 TO 15, 73 ;
        TITLE If( lAppend, "Crear producto", "Edici¢n de producto" ) ;
        NOMINIMIZE ;
        NOMAXIMIZE ;
        NORESIZE

    SET MESSAGE OF oAlmWindow TO "Ventana de almac‚n"

    // Pone la pantalla de almacene
    PanAlm( oAlmWindow )

    // Pone el codigo.
    oAlmWindow:Say(  1, 11, oAlmacen:Codigo, W__BG )

    @  1, 11 GET oAlmacen:Codigo    OF oAlmWindow ;
        PICTURE "@!"

    @  1, 49 GET oAlmacen:Alta      OF oAlmWindow

    @  4, 11 GET oAlmacen:Nombre    OF oAlmWindow

    @  4, 47 GET oAlmacen:Tipo      OF oAlmWindow ;
        PICTURE "@!"

    @  6, 14 GET oAlmacen:Ubicacion OF oAlmWindow ;
        PICTURE "@!"

    @  6, 36 GET oAlmacen:Cant      OF oAlmWindow ;
        PICTURE "@E 9999" ;
        VALID oAlmacen:Cant > 0

    @  6, 53 GET oAlmacen:CantMin   OF oAlmWindow ;
        PICTURE "@E 9999" ;
        VALID oAlmacen:CantMin > 0

    @  8, 14 GET oGetCodPro VAR oAlmacen:CodProvee OF oAlmWindow ;
        VALID !Empty( oAlmacen:CodProvee ) .And. ;
              IsProveedor( oAlmacen ) .And. ;
              ( oGetCodPro:oGet:UpdateBuffer(), .T. )

    @  8, 36 GET oAlmacen:PCost     OF oAlmWindow ;
        PICTURE "@E 999999" ;
        VALID ( !Empty( oAlmacen:PCost ) .And. ;
              ( !Empty( oAlmacen:PVP ) .Or. ;
              ( ( oAlmacen:PVP := oAlmacen:PCost + ;
                  Int( ( oAlmacen:PCost * 4 ) / 100 ) + ;
                  Int( ( oAlmacen:PCost * 30 ) / 100 ) ), .T. ) ) )

    @  8, 49 Get oAlmacen:PVP       OF oAlmWindow ;
        PICTURE "@E 999999" ;
        VALID oAlmacen:PVP > 0

    @ 10, 35 BUTTON " &Salvar " OF oAlmWindow ;
        ACTION ( If( lAppend, oAlmacen:Append(), NIL ), ;
                    oAlmacen:Save(), PonAlm(), oAlmWindow:Close() )

    @ 10, 47 BUTTON " &Cancelar " OF oAlmWindow ;
        ACTION oAlmacen:Load(), oAlmWindow:Close()

    ACTIVATE WINDOW oAlmWindow ;
        ON INIT oWndAlm:Minimize() ;
        ON CLOSE oWndAlm:Normal()

Return NIL

// -------------------------------------------------------------------------- //
Function IsProducto( aEdit )
    Local lValor
    Local nReg
    Local oWndBrow
    Local oLbx

    DEFAULT oAlmacen := GetAlmacen()

    nReg := oAlmacen:RecNo()

    If !( lValor := oAlmacen:Seek( aEdit[ DES_CODPRO ] ) )

        If nMsgBox( "C¢digo de producto no encontrado", ;
                   "Atenci¢n", { " &Cancelar ", " &Listar " },, ;
                   ICO_STOP, "GR+/B" ) == 2

            // Para que no este al final
            oAlmacen:GoTop()

            // Se hace un Browse de Productos.
            DEFINE WINDOW oWndBrow ;
                FROM 4, 5 TO 22, 59 ;
                TITLE "Seleccione Producto" ;
                NOMAXIMIZE ;
                NOMINIMIZE ;
                NORESIZE

            @  1,  1 LISTBOX oLbx FIELDS oAlmacen:Codigo, ;
                                         oAlmacen:Nombre, ;
                                         oAlmacen:Cant ;
                PROMPT "&Productos" ;
                ALIAS oAlmacen ;
                HEADERS "C¢digo", "Nombre", "Cant." ;
                SIZE 51, 13 OF oWndBrow ;
                ON DBLCLICK lValor := .T., oWndBrow:Close() ;
                LOGICLEN oAlmacen:RecCount()

            @ 15, 23 BUTTON " &Seleccionar " OF oWndBrow ;
                ACTION lValor := .T., oWndBrow:Close()

            @ 15, 40 BUTTON " &Cancelar " Of oWndBrow ;
                ACTION oWndBrow:Close()

            ACTIVATE WINDOW oWndBrow

        EndIf

    EndIf

    If lValor
        aEdit[ DES_CODPRO ] := oAlmacen:Codigo
        aEdit[ DES_NOMBRE ] := oAlmacen:Nombre
        aEdit[ DES_PVP    ] := oAlmacen:PVP
    EndIf

    oAlmacen:Goto( nReg )

Return lValor

// -------------------------------------------------------------------------- //
Function IsCantidad( aEdit )
    Local lValor := .F.
    Local nReg

    DEFAULT oAlmacen := GetAlmacen()

    nReg := oAlmacen:RecNo()

    If oAlmacen:Seek( aEdit[ DES_CODPRO ] )

        If !( lValor := ( aEdit[ DES_CANT ] <= oAlmacen:Cant ) )

            MsgStop( "No hay tanta cantidad.;Quedan: " + ;
                      Str( oAlmacen:Cant, 4 ) )

        EndIf

    EndIf

    oAlmacen:GoTo( nReg )

Return lValor

// -------------------------------------------------------------------------- //
Function ActAlm( aEdit, lAppend )       // Actualiza las cantidades del almacen
    Local nReg

    DEFAULT lAppend := .F., ;
            oAlmacen := GetAlmacen()

    nReg := oAlmacen:RecNo()

    aEval( aEdit, {|aPro| If( oAlmacen:Seek( aPro[ DES_CODPRO ] ), ;
           ( If( lAppend, oAlmacen:Cant += aPro[ DES_CANT ], ;
                        oAlmacen:Cant -= aPro[ DES_CANT ] ), oAlmacen:Save() ), ) } )

    oAlmacen:Goto( nReg )

Return NIL

// -------------------------------------------------------------------------- //

static procedure CliReport()

    local oReport, oAlmacen := GetAlmacen()
    local nRec := oAlmacen:RecNo()

    oAlmacen:GoTop()
    select ( oAlmacen:nArea )

    REPORT oReport TITLE  "*** Listado de Stoks ***"

    COLUMN TITLE "C¢digo"    DATA oAlmacen:Codigo
    COLUMN TITLE "Nombre"    DATA oAlmacen:Nombre
    COLUMN TITLE "Cantidad"  DATA oAlmacen:Cant

    END REPORT

    ACTIVATE REPORT oReport

    oAlmacen:GoTo( nRec )

return

// -------------------------------------------------------------------------- //



