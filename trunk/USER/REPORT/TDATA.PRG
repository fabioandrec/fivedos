//----------------------------------------------------------------------------//
//                          Clase DATA de listados de formatos                //
//----------------------------------------------------------------------------//

#include "FiveDOS.ch"

//----------------------------------------------------------------------------//

CLASS TData FROM TRColumn

    DATA nRow, nCol     AS NUMERIC

    METHOD New( nRow, nCol, bBlock, nWidth, cPicture ) CONSTRUCTOR

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bBlock, nWidth, cPicture ) CLASS TData

    local cHeader := ""
    local lSummary := .f.

    DEFAULT nRow := 0, ;
            nCol := 0

    ::nRow := nRow
    ::nCol := nCol

    ::Super:New( bBlock, cHeader, nWidth, lSummary, cPicture )

return nil

//----------------------------------------------------------------------------//

