// Clase DCPrinter   gestion de impresoras

#include "FiveDos.ch"
#include "SysStr.ch"
#include "PRNDef.ch"

//---------------------------------------------------------------------------//

CLASS DCPrinter FROM TDevice

    DATA aDef           AS ARRAY ;
                            INSTANTIATE aFill( Array( PRNDEF_LEN ), "" )

    DATA nRow, nCol     AS Numeric
    DATA cBuffer        AS Character


    METHOD New( cDevice, cMode )    CONSTRUCTOR
    METHOD nVSize()                 INLINE ::nHeight
    METHOD nHSize()                 INLINE ::nWidth
    METHOD nHRes()                  INLINE ::nWidth
    METHOD nVRes()                  INLINE ::nHeight
    METHOD nNumBrushes()            INLINE 5
    METHOD nPixelx()                INLINE 1
    METHOD nPixelY()                INLINE 1
    METHOD Say( nRow, nCol, cString, nCharType )
    METHOD Eject()                  INLINE ::nRow := ::nCol := 0, ::cBuffer += chr( 12 )

    METHOD Flush( nWhere, lFile )

    // a¤adir los m‚todos de pintado de linea ....
    // METHOD ...

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( cDrv, cPORT )

    if File( cDrv )
        ::aDef   := uLoadObject( cDrv )
        ::cRight := ::aDef[ DC_RIGHT ]

    else
        alert( strtran( aSysStr( SST_NODEVICE ), "%1", cDrv ) )
    endif
        ::nHeight = 65
        ::nWidth  = 80

    // Super:New( "PRN" )

return

//---------------------------------------------------------------------------//

METHOD Say( nRow, nCol, cString, nType )

    local  cLine, cPrecode := "", cPostCode := ""

    cLine := chr( 13 )

    ::nCol := nCol + len( cString )

    if nRow < ::nRow
        cLine += chr(12) + replicate( chr(10), nRow )
    elseif nRow > ::nRow
        cLine += replicate( chr(10), nRow - ::nRow )
    endif

    cLine += space( nCol )

    ::nRow = nRow

    DEFAULT nType := TP_NORMAL

    if lAnd( nType, TP_NORMAL )
        cPrecode += ::aDef[ DC_NORMAL ]
    endif

    if lAnd(nType, TP_EXPANDED )
        cPrecode += ::aDef[ DC_EXPANDED ]
        cPostCode += ::aDef[ DC_NORMAL ]
    endif

    if lAnd(nType, TP_COMPRESSED )
        cPrecode += ::aDef[ DC_COMPRESSED ]
        cPostCode += ::aDef[ DC_NORMAL ]
    endif

    if lAnd(nType, TP_ITALIC )
        cPrecode += ::aDef( DC_ITALIC )
        cPostCode += ::aDef( DC_ITALIC_OFF)
    endif

    if lAnd(nType, TP_BOLD )
        cPrecode += ::aDef( DC_BOLD )
        cPostCode += ::aDef( DC_BOLD_OFF)
    endif

    if lAnd(nType, TP_UNDERLINE )
        cPrecode += ::aDef( DC_UNDERLINE )
        cPostCode += ::aDef( DC_UNDERLINE_OFF)
    endif

    if lAnd(nType, TP_OVER )
        cPrecode += ::aDef[ DC_OVER ]
        cPostCode += ::aDef[ DC_OVER_OFF ]
    endif


    ::cBuffer += cLine + cPrecode + cString + cPostcode

return nil

//---------------------------------------------------------------------------//

METHOD Flush( nWhere, lFile )

    local nBytes, cBuffer := ::cBuffer

    DEFAULT lFile := .f.

    if nWhere == nil
        nWhere = if( !lFile, 1, 0 )
    endif


    if !empty( cBuffer ) .and. nWhere != 0
        if lFile
            nBytes := FWrite( nWhere, @cBuffer, len( cBuffer ) )
        else
            nBytes := nLPTWrite( 1, cBuffer )
        endif

        if nBytes < len( cBuffer )
            ::cBuffer = right( cBuffer, len( cBuffer ) - nBytes )
        else
            ::cBuffer = ""
        endif
    endif

return len( ::cBuffer ) == 0

//---------------------------------------------------------------------------//
