/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Class RGroup for class TReport                             ³
³         File: RGROUP.PRG                                                 ³
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

CLASS TRGroup

     DATA oReport
     DATA aTotal
     DATA bGroup, bHeader, bFooter, bHeadFont, bFootFont
     DATA cValue, cOldValue
     DATA nCounter, nHeaderHeight, nFooterHeight
     DATA lEject

     METHOD New(bGroup, bHeader, bFooter, bFont, lEject, oReport) CONSTRUCTOR

     METHOD Reset() INLINE Afill(::aTotal,0)      ,;
                           ::nCounter := 0        ,;
                           ::cValue := ::cOldValue

     METHOD Stabilize()
     METHOD Header(nRow)
     METHOD Footer(nRow)
     METHOD Total(nRow)

     METHOD Evaluate() INLINE ::nCounter++

     METHOD Check()    INLINE !(::cOldValue := cValToChar(Eval(::bGroup)) ,;
                                ::cOldValue == ::cValue )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( bGroup     ,;
            bHeader    ,;
            bFooter    ,;
            bFont      ,;
            lEject     ,;
            oReport     )  CLASS TRGroup

     DEFAULT bGroup      := {|| ""}          ,;
             bHeader     := {|| ""}          ,;
             bFooter     := {|| "Total..."}  ,;
             bFont       := {|| 1 }          ,;
             lEject      := .F.

     ::bGroup     = bGroup
     ::bHeader    = bHeader
     ::bFooter    = bFooter
     ::bHeadFont  = bFont
     ::bFootFont  = bFont
     ::oReport    = oReport
     ::lEject     = lEject
     ::cValue     = ""
     ::cOldValue  = ""
     ::nCounter   = 0

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Total(nRow,bFont)  CLASS TRGroup

     LOCAL nFor, nColumns, nCol

     DEFAULT nRow  := 0 ,;
             bFont := ::oReport:bStdFont

     nColumns := len(::oReport:aColumns)

     IF !(::oReport:lTotal)
          RETU NIL
     ENDIF

     FOR nFor := 1 TO nColumns

          IF !(::oReport:aColumns[nFor]:lTotal)
               LOOP
          ENDIF

          DO CASE

               CASE ::oReport:aColumns[nFor]:nPad == RPT_LEFT
                    nCol := ::oReport:aCols[nFor]

               CASE ::oReport:aColumns[nFor]:nPad == RPT_RIGHT
                    nCol := ::oReport:aCols[nFor]+;
                            ::oReport:aColumns[nFor]:nWidth-;
                            ::oReport:oDevice:GetTextWidth(;
                              Transform(::aTotal[nFor],;
                                        ::oReport:aColumns[nFor]:cTotalPict),;
                              ::oReport:aFont[eval(bFont)])

               CASE ::oReport:aColumns[nFor]:nPad == RPT_CENTER
                    nCol := ::oReport:aCols[nFor]+;
                            Int(::oReport:aColumns[nFor]:nWidth/2)-;
                            Int(::oReport:oDevice:GetTextWidth(;
                              Transform(::Total[nFor],;
                                        ::oReport:aColumns[nFor]:cTotalPict),;
                               ::oReport:aFont[eval(bFont)])/2)
               OTHERWISE
                    nCol := ::oReport:aCols[nFor]
          ENDCASE

          ::oReport:oDevice:Say(::oReport:nRow ,;
                                nCol ,;
                                Transform(::aTotal[nFor],;
                                ::oReport:aColumns[nFor]:cTotalPict),;
                                ::oReport:aFont[eval(bFont)] )

     NEXT

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Stabilize() CLASS TRGroup

     ::aTotal    := Array(len(::oReport:aColumns))
     ::cOldValue := cValToChar(Eval(::bGroup))
     ::cValue    := ::cOldValue


     IF eval(::bHeader) == ""
          ::nHeaderHeight := 0
     ELSE
          ::nHeaderHeight := ::oReport:oDevice:GetTextHeight(eval(::bHeader),;
                             ::oReport:aFont[eval(::bHeadFont)] )
     ENDIF

     IF eval(::bFooter) == ""
          ::nFooterHeight := 0
     ELSE
          ::nFooterHeight := ::oReport:oDevice:GetTextHeight(eval(::bFooter),;
                             ::oReport:aFont[eval(::bFootFont)] )
     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Header(nRow) CLASS TRGroup

     IF eval(::bHeader) == ""
          RETU NIL
     ENDIF

     ::oReport:oDevice:Say(nRow ,;
                           ::oReport:nMargin ,;
                           eval(::bHeader) ,;
                           ::oReport:aFont[eval(::bHeadFont)] )

     IF eval(::bFooter) == "" .AND. ::oReport:lSummary
          ::Total(nRow,::bHeadFont)
     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Footer(nRow) CLASS TRGroup

     IF eval(::bFooter) == ""
          IF !::oReport:lSummary
               ::Total(nRow)
          ENDIF
          RETU NIL
     ENDIF

     ::oReport:oDevice:Say(nRow ,;
                           ::oReport:nMargin ,;
                           eval(::bFooter) ,;
                           ::oReport:aFont[eval(::bFootFont)] )

     ::Total(nRow,::bFootFont)

RETURN NIL
