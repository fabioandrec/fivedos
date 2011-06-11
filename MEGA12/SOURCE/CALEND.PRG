// Calendario para VEC By Juan Rios Olivares

#include "MegaReco.ch"

Static oWndCal
Static nMonth, nYear

// -------------------------------------------------------------------------- //
Function Calend()
    Local cDate
    Local oBar

    If oWndCal == NIL

        cDate  := Date()
        nYear  := Year( cDate )
        nMonth := Month( cDate )

        DEFINE WINDOW oWndCal ;
            FROM  6, 29 TO 17, 52 ;
            TITLE " Calendario " ;
            NOMAXIMIZE ;
            NORESIZE

        SET MESSAGE OF oWndCal TO "Ventana del Calendario"

        DEFINE BUTTONBAR oBar OF oWndCal

        DEFINE BUTTON OF oBar ;
            LABEL "" ;
            MESSAGE "Ir al a¤o anterior" ;
            ACTION nYear--, PonCalendDat()

        DEFINE BUTTON OF oBar ;
            LABEL "" ;
            MESSAGE "Ir al mes anterior" ;
            ACTION If( --nMonth == 0, ;
                        ( nMonth := 12, nYear-- ),  ), PonCalendDat()

        DEFINE BUTTON OF oBar ;
            LABEL "" ;
            MESSAGE "Ir a la fecha actual" ;
            ACTION nMonth := Month( cDate ), ;
                     nYear  := Year( cDate  ), PonCalendDat()

        DEFINE BUTTON OF oBar ;
            LABEL "" ;
            MESSAGE "Ir un mes adelante" ;
            ACTION If( ++nMonth == 13, ;
                        ( nMonth := 1, nYear++ ), ), PonCalendDat()

        DEFINE BUTTON OF oBar ;
            LABEL "" ;
            MESSAGE "Ir al siguiente a¤o" ;
            ACTION nYear++, PonCalendDat()

        ACTIVATE WINDOW oWndCal ;
            ON PAINT PonCalendDat() ;
            NOWAIT ;
            VALID oWndCal = NIL, .T. ;

    Else

        oWndCal:SetCurrent()
        If oWndCal:lMinimized()
            oWndCal:Normal()
        EndIf

    EndIf

Return NIL

// -------------------------------------------------------------------------- //
Static Function PonCalendDat()

    Local nLast, nDay, nCol, nRow, cDate

    oWndCal:BeginPaint()

    // Limpiamos la ventana
    oWndCal:oClient:EraseBackGround( " ", N_BG )

    // Ponemos el mes y el a¤o
    oWndCal:Say(  1,  1, cMonth( CToD( "01/" + Str( nMonth, 2 ) + "/" + ;
                         Str( nYear, 4 ) ) ) + ", " + ;
                         Str( nYear, 4 ), W__BG )

    // Ponemos el rotulo
    oWndCal:Say( 2, 1, "Lu Ma Mi Ju Vi Sa Do", GR__BG )

    cDate := Date()

    nCol := Dow( CToD( "01/" + Str( nMonth, 2 ) + "/" + Str( nYear, 4 ) ) ) - 1

    // Por si es Domingo.
    If nCol == 0
        nCol := 7
    EndIf

    // Para obtener la columna real.
    nCol := ( ( nCol - 1 ) * 3 ) + 1

    // Calculamos el £ltimo dia del mes.
    nLast := LastDay()

    // Fila inicial
    nRow := 3
    For nDay := 1 To nLast
        oWndCal:Say( nRow, nCol, Str( nDay, 2 ), ;
            If( nDay == Day( cDate ) .And. ;
                      nMonth == Month( cDate ) .And. ;
                      nYear == Year( cDate ), BR__BG, BG__BG ) )
        nCol += 3
        If nCol > 19
            nCol := 1
            nRow++
        EndIf
    Next

    oWndCal:EndPaint()

Return NIL

// -------------------------------------------------------------------------- //
Static Function LastDay()
    Local Month := nMonth + 1
    Local Year := nYear
    If Month > 12
        Month := 1
        Year++
    EndIf
Return Day( cToD( "01/" + Str( Month ) + "/" + Str( Year, 4 ) ) - 1 )

// -------------------------------------------------------------------------- //
