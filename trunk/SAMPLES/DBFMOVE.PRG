/*  DbfMove()

    to be included in several samples
*/
//---------------------------------------------------------------------------//

static function DbfMove( oLbx, oWnd )

    local oDlg

    DEFINE DIALOG oDlg ;
           AT 10, 20 SIZE 38, 5 ;
           TITLE "Mueve el Browse" // OF oWnd

    @ 1, 3  BUTTON " &Arriba " WHILE PRESSED oLbx:GoUp()   OF oDlg
    @ 1, 14 BUTTON " A&bajo "  WHILE PRESSED oLbx:GoDown() OF oDlg
    @ 1, 24 BUTTON " &Salir "  ACTION oDlg:Close()   OF oDlg

    ACTIVATE DIALOG oDlg          NOWAIT

return nil

//---------------------------------------------------------------------------//
