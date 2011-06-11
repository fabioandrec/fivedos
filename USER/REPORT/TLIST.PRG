
/*
            NOTAS:

    Poner todo con el nuevo sistema de Objects
    Implementar CANAL de SALIDA y en ACTIVATE todos los bloques de codigo
    ejemplo Saltar de pagina, de linea etc
    Resto de margenes y ancho de listado

*/

//---------------------------------------------------------------------------//

#include "FiveDOS.ch"

#define CRLF Chr( 13 ) + Chr( 10 )

//---------------------------------------------------------------------------//

CLASS TReport

    DATA bWhile, ;
         bFor, ;
         bInit, ;
         bEnd, ;
         bStartPage, ;
         bEndPage, ;
         bLine              AS BLOCK
    DATA cAlias,    ;
         cColSep,   ;
         cHeadIng,  ;
         cHeadSep,  ;
         cCanal             AS CHARACTER
    DATA nLines, ;
         nPgLines, ;
         nMrgUp, ;
         nMrgLeft, ;
         nWidth, ;
         nPage              AS NUMERIC
    DATA aColumns, aHead    AS ARRAY


    METHOD New( cCanal, cAlias, aHead, nMrgUp, nMrgLeft, ;
                cHeadIng, cHeadSep, cColSep )  CONSTRUCTOR
    METHOD SayLine( cOut )
    METHOD SayHead()
    METHOD GenNames()
    METHOD GenHeadSep()
    METHOD GenDetail()
    METHOD SayPage()
    METHOD SayBlank( nLines )
    METHOD SayMrgUp() INLINE ::SayBlank( ::nMrgUp )

    METHOD AddColumn( oColumn ) INLINE AAdd( ::aColumns, oColumn )
    METHOD DelColumn( nColumn ) INLINE ADel( ::aColumns, nColumn ),;
                                      ASize( ::aColumns, Len( ::aColumns ) -1 )
    METHOD InsColumn( oColumn, nColumn ) INLINE AIns( ::aColumns, nColumn ),;
                                      ::aColumns[ nColumn ] := oColumn

    METHOD Say( uVal ) INLINE QQOut( uVal )

    METHOD OpenCanal()
    METHOD CloseCanal()
    METHOD ToPrint()
    METHOD ToScreen()

    METHOD Activate( bFor, bWhile, bInit, bEnd, bStartPage, bEndPage, bLine )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( cCanal, cAlias, aHead, nMrgUp, nMrgLeft, ;
            cHeadIng, cHeadSep, cColSep ) CLASS TReport

    DEFAULT cCanal      := "PRINTER",           ;
            cAlias      := Alias( Select() ),   ;
            aHead       := { { || "" } },       ;
            nMrgUp      := 0,                   ;
            nMrgLeft    := 0,                   ;
            cColSep     := " ",                 ;
            cHeadIng    := "-",                 ;
            cHeadSep    := " "


    ::cCanal   := cCanal
    ::cAlias   := cAlias
    ::aColumns := {}
    ::nLines   := 0
    ::nPgLines := 66
    ::nPage    := 0
    ::aHead    := AClone( aHead )
    ::nMrgUp   := nMrgUp
    ::nMrgLeft := nMrgLeft
    ::cColSep  := cColSep
    ::cHeadIng := cHeadIng
    ::cHeadSep := cHeadSep

return Self

//---------------------------------------------------------------------------//
//  bWhile      Bloque While selecina registros CLAVE
//  bFor        Bloque For   selecciona cualquier registro
//  bInit       Se ejecuta al iniciar el listado
//  bEnd        Se ejecuta al finalizar el listado
//  bStartPage  Se ejecuta al empezar cada pagina
//  bEndPage    Se ejecuta al finalizar cada pagina
//  bLine       Se ejecuta por cada linea de listado
//
METHOD Activate( bFor, bWhile, bInit, bEnd, bStartPage, ;
                                            bEndPage, bLine ) CLASS TReport

    local nAvance := 0

//--------------------------------------------------------------------

    DEFAULT bWhile      := { || (::cAlias)->( !Eof() ) }, ;
            bFor        := { || .t. }, ;
            bInit       := { || nil }, ;
            bEnd        := { || nil }, ;
            bStartPage  := { || nil }, ;
            bEndPage    := { || nil }, ;
            bLine       := { || nil }

    ::bFor          := bFor
    ::bWhile        := bWhile
    ::bInit         := bInit
    ::bEnd          := bEnd
    ::bStartPage    := bStartPage
    ::bEndPage      := bEndPage
    ::bLine         := bLine

    ::nWidth := Len( ::GenNames() )

    DbSelectArea( ::cAlias )

    ::ToPrint()
    ::OpenCanal()

    eval( ::bInit )

    if eval( ::bWhile )

        if ::nPgLines < len( ::aHead ) + 3
            ::Say( "La cabecera es muy grande" )
            return nil
        endif

        ::SayMrgUp()
        ::SayHead()
        ::SayLine( ::GenNames() )
        ::SayLine( ::GenHeadSep() )

    endif

    while Eval( ::bWhile )

        if !eval(::bFor)
            DbSkip( 1 )
            LOOP
        endif

        ::SayLine( ::GenDetail() )

        DbSkip( 1 )

    end while

    if ( nAvance := ::nPgLines - ( ::nLines + 4 ) ) > 0
        ::nLines := 0
        ::SayBlank( nAvance )
        ::nLines := 0
        ::SayPage( 0 )
    endif

    eval( ::bEnd )

    ::CloseCanal()
    ::ToScreen()

return nil

//----------------------------------------------------------------------------//

METHOD SayLine( cOut ) CLASS TReport

    if ::nLines >= ::nPgLines - 4
        ::SayPage( 0 )
        ::SayBlank( 1 )
        ::SayMrgUp()
        ::SayHead()
        ::SayLine( ::GenNames() )
        ::SayLine( ::GenHeadSep() )
    endif

    ++::nLines

    ::Say( Space( ::nMrgLeft ) + cOut + CRLF )

return nil

//----------------------------------------------------------------------------//

METHOD SayHead() CLASS TReport

    ::nLines := 0

    eval( ::bStartPage )

    ++::nPage

    AEval( ::aHead, ;
        { | uElem, nPos | ::Say( Space( ::nMrgLeft ) + ;
                                if( ValType( ::aHead[ nPos ] ) == "B" ,;
                                     Eval( ::aHead[ nPos ] ), ;
                                     ::aHead[ nPos ] ) + CRLF ) } )

    ::nLines += len( ::aHead ) + ::nMrgUp

return nil

//----------------------------------------------------------------------------//

METHOD GenNames() CLASS TReport

    local cVal := ""

     AEval( ::aColumns, { | oCol | cVal += PadC( oCol:cHeader, oCol:nWidth ) ;
                      + if( oCol:cColSep != "", oCol:cColSep, ::cColSep ) } )

return( cVal )

//----------------------------------------------------------------------------//

METHOD GenHeadSep() CLASS TReport

    local cVal := ""

    AEval( ::aColumns, { | oCol | cVal += PadC( "", oCol:nWidth, ::cHeadIng ) + ;
                ::cHeadSep } )

return( cVal )

//----------------------------------------------------------------------------//

METHOD GenDetail() CLASS TReport

    local cVal := ""

    AEval( ::aColumns, { | oCol | cVal += oCol:SetOut() + ;
                    if( oCol:cColSep != "", oCol:cColSep, ::cColSep ) } )

    eval( ::bLine )

return( cVal )

//----------------------------------------------------------------------------//

METHOD SayPage( nPos ) CLASS TReport
                        // 0 -> Centro   1 -> derecha  defecto izquierdo

    local cOutTmp := "- Pg. " + AllTrim( Str( ::nPage ) ) + " -"

    ::SayBlank( 2 )

    nPos := if( ValType( nPos ) != "N", 2, nPos )

    if nPos == 0
        cOutTmp := space( int( ::nWidth / 2 ) - int( len( cOutTmp ) / 2 )  ) + ;
                        cOutTmp
    elseif nPos == 1
        cOutTmp := space( ::nWidth - len( cOutTmp ) ) + cOutTmp
    else
        // cOutTmp no cambia
    endif

    eval( ::bEndPage )

    ++::nLines

    ::Say( cOutTmp + CRLF )


return nil

//----------------------------------------------------------------------------//

METHOD SayBlank( nLin ) CLASS TReport

    local nTmp := 0

    nLin := if( ValType( nLin ) == "N", nLin, 1 ) // Si se manda 0 no hace nada
                                                  // si es nil manda 1
    while ++nTmp <= nLin
        ::Say( CRLF )
        ++::nLines
    end

return nil

//----------------------------------------------------------------------------//

METHOD OpenCanal() CLASS TReport

    if ::cCanal != "PRINTER"
        Set( _SET_PRINTFILE, ::cCanal )
    else
        Set( _SET_PRINTFILE, "" )
    endif

return nil

//----------------------------------------------------------------------------//

METHOD CloseCanal() CLASS TReport

    if ::cCanal != "PRINTER"
        Set( _SET_PRINTFILE, "" )
    else
        EJECT
    endif

return nil
//----------------------------------------------------------------------------//

METHOD ToPrint() CLASS TReport

    SET CONSOLE OFF
    SET PRINT ON

return nil

//----------------------------------------------------------------------------//

METHOD ToScreen( ) CLASS TReport

    SET PRINT   OFF
    SET CONSOLE ON

return nil

//----------------------------------------------------------------------------//
//
//  Funcion amiga para la creaci¢n de columnas de listado
//
//----------------------------------------------------------------------------//
//
function RptAddColumn( bColumn, cHeader, nWidth, lSumary, cPicture, cColSep, oReport )
    
    local oCol := TRColumn():New( bColumn, cHeader, nWidth, lSumary, cPicture, cColSep )

    oReport:AddColumn( oCol )

return( oCol )

//----------------------------------------------------------------------------//



