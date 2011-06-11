/*
        NOTAS:

    Arreglar contador de lineas

*/

//---------------------------------------------------------------------------//
//                                                                           //
//          Clase listados tipo mailing, etiquetas etc                       //
//                                                                           //
//---------------------------------------------------------------------------//

#include "FiveDOS.ch"

#ifndef CRLF
    #define CRLF Chr( 13 ) + Chr( 10 )
#endif

static __ThisRpt        // Guardo el 'Report' para las funciones amigas y no
                        // tener que hacer virguer¡as con 'Prepro'

//---------------------------------------------------------------------------//

CLASS TMail FROM TReport

    DATA    cModel,     ;
            cImpr,      ;
            cText,      ;
            cExpr           AS CHARACTER

    DATA    nLCount         AS NUMERIC INIT 0

    DATA    lEject          AS LOGICAL INIT .f.

    DATA    uContain        AS ALL


    METHOD  New( cText, cCanal, lEject, nWidth, cAlias, aHead, ;
                        nMrgUp, nMrgLeft, lPage, nPosPg ) CONSTRUCTOR

    METHOD  CtrlReport()

    METHOD  Translator( uVal )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cText, cCanal, lEject, nWidth, cAlias, aHead, ;
                        nMrgUp, nMrgLeft, lPage, nPosPg ) CLASS TMail

    DEFAULT cText   := "Texto.txt", ;
            nWidth  := 80, ;
            lEject  := .f.

    ::cText  := cText
    ::lEject := lEject
    ::nWidth := nWidth

    ::Super:New( cCanal, cAlias, aHead, nMrgUp, nMrgLeft, lPage, nPosPg )
    
//-------------------------------- ¨ en activate ? ---------------------------

    if !File( ::cText )
        Alert( "El fichero " + ::cText + " no existe" )
        ::lEnd := .t.
    else
        ::cModel := ::cImpr := MemoRead( ::cText )
        ::nLCount := MlCount( ::cModel, ::nWidth )  // De momento asi ¨?
    endif

return self

//---------------------------------------------------------------------------//

METHOD CtrlReport() CLASS TMail

    local cType := " "
    local bBlock := { || nil }

    DbSelectArea( ::cAlias )

    ::SayBlank( ::nMrgUp )  // Primer margen superior

    while eval( ::bWhile ) .and. !::lEnd

        // Si se presiona ESCape se corta el listado:

        if NextKey() == 27    //  K_ESC
            CLEAR TYPEAHEAD   // Por si controla el ESCape para otros procesos
            if Alert( "Listado interrumpido por el usuario", ;
                        { " Terminar ", " Continuar " } ) == 1
                ::lEnd := .t.
                LOOP
            endif
        endif

        if !eval(::bFor)
            ::Skip( 1 )
            LOOP
        endif

        ::SayHead()

    // Bucle de sustituci¢n por registro:

        while "{" $ ::cImpr

            ::cExpr := SubStr( ::cImpr, at( "{", ::cImpr ) + 1, ;
                                         at( "}", ::cImpr ) ;
                                       - at( "{", ::cImpr ) - 1 )

            ::uContain := ::Translator( ::cExpr )

            cType := ValType( ::uContain )

            do case

                case cType == "N"           // Num‚rico

                    ::uContain := AllTrim( str( ::uContain ) )
                    
                case cType == "D"           // Fecha

                    ::uContain := DToC( ::uContain )

                case cType == "L"           // L¢gico

                    ::uContain := if( ::uContain, ".T.", ".F." )

            endcase

            ::cImpr := StrTran( ::cImpr, "{" + ::cExpr + "}", ::uContain, 1 )

        end while

        ::Say( ::cImpr )

        ::cImpr := ::cModel

        ::nLines += ::nLCount
        --::nLines          // Ojo hace un salto autom tico

        eval( ::bLine )

        if ::lEject
            if ::lPage
                --::nPage
                ::Eject( 0 )      // El 'Eject' cuenta 1 a nPage y SayHead
            else
                --::nPage
                ::Eject()
            endif

            ::nLines := 0

        endif

        ::Skip( 1 )

        if !::lEnd
            ::SayBlank( ::nMrgUp )
        endif

    end while

return nil

//---------------------------------------------------------------------------//

METHOD Translator( uVal ) CLASS TMail

    local xVal := "{ || " + uVal + " }"

 return( eval( &xVal ) )

//---------------------------------------------------------------------------//

