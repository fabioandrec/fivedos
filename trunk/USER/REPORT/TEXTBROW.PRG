#include "FiveDos.ch"
#include "FileIO.ch"

//---------------------------------------------------------------------------//

function TextBrowse( cFile )

    local oDlg, oLbx
    local oBrw, oFile

    if ValType( cFile ) != "C"
        cFile := "*.*"
        cFile := cGetFile( cFile )
    endif

    SetMCursor( IDC_CLOCK )

    if ! File( cFile )
        Alert( "­ El fichero:;" + cFile + ";no existe !" )
        return nil
    endif

    oFile := TFile():New( cFile )

    if oFile:Open( FO_READ + FO_DENYWRITE ) == -1 // Solo lectura y Sin compartir escritura.
        Alert( "­ El fichero:;" + cFile + ";no se puede abrir !" + ;
               ";Error DOS N§: " + str( FERROR(), 3 ) )
        return nil
    endif

    DEFINE DIALOG oDlg          ;
        FROM 0, 0 TO 24, 79     ;
        NOMOVE                  ;
        TITLE "Text Browser: " + cFile

    BEGIN BROWSE oBrw COLOR "n/w, w+/b, w/b"                  // Browse Colors
        COLUMN TITLE "Line:" + str( 1 ) ;
               SHOW oFile:ReadLn( TABSIZE ) ;
               WIDTH oDlg:nWidth - 6
    END BROWSE

    oBrw:SkipBlock     = { | nSkip, nRec | nRec := oFile:RecNo(),;
                                           oFile:Skip( nSkip ),;
                                           oFile:RecNo() - nRec }
    oBrw:goTopBlock    = {|| oFile:GoTop() }
    oBrw:goBottomBlock = {|| oFile:GoBottom() }

    @  0, 0 LISTBOX oLbx BROWSE oBrw                ;
            SIZE oDlg:nWidth - 2, oDlg:nHeight - 2  ;
            LOGICLEN oFile:LastRec()                ;
            ON DBLCLICK MsgInfo( "Doble Click.;Viendo:;"+ cFile + ;
                                 ";Linea:" + str( oFile:Recno() ) + ;
                                 ";Texto: " + left( oFile:ReadLn( TABSIZE ), 30 ) ) ;
            ON CHANGE  if( oLbx != nil, oLbx:Say( 1, 0, " Line:" + ;
                            str( oFile:RecNo() ), 127 ), ) ;
            OF oDlg

    ACTIVATE DIALOG oDlg

    oFile:Close()

return nil

//---------------------------------------------------------------------------//

