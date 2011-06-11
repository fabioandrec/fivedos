// -------------------------------------------------------------------------- //
//               Funciones para Ventanas de Mensajes by Juan Rios             //
// -------------------------------------------------------------------------- //

#include "FiveDos.Ch"

Static aWnd := {}       // Array que contendra las ventanas de mensajes

// -------------------------------------------------------------------------- //
// Abre una ventana de mensajes y la a¤ade al array aWnd
Function PonMsg( cText, cTitle )
    Local oWnd
    Local nLen := Max( nLabelLen( cText ) + 4, 40 )

    DEFAULT cTitle := "Informaci¢n"

    DEFINE DIALOG oWnd ;
        AT 0, 0 ;
        SIZE nLen + 1, 5 ;
        TITLE cTitle ;
        NOSYSMENU

    @ 2, Int( ( nLen - nLabelLen( cText ) ) / 2 ) SAY cText OF oWnd

    ACTIVATE DIALOG oWnd CENTERED NOWAIT

    aAdd( aWnd, oWnd )

Return NIL

// -------------------------------------------------------------------------- //
// Cierra la £ltima ventana de mensajes
Function QuitaMsg()
    If( Len( aWnd ) > 0 )
        aTail( aWnd ):Close()
        aSize( aWnd, Len( aWnd ) - 1 )
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
