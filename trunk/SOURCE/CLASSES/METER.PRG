#include "FiveDos.ch"
#include "SysColor.ch"

//------------------------------------------------------------------------//

CLASS TMeter FROM TControl

    CLASSDATA nOrder            AS NUMERIC

    DATA nLocalOrder, nClrBar,  ;
         nClrNoBar, nLine,      ;
         nTotal, nClrBar        AS NUMERIC

    DATA cText, cMeterChar      AS CHARACTER
    DATA lPercent               AS LOGICAL
    DATA bActual                AS BLOCK

    METHOD New( nRow, nCol, bnActual,;
                nTotal, oWnd, nWidth, cPrompt, lNoPorcentage, ;
                cClrBar, acColorLabel , lUpdate ) CONSTRUCTOR

    METHOD Refresh()

    METHOD SetActual( nActual )

    METHOD SetColors( cColor, n ) INLINE ;                // n = local var.
           ::nClrBar    := if( Empty( n := nStrColor( cColor, 1 ) ),;
                              aSysColor( CLR_GET ), n ),;
           ::nClrNoBar  := if( Empty( n := nStrColor( cColor, 2 ) ),;
                              aSysColor( CLR_GET_HI ), n )

    METHOD Destroy() INLINE ReleaseChar( ".METER." + StrZero( ::nLocalOrder, 8 ) )

ENDCLASS

//------------------------------------------------------------------------//

METHOD New( nRow, nCol, bActual, nTotal, oWnd, nWidth, cPrompt,;
            lNoPorcentage, cClrBar, acColorLabel, lUpdate )

    DEFAULT     nWidth          := 10,;
                nRow            := 1 ,;
                nCol            := 1 ,;
                lNoPorcentage   := .f.,;
                bActual         := {|| 0 }

    BYNAME nTotal DEFAULT 10
    DEFAULT cPrompt := ""

    ::cText     := cPrompt
    ::nLine     := if( Empty( cPrompt ) .and. !lNoPorcentage, 1, 0 )
    ::bActual   := bActual
    ::lPercent  := !lNoPorcentage

    ::nLocalOrder   := ++::nOrder
    ::cMeterChar    := AllocChars( '.METER.'+ strzero( ::nLocalOrder, 8 ), 1 )

    Super:New( nRow, nCol, nWidth, 2 - ::nLine ,,, oWnd,,cPrompt,, acColorLabel )
    ::lUpdate := lUpdate

    if ::nLine = 1
        ::oLabel:SetPos( 500, 500 ) // al limbo
    else
        ::oLabel:ChangeSize( ::nWidth, 1 )
    endif

    ::SetColors( cClrBar )

    ::Refresh()

return Self

//------------------------------------------------------------------------//

METHOD Refresh()
    local n, nActual := eval( ::bActual )

    ::BeginPaint()

    if ::nLine = 0 .and. ::lPercent
        ::oLabel:SetText( ::cText + Transform( nActual / ::nTotal * 100, '999' ) + '%' )
    endif

    ::Say( 1 - ::nLine , 0, space( ::nWidth ), ::nClrNoBar )
         // limpio el aarea ( por si baja ....)

    n := int( nActual / ::nTotal * ::nWidth * 8 )

    ::Say( 1 - ::nLine, 0, replicate( "Û", int( n / 8 ) ), ::nClrBar )

    if n % 8 > 0
        SetChar( asc( ::cMeterChar ), ;
                 replicate( chr( nBin2Dec( left( ;
                        Replicate('1', n % 8)+ '0000000', 8 ) ) ), 16 ) )
        ::Say( 1-::nLine, int( n / 8 ), ::cMeterChar, ::nClrBar )
    endif

    ::Super:Refresh()

    ::EndPaint()

return nil

//--------------------------------------------------------------------------//

METHOD SetActual( nActual )

    if nActual > 0 .and. nActual <= ::nTotal

        eval( ::bActual, nActual )

        ::Refresh()
    end

return nil

//---------------------------------------------------------------------------//
