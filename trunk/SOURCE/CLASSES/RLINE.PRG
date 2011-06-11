/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Class RLine for class TReport                              ³
³         File: RLINE.PRG                                                  ³
³       Author: Ignacio Ortiz de Z£¤iga Echeverr¡a                         ³
³          CIS: Ignacio Ortiz (100042,3051)                                ³
³         Date: 07/28/94                                                   ³
³         Time: 20:20:07                                                   ³
³    Copyright: 1994 by Ortiz de Zu¤iga, S.L.                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
#include "FiveDos.ch"
#include "report.ch"

//----------------------------------------------------------------------------//

CLASS TRLine

     DATA oReport
     DATA aLine, aFont, aRow, aWidth, aPad
     DATA nCol, nHeight, nWidth

     METHOD New(aLine, oReport, nPad) CONSTRUCTOR

     METHOD Stabilize(nFirstRow, nFirstCol)

     METHOD Say(nStartRow)

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( aLine      ,;
            oReport    ,;
            nPad         )  CLASS TRLine

     DEFAULT nPad  := RPT_LEFT

     IF len(aLine) == 0
          aLine := {{|| ""} }
     ENDIF

     ::aLine   = aLine
     ::oReport = oReport
     ::aFont   = Afill(Array(len(aLine)),{|| 1 })
     ::aPad    = Afill(Array(len(aLine)), nPad )
     ::aWidth  = Afill(Array(len(aLine)), 0 )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Stabilize(nFirstRow,nFirstCol) CLASS TRLine

     LOCAL nFor, nTmpRow

     DEFAULT nFirstRow := 0 ,;
             nFirstCol := 0

     nTmpRow := nFirstRow

     ::aRow   := array(len(::aLine ))
     ::nCol   := nFirstCol
     ::nWidth := 0

     IF eval(::aLine[1]) == ""
          Afill(::aWidth,0)
          ::nHeight := 0
          RETU NIL
     ENDIF

     FOR nFor := 1 TO len(::aRow)
          ::aRow[nFor]   := nTmpRow
          nTmpRow        += ::oReport:oDevice:GetTextHeight(eval(::aLine [nFor]),;
                            ::oReport:aFont[eval(::aFont[nFor])])
          ::aWidth[nFor] := ::oReport:oDevice:GetTextWidth(eval(::aLine [nFor]),;
                            ::oReport:aFont[eval(::aFont[nFor])])
          ::nWidth       := Max(::nWidth,::aWidth[nFor])
     NEXT

     ::nHeight := nTmpRow - nFirstRow

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Say(nStartRow) CLASS TRLine

     LOCAL nFor, nCol

     DEFAULT nStartRow := 0

     IF eval(::aLine[1]) == ""
          RETU NIL
     ENDIF

     FOR nFor := 1 TO len(::aLine )

          DO CASE
               CASE ::aPad[nFor] == RPT_LEFT
                    nCol := ::nCol
               CASE ::aPad[nFor] == RPT_RIGHT
                    nCol := ::oReport:nMargin+;
                            ::oReport:nRptWidth-;
                            ::aWidth[nFor]
               CASE ::aPad[nFor] == RPT_CENTER
                    nCol := ::oReport:nMargin+;
                            Int(::oReport:nRptWidth/2)-;
                            Int(::aWidth[nFor]/2)
               OTHERWISE
                    nCol := ::nCol
          ENDCASE

          ::oReport:oDevice:Say(::aRow[nFor]+nStartRow ,;
                                nCol ,;
                                eval(::aLine [nFor]),;
                                ::oReport:aFont[eval(::aFont[nFor])] )

     NEXT

RETURN NIL
