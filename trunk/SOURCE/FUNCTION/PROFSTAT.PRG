#include "FiveDos.ch"

//---------------------------------------------------------------------------//

procedure ProfStats( cInputFile, cOutputFile, lVerbose )

    local aStats := {}
    local Handle
    local cMet, n, lNoEof
    local nTotal := 0

    DEFAULT cInputFile  := "Profiler.log",;
            cOutputFile := "ProfStat.log",;
            lVerbose    := .t.

    Handle := FOpen( cInputFile, 0 ) // para lectura..

    if lVerbose
        ? "Computing method calls..."
        ?
    endif

    while .t.

        lNoEof = lGetTextLine( Handle, @cMet )

        cMet   = Alltrim( cMet )

        if ( n := ascan( aStats, {|x| x[1] == cMet } ) ) > 0
            aStats[ n ][ 2 ]++
            nTotal++
        elseif !empty( cMet )
            aadd( aStats, { cMet, 1 } )
            if lVerbose
                ? "New Method...", cMet
            endif
            nTotal++
        endif

        SysRefresh()

        if !lNoEof
            EXIT
        endif

    end

    FClose( Handle )
    if lVerbose
        ? "Sorting results..."
    endif
    aStats := aSort( aStats,,, {|x,y| x[2] > y[2] } )
    if lVerbose
        ? "Writing results..."
    endif

    Handle = FCREATE( cOutputFile )

    cMet = "Total " + alltrim( str( nTotal ) ) + " messages processed. Profile results:" + CHR(13) + CHR(10) + CHR(13) +CHR(10)
    FWrite( Handle, cMet )

    for n = 1 to len( aStats )
        cMet = padr( aStats[ n ][ 1 ], 22 ) + " --> " + str( aStats[ n ][ 2 ], 6 ) + chr(13) + chr(10)
        FWrite( Handle, cMet )
        SysRefresh()
    next

    FClose( Handle )

return

//---------------------------------------------------------------------------//
