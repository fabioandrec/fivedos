/*  DbfDel()

    to be included in several samples
*/
//---------------------------------------------------------------------------//

static function DbfDel( oLbx, oDbf )

    local nKey := oDbf:KeyNum()

    if MsgYesNo( "¨ Esta seguro de borrar a ;" + AllTrim( oDbf:Name ) + " ? ", "Borrar Registro" )
        oDbf:Delete()
        oDbf:KeyGoto( nKey )
        oLbx:Refresh()
    endif

return nil

//---------------------------------------------------------------------------//
