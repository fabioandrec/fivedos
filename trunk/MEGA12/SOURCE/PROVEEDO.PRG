// -------------------------------------------------------------------------- //
// Funciones para el Mantenimiento de Proveedores.
// -------------------------------------------------------------------------- //

#include "MegaReco.ch"
#include "Icons.ch"

Static oWndPro							// Ventana de Proveedores
Static oProveedo						// Referencia al objeto Proveedo

// -------------------------------------------------------------------------- //
// Crea y Muestra la ventana de Proveedors
Function Proveedores()
    Local oBar,;
          cVar  := IMG_VARNAME  // Nombre del array de recursos Bitmaps

    CursorWait()

	If oWndPro == NIL

        DEFAULT oProveedo := GetProveedo()

        // Creamos la ventana de Proveedores.
		DEFINE WINDOW oWndPro ;
			FROM 3, 6 TO 18, 73 ;
			TITLE " Proveedores " ;
			NOMAXIMIZE ;
			NORESIZE ;
			MENU MenuPro()

		SET MESSAGE OF oWndPro TO "Ventana de Proveedores"

		DEFINE BUTTONBAR oBar OF oWndPro

		DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_TOP ;
            MESSAGE "Va al primer proveedor." ;
            TIPS "Va al primer proveedor." ;
			ACTION oProveedo:GoTop(), PonPro()

		DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_LEFT ;
            MESSAGE "Va al anterior proveedor." ;
            TIPS "Va al anterior proveedor." ;
			ACTION oProveedo:Skip( -1 ), If( oProveedo:Bof(), ;
				   Tone( 800 ), PonPro() )

		DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_RIGHT ;
            MESSAGE "Va al siguiente proveedor." ;
            TIPS "Va al siguiente proveedor." ;
			ACTION oProveedo:Skip( 1 ), ;
				  If( oProveedo:Eof(), ;
					( oProveedo:Skip( -1 ), Tone( 800 ) ), PonPro() )

		DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_BOTTOM ;
            MESSAGE "Va al £ltimo proveedor." ;
            TIPS "Va al £ltimo proveedor." ;
			ACTION oProveedo:GoBottom(), PonPro()

		DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_EDIT ;
			GROUP ;
			MESSAGE "Edita los datos del proveedor." ;
            TIPS "Edita los datos del proveedor." ;
			ACTION EdiPro()

		DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_ADD ;
			MESSAGE "A¤ade un proveedor." ;
            TIPS "A¤ade un proveedor." ;
			ACTION EdiPro( .T. )

		DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_TRASH ;
			MESSAGE "Borra el actual proveedor." ;
            TIPS "Borra el actual proveedor." ;
			ACTION DelPro()

		DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_SEEK ;
			LABEL "Nombre" ;
			GROUP ;
			MESSAGE "Buscar un proveedor por Nombre." ;
            TIPS "Buscar un proveedor por Nombre." ;
			ACTION ScanName()

		DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_SEEK ;
			LABEL "C¢digo" ;
			MESSAGE "Buscar un proveedor por C¢digo." ;
            TIPS "Buscar un proveedor por C¢digo." ;
			ACTION ScanCodigo()

		DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_SEEK ;
            LABEL "NIF" ;
			MESSAGE "Buscar un proveedor por NIF." ;
            TIPS "Buscar un proveedor por NIF." ;
			ACTION ScanNIF()

		DEFINE BUTTON OF oBar ;
            FILENAME cVar + IMG_PRINTER ;
			GROUP ;
			MESSAGE "Imprimir proveedores" ;
            TIPS "Imprimir proveedores" ;
			ACTION NIL

        // Ponemos la Pantalla
        PanPro( oWndPro )

        // Ponemos los datos.
        PonPro()

        ACTIVATE WINDOW oWndPro ;
			NOWAIT ;
            CENTERED ;
			VALID oWndPro := NIL, .T.

	Else

		oWndPro:SetCurrent()
		If oWndPro:lMinimized
			oWndPro:Normal()
		EndIf

	EndIf

    CursorArrow()

Return NIL

// -------------------------------------------------------------------------- //
Static Function MenuPro()
	Local oMenu

		MENU oMenu

			MENUITEM "&Editar" ;
				MESSAGE "Crear, borrar, modificar proveedor"
			MENU

				MENUITEM "&A¤adir     Alt-Ins" ;
					SHORTCUT K_ALT_INS ;
					MESSAGE "Crea un nuevo proveedor" ;
					ACTION EdiPro( .T. )

				MENUITEM "&Modificar  Alt-F2" ;
					SHORTCUT K_ALT_F2 ;
					MESSAGE "Modificar los datos del proveedor" ;
					ACTION EdiPro()

				MENUITEM "&Borrar     Alt-Supr" ;
					SHORTCUT K_ALT_DEL ;
					MESSAGE "Borrar el proveedor" ;
					ACTION DelPro()

			ENDMENU

			MENUITEM "&Desplazar" ;
				MESSAGE "Ir al proveedor siguiente, anterior, primero, £ltimo, ..."
			MENU
				MENUITEM "&Siguiente        Alt-S" ;
					SHORTCUT K_ALT_S ;
					MESSAGE "Ir al siguiente proveedor" ;
					ACTION oProveedo:Skip( 1 ), ;
						  If( oProveedo:Eof(), ;
							( oProveedo:Skip( -1 ), Tone( 800 ) ), PonPro() )

				MENUITEM "&Anterior         Alt-A" ;
					SHORTCUT K_ALT_A ;
					MESSAGE "Ir al anterior proveedor" ;
					ACTION oProveedo:Skip( -1 ), If( oProveedo:Bof(), ;
						   Tone( 800 ), PonPro() )

				MENUITEM "&Registro n£mero  Alt-R" ;
					SHORTCUT K_ALT_R ;
					MESSAGE "Ir al proveedor del registro n£mero..." ;
					ACTION GetReg()


				MENUITEM "&Primero          Alt-P" ;
					SHORTCUT K_ALT_P ;
					MESSAGE "Ir al primer proveedor" ;
					ACTION oProveedo:GoTop(), PonPro()


				MENUITEM "&Ultimo           Alt-U" ;
					SHORTCUT K_ALT_U ;
					MESSAGE "Ir al £ltimo proveedor" ;
					ACTION oProveedo:GoBottom(), PonPro()

			ENDMENU

			MENUITEM " &Buscar " ;
				MESSAGE "Localizar un proveedor por Nombre, NIF, C¢digo"
			MENU

				MENUITEM " Por &C¢digo " ;
					MESSAGE "Buscar un proveedor por el c¢digo" ;
					ACTION ScanCodigo()

				MENUITEM " Por &Nombre " ;
					MESSAGE "Buscar un proveedor por su nombre" ;
					ACTION ScanName()

				MENUITEM " Por N&IF " ;
					MESSAGE "Buscar un proveedor por su NIF" ;
					ACTION ScanNIF()

			ENDMENU

		ENDMENU

Return oMenu

// -------------------------------------------------------------------------- //
Static Function GetReg()
	Static nReg := 1
	If lGetReg( @nReg, oProveedo:RecCount() ) .And. nReg != oProveedo:RecNo()
		oProveedo:Goto( nReg )
		PonPro()
	EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function ScanNIF()
	Local nRecNo
	Static cNif

	DEFAULT cNif := Space( 10 )

	If lMsgGet( "Introduzca el NIF", "NIF: ", @cNif )
		oProveedo:SetOrder( ORD_PRO_NIF )
		nRecNo := oProveedo:RecNo()
		If oProveedo:Seek( cNif )
			PonPro()
		Else
			MsgStop( "No encontrado el NIF: " + CRLF + ;
					 cNif, "Informaci¢n" )
			oProveedo:GoTo( nRecNo )
		EndIf
		oProveedo:SetOrder( ORD_CLI_CODIGO )
	EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function ScanCodigo()
	Local nRecNo
	Static cCodigo

	DEFAULT cCodigo := Space( 10 )

	If lMsgGet( "Introduzca el c¢digo", "C¢digo: ", @cCodigo )
		nRecNo := oProveedo:RecNo()
		If oProveedo:Seek( cCodigo )
			PonPro()
		Else
			MsgStop( "No encontrado el c¢digo: " + CRLF + ;
					 cCodigo, "Informaci¢n" )
			oProveedo:GoTo( nRecNo )
		EndIf
	EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function ScanName()
	Local nRecNo
	Static cNombre

	DEFAULT cNombre := Space( 35 )

	If lMsgGet( "Introduzca el nombre", "Nombre: ", @cNombre )
		oProveedo:SetOrder( ORD_PRO_NOMBRE )
		nRecNo := oProveedo:RecNo()
		If oProveedo:Seek( AllTrim( cNombre ) )
			PonPro()
		Else
			MsgStop( "No encontrado el Proveedor: " + CRLF + ;
				AllTrim( cNombre ), "Informaci¢n" )
			oProveedo:GoTo( nRecNo )
		EndIf
		oProveedo:SetOrder( ORD_PRO_CODIGO )
	EndIf
Return NIL

// -------------------------------------------------------------------------- //
Static Function DelPro()
	If MsgYesNo( "Seguro de borrar el proveedor", "Confirmaci¢n de borrado" )
		oProveedo:Delete()
		oProveedo:Skip( -1 )
		PonPro()
	EndIf
Return NIL

// -------------------------------------------------------------------------- //
// Pone los datos del proveedor en la pantalla
Static Function PonPro()
	oWndPro:Say(  1, 10, oProveedo:Codigo,	  GR__BG )
	oWndPro:Say(  4, 10, oProveedo:Nombre,	  GR__BG )
	oWndPro:Say(  4, 52, oProveedo:NIF, 	  GR__BG )
	oWndPro:Say(  6, 13, oProveedo:Domicilio, GR__BG )
	oWndPro:Say(  8, 13, oProveedo:Poblacion, GR__BG )
	oWndPro:Say(  8, 41, oProveedo:CodPost,   GR__BG )
	oWndPro:Say( 10, 12, oProveedo:Telefono,  GR__BG )
Return NIL

// -------------------------------------------------------------------------- //
Static Function PanPro( oWnd )

	// Poner los controles en la ventana
    oWnd:Box3D(  0,  1,  2, 20, N_BG, BG__BG )
    oWnd:Box3D(  3,  1, 11, 62, BG__BG, N_BG )

	// Pone las etiquetas
	oWnd:Say(  1,  2, "C¢digo:",    W__BG )
	oWnd:Say(  4,  2, "Nombre:",    W__BG )
	oWnd:Say(  4, 47, "NIF:",       W__BG )
	oWnd:Say(  6,  2, "Domicilio:", W__BG )
	oWnd:Say(  8,  2, "Poblaci¢n:", W__BG )
	oWnd:Say(  8, 30, "Cod.Post.:", W__BG )
	oWnd:Say( 10,  2, "Tel‚fono:",  W__BG )

Return NIL

// -------------------------------------------------------------------------- //
Static Function EdiPro( lAppend )
	Local oWndPro

	DEFAULT lAppend := .F.

	// Se se va a a¤adir se inicializa el array de cliente
	If lAppend
		oProveedo:Blank()
		oProveedo:Codigo := Str( aCont()[ CONT_PRO ], 10 )
	EndIf

	// Creamos la ventana de clientes
	DEFINE WINDOW oWndPro ;
		FROM 3, 6 TO 18, 73 ;
		TITLE If( lAppend, "Crear Proveedor", "Edici¢n de Proveedores" ) ;
		NOMINIMIZE ;
		NOMAXIMIZE ;
		NORESIZE

	SET MESSAGE OF oWndPro TO "Ventana de proveedores"

	// Ponemos la pantalla de Proveedores.
	PanPro( oWndPro )

    // Poner el codigo.
    oWndPro:Say( 1, 10, oProveedo:Codigo, GR__BG )

	@  4, 10 GET oProveedo:Nombre	 OF oWndPro
	@  4, 52 GET oProveedo:Nif		 OF oWndPro PICTURE "@!"
	@  6, 13 GET oProveedo:Domicilio OF oWndPro
	@  8, 13 GET oProveedo:Poblacion OF oWndPro PICTURE "@!"
	@  8, 41 GET oProveedo:CodPost	 OF oWndPro
	@ 10, 12 GET oProveedo:Telefono  OF oWndPro

	@ 12, 40 BUTTON " &Salvar " OF oWndPro ;
		ACTION ( If( lAppend, ;
				   ( oProveedo:Append(), ;
					 aCont()[ CONT_PRO ]++, ;
					 Array2F( aCont(), "MegaReco.Dat" ) ), ), ;
			   oProveedo:Save(), PonPro(), oWndPro:Close() )

	@ 12, 52 BUTTON " &Cancelar " OF oWndPro ;
        ACTION oProveedo:Load(), oWndPro:Close()

    ACTIVATE WINDOW oWndPro

Return NIL

// -------------------------------------------------------------------------- //
Function IsProveedor( oAlmacen )
	Local lValor := .F.
	Local oWndBrow
	Local oLbx
	Local nReg

	DEFAULT oProveedo := GetProveedo()

	nReg := oProveedo:RecNo()

	If !( lValor := oProveedo:Seek( oAlmacen:CodProvee ) )

		If nMsgBox( "C¢digo de Proveedor no encontrado", ;
                   "Atenci¢n", { " &Cancelar ", " &Listar " },, ;
				   ICO_STOP, "GR+/B" ) == 2

			// Para que no este al final
			oProveedo:GoTop()

			// Se hace un Browse de PROVEEDORES.
			DEFINE WINDOW oWndBrow ;
                FROM 4, 5 TO 19, 59 ;
				TITLE "Seleccione Proveedor" ;
				NOMAXIMIZE ;
				NOMINIMIZE ;
				NORESIZE

			@  1,  1 LISTBOX oLbx FIELDS oProveedo:Codigo, ;
										 oProveedo:Nombre  ;
				PROMPT "&Proveedores:" ;
				ALIAS "PROVEEDO" ;
				HEADERS "C¢digo", "Nombre" ;
                SIZE 51, 10 OF oWndBrow ;
                ON DBLCLICK lValor := .T., oWndBrow:Close() ;
				LOGICLEN oProveedo:RecCount()

            // Asignamos el codeblock de salto del browse.
            oLbx:SkipBlock := {|n| oProveedo:Skipper( n ) } // oLbx:oBrowse:SkipBlock := {|n| oProveedo:Skipper( n ) }

//            oLbx:Reset()

            @ 12, 23 BUTTON " &Seleccionar " OF oWndBrow ;
				ACTION lValor := .T., oWndBrow:Close()

            @ 12, 40 BUTTON " &Cancelar " OF oWndBrow ;
				ACTION oWndBrow:Close()

			ACTIVATE WINDOW oWndBrow

		EndIf

	EndIf

	If lValor
		oAlmacen:CodProvee := oProveedo:Codigo
	EndIf

	oProveedo:Goto( nReg )

Return lValor

// -------------------------------------------------------------------------- //
