// Funciones miscelaneas para MegaRecords.

#include "MegaReco.ch"

// -------------------------------------------------------------------------- //
// Ventana para recoger un n£mero de registro entre 1 y nMax.
Function lGetReg( nReg, nMax )
    Local oWndReg
    Local lRetVal := .F.

    DEFINE WINDOW oWndReg ;
        FROM  6, 23 TO 14, 52 ;
        TITLE "Registro 1 - " + AllTrim( Str( nMax ) ) ;
        NOMAXIMIZE ;
        NOMINIMIZE ;
        NORESIZE

    @  2,  2 GET nReg OF oWndReg ;
        LABEL "Registro N£mero: " ;
        PICTURE "@E 999999" ;
        VALID ( nReg > 0 .And. nReg <= nMax ) ;
        MESSAGE "Introduzca n£mero de registro"

    @  5,  2  BUTTON " &Aceptar " OF oWndReg ;
        MESSAGE "Cierra la ventana aceptando" ;
        ACTION oWndReg:Close(), lRetVal := .T.

    @  5, 15  BUTTON " &Cancelar " OF oWndReg ;
        MESSAGE "Cierra la ventana cancelando" ;
        ACTION oWndReg:Close()

    ACTIVATE WINDOW oWndReg

Return lRetVal

// -------------------------------------------------------------------------- //
