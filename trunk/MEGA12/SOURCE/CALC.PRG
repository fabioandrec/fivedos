// Sample of Calculator with FiveDos

#include "FiveDos.ch"

#define cActual oSay:Cargo[ 1 ]             // Se pone en pantalla
#define nTemp   oSay:Cargo[ 2 ]             //
#define cOper   oSay:Cargo[ 3 ]             // Operacion a realizar

// -------------------------------------------------------------------------- //
function Calc( oWnd )
    Local oWndCalc, oSay
   
   DEFINE WINDOW oWndCalc OF oWnd ;
        AT 2, 2 ;
        SIZE 21, 14 ;
        NOMAXIMIZE ;
        NORESIZE ;
        TITLE " Calculadora " ;

    @  0, 1 SAY oSay OF oWndCalc ;
        PROMPT PadL( "0", 17 ) ;
        COLOR "W+/B"

    oWndCalc:bKey := {| nKey | CalcKeyPressed( nKey, oSay ) }

    oSay:bGetText = {|| PadL( cActual, 17 ) }
    oSay:Cargo    = { "0", 0, " " }

    @  2,  0 BUTTON " / " OF oWndCalc ACTION PressSign( "/", oSay )

    @  2,  5 BUTTON " * " OF oWndCalc ACTION PressSign( "*", oSay )

    @  2, 10 BUTTON " - " OF oWndCalc ACTION PressSign( "-", oSay )

    @  2, 15 BUTTON " + " OF oWndCalc ACTION PressSign( "+", oSay )

    @  4,  0 BUTTON " 7 " OF oWndCalc ACTION Key( "7", oSay )

    @  4,  5 BUTTON " 8 " OF oWndCalc ACTION Key( "8", oSay )

    @  4, 10 BUTTON " 9 " OF oWndCalc ACTION Key( "9", oSay )

    @  4, 15 BUTTON " C " OF oWndCalc ACTION ( cActual := "0", nTemp := 0, oSay:Refresh() )

    @  6,  0 BUTTON " 4 " OF oWndCalc ACTION Key( "4", oSay )

    @  6,  5 BUTTON " 5 " OF oWndCalc ACTION Key( "5", oSay )

    @  6, 10 BUTTON " 6 " OF oWndCalc ACTION Key( "6", oSay )

    @  6, 15 BUTTON " A " OF oWndCalc ACTION ( cActual := "0", nTemp := 0, ;
                                                  cOper := " ", oSay:Refresh() )

    @  8,  0 BUTTON " 1 " OF oWndCalc ACTION Key( "1", oSay )

    @  8,  5 BUTTON " 2 " OF oWndCalc ACTION Key( "2", oSay )

    @  8, 10 BUTTON " 3 " OF oWndCalc ACTION Key( "3", oSay )

    @  8, 15 BUTTON " P " OF oWndCalc ACTION ( oWndCalc:End(), ;
                                            KeyPlus( AllTrim( Str( nTemp ) ) ) )

    @ 10,  0 BUTTON " 0      " OF oWndCalc ACTION Key( "0", oSay )

    @ 10, 10 BUTTON " . " OF oWndCalc ACTION Key( ".", oSay )

    @ 10, 15 BUTTON " = " OF oWndCalc ACTION GetResult( oSay )

    ACTIVATE WINDOW oWndCalc NOWAIT

Return nil

// -------------------------------------------------------------------------- //
Static Function CalcKeyPressed( nKey, oSay )
    Do Case
        Case nKey >= 48 .And. nKey <= 57
            Key( Chr( nKey ), oSay )
        Case nKey == 47  // /
            PressSign( Chr( nKey ), oSay )
        Case nKey == 42  // *
            PressSign( Chr( nKey ), oSay )
        Case nKey == 43  // +
            PressSign( Chr( nKey ), oSay )
        Case nKey == 45  // -
            PressSign( Chr( nKey ), oSay )
        Case nKey == 46  // .
            PressSign( Chr( nKey ), oSay )
        Case nKey == K_ENTER .Or. nKey == 61  // =
            GetResult( oSay )
    Otherwise
        Return nKey
    EndCase
Return 0

// -------------------------------------------------------------------------- //
Static Procedure PressSign( cSign, oSay )
    If !Empty( cOper )
        GetResult( oSay )
    EndIf
    cOper := cSign
    nTemp := Val( cActual )
    cActual := "0"
//    oSay:Refresh()
Return

// -------------------------------------------------------------------------- //
Static Procedure GetResult( oSay )
    Do Case
        Case cOper == "+"
            nTemp += Val( cActual )
        Case cOper == "-"
            nTemp -= Val( cActual )
        Case cOper == "*"
            nTemp *= Val( cActual )
        Case cOper == "/"
            nTemp /= Val( cActual )
        Otherwise
            Return
    EndCase
    cActual := Alltrim( Str( nTemp, 17, 4 ) )
    While SubStr( cActual, Len( cActual ) ) == "0"
        cActual := SubStr( cActual, 1, Len( cActual ) - 1 )
    EndDo
    If SubStr( cActual, Len( cActual ) ) == "."
        cActual := SubStr( cActual, 1, Len( cActual ) - 1 )
    EndIf
    cOper := " "
    oSay:Refresh()
Return

// -------------------------------------------------------------------------- //
Static Procedure Key( cKey, oSay )
    If Len( cActual ) < 17
        If cActual == "0"
            cActual := cKey
        Else
            cActual += cKey
        EndIf
        oSay:Refresh()
    EndIf
Return

// -------------------------------------------------------------------------- //
