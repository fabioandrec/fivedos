//----------------------------------------------------------------------------//
//                          Clase COLUMNA de listados                         //
//----------------------------------------------------------------------------//

#include "FiveDOS.ch"

//----------------------------------------------------------------------------//

CLASS TRColumn

    DATA bColumn            AS BLOCK
    DATA cValType, ;
         cHeader,  ;
         cPicture           AS CHARACTER

    DATA nTotal,   ;
         nWidth             AS NUMERIC

    DATA lSummary, ;
         lPicture           AS LOGICAL

    METHOD  New( bColumn, cHeader, nWidth, lSummary, cPicture ) CONSTRUCTOR
    METHOD  Say()
    METHOD  SetOut()
    METHOD  SetForm()

END CLASS

//----------------------------------------------------------------------------//

METHOD  New( bColumn, cHeader, nWidth, lSummary, cPicture ) CLASS TRColumn

    DEFAULT bColumn  := { || nil },  ;
            cHeader  := "",          ;
            lSummary := .f.,         ;
            cPicture := ""

    ::lPicture := if( cPicture == "", .f., .t. )

  // Comprueba lSummary y carga cValType:

    if ( ( ::cValType := ValType( eval( bColumn ) ) ) != "N" )
        lSummary := .f.
    endif

    ::cPicture := cPicture

    DEFAULT nWidth := len( ::SetForm( eval( bColumn ) ) )

    ::nWidth   := nWidth
    ::cHeader  := PadC( cHeader, ::nWidth )
    ::bColumn  := bColumn
    ::lSummary := lSummary


return nil

//----------------------------------------------------------------------------//
//
// Escribe el valor de la columna sin retorno de carro
//
METHOD Say()    

    QQOut( PadC( Eval( ::bColumn ), ::nWidth ) )

return nil

//----------------------------------------------------------------------------//
//
// Devuelve el valor de la columna en formato caracter y formateado
//
METHOD SetOut() CLASS TRColumn

    local uVal := eval( ::bColumn )
    local cOut  := ""

    if ::lSummary
        ::nTotal += uVal
    endif

    if ::cValType == "N"
        cOut := PadR( ::SetForm( uVal ), ::nWidth )
    else
        cOut := PadC( ::SetForm( uVal ), ::nWidth )
    endif

return( cOut )

//----------------------------------------------------------------------------//
//
// Formatea cualquier valor a la PICTURE de esa columna
//
METHOD SetForm( uVal ) CLASS TRColumn

    local cOut  := ""

    do case

        case ::cValType == "D"

            cOut := DToC( uVal )

        case ::cValType == "N"

            if ::lPicture
                cOut := Transform( uVal, ::cPicture )
            else
                cOut := Str( uVal, ::nWidth )
            endif

        case ::cValType == "L"

            cOut := if( uVal, ".T.", ".F." )

        case ::cValType == "C"

            if ::lPicture
                cOut := Transform( uVal, ::cPicture )
            else
                cOut := uVal
            endif

    endcase

return( cOut )

//----------------------------------------------------------------------------//

