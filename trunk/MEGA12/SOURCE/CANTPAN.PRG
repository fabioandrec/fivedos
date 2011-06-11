// -------------------------------------------------------------------------- //
// Funciones para el panel de cantidad.                                       //
// -------------------------------------------------------------------------- //

#include "FiveDos.ch"

Static oCantPanelWnd
Static oTotDisp

// -------------------------------------------------------------------------- //
Function AddCantPanel()

    If oCantPanelWnd = NIL

        DEFINE WINDOW oCantPanelWnd ;
            SIZE 39,  8 ;
            TITLE "Cantidad" ;
            NOMAXIMIZE ;
            NORESIZE

        oTotDisp := TDisplay():New( 0, 0, "N/BG", oCantPanelWnd, 6 )

        ACTIVATE WINDOW oCantPanelWnd ;
            VALID oCantPanelWnd := NIL, oTotDisp := NIL, .T. ;
            CENTERED ;
            NOWAIT
    Else
        oCantPanelWnd:SetCurrent()
        If oCantPanelWnd:lMinimized
            oCantPanelWnd:Normal()
        EndIf
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Function SetTotalCant( nCant )
    If oTotDisp <> NIL
        oCantPanelWnd:SetCurrent()
        oTotDisp:SetValue( nCant )
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Function RemoveCantPanel()
    If oCantPanelWnd <> NIL
        oCantPanelWnd:Close()
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
