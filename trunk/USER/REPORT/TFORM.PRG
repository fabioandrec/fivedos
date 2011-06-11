
//---------------------------------------------------------------------------//
//                                                                           //
//          Clase listados tipo primpresos y formularios                     //
//                                                                           //
//---------------------------------------------------------------------------//

#include "FiveDOS.ch"

#ifndef CRLF
    #define CRLF Chr( 13 ) + Chr( 10 )
#endif

static __ThisRpt        // Guardo el 'Report' para las funciones amigas y no
                        // tener que hacer virguer¡as con 'Prepro'

//---------------------------------------------------------------------------//

CLASS TForm FROM TReport

    DATA    aData,  ;
            aLines          AS ARRAY

    DATA    nLines, ;
            nData           AS NUMERIC


    METHOD  New( cCanal, nLines, nWidth, lEject, cAlias, aHead, ;
                        nMrgUp, nMrgLeft, lPage, nPosPg ) CONSTRUCTOR

    METHOD  AddData( oData )

    METHOD  CtrlReport()

    METHOD  GenALine()

    METHOD  SayALine()

    METHOD  TAFill( cExp )

END CLASS

METHOD  New( cCanal, nLines, nWidth, lEject, cAlias, aHead, ;
                        nMrgUp, nMrgLeft, lPage, nPosPg ) CLASS TForm


    ::Super:New( cCanal, cAlias, aHead, nMrgUp, nMrgLeft, lPage, nPosPg )

    DEFAULT aHead := {}, ;
            nLines  := ::nPgLines, ;
            nWidth  := 80

    ::lEject    := lEject
    ::aHead     := aHead
    ::nWidth    := nWidth
    ::aData     := {}
    ::nData     := 0
    ::aLines    := Array( nLines )

    __ThisRpt := Self     // Para a¤adir TDatas

return nil

//---------------------------------------------------------------------------//

METHOD  AddData( oData ) CLASS TForm

    AAdd( ::aData, oData )

    ++::nData

return nil

//---------------------------------------------------------------------------//

METHOD  TAfill( cExp ) CLASS TForm

    DEFAULT cExp := space( ::nWidth )

    ::aLines := aFill( ::aLines, cExp )

return nil

//---------------------------------------------------------------------------//

METHOD  CtrlReport() CLASS TForm

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

        ::SayHead()     // Si cuenta las pg y si hay la imprime

        ::GenALine()     // Genera un array de lineas del listado

        ::SayALine()

        if ::lEject         // ¨ Cambiar y poner como en los grupos ?

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

METHOD  GenALine() CLASS TForm

    local n := 0

    ::TAFill()              // Pone vac¡a el array de l¡neas

    AEval( ::aData, { | oData, nEle | ;
           ::aLines[ oData:nRow ] := Stuff( ::aLines[ oData:nRow ], ;
           oData:nCol, oData:nWidth, oData:SetOut() ) } )

return nil

//---------------------------------------------------------------------------//

METHOD  SayALine()

    AEval( ::aLines, { | cEle, nEle | ::SayLine( cEle ) } )

return nil

//----------------------------------------------------------------------------//
//
function RptAddData( nRow, nCol, bBlock, nWidth, cPicture, oReport )
    
    local oCol := TData():New(nRow, nCol, bBlock, nWidth, cPicture )

    DEFAULT oReport := __ThisRpt

    oReport:AddData( oCol )

return( oCol )

//----------------------------------------------------------------------------//

