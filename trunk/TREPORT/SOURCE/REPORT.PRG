#include "fivedos.ch"
#include "Font.ch"
#include "Pen.ch"

#define RPT_LEFT     1
#define RPT_RIGHT    2
#define RPT_CENTER   3
#define RPT_TOP      4
#define RPT_BOTTOM   5

#define INCHES   1
#define CMETERS  2

#define CLR_BLACK   0

//----------------------------------------------------------------------------//

CREATE CLASS TReport
export:
     VAR oDevice, oTitle, oHeader, oFooter, oRptWnd, oBrush
     VAR aGroups, aColumns, aFont, aCols, aText, aData, aPen
     VAR bFor, bWhile , bInit, bEnd, bStartLine, bEndLine, bStartPage, ;
          bEndPage, bStartGroup, bEndGroup, bSkip, bStdFont, bPreview, ;
          bChange
     VAR cRptFile, cResName, cTotalChr, cGroupChr, cTitleUpChr, ;
          cTitleDnChr, cFile, cName, cPageTotal, cGrandTotal
     VAR nWidth, nHeight, nMargin, nRow, nPage, nMaxTitle, nMaxData,;
          nSeparator, nLeftMargin, nRightMargin, nTopMargin, nDnMargin,;
          nTitleRow, nBottomRow, nStdLineHeight, nRptWidth, nLogPixX,;
          nLogPixY, nFirstdrow, nLastdrow, nTitleHeight, nCounter
     VAR lSummary, lTotal, lFinish, lStable, lGroup, lPrinter, lScreen, ;
          lFirstRow, lCreated, lPreview, lBreak, lSpanish, lShadow, lGrid
     VAR cargo

     METHOD New CONSTRUCTOR

     METHOD AddColumn
     METHOD DelColumn
     METHOD InsColumn

     METHOD AddGroup
     METHOD DelGroup

     METHOD Stabilize
     METHOD Skip

     METHOD Start     // KF instead of init() for compatibnility with Class(y)
     METHOD End


     METHOD StartLine
     METHOD EndLine
     METHOD StartGroup
     METHOD EndGroup
     METHOD StartPage
     METHOD EndPage
     METHOD NeedNewPage

     METHOD NewLine
     METHOD BackLine

     METHOD ColTitle
     METHOD TotalLine
     METHOD PageTotal

     METHOD Activate

     METHOD Play

     METHOD Margin

     METHOD Say

     METHOD SayBitmap
     METHOD Box
     METHOD Line
     METHOD Shadow
     METHOD KillShadow
     METHOD Grid

     METHOD Inc2Pix
     METHOD Cmt2Pix

END CLASS

//----------------------------------------------------------------------------//

METHOD new( aTitle, aHead, aFoot, aFont, aPen, lSummary, cRptFile, ;
            cResName, lPrinter, lScreen, cFile, oDevice, cName,;
            cTFmt, cHFmt, cFFmt)

     LOCAL nFor, nTFmt, nHFmt, nFFmt, cPrinter

     LOCAL lFontDefined := .T. ,;
           lPenDefined  := .T.

     DEFAULT aTitle      := {{|| ""} }   ,;
             aHead       := {{|| ""} }   ,;
             aFoot       := {{|| ""} }   ,;
             lSummary    := .F.          ,;
             cRptFile    := ""           ,;
             cResName    := ""           ,;
             lPrinter    := .F.          ,;
             lScreen     := .F.          ,;
             cFile       := ""           ,;
             cName       := "FiveWin Report" ,;
             cTFmt       := "CENTER"     ,;
             cHFmt       := "LEFT"       ,;
             cFFmt       := "LEFT"

     ::lSummary      = lSummary
     ::cRptFile      = cRptFile
     ::cResName      = cResName
     ::lStable       = .F.
     ::nRow          = 0
     ::nPage         = 0
     ::nSeparator    = 0
     ::nCounter      = 0
     ::aColumns      = {}
     ::aGroups       = {}
     ::bStdFont      = {|| 1 }
     ::bPreview      = {|oDevice, lSpanish| .t. } // KF {|oDevice, lSpanish| rPreview(oDevice, lSpanish) }
     ::cTotalChr     = "="
     ::cGroupChr     = "-"
     ::cTitleUpChr   = "="
     ::cTitleDnChr   = "="
     ::cPageTotal    = ""
     ::cGrandTotal   = ""
     ::lPrinter      = lPrinter
     ::lScreen       = lScreen
     ::lFirstRow     = .T.
     ::lCreated      = .F.
     ::lPreview      = .F.
     ::lSpanish      = .F.
     ::lBreak        = .F.
     ::lShadow       = .F.
     ::cFile         = cFile
     ::cName         = cName

     IF cTFmt == "LEFT"
          nTFmt = RPT_LEFT
     ELSEIF cTFmt == "RIGHT"
          nTFmt = RPT_RIGHT
     ELSEIF cTFmt == "CENTER" .OR. cTFmt == "CENTERED"
          nTFmt = RPT_CENTER
     ELSE
          nTFmt = RPT_CENTER
     ENDIF

     IF cHFmt == "LEFT"
          nHFmt = RPT_LEFT
     ELSEIF cHFmt == "RIGHT"
          nHFmt = RPT_RIGHT
     ELSEIF cHFmt == "CENTER" .OR. cHFmt == "CENTERED"
          nHFmt = RPT_CENTER
     ELSE
          nHFmt = RPT_LEFT
     ENDIF

     IF cFFmt == "LEFT"
          nFFmt = RPT_LEFT
     ELSEIF cFFmt == "RIGHT"
          nFFmt = RPT_RIGHT
     ELSEIF cFFmt == "CENTER" .OR. cFFmt == "CENTERED"
          nFFmt = RPT_CENTER
     ELSE
          nFFmt = RPT_LEFT
     ENDIF

     /*
     Indicar device
     */

     IF oDevice <> NIL
          ::oDevice := oDevice
     ELSEIF ::lPrinter
          cPrinter := SetDriver()
          if "HP" $ cPrinter .and. "LASER" $ cPrinter
             ::oDevice := TDevice():New()  // KF
          else
             // ::oDevice := THpLaser():New()  // KF
          endif
     ELSEIF ::lScreen
          ::oDevice := TDevice():New()  // KF
          // ::lPreview := .T.
          // ::oDevice := TPrinter():New(cName,.T.,.T.)
     ELSEIF !empty(::cFile)
          ::oDevice := TDevice():New(::cFile) // KF
     ELSE
          ::oDevice := TDevice():New()        // KF
     ENDIF

     /*
     Control de que el device es correcto
     */

     * IF empty(::oDevice:hDC)       // KF
     *      RETU NIL                 // KF
     * ELSE                          // KF
          ::lCreated := .T.
     * ENDIF                         // KF


     /*
     Pedir coordenadas del device
     */

     ::nWidth  := ::oDevice:nHorzRes()
     ::nHeight := ::oDevice:nVertRes()

     /*
     Calcular n§ de pixels por pulgada del device
     (nLogPixelX y nLogPixelY siempre me devuelven el valor
     de nLogPixelY, cuando p.p.p. es igual en X que en Y no hay
     problema (lasers) pero sin embargo con matriciales no funciona.)
     Por lo que tengo que calcular el dato jugando con las dimensiones
     f¡sicas y en pixeles del device
     */

     ::nLogPixX := Round(::nWidth/(::oDevice:nHorzSize()/25.4),0)
     ::nLogPixY := Round(::nHeight/(::oDevice:nVertSize()/25.4),0)

     /*
     Si no ha especificado font asignar ARIAL 10
     */

     IF len(aFont) == 0
          lFontDefined := .F.
          Asize(aFont,1)
          DEFINE FONT aFont[1] NAME "ARIAL" SIZE 0,-10
     ENDIF

     /*
     Si no se ha especificado pen crearlo (por si acaso)
     */

     IF len(aPen) == 0
          lPenDefined := .F.
          Asize(aPen,1)
          DEFINE PEN aPen[1] STYLE 0 WIDTH 1 COLOR CLR_BLACK
     ENDIF

     /*
     Crear nuevos fonts basandonos en el Device para ajustar
     el tama¤o de los mismos al device elegido
     */

     ::aFont := Array(len(aFont))
     Aeval(aFont                                       ,;
          {|val,elem|                                   ;
          ::aFont[elem]:= TFont():New(val:cFaceName    ,;
          Int(val:nWidth*::nLogPixX/72)                ,;
          Int(val:nHeight*::nLogPixY/72)               ,;
          .F.                                          ,;
          val:lBold                                    ,;
          val:nEscapement                              ,;
          val:nOrientation                             ,;
          val:nWeight                                  ,;
          val:lItalic                                  ,;
          val:lUnderline                               ,;
          val:lStrikeOut                               ,;
          val:nCharSet                                 ,;
          val:nOutPrecision                            ,;
          val:nClipPrecision                           ,;
          val:nQuality) })

     IF !lFontDefined
          aFont[1]:Release()
     ENDIF

     /*
     Crear nuevos Pens basandonos en el device
     */

     ::aPen := Array(len(aPen))
     Aeval(aPen, {|val,elem|                             ;
                 ::aPen[elem] := Tpen():New( val:nStyle ,;
                 Int(val:nWidth*::nLogPixX/72)          ,;
                 val:nColor)} )
     IF !lPenDefined
          aPen[1]:Release()
     ENDIF

     /*
     Establecer margenes de impresi¢n a 0,2 pulgadas
     */

     ::nLeftMargin  := Int(::nLogPixX*0.2)
     ::nRightMargin := Int(::nLogPixX*0.2)
     ::nTopMargin   := Int(::nLogPixY*0.2)
     ::nDnMargin    := Int(::nLogPixY*0.2)

     /*
     Crear objetos del listado
     */

     ::oHeader := TrLine():New(aHead,Self,nHFmt)
     ::oTitle  := TrLine():New(aTitle,Self,nTFmt)
     ::oFooter := TrLine():New(aFoot,Self,nFFmt)

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Margin(nValue, nType, nScale)

     DEFAULT nValue := .2     ,;
             nType  := RPT_LEFT   ,;
             nScale := INCHES

     IF nScale == CMETERS
          nValue := Int(nValue/2.54)
     ENDIF

     DO CASE
     CASE nType == RPT_TOP
          ::nTopMargin   := Int(::nLogPixY*nValue)
     CASE nType == RPT_BOTTOM
          ::nDnMargin    := Int(::nLogPixY*nValue)
     CASE nType == RPT_LEFT
          ::nLeftMargin  := Int(::nLogPixX*nValue)
     CASE nType == RPT_RIGHT
          ::nRightMargin := Int(::nLogPixX*nValue)
     ENDCASE

     ::lStable := .F.

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Say(nCol, xText, nFont, nPad, nRow)

     LOCAL nStartCol, cText

     DEFAULT nCol  := 1       ,;
             nFont := 1       ,;
             xText := ""      ,;
             nRow  := ::nRow  ,;
             nPad  := 1


     IF nCol <1 .OR. nCol > len(::aCols)
          nCol := 1
     ENDIF

     IF nFont <1 .OR. nFont > len(::aFont)
          nFont := 1
     ENDIF

     cText := cValToChar(xText)


     DO CASE

          CASE nPad == RPT_LEFT
               nStartCol := ::aCols[nCol]

          CASE nPad == RPT_RIGHT
               nStartCol := ::aCols[nCol]+;
                            ::aColumns[nCol]:nWidth-;
                            ::oDevice:GetTextWidth(cText,;
                            ::aFont[nFont])

          CASE nPad == RPT_CENTER
               nStartCol := ::aCols[nCol]+;
                            Int(::aColumns[nCol]:nWidth/2)-;
                            Int(::oDevice:GetTextWidth(cText,;
                               ::aFont[nFont])/2)
          OTHERWISE
               nStartCol := ::aCols[nCol]
     ENDCASE

     ::oDevice:Say(nRow            ,;
                   nStartCol       ,;
                   cText           ,;
                   ::aFont[nFont] )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SayBitmap(nRow, nCol, cBitmap, nWidth, nHeight, nScale)

     LOCAL nPixRow, nPixCol, nPixWidth, nPixHeight

     DEFAULT nRow    := .2       ,;
             nCol    := .2       ,;
             nWidth  := 1        ,;
             nHeight := 1        ,;
             nScale  := INCHES

     IF nScale == CMETERS
          nRow := Int(nRow/2.54)
          nCol := Int(nCol/2.54)
          nWidth := Int(nWidth/2.54)
          nHeight := Int(nHeight/2.54)
     ENDIF

     nPixRow    := Int(::nLogPixY*nRow)
     nPixCol    := Int(::nLogPixX*nCol)
     nPixWidth  := Int(::nLogPixX*nWidth)
     nPixHeight := Int(::nLogPixY*nHeight)

     ::oDevice:SayBitmap(nPixRow, nPixCol, cBitmap, nPixWidth, nPixHeight)

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Box(nRow, nCol, nBottom, nRight, nPen, nScale )


     LOCAL nPixRow, nPixCol, nPixBottom, nPixRight

     DEFAULT nRow    := .2   ,;
             nCol    := .2   ,;
             nBottom := 5    ,;
             nRight  := 5    ,;
             nPen    := 1    ,;
             nScale  := INCHES

     IF nScale == CMETERS
          nRow    := Int(nRow/2.54)
          nCol    := Int(nCol/2.54)
          nBottom := Int(nBottom/2.54)
          nRight  := Int(nRight/2.54)
     ENDIF

     nPixRow    := Int(::nLogPixY*nRow)
     nPixCol    := Int(::nLogPixX*nCol)
     nPixBottom := Int(::nLogPixY*nBottom)
     nPixRight  := Int(::nLogPixX*nRight)

     ::oDevice:Box(nPixRow, nPixCol, nPixBottom, nPixRight, ::aPen[nPen])

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Line( nTop, nLeft, nBottom, nRight, nPen, nScale )


     LOCAL nPixTop, nPixLeft, nPixBottom, nPixRight

     DEFAULT nTop    := .2   ,;
             nLeft   := .2   ,;
             nBottom := 5    ,;
             nRight  := 5    ,;
             nPen    := 1    ,;
             nScale  := INCHES

     IF nScale == CMETERS
          nTop    := Int(nTop/2.54)
          nLeft   := Int(nLeft/2.54)
          nBottom := Int(nBottom/2.54)
          nRight  := Int(nRight/2.54)
     ENDIF

     nPixTop    := Int(::nLogPixY*nTop)
     nPixLeft   := Int(::nLogPixX*nLeft)
     nPixBottom := Int(::nLogPixY*nBottom)
     nPixRight  := Int(::nLogPixX*nRight)

     ::oDevice:Line(nPixTop, nPixLeft, nPixBottom, nPixRight, ::aPen[nPen])

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Shadow ()
     /*
     LOCAL nFor, nCols

     nCols := len(::aColumns)

     IF ::oBrush == NIL
          DEFINE BRUSH ::oBrush COLOR CLR_LIGHTGRAY
     ENDIF

     FOR nFor := 1 TO nCols

          IF ::aColumns[nFor]:lShadow

               ::oDevice:FillRect({::nFirstdRow    ,;
                                   ::aCols[nFor]   ,;
                                   ::nLastdRow     ,;
                                   ::aCols[nFor]+::aColumns[nFor]:nWidth} ,;
                                   ::oBrush)
          ENDIF

     NEXT
     */
RETURN NIL

//----------------------------------------------------------------------------//

METHOD KillShadow ()
     /*
     LOCAL oBrush
     LOCAL nFor, nCols

     nCols := len(::aColumns)

     DEFINE BRUSH oBrush COLOR CLR_WHITE

     FOR nFor := 1 TO nCols

          IF ::aColumns[nFor]:lShadow

               ::oDevice:FillRect({::nRow          ,;
                                   ::aCols[nFor]   ,;
                                   ::nLastdRow     ,;
                                   ::aCols[nFor]+::aColumns[nFor]:nWidth} ,;
                                   oBrush)
          ENDIF

     NEXT

     oBrush:Release()
     */
RETURN NIL

//----------------------------------------------------------------------------//

METHOD Grid ()

     LOCAL nFor, nCols

     nCols := len(::aColumns)

     FOR nFor := 1 TO nCols

          IF ::aColumns[nFor]:lGrid

               ::oDevice:line(::nFirstdRow    ,;
                              ::aCols[nFor]-(::nSeparator/2)   ,;
                              ::nRow     ,;
                              ::aCols[nFor]-(::nSeparator/2),;
                              ::aPen[::aColumns[nFor]:nPen])
               ::oDevice:line(::nFirstdRow    ,;
                              ::aCols[nFor]+::aColumns[nFor]:nWidth+(::nSeparator/2) ,;
                              ::nRow     ,;
                              ::aCols[nFor]+::aColumns[nFor]:nWidth+(::nSeparator/2) ,;
                              ::aPen[::aColumns[nFor]:nPen])
          ENDIF

     NEXT

RETURN NIL


//----------------------------------------------------------------------------//

METHOD Activate(bFor, bWhile, bInit, bEnd, bStartPage, ;
                bEndPage, bStartGroup, bEndGroup, ;
                bStartLine, bEndLine, bChange   )

     LOCAL nColumns, nGroups, nFor1, nFor2, nFor3, nMaxHeight

     DEFAULT bFor     := {|| .T.    } ,;
             bWhile   := {|| !eof() }

     ::bFor        = bFor
     ::bWhile      = bWhile
     ::bInit       = bInit
     ::bEnd        = bEnd
     ::bStartPage  = bStartPage
     ::bEndPage    = bEndPage
     ::bStartGroup = bStartGroup
     ::bEndGroup   = bEndGroup
     ::bStartLine  = bStartLine
     ::bEndLine    = bEndLine
     ::bChange     = bChange

     /*
     Estabilizar el listado
     */

     IF !::lCreated
          RETU NIL
     ENDIF

     ::Stabilize()

     IF !::lStable
          RETU NIL
     ENDIF

     ::Play()  // KF

return self

METHOD Play()

     LOCAL nColumns, nGroups, nFor1, nFor2, nFor3, nMaxHeight

     /*
     Inicializar variables
     */

     nColumns   := len(::aColumns)
     nGroups    := len(::aGroups)
     nMaxHeight := 0

     /*
     Reset de totales por grupo
     */

     Aeval(::aGroups,{|val| val:Reset() })


     /*
     Start de grupo
     */

     Aeval(::aGroups,{|val,elem| ::StartGroup(elem) })

     /*
     Comienzo de la Impresi¢n
	*/

     ::StartPage()
     ::Start()         // KF instead of init() for compatibnility with Class(y)

     /*
     Bucle de rastreo
	*/

     DO WHILE !::lBreak .AND. eval(::bWhile)


          /*
          Refresh
          */

          * SysRefresh() // KF

          /*
          Comprobar condici¢n for
          */

          IF !eval(::bFor)
               ::Skip(1)
               LOOP
          ENDIF

          /*
		Condici¢n de Grupo
		*/

          IF ::lGroup
               FOR nFor1 := 1 TO nGroups
                    ::aGroups[nFor1]:Evaluate()
               NEXT
		ENDIF

		/*
		Cuerpo del Listado
		*/

          FOR nFor1 := 1 TO ::nMaxData

               IF !::lSummary
                    nMaxHeight := 0
                    Aeval(::aColumns,;
                          {|val| nMaxHeight:=Max(nMaxHeight,val:nDataHeight) })
                    ::StartLine(nMaxHeight)
               ENDIF

               FOR nFor2 := 1 TO nColumns

                    IF !::lSummary
                         ::aColumns[nFor2]:SayData(::nRow ,;
                                                   ::aCols[nFor2] ,;
                                                   nFor1)
                    ENDIF

				/*
				Control Sumas
				*/

                    IF ::lTotal                                    .AND. ;
                       ::aColumns[nFor2]:lTotal                    .AND. ;
                       valtype(eval(::aData[nFor2][nFor1])) == "N" .AND. ;
                       eval(::aColumns[nFor2]:bTotalExpr)

                         ::aColumns[nFor2]:ntotal += eval(::aData[nFor2][nFor1])

                         IF ::lGroup
                              FOR nFor3 := 1 TO nGroups
                                   ::aGroups[nFor3]:aTotal[nFor2] += ;
                                     eval(::aData[nFor2][nFor1])
                              NEXT
                         ENDIF

				ENDIF

			NEXT

               IF !::lSummary
                    ::EndLine(nMaxHeight)
               ENDIF

		NEXT

          /*
          Proximo registro o equivalente
		*/

          ::Skip(1)

		/*
		Control Grupo
		*/

          IF ::lGroup
               FOR nFor1 := 1 TO nGroups
                    IF ::aGroups[nFor1]:Check()
                         ::EndGroup(nFor1)
                    ENDIF
               NEXT
		ENDIF

     ENDDO

     ::End()

RETURN Nil

//----------------------------------------------------------------------------//

METHOD Stabilize()

     LOCAL nColumns, nFor1, nFor2, nMaxHeight, nPrnWidth

     nColumns   := len(::aColumns)
     nMaxHeight := 0

     IF nColumns == 0
          ::lCreated := .F.
          Retu (NIL)                           // No hay columnas
     ENDIF

     /*
     Calculo del tama¤o del separador de columnas
     */

     IF empty(::nSeparator)
          ::nSeparator := ::oDevice:GetTextWidth("B",::aFont[eval(::bStdFont)])
     ENDIF

     /*
     C lculo del alto standard de una linea
     */

     ::nStdLineHeight := ::oDevice:GetTextHeight("B",::aFont[eval(::bStdFont)])

     /*
     C lculo del n£mero maximo de titulos y datos pasados a los objetos
     columna
     */

     ::nMaxTitle := 0
     ::nMaxData  := 0

     Aeval(::aColumns, {|Val| ::nMaxTitle := Max(len(Val:aTitle),::nMaxTitle) })
     Aeval(::aColumns, {|Val| ::nMaxData  := Max(len(Val:aData),::nMaxData) })

     /*
     Generar matriz de trabajo para titulos
     */

     ::aText := Array(nColumns,::nMaxTitle)

     FOR nFor1 := 1 TO nColumns
          FOR nFor2 := 1 TO ::nMaxTitle
               IF len(::aColumns[nFor1]:aTitle) < nFor2
                    ::aText[nFor1][nFor2] := {|| "" }
               ELSE
                    ::aText[nFor1][nFor2] := ::aColumns[nFor1]:aTitle[nFor2]
               ENDIF
          NEXT
     NEXT

     /*
     Generar matrices de trabajo para datos de las columnas
     */

     ::aData    := Array(nColumns,::nMaxData)

     FOR nFor1 := 1 TO nColumns
          FOR nFor2 := 1 TO ::nMaxData
               IF len(::aColumns[nFor1]:aData) < nFor2
                    ::aData[nFor1][nFor2] := {|| "" }
               ELSE
                    ::aData[nFor1][nFor2] := ::aColumns[nFor1]:aData[nFor2]
               ENDIF
          NEXT
     NEXT

     /*
     Comprobar si hay grupos
     */

     ::lGroup := (len(::aGroups)>0)


     /*
     Estabilizar objetos
     */

     ::oHeader:Stabilize()
     ::oFooter:Stabilize()
     ::oTitle:Stabilize()

     Aeval(::aColumns, {|Val| Val:Stabilize() })

	/*
	Comprobar si hay algun total
	*/

     ::lTotal := .F.
     aeval(::aColumns,{|Val| iif(Val:lTotal,::lTotal := .T. ,NIL ) })

     /*
     Comprobar si hay alguna columna con Sombra
     */

     ::lShadow := .F.
     aeval(::aColumns,{|Val| iif(Val:lShadow,::lShadow := .T. ,NIL ) })

     /*
     Comprobar si hay alguna columna con Grid
     */

     ::lGrid := .F.
     aeval(::aColumns,{|Val| iif(Val:lGrid,::lGrid := .T. ,NIL ) })

     /*
     C lculo del ancho del listado
     */

     ::nRptWidth := 0
     aeval(::aColumns,{|Val| ::nRptWidth += Val:nWidth+::nSeparator })

     ::nRptWidth -= ::nSeparator

     ::nRptWidth := max(::nRptWidth,::oTitle:nWidth)
     ::nRptWidth := max(::nRptWidth,::oHeader:nWidth)
     ::nRptWidth := max(::nRptWidth,::oFooter:nWidth)

	/*
     Margen del Listado
	*/

     nPrnWidth := ::nWidth - ::nLeftMargin - ::nRightMargin
     ::nMargin := max(Int((nPrnWidth-::nRptWidth)/2),0) + ::nLeftMargin

	/*
     Calculo de las distintas coordenadas de las columnas del listado
	*/

     ::aCols := Array(nColumns)

     ::aCols[1] := iif(::aColumns[1]:nCol>0, ::aColumns[1]:nCol, ::nMargin)

     FOR nFor1 := 2 TO nColumns
          IF ::aColumns[nFor1]:nCol>0
               ::aCols[nFor1] := ::aColumns[nFor1]:nCol
          ELSE
               ::aCols[nFor1] := ::aCols[nFor1-1] + ;
                                ::aColumns[nFor1-1]:nWidth + ;
                                ::nSeparator
          ENDIF
	NEXT

     /*
     Estabilizar lineas fijas de nuevo indicando coordenadas
     */

     ::oHeader:Stabilize(::nTopMargin,::nMargin)
     ::oTitle:Stabilize(::oHeader:nHeight+::nTopMargin,::nMargin)
     ::oFooter:Stabilize(::nHeight-::nDnMargin-::oFooter:nHeight,::nMargin)

     /*
     Inicializar variables de coordenadas
     */

     Aeval(::aColumns,;
               {|val| nMaxHeight:=Max(nMaxHeight,val:nDataHeight) })

     ::nTitleRow  := ::oHeader:nHeight + ::oTitle:nHeight + ::nTopMargin

     ::nBottomRow := ::nHeight-::oFooter:nHeight-::nDnMargin- ;
                     iif(!::lTotal,0,::nStdLineHeight+nMaxHeight)


     /*
     Calcular alto de los titulos
     */

     nMaxHeight     := 0
     ::nTitleHeight := 0

     FOR nFor1 := 1 TO ::nMaxTitle

          FOR nFor2 := 1 TO nColumns
               nMaxHeight := Max(nMaxHeight, ::aColumns[nFor2]:nTitleHeight)
		NEXT

          ::nTitleHeight += nMaxHeight

	NEXT

     /*
     Calcular coordenadas de impresi¢n de datos
     */

     ::nFirstdRow := ::nTitleRow +;
                     iif(!empty(::cTitleUpChr),::nStdLineHeight,0) +;
                     ::nTitleHeight +;
                     iif(!empty(::cTitleDnChr),::nStdLineHeight,0)

     ::nLastdRow  := ::nBottomRow -;
                     iif(::lTotal,::nStdLineHeight/2 ,0 )


     /*
     Indicar que ya esta estable
     */

     ::lStable := .T.
     ::lFinish := .F.

RETURN (NIL)


//----------------------------------------------------------------------------//

METHOD start()  // KF instead of init() for compatibnility with Class(y)

     IF ::bInit != nil
          Eval( ::bInit )
     ENDIF

RETURN Nil

//----------------------------------------------------------------------------//

METHOD End(lFin)

     ::lFinish := .T.

     IF !::lBreak .AND. ::bEnd != nil
          Eval( ::bEnd )
     ENDIF

     IF ::lShadow
          ::KillShadow()
     ENDIF

     ::EndPage()

     IF !::lPreview
          ::oDevice:End()
     ENDIF

     IF ::oBrush != NIL
          ::oBrush:Release()
     ENDIF

     Aeval(::aFont,{|val| val:Release() })

     Aeval(::aPen,{|val| val:Release() })


RETURN Nil

//----------------------------------------------------------------------------//

METHOD Skip( n )

     STATIC lRunning := .F.

     ::nCounter++

     IF ::bChange != nil .AND. !lRunning
          lRunning := .T.
          Eval( ::bChange )
          lRunning := .F.
     ENDIF

     IF ::bSkip != nil
          retu Eval( ::bSkip, n )
     ENDIF

RETURN DbSkip( n )

//----------------------------------------------------------------------------//

METHOD StartPage()

     STATIC lRunning := .F.

     ::oDevice:StartPage()

     ::nPage++

     * ::oRptWnd:Refresh() // KF

     IF ::bStartPage != nil .AND. !lRunning
          lRunning := .T.
          Eval( ::bStartPage )
          lRunning := .F.
     ENDIF

     IF ::lShadow
          ::Shadow()
     ENDIF

     ::oHeader:Say()
     ::oTitle:Say()
     ::ColTitle()
     ::lFirstRow := .T.

RETURN NIL

//----------------------------------------------------------------------------//

METHOD EndPage()

     STATIC lRunning := .F.

     IF ::lGrid
          ::Grid()
     ENDIF

     ::PageTotal()
     ::oFooter:Say()

     IF ::bEndPage != nil .AND. !lRunning
          lRunning := .T.
          Eval( ::bEndPage )
          lRunning := .F.
     ENDIF

     ::oDevice:EndPage()

     IF !(::lFinish)
          ::StartPage()
     ENDIF
RETURN NIL

//----------------------------------------------------------------------------//

METHOD StartLine(nHeight)

     STATIC lRunning := .F.

     DEFAULT nHeight := ::nStdLineHeight

     IF (nHeight+::nRow) >= ::nBottomRow
          ::EndPage()
     ENDIF

     IF ::bStartLine != nil .AND. !lRunning
          lRunning := .T.
          Eval( ::bStartLine)
          lRunning := .F.
     ENDIF

RETURN nil

//----------------------------------------------------------------------------//

METHOD EndLine(nHeight)

     STATIC lRunning := .F.

     DEFAULT nHeight := ::nStdLineHeight

     IF ::bEndLine != nil .AND. !lRunning
          lRunning := .T.
          Eval( ::bEndLine)
          lRunning := .F.
     ENDIF

     ::nRow      += nHeight
     ::lFirstRow := .F.

     IF ::NeedNewPage()
          ::EndPage()
     ENDIF

RETURN nil

//----------------------------------------------------------------------------//

METHOD StartGroup(nGroup)

     STATIC lRunning := .F.

     IF !eval(::bWhile) .OR. !eval(::bFor)
          RETU NIL
     ENDIF

     IF ::bStartGroup != nil .AND. !lRunning
          lRunning := .T.
          Eval( ::bStartGroup)
          lRunning := .F.
     ENDIF

     ::StartLine(::aGroups[nGroup]:HeaderHeigth())
     ::aGroups[nGroup]:Header(::nRow)
     ::EndLine(::aGroups[nGroup]:HeaderHeigth())

RETURN NIL

//----------------------------------------------------------------------------//

METHOD EndGroup(nGroup)

     STATIC lRunning := .F.

     IF ::bEndGroup != nil .AND. !lRunning
          lRunning := .T.
          Eval( ::bEndGroup)
          lRunning := .F.
     ENDIF

     IF !::lSummary
          ::StartLine(::aGroups[nGroup]:FooterHeigth())
          ::TotalLine(::cGroupChr)
     ENDIF

     ::StartLine(::aGroups[nGroup]:FooterHeigth())
     ::aGroups[nGroup]:Footer(::nRow)
     ::EndLine(::aGroups[nGroup]:FooterHeigth())

     IF !::lFirstRow               .AND. ;
         ::aGroups[nGroup]:lEject  .AND. ;
         eval(::bWhile)            .AND. ;
         eval(::bFor)
          ::EndPage()
     ENDIF

     ::aGroups[nGroup]:Reset()
     ::StartGroup(nGroup)

RETURN NIL

//----------------------------------------------------------------------------//

METHOD PageTotal()

     LOCAL nFor, nColumns

	/*
	Si no hay ningun total no hacer nada
	*/

     IF !(::lTotal)
		RETU (NIL)
	ENDIF

     nColumns := len(::aColumns)

     /*
	Mostrar linea superior de totales
	*/

     ::TotalLine(::cTotalChr)

     /*
     Imprimir leyenda de totales (si esta definida, ojo por defecto no esta)
     */

     IF ::lFinish
          IF !empty(::cGrandTotal)
               ::oDevice:Say(::nRow                    ,;
                             ::aCols[1]                ,;
                             ::cGrandTotal             ,;
                             ::aFont[eval(::bStdFont)])
          ENDIF
     ELSE
          IF !empty(::cPageTotal)
               ::oDevice:Say(::nRow                    ,;
                             ::aCols[1]                ,;
                             ::cPageTotal              ,;
                             ::aFont[eval(::bStdFont)])
          ENDIF
     ENDIF

     /*
	Imprimir los totales para las columnas que lo lleven
	*/

     FOR nFor := 1 TO nColumns
          ::aColumns[nFor]:SayTotal(::nRow, ::aCols[nFor])
	NEXT

     ::nRow += ::nStdLineHeight

RETURN NIL

//----------------------------------------------------------------------------//

METHOD ColTitle()

     LOCAL nFor1, nFor2, nColumns, nMaxHeight

     nColumns   := len(::aColumns)
     nMaxHeight := 0

     ::nRow := ::nTitleRow

     /*
     Imprimir linea superior de titulos
     */

     ::TotalLine(::cTitleUpChr)

	/*
     Descriptores de titulos de cada columna
	*/

     FOR nFor1 := 1 TO ::nMaxTitle

          FOR nFor2 := 1 TO nColumns

               ::aColumns[nFor2]:saytitle(::nRow ,;
                                          ::aCols[nFor2] ,;
                                          nFor1 )

               nMaxHeight := Max(nMaxHeight, ::aColumns[nFor2]:nTitleHeight)
		NEXT

          ::nRow += nMaxHeight

          nMaxHeight := 0

	NEXT

     /*
     Imprimir linea inferior de titulos
     */

     ::TotalLine(::cTitleDnChr,::nRow)

RETURN NIL

//----------------------------------------------------------------------------//

METHOD TotalLine(cChar)

     LOCAL nFor, nColumns, cText, nCol

     IF cChar == NIL .OR. empty(cChar)
          RETU NIL
     ENDIF

     nColumns := len(::aColumns)

     FOR nFor := 1 TO nColumns

          cText := ""

          DO WHILE ::oDevice:GetTextWidth(cText,;
                                          ::aFont[eval(::bStdFont)]) < ;
                   ::aColumns[nFor]:nWidth
               cText += cChar
          ENDDO

          DO CASE

               CASE ::aColumns[nFor]:nPad == RPT_LEFT
                    nCol := ::aCols[nFor]

               CASE ::aColumns[nFor]:nPad == RPT_RIGHT
                    nCol := ::aCols[nFor]+;
                            ::aColumns[nFor]:nWidth-;
                            ::oDevice:GetTextWidth(cText,;
                              ::aFont[eval(::bStdFont)])

               CASE ::aColumns[nFor]:nPad == RPT_CENTER
                    nCol := ::aCols[nFor]+;
                            Int(::aColumns[nFor]:nWidth/2)-;
                            Int(::oDevice:GetTextWidth(cText,;
                                ::aFont[eval(::bStdFont)])/2)
               OTHERWISE
                    nCol := ::aCols[nFor]
          ENDCASE

          ::oDevice:Say(::nRow,;
                        nCol,;
                        cText,;
                        ::aFont[eval(::bStdFont)],;
                        ::aColumns[nFor]:nWidth)
     NEXT

     ::nRow += ::nStdLineHeight

RETURN NIL


METHOD AddColumn(oColumn)
Aadd(::aColumns,oColumn)
return self

METHOD DelColumn(nColumn)
Adel(::aColumns,nColumn)
Asize(::aColumns,len(::aColumns)-1)
return self

METHOD InsColumn(oColumn, nColumn)
Ains(::aColumns,nColumn)
::aColumns[nColumn]:= oColumn
return self

METHOD AddGroup(oGroup)
Aadd(::aGroups,oGroup)
return self

METHOD DelGroup(nGroup)
Adel(::aGroups,nGroup)
Asize(::aGroups,len(::aGroups)-1)
return self

METHOD NeedNewPage()
return (::nRow >= ::nBottomRow)

METHOD NewLine()
::StartLine(::nStdLineHeight)
iif(!::lFirstRow, ::EndLine(::nStdLineHeight), )
return self

METHOD BackLine(nLine)
::nRow -= ::nStdLineHeight* iif(nLine == NIl,1 ,nLine )
return self

METHOD Inc2Pix(nValue)
return (::nLogPixY*nValue)

METHOD Cmt2Pix(nValue)
return (::nLogPixY*Int(nValue/2.54))
