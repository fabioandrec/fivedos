
//---------------------------------------------------------------------------//
//                                                                           //
//          Clase para el tratamiento de listados de browses                 //
//                                                                           //
//---------------------------------------------------------------------------//


//---------------------------------------------------------------------------//

#include "FiveDOS.ch"

//---------------------------------------------------------------------------//

CLASS TRBrw FROM TRptCol

    DATA oBrw               AS OBJECTS

    METHOD New( oBrw, cCanal, aHead, nMrgUp, nMrgLeft, cHeadSepH, ;
            cHeadSep, cColSep, lTotalPg, lTotal, lPage, nPosPg ) CONSTRUCTOR

    METHOD AutoColumn()

    METHOD Skip( nSkip )
    METHOD GoToIni()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oBrw, cCanal, aHead, nMrgUp, nMrgLeft, cHeadSepH, ;
            cHeadSep, cColSep, lTotalPg, lTotal, lPage, nPosPg ) CLASS TRBrw

    ::oBrw := oBrw

    DEFAULT cHeadSepH := "Ä"

    DEFAULT cColSep  := AllTrim( ::oBrw:ColSep )


    DEFAULT cHeadSep  := cColSep

    ::Super:New( cCanal, , aHead, nMrgUp, nMrgLeft, cHeadSepH, ;
            cHeadSep, cColSep, lTotalPg, lTotal, lPage, nPosPg )

return Self

//----------------------------------------------------------------------------//

METHOD Skip( nSkip ) CLASS TRBrw

    ::lEnd := ( eval( ::oBrw:SkipBlock, nSkip ) == 0 )

return nil

//----------------------------------------------------------------------------//

METHOD GoToIni( ) CLASS TRBrw

    eval( ::oBrw:goTopBlock )

return nil

//----------------------------------------------------------------------------//

METHOD AutoColumn() CLASS TRBrw

    local nNum      := 0
    local nColum    := ::oBrw:colCount
    local nWidth    := 0
    local lSummary  := .t.
    local oBrwCol, oTRCol

    local xVal

    for nNum := 1 to nColum

        oBrwCol := ::oBrw:getColumn( nNum )

        xVal := eval( oBrwCol:Block )   // Controlar type para saber el len

        lSummary := ( ValType( xVal ) == "N" )

        oTRCol := TRColumn():New( oBrwCol:Block, oBrwCol:Heading, ;
                    oBrwCol:Width, lSummary, oBrwCol:Picture )

        ::AddColumn( oTRCol )

    next

return nil

//----------------------------------------------------------------------------//


