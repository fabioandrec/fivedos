#include "FiveDos.ch"
#include "Eval.ch"

//----------------------------------------------------------------------------//

function PaletteDlg()

    local oDlgPal
    local oRed, oGreen, oBlue
    local oGetDAC, nDAC := 0
    local aDAC := aGetDAC( nDAC )
    local oGetRed, oGetGreen, oGetBlue

    DEFINE DIALOG oDlgPal ;
                    SIZE 73, 16 ;
                    TITLE 'FiveDos VGA pallete control'

    @ 1, 31 GET oGetDAC VAR nDAC LABEL "&Color Reg" PICTURE "99" ;
            VALID oGetDAC:cText := max( 0, min( 63, nDAC ) ), ;
                  RefreshAll( nDAC, oRed, oGreen, oBlue,;
                              oGetRed, oGetGreen, oGetBlue,;
                              aDAC, oDlgPal ), .t. ;
            OF oDlgPal

    @ 3, 1 GET oGetRed VAR aDAC[ 1 ] LABEL "&Red  " PICTURE "999" ;
            VALID oGetRed:cText := max( 0, min( 63, aDAC[ 1 ] ) ), ;
                  RefreshDac( nDAC, aDAC ), .t. ;
            OF oDlgPal
    @ 4, 1 SCROLLBAR oRed SIZE 69 RANGE 64 HORIZONTAL ;
                ON UP       oGetRed:cText := max( --aDAC[ 1 ], 0   ), RefreshDac( nDAC, aDAC )    ;
                ON DOWN     oGetRed:cText:= min( ++aDAC[ 1 ], 63 ), RefreshDac( nDAC, aDAC )      ;
                ON PAGEUP   oGetRed:cText:= max( aDAC[ 1 ] - 8, 0 ), RefreshDac( nDAC, aDAC )     ;
                ON PAGEDOWN oGetRed:cText:= min( aDAC[ 1 ] + 8, 63 ), RefreshDac( nDAC, aDAC )    ;
                ON THUMBPOS oGetRed:cText:= max( 0, min( 63, aDAC[ 1 ] + nPos ) ), RefreshDac( nDAC, aDAC ) ;
                PAGESTEP 8   ;
                OF oDlgPal
    @ 6, 1 GET oGetGreen VAR aDAC[ 2 ] LABEL "&Green" PICTURE "999" ;
            VALID oGetGreen:cText := max( 0, min( 63, aDAC[ 2 ] ) ), ;
                  RefreshDac( nDAC, aDAC ), .t. ;
            OF oDlgPal
    @ 7, 1 SCROLLBAR oGreen SIZE 69 RANGE 64 HORIZONTAL ;
                ON UP       oGetGreen:cText := max( --aDAC[ 2 ], 0   ), RefreshDac( nDAC, aDAC )    ;
                ON DOWN     oGetGreen:cText := min( ++aDAC[ 2 ], 63 ), RefreshDac( nDAC, aDAC )     ;
                ON PAGEUP   oGetGreen:cText := max( aDAC[ 2 ] - 8, 0 ), RefreshDac( nDAC, aDAC )    ;
                ON PAGEDOWN oGetGreen:cText := min( aDAC[ 2 ] + 8, 63 ), RefreshDac( nDAC, aDAC )   ;
                ON THUMBPOS oGetGreen:cText := max( 0, min( 63, aDAC[ 2 ] + nPos ) ), RefreshDac( nDAC, aDAC ) ;
                PAGESTEP 8   ;
                OF oDlgPal
    @ 9, 1 GET oGetBlue VAR aDAC[ 3 ] LABEL "&Blue " PICTURE "999" ;
            VALID oGetBlue:cText := max( 0, min( 63, aDAC[ 3 ] ) ), ;
                  RefreshDac( nDAC, aDAC ), .t. ;
            OF oDlgPal
    @ 10, 1 SCROLLBAR oBlue SIZE 69 RANGE 64 HORIZONTAL ;
                ON UP       oGetBlue:cText := max( --aDAC[ 3 ], 0   ), RefreshDac( nDAC, aDAC )    ;
                ON DOWN     oGetBlue:cText := min( ++aDAC[ 3 ], 63 ), RefreshDac( nDAC, aDAC )     ;
                ON PAGEUP   oGetBlue:cText := max( aDAC[ 3 ] - 8, 0 ), RefreshDac( nDAC, aDAC )    ;
                ON PAGEDOWN oGetBlue:cText := min( aDAC[ 3 ] + 8, 63 ), RefreshDac( nDAC, aDAC )   ;
                ON THUMBPOS oGetBlue:cText := max( 0, min( 63, aDAC[ 3 ] + nPos ) ), RefreshDac( nDAC, aDAC ) ;
                PAGESTEP 8   ;
                OF oDlgPal

    oRed:nOption   = aDac[ 1 ] + 1
    oGreen:nOption = aDac[ 2 ] + 1
    oBlue:nOption  = aDac[ 3 ] + 1

    @ 12, 10 BUTTON " &Plus Reg " OF oDlgPal ;
                    ACTION oGetDAC:cText := max( 0, min( 63, ++nDAC ) ),;
                           RefreshAll( nDAC, oRed, oGreen, oBlue,;
                                       oGetRed, oGetGreen, oGetBlue,;
                                       aDAC, oDlgPal )
    @ 12, 32 BUTTON " &Minus Reg " OF oDlgPal ;
                    ACTION oGetDAC:cText := max( 0, min( 63, --nDAC ) ),;
                           RefreshAll( nDAC, oRed, oGreen, oBlue,;
                                       oGetRed, oGetGreen, oGetBlue,;
                                       aDAC, oDlgPal )
    @ 12, 54 BUTTON "   &Ok   " OF oDlgPal ACTION oDlgPal:End()

    ACTIVATE DIALOG oDlgPal ON PAINT ;
            DO oDlgPal:Say( 1, 5 + n, chr( 219 ), n ) ;
               FOR n := 0 TO 15

return nil

//---------------------------------------------------------------------------//

static function RefreshDac( nDac, aDAC )
return SetDAC( nDac, aDAC[ 1 ], aDAC[ 2 ], aDAC[ 3 ] )

//---------------------------------------------------------------------------//

static function RefreshAll( nDAC, oRed, oGreen, oBlue, ;
                            oGetRed, oGetGreen, oGetBlue, aDAC, oDlg )

    local aNew := aGetDAC( nDAC )
    acopy( aNew, aDac )

    oDlg:BeginPaint()

    oGetRed:Clear()
    oGetGreen:Clear()
    oGetBlue:Clear()
    oRed:SetOption( aDac[ 1 ] + 1 )
    oGreen:SetOption( aDac[ 2 ] + 1 )
    oBlue:SetOption( aDac[ 3 ] + 1 )

    oDlg:EndPaint()

return nil

//---------------------------------------------------------------------------//
