/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Class RColumn for class TReport                            ³
³         File: RCOLUMN.PRG                                                ³
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

CLASS TRColumn

     DATA oReport
     DATA aData, aTitle, aPicture
     DATA bDataFont, bTitleFont, bTotalFont, bTotalExpr
	DATA cTotalPict
     DATA nWidth, nDataHeight, nTitleHeight, nTotal, nCol, nSize, nPad, nPen
     DATA lTotal, lShadow, lGrid, lTotalExpr

     METHOD New(aTitle, nCol, aData, nSize, aPicture,;
                bFont, lTotal, bTotalExpr, cFmt, lShadow, lGrid,;
                oReport  ) CONSTRUCTOR

     METHOD Stabilize()

     METHOD SayTitle(nRow, nCol, nLine)
     METHOD SayData(nRow, nCol, nLine)
     METHOD SayTotal(nRow, nCol)

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( aTitle     ,;
            nCol       ,;
            aData      ,;
            nSize      ,;
            aPicture   ,;
            bFont      ,;
            lTotal     ,;
            bTotalExpr ,;
            cFmt       ,;
            lShadow    ,;
            lGrid      ,;
            nPen       ,;
            oReport     )  CLASS TRColumn

     DEFAULT aTitle      := {{|| ""} }                   ,;
             aData       := {{|| ""} }                   ,;
             nSize       := 0                            ,;
             aPicture    := {""}                         ,;
             nCol        := 0                            ,;
             bFont       := {|| 1 }                      ,;
             nPen        := 1                            ,;
             lTotal      := .F.                          ,;
             bTotalExpr  := { || .t. },;
             lShadow     := .F.                          ,;
             lGrid       := .F.                          ,;
             cFmt        := iif(Valtype(Eval(aData[1]))=="N",;
                                "RIGHT", "LEFT")

     ::aTitle     = aTitle
     ::aData      = aData
     ::nSize      = nSize
     ::aPicture   = aPicture
     ::bDataFont  = bFont
     ::bTitleFont = {|| 1 }
     ::bTotalFont = bFont
     ::lTotal     = lTotal
     ::lShadow    = lShadow
     ::lGrid      = lGrid
     ::nPen       = nPen
     ::nTotal     = 0
     ::oReport    = oReport
     ::bTotalExpr = bTotalExpr
     ::nCol       = nCol
     ::cTotalPict = iif(len(aPicture)>0, aPicture[1], "")
     ::nWidth     = 0

     ::lTotalExpr = !(bTotalExpr == NIL)

     IF cFmt == "LEFT"
          ::nPad = RPT_LEFT
     ELSEIF cFmt == "RIGHT"
          ::nPad = RPT_RIGHT
     ELSEIF cFmt == "CENTER" .OR. cFmt == "CENTERED"
          ::nPad = RPT_CENTER
     ELSE
          ::nPad = RPT_LEFT
     ENDIF

     DO WHILE len(::aPicture) < len(::aData)
          Aadd(::aPicture,::cTotalPict)
     ENDDO

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Stabilize() CLASS TRColumn

     LOCAL nFor, nWidth, nLen

     ::nDataHeight  := ::oReport:oDevice:GetTextHeight("B",;
                       ::oReport:aFont[eval(::bDataFont)])
     ::nTitleHeight := ::oReport:oDevice:GetTextHeight("B",;
                       ::oReport:aFont[eval(::bTitleFont)])

     IF !empty(::nSize)
          ::nWidth := ::oReport:oDevice:GetTextWidth(Replicate("B",::nSize),;
                       ::oReport:aFont[eval(::bDataFont)])
          RETU NIL
     ENDIF


     FOR nFor := 1 TO len(::aData)
          nLen      := len(cValtoChar(Transform(eval(::aData[nFor]),;
                           ::aPicture[nFor])))
          nWidth    := ::oReport:oDevice:GetTextWidth(Replicate("B",nLen),;
                       ::oReport:aFont[eval(::bDataFont)])
          ::nWidth  := Max(::nWidth,nWidth)
     NEXT

     FOR nFor := 1 TO len(::aTitle)
          nLen      := len(eval(::aTitle[nFor]))
          nWidth    := ::oReport:oDevice:GetTextWidth(Replicate("B",nLen),;
                       ::oReport:aFont[eval(::bTitleFont)])
          ::nWidth  := Max(::nWidth,nWidth)
     NEXT


RETURN NIL

//----------------------------------------------------------------------------//

METHOD SayTitle(nRow, nCol, nLine)  CLASS TRColumn

     DEFAULT nRow  := 0      ,;
             nCol  := ::nCol ,;
             nLine := 1

     IF nLine > len(::aTitle)
          RETU NIL
     ENDIF

     DO CASE
          CASE ::nPad == RPT_RIGHT
               nCol := nCol+::nWidth-;
                       ::oReport:oDevice:GetTextWidth(eval(::aTitle[nLine]),;
                       ::oReport:aFont[eval(::bTitleFont)])

          CASE ::nPad == RPT_CENTER
               nCol := nCol+Int(::nWidth/2)-;
                       Int(::oReport:oDevice:GetTextWidth(eval(::aTitle[nLine]),;
                          ::oReport:aFont[eval(::bTitleFont)])/2)
     ENDCASE

     ::oReport:oDevice:Say(nRow ,;
                           nCol ,;
                           eval(::aTitle[nLine]) ,;
                           ::oReport:aFont[eval(::bTitleFont)] ,;
                           ::nWidth)

RETURN NIL


//----------------------------------------------------------------------------//

METHOD SayData(nRow, nCol, nLine)  CLASS TRColumn

     DEFAULT nRow  := 0      ,;
             nCol  := ::nCol ,;
             nLine := 1

     IF nLine > len(::aData)
          RETU NIL
     ENDIF

     DO CASE
          CASE ::nPad == RPT_RIGHT
               nCol := nCol+::nWidth-;
                       ::oReport:oDevice:GetTextWidth(;
                         Transform(eval(::aData[nLine]),;
                                   ::aPicture[nLine]),;
                         ::oReport:aFont[eval(::bDataFont)])

          CASE ::nPad == RPT_CENTER
               nCol := nCol+Int(::nWidth/2)-;
                       Int(::oReport:oDevice:GetTextWidth(;
                           Transform(eval(::aData[nLine]),;
                                     ::aPicture[nLine]),;
                           ::oReport:aFont[eval(::bDataFont)])/2)
     ENDCASE

     ::oReport:oDevice:Say(nRow,;
                           nCol,;
                           Transform(eval(::aData[nLine]),;
                                     ::aPicture[nLine]),;
                           ::oReport:aFont[eval(::bDataFont)] ,;
                           ::nWidth)

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SayTotal(nRow, nCol)  CLASS TRColumn

     DEFAULT nRow  := 0      ,;
             nCol  := ::nCol

     IF !::lTotal
          RETU NIL
     ENDIF

     DO CASE
          CASE ::nPad == RPT_RIGHT
               nCol := nCol+::nWidth-;
                       ::oReport:oDevice:GetTextWidth(Transform(::nTotal,::cTotalPict),;
                       ::oReport:aFont[eval(::bTotalFont)])

          CASE ::nPad == RPT_CENTER
               nCol := nCol+Int(::nWidth/2)-;
                       Int(::oReport:oDevice:GetTextWidth(Transform(::nTotal,::cTotalPict),;
                          ::oReport:aFont[eval(::bTotalFont)])/2)
     ENDCASE

     ::oReport:oDevice:Say(nRow,;
                           nCol,;
                           Transform(::nTotal, ::cTotalPict),;
                           ::oReport:aFont[eval(::bTotalFont)] ,;
                           ::nWidth)

RETURN NIL

//----------------------------------------------------------------------------//

METHOD TitleHeight(nLine) CLASS TRColumn

     LOCAL nFor, nWidth, nLen

     ::nDataHeight  := len(::aData) * ;
                       ::oReport:oDevice:GetTextHeight("B",;
                       ::oReport:aFont[eval(::bDataFont)])
     ::nTitleHeight := len(::aTitle) * ;
                       ::oReport:oDevice:GetTextHeight("B",;
                       ::oReport:aFont[eval(::bTitleFont)])

     IF !empty(::nWidth)
          RETU NIL
     ENDIF

     FOR nFor := 1 TO len(::aData)
          nLen      := cValtoChar(len(eval(::aLine [nFor])))
          nWidth    := ::oReport:oDevice:GetTextWidth(Replicate("B",nLen),;
                       ::oReport:aFont[eval(::bDataFont)])
          ::nWidth  := Max(::nWidth,nWidth)
     NEXT

RETURN NIL
