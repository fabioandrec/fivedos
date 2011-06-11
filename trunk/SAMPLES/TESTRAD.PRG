
#include "FiveDos.ch"

//---------------------------------------------------------------------------//

function main()

    local oDlg, oGet, oRad, nCtrl := 1

    DEFINE DIALOG oDlg FROM 1, 1 TO 17, 45  ;
             TITLE "Test de RadioButton Menu"

    DEFINE MESSAGE BAR OF oDlg              ;
        PROMPT F2VERSION + " La mejor elecci¢n"

    @ 1, 6  GET oGet VAR nCtrl PICTURE "9"  ;
        PROMPT "&Este Get"                  ;
        MESSAGE "Esto Es un Get"            ;
        OF oDlg

    @ 3,  6 RADIO oRad VAR oGet:cText OF oDlg    ;
            ITEMS "&Primero", "&Segundo", "&Tercero", "C&uarto" ;
            MESSAGE "Selecione uno..."

    @ 10,  13 BUTTON " &Ok "                ;
             SIZE 16, 3                     ;
             ACTION oDlg:End()              ;
             MESSAGE "Terminar el test"     ;
             OF oDlg


    oRad:SetPos( oRad:nTop, oRad:nLeft + 5 )

    AEval( oRad:aChilds, { | o | o:SetPos( o:nTop, o:nLeft + nCtrl++ ) } )
    oRad:ChangeSize( oRad:nWidth() + 20, oRad:nHeight() )

    oDlg:Clear()  // Nuevo. Ahora Clear hace un Deep Clear. antes esto no
                  // actualizaba los controles hijos del cliente...
                  // si hubieras hecho un oDlg:oClient:Clear() te habria
                  // funcionado...

    nCtrl = 1

    ACTIVATE DIALOG oDlg CENTERED

    Alert( Str( nCtrl ) )

return nil

//---------------------------------------------------------------------------//
