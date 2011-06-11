// Funciones para la ventana de indexaci¢n

#include "MegaReco.ch"

#define INDEX_ALIAS     1
#define INDEX_AINDICES  2

#define INDEX_NAME      1
#define INDEX_CCOND     2
#define INDEX_BCOND     3

Static oWndInd
Static nMaxRec

// -------------------------------------------------------------------------- //
Function oWndReIndex( aIndices )

    If !Empty( aIndices )

        DEFINE WINDOW oWndInd ;
            FROM  6, 12 TO 15, 65 ;
            TITLE " Indexando " ;
            NOMINIMIZE ;
            NOMAXIMIZE ;
            NORESIZE

        // Ponemos los marcos
        oWndInd:Box3D(  0,  0,  4, 51 )
        oWndInd:Box3D(  5,  0,  7, 51, N_BG, BG__BG )

        // Ponemos los textos.
        oWndInd:Say(  1,  2, "Nombre    :", W__BG )
        oWndInd:Say(  2,  2, "Condici¢n :", W__BG )
        oWndInd:Say(  3,  2, "Area      :", W__BG )

        ACTIVATE WINDOW oWndInd NOWAIT

        // Creamos los indices
        aEval( aIndices, {|aElem| IndexAlias( aElem ) } )

        // Se avisa de fin de indexado
        MsgInfo( "Fin de la indexaci¢n." )

        // Cerramos la ventana de indexaci¢n.
        oWndInd:Close()

    EndIf

Return NIL

// -------------------------------------------------------------------------- //
Static Function IndexAlias( aElem )

    // Pintamos el nombre del indice y la condici¢n.
    oWndInd:Say( 3, 14, PadR( aElem[ INDEX_ALIAS ], 35 ), GR__BG )

    // Eliminamos los borrados
    ( aElem[ INDEX_ALIAS ] )->( __DbPack() )

    // Ponemos el contador de Registros.
    nMaxRec := ( aElem[ INDEX_ALIAS ] )->( LastRec() )

    // Creamos los indices.
    ( aElem[ INDEX_ALIAS ] )->( aEval( aElem[ INDEX_AINDICES ], ;
                                       {|aInd| CreaIndice( aInd ) } ) )

    // Restauramos el orden de los indices
    ( aElem[ INDEX_ALIAS ] )->( OrdListClear() )
    ( aElem[ INDEX_ALIAS ] )->( aEval( aElem[ INDEX_AINDICES ], ;
                               {|aInd| OrdListAdd( aInd[ INDEX_NAME ] ) } ) )

Return NIL

// -------------------------------------------------------------------------- //
Static Function CreaIndice( aInd )

    // Ponemos los datos del indice actual.
    oWndInd:Say(  1, 14, PadR( aInd[ INDEX_NAME  ], 35 ), GR__BG )
    oWndInd:Say(  2, 14, PadR( aInd[ INDEX_CCOND ], 35 ), GR__BG )

    oWndInd:Say(  6,  1, Space( 50 ), BG_W )

    // Creamos el indice.
    OrdCondSet(,,,, {|| oWndInd:Say(  6, 1, ;
                        Space( ( 50 * RecNo() ) / nMaxRec ), BG_W_ ), ;
                        .T. }, ;
                        ( nMaxRec / 10 ), RecNo(),,,, )

    OrdCreate( aInd[ 1 ],, aInd[ 2 ], aInd[ 3 ], )

Return NIL

// -------------------------------------------------------------------------- //
