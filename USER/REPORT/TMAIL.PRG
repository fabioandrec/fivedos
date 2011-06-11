
//---------------------------------------------------------------------------//
//                                                                           //
//          Clase listados tipo mailing, etiquetas etc                       //
//                                                                           //
//---------------------------------------------------------------------------//

#include "FiveDOS.ch"
#include "FileIO.ch"

#ifndef CRLF
    #define CRLF Chr( 13 ) + Chr( 10 )
#endif

//---------------------------------------------------------------------------//

CLASS TMail FROM TReport

    DATA    cFile           AS CHARACTER
    DATA    oFile           AS OBJECTS


    METHOD  New( cFile, cCanal, lEject, nWidth, cAlias, aHead, ;
                        nMrgUp, nMrgLeft, lPage, nPosPg ) CONSTRUCTOR
    METHOD  CtrlReport()
    METHOD  CtrlText()

    METHOD  GenLine()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cFile, cCanal, lEject, nWidth, cAlias, aHead, ;
                        nMrgUp, nMrgLeft, lPage, nPosPg )   CLASS TMail

    DEFAULT cFile   := "Texto.txt", ;
            nWidth  := 80, ;
            lEject  := .f.

    ::cFile  := cFile
    ::lEject := lEject
    ::nWidth := nWidth

    ::Super:New( cCanal, cAlias, aHead, nMrgUp, nMrgLeft, lPage, nPosPg )
    
    ::oFile := TFile():New( ::cFile )

    if ::oFile:Open( FO_READ + FO_DENYWRITE ) == -1
        Alert( "­ El fichero: " + cFile + ";no se puede abrir !" )
        ::lEnd := .t.
    endif

return self

//---------------------------------------------------------------------------//

METHOD CtrlReport()     CLASS TMail

    DbSelectArea( ::cAlias )

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

        ::SayBlank( ::nMrgUp )

        ::SayHead()     // Si cuenta las pg y si hay la imprime

        ::CtrlText()     // Recorre fichero de texto e imprime

        if ::lEject     // Cambiar y poner como en los grupos

            if ::lPage
                --::nPage
                ::Eject( 0 )      // El 'Eject' cuenta 1 a nPage y SayHead
            else
                --::nPage
                ::Eject()
            endif

            eval( ::bEndPage )
            ::nLines := 0

        endif

        ::Skip( 1 )

    end while

return nil

//---------------------------------------------------------------------------//

METHOD CtrlText() CLASS TMail

   local cLine := ""

   ::oFile:GoTo( 0 )    // Lo pongo al pricipio del fichero

   while !::oFile:Eof()

        cLine := ::oFile:ReadLn( TABSIZE )  // Ojo TABSIZE esta definido con 4
        ::SayLine( ::GenLine( cLine ) )
        ::oFile:Skip( 1 )

   end

return nil

//---------------------------------------------------------------------------//

METHOD GenLine( cLine )    CLASS TMail

    local cType := "C"
    local cExpr := ""
    local uContain

    while "{" $ cLine

        cExpr := SubStr( cLine, at( "{", cLine ) + 1, ;
                                at( "}", cLine ) ;
                              - at( "{", cLine ) - 1 )

            uContain := eval( ::ToBlock( cExpr ) )

            cType := ValType( uContain )

            do case

                case cType == "N"           // Num‚rico

                    uContain := AllTrim( str( uContain ) )
                    
                case cType == "D"           // Fecha

                    uContain := DToC( uContain )

                case cType == "L"           // L¢gico

                    uContain := if( uContain, ".T.", ".F." )

            endcase

            cLine := StrTran( cLine, "{" + cExpr + "}", uContain, 1 )

        end while

return( cLine )

//---------------------------------------------------------------------------//


