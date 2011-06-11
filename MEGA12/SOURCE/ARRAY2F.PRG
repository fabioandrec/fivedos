// -------------------------------------------------------------------------- //
// Funciones para Salvar / Recuperar arrays a / desde archivos. By JRO 1.994  //
// -------------------------------------------------------------------------- //

#include "FileIo.ch"

Static nHandle          // Manejador del fichero

// -------------------------------------------------------------------------- //
Function Array2f( aTabla, cNombre )
    nHandle := fCreate( cNombre, FC_NORMAL )
    If fError() == 0
        SaveArray( aTabla )
        fClose( nHandle )
    EndIf
Return NIL

// -------------------------------------------------------------------------- //
Function File2A( cNombre )
    Local aTabla
    nHandle := fOpen( cNombre, FO_READ )
    If fError() == 0 .And. fReadStr( nHandle, 1 ) == "A"
        aTabla := RecupArray()
        fClose( nHandle )
    EndIf
Return aTabla

// -------------------------------------------------------------------------- //
Static Function SaveArray( aTabla )
    Local nLong, nElem, cTipoElem, cNum
    nLong  := Len( aTabla )
    fWrite( nHandle, "A" + Chr( nLong ) )
    For nElem := 1 To nLong
        cTipoElem := ValType( aTabla[nElem] )
        Do Case
            Case cTipoElem == "A"
                SaveArray( aTabla[nElem] )
            Case cTipoElem == "C"
                fWrite( nHandle, "C" + Chr( Len( aTabla[nElem] ) ) + aTabla[nElem] )
            Case cTipoElem == "D"
                fWrite( nHandle, "D" + DToC( aTabla[nElem] ) )
            Case cTipoElem == "L"
                fWrite( nHandle, "L" + If( aTabla[nElem], "T", "F" ) )
            Case cTipoElem == "N"
                cNum := Alltrim( Str( aTabla[nElem] ) )
                fWrite( nHandle, "N" + Chr( Len( cNum ) ) + cNum )
        EndCase
    Next
Return aTabla

// -------------------------------------------------------------------------- //
Static Function RecupArray()
    Local nLong, nElem, cTipoElem, aRecup
    nLong  := Asc( fReadStr( nHandle, 1 ) )
    aRecup := Array( nLong )
    For nElem := 1 To nLong
        cTipoElem := fReadStr( nHandle, 1 )
        Do Case
            Case cTipoElem == "A"
                aRecup[nElem] := RecupArray()
            Case cTipoElem == "C"
                aRecup[nElem] := fReadStr( nHandle, Asc( fReadStr( nHandle, 1 ) ) )
            Case cTipoElem == "D"
                aRecup[nElem] := CToD( fReadStr( nHandle, 8 ) )
            Case cTipoElem == "L"
                aRecup[nElem] := fReadStr( nHandle, 1 ) == "T"
            Case cTipoElem == "N"
                aRecup[nElem] := Val( fReadStr( nHandle, Asc( fReadStr( nHandle, 1 ) ) ) )
        EndCase
    Next
Return aRecup

// -------------------------------------------------------------------------- //
