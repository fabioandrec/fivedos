// -------------------------------------------------------------------------- //
//               Funciones para Ventanas de Mensajes by Juan Rios             //
// -------------------------------------------------------------------------- //

#include "FiveDos.Ch"

static aWnd := {}       // Array que contendra las ventanas de mensajes

// -------------------------------------------------------------------------- //

// Abre una ventana de mensajes y la a¤ade al array aWnd

function PushMsg( cText, cTitle, nRow, nCol )

    local oWnd, ;
          lCentered := empty( nRow ) .and. empty( nCol ),;
          nSayRect  := nLabelRect( cText )


    DEFAULT cTitle := "Informaci¢n", ;
            nRow   := 0, ;
            nCol   := 0

    DEFINE DIALOG oWnd ;
        AT nRow, nCol  ;
        SIZE RectWidth( nSayRect ) + 4, RectHeight( nSayRect ) + 4 ;
        TITLE cTitle ;
        NOSYSMENU

    @ 2, 1 SAY cText OF oWnd

    if lCentered
        ACTIVATE DIALOG oWnd CENTERED NOWAIT
    else
        ACTIVATE DIALOG oWnd NOWAIT
    endif

    aAdd( aWnd, oWnd )

return NIL

// -------------------------------------------------------------------------- //
// Cierra la £ltima ventana de mensajes
function PopMsg()

    if Len( aWnd ) > 0
        aTail( aWnd ):Close()
        aSize( aWnd, Len( aWnd ) - 1 )
    endif

return NIL

// -------------------------------------------------------------------------- //

Function oTailMsg()
return aTail( aWnd )

// -------------------------------------------------------------------------- //
