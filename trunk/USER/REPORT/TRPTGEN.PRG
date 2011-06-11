
//---------------------------------------------------------------------------//
//                                                                           //
//          Clase padre de los listados en general                           //
//                                                                           //
//---------------------------------------------------------------------------//

#include "FiveDOS.ch"

#ifndef CRLF
    #define CRLF Chr( 13 ) + Chr( 10 )
#endif

//---------------------------------------------------------------------------//

CLASS TReport

    DATA aHead              AS ARRAY

    DATA bWhile,        ;
         bFor,          ;
         bInit,         ;
         bEnd,          ;
         bStartPage,    ;
         bEndPage,      ;
         bLine              AS BLOCK

    DATA cAlias,        ;
         cCanal             AS CHARACTER

    DATA nZonInf,       ;
         nLines,        ;
         nPgLines,      ;
         nMrgUp,        ;
         nMrgLeft,      ;
         nWidth,        ;
         nPosPg,        ;
         nPage              AS NUMERIC

    DATA lPage, ;
         lCanal, ;
         lEject,     ;
         lPrint, ;
         lEnd               AS LOGICAL

    METHOD New( cCanal, cAlias, aHead, ;
                        nMrgUp, nMrgLeft, lPage, nPosPg ) CONSTRUCTOR

//-------------------------------------------- Impresores de l¡nesa -----------
    METHOD Say( uVal )
    METHOD SayHead()
    METHOD SayLine( cOut )
    METHOD SayPage()
    METHOD SayBlank( nLines )

//-------------------------------------------- Generadores de l¡neas ----------
    METHOD GenDetail()          VIRTUAL
    METHOD GenNPg()

//-------------------------------------------- Operaciones con impresoras -----
    METHOD OpenCanal()
    METHOD CloseCanal()
    METHOD ToPrint()
    METHOD ToScreen()

    METHOD Eject( nType )

    METHOD Skip( nSkip )
    METHOD GoToIni()

    METHOD CtrlPage()
    METHOD CtrlReport()         VIRTUAL

    METHOD ToBlock( cExp )

    METHOD Activate( bFor, bWhile, bInit, bEnd, ;
                                    bStartPage, bEndPage, bLine )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cCanal, cAlias, aHead, nMrgUp, nMrgLeft, ;
                                            lPage, nPosPg ) CLASS TReport

    DEFAULT cCanal    := "PRINTER",           ;
            cAlias    := Alias( Select() ),   ;
            aHead     := { ;
                 { || "Fecha: " + DToC( Date() ) + "      Hora: " + Time() }, ;
                 { || "Listado General de " + cAlias }, ;
                 { ||  ""  } }, ;
            nMrgUp    := 0,                   ;
            nMrgLeft  := 0,                   ;
            lPage     := .f.,                 ;
            nPosPg    := 0

    ::cCanal   := cCanal                   // Canal de salida
    ::cAlias   := cAlias                   // Alias de la DBF principal
    ::aHead    := aHead                    // Cabecera
    ::nMrgUp   := nMrgUp                   // Margen derecho
    ::nMrgLeft := nMrgLeft                 // Margen izquierdo
    ::lPage    := lPage                    // Escribe numero de p gina
    ::nPosPg   := nPosPg                   // 0 Centro, 1 Derecha otro Izquierda

    ::nLines   := 0                        // Linea actual en pagina
    ::nPgLines := 66                       // Lineas por pagina
    ::nPage    := 0                        // Num. de pagina
    ::nZonInf  := 4

    ::lEnd     := .f.                       // Fin de listado

    ::lPrint   := .f.                       // Est  activo el canal?
    ::lCanal   := .f.                       // Est  abierto el canal?

return Self

//---------------------------------------------------------------------------//
//                                                                           //
//          bWhile      Bloque While selecina registros CLAVE                //
//          bFor        Bloque For   selecciona cualquier registro           //
//          bInit       Se ejecuta al iniciar el listado                     //
//          bEnd        Se ejecuta al finalizar el listado                   //
//          bStartPage  Se ejecuta al empezar cada pagina                    //
//          bEndPage    Se ejecuta al finalizar cada pagina                  //
//          bLine       Se ejecuta por cada linea de listado                 //
//                                                                           //
//---------------------------------------------------------------------------//
//
METHOD Activate( bFor, bWhile, bInit, bEnd, ;
                       bStartPage, bEndPage, bLine ) CLASS TReport

    DEFAULT bWhile      := { || (::cAlias)->( !Eof() ) }, ;
            bFor        := { || .t. }, ;
            bInit       := { || nil }, ;
            bEnd        := { || nil }, ;
            bStartPage  := { || nil }, ;
            bEndPage    := { || nil }, ;
            bLine       := { || nil }

    DbSelectArea( ::cAlias )        // Slecciona el area de trabajo

//  Convierto todos los argumentos en CodeBloc

    ::bFor          := bFor
    ::bWhile        := bWhile
    ::bInit         := bInit
    ::bEnd          := bEnd
    ::bStartPage    := bStartPage
    ::bEndPage      := bEndPage
    ::bLine         := bLine

    ::ToPrint()
    ::OpenCanal()

    ::GoToIni()         // Va al principio del fichero DBF o BROWSE

    eval( ::bInit )     // Evalua el CodeBlock de inicio

    ::CtrlReport()

    eval( ::bEnd )

    ::CloseCanal()
    ::ToScreen()

return nil

//----------------------------------------------------------------------------//

METHOD Skip( nSkip ) CLASS TReport

    ( ::cAlias )->( DbSkip( nSkip ) )

    ::lEnd := ( ::cAlias )->( Eof() )

return nil

//----------------------------------------------------------------------------//

METHOD GoToIni( ) CLASS TReport

    ( ::cAlias )->( DbGoTop() )

return nil

//----------------------------------------------------------------------------//

METHOD SayHead() CLASS TReport

    ::nLines := 0

    eval( ::bStartPage )

    ++::nPage

    ::SayBlank( ::nMrgUp )      // Si tiene margen superior lo hace

    AEval( ::aHead, ;
        { | uElem, nPos | ::Say( Space( ::nMrgLeft ) + ;
                                if( ValType( uElem ) == "B" ,;
                                    Eval( uElem ), ;
                                    uElem ) + CRLF ) } )

    ::nLines += len( ::aHead )

return nil

//----------------------------------------------------------------------------//

METHOD SayLine( cOut ) CLASS TReport

    ::CtrlPage()

    ++::nLines

    eval( ::bLine )

    ::Say( Space( ::nMrgLeft ) + cOut + CRLF )

return nil

//----------------------------------------------------------------------------//

METHOD CtrlPage() CLASS TReport

    if ::nLines >= ::nPgLines - ::nZonInf
        ::SayPage()
        eval( ::bEndPage )
    endif

return nil

//----------------------------------------------------------------------------//
//
METHOD SayPage() CLASS TReport

    if( ::lPage, ( ::Say( space(::nMrgLeft ) + ;
        ::GenNPg() + CRLF ), ++::nLines ), ::SayBlank( 1 ) )

    ::SayBlank( 1 )

    ::nLines := 0       // Empieza el contador de l¡neas

return nil

//----------------------------------------------------------------------------//

METHOD Say( uVal ) CLASS TReport

    QQOut( uVal )

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
//
// 0 -> Centro   1 -> derecha  defecto izquierdo
//
METHOD GenNPg() CLASS TReport
                        
    local cOutTmp := "- Pg. " + LTrim( Str( ::nPage ) ) + " -"

    if ::nPosPg == 0
        cOutTmp := space( int( ::nWidth / 2 ) - int( len( cOutTmp ) / 2 )  ) + ;
                        cOutTmp
    elseif ::nPosPg == 1
        cOutTmp := space( ::nWidth - len( cOutTmp ) ) + cOutTmp
    else
        // cOutTmp no cambia
    endif

return( cOutTmp )

//----------------------------------------------------------------------------//
// Por de fecto hace un salto de pagina
// Si nType es 0 adem s pone el numero de pagina

METHOD Eject( nType ) CLASS TReport

    local lCanalOld := ::lCanal
    local nDown     := ::nPgLines - ::nLines

    ++::nPage       // Suma uno al contador de p ginas

    if !lCanalOld
        if ::cCanal != "PRINTER"
            Set( _SET_PRINTFILE, ::cCanal, .t. )
        else
            Set( _SET_PRINTFILE, "" )
        endif
    endif

    if !::lPrint                // No esta activo el canal
        ::ToPrint()
        if nType == 0  .and. ::lPage
            ::SayBlank( nDown - ( ::nZonInf - 2 ) )
            ::Say( ::GenNPg() )
            ::SayBlank( 2 )
        else
            ::SayBlank( nDown )
        endif
        ::ToScreen()
    else
        if nType == 0  .and. ::lPage
            ::SayBlank( nDown - ( ::nZonInf - 2 ) )
            ::Say( ::GenNPg() )
            ::SayBlank( 2 )
        else
            ::SayBlank( nDown )
        endif
    endif

    if !lCanalOld
        Set( _SET_PRINTFILE, "" )
    endif

return nil

//----------------------------------------------------------------------------//

METHOD OpenCanal() CLASS TReport

    ::lCanal := .t.

    if ::cCanal != "PRINTER"
        Set( _SET_PRINTFILE, ::cCanal )
    else
        Set( _SET_PRINTFILE, "" )
    endif

return nil

//----------------------------------------------------------------------------//

METHOD CloseCanal() CLASS TReport

    ::lCanal := .f.

    Set( _SET_PRINTFILE, "" )

return nil
//----------------------------------------------------------------------------//

METHOD ToPrint() CLASS TReport

    SET CONSOLE OFF
    SET PRINT   ON

    ::lPrint := .t.

return nil

//----------------------------------------------------------------------------//

METHOD ToScreen( ) CLASS TReport

    SET PRINT   OFF
    SET CONSOLE ON

    ::lPrint := .f.

return nil

//----------------------------------------------------------------------------//
// Convierte una expresion en CodeBlock

METHOD ToBlock( cExp ) CLASS TReport

    local bVal := "{ || " + cExp + " }"

return &( bVal )

//---------------------------------------------------------------------------//

