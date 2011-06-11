#include "FiveDos.ch"
#include "common.ch"

class TDevice
   var aRows
   DATA hDc
   DATA cPort
   DATA nPort
   DATA nLeftMargin ,;
       nRightMargin,;
       nTopMargin  ,;
       nDnMargin   ,;
       nHeight     ,;
       nWidth
   DATA bStartPage,bEndPage,bEject,bEnd

   method New  CONSTRUCTOR
   METHOD SetHeight
   method GetTextWidth
   method GetTextHeight
   method StartPage
   method EndPage
   method End
   method Say
   METHOD SayBitmap
   METHOD Line
   METHOD Box
   METHOD nVertRes
   METHOD nHorzRes

   METHOD nVertSize
   METHOD nHorzSize

ENDCLASS

method new(cPort)
DEFAULT cPORT := SetPort()
::cPort        := upper(alltrim(cPort))
if left(::cPort,3)=="LPT" .and. (len(::cPort)==4)
   ::nPort := val(right(::cPort,1))
else
   ::nPort := NIL
endif
::nLeftMargin  :=  2
::nRightMargin :=  2
::nTopMargin   :=  2
::nDnMargin    :=  2
::nWidth       := 78
::nHeight      := 66
::aRows := array(::nHeight)
afill(::aRows,space(::nWidth))
return self

method GetTextWidth(cTxt,oFont)
DEFAULT cTxt TO ""
return len(cTxt)

method GetTextHeight(cTxt,oFont)
return 1

METHOD nVertRes()
RETURN  ::nHeight

METHOD nHorzRes()
RETURN  ::nWidth

METHOD nVertSize()
RETURN  (::nHeight * 25.4)

METHOD nHorzSize()
RETURN  (::nWidth  * 25.4)

method StartPage
::aRows := array(::nHeight)
afill(::aRows,space(::nWidth))
return self

METHOD SetHeight(nHeight)
::aRows := array(nHeight)
afill(::aRows,space(::nWidth))
return NIL

method EndPage
local i, nLen, aRows := ::aRows, bOldError
if ! empty(::nPort)
   bOldError := errorBlock()
   errorblock({|e|PrinterError(e,boldError,::nPort) })
endif
nLen := len(aRows)
set printer to (::cPort) additive
set device to printer
SET PRINTER ON
SET CONSOLE OFF

if valtype(::bStartPage) == "B"
   eval(::bStartPage)
endif
devpos(0,0)
for i := 1 to nLen
   ?? left(trim(aRows[i]),::nWidth)+CRLF
next
if valtype(::bEndPage) == "B"
   eval(::bEndPage)
endif
::aRows := {}
if ! empty(::nPort)
   if valtype(::bEject) == "B"
      eval(::bEject)
   else
      EJECT
   endif
endif
SET CONSOLE ON
set device to screen
SET PRINTER OFF
SET PRINTER TO                      // (mit PrinterOn (kanal) ge”ffnet)
commit
if ! empty(bOldError)
   errorblock(bOldError)
endif
return self

method end
if ! empty(::aRows)
   ::EndPage()
endif
if valtype(::bEnd) == "B"
   eval(::bEnd)
endif
return self

method Say(nRow, nCol, cText, oFont,nWidth)
local nDiff
DEFAULT cText := ""
cText  := trim(cText)
nRow   := int(nRow)
nCol   := int(nCol)
nDiff  := len(cText)-len(ltrim(cText))
if nDiff > 0
   nCol  +=  nDiff
   cText := ltrim(cText)
endif

if nWidth == NIL .or. nWidth < 1
   nWidth := len(cText)
else
   nWidth := int(nWidth)
   nWidth -= nDiff
   cText  := padr(left(cText,nWidth),nWidth)
endif

nRow++
nCol++
if nRow > 0 .and. nRow <= ::nHeight
   ::aRows[nRow] := stuff(::aRows[nRow],nCol,nWidth,cText)
endif
return self

METHOD SayBitmap( nRow, nCol, cBitmap, nWidth, nHeight, nRaster )
// can't handle
return self

METHOD Line( nTop, nLeft, nBottom, nRight, oPen )
local nLen,i
nTop    := int(nTop)
nLeft   := int(nLeft)
nBottom := int(nBottom)
nRight  := int(nRight)

if (nTop == nBottom)
   ::Say(nTop  , nLeft, replicate("Ä",nRight-nLeft+1))
elseif (nLeft == nRight)
   nLen := int(nBottom-nTop+1)
   for i := 1 to nLen
      ::Say(nTop+i-1, nLeft  , "³")
   next
endif
return self

METHOD Box( nRow, nCol, nBottom, nRight, oPen )
local nLen,i
nRow    := int(nRow)
nCol    := int(nCol)
nBottom := int(nBottom)
nRight  := int(nRight)
if (nRow == nBottom)
   ::Line( nRow, nCol, nBottom, nRight, oPen )
elseif (nCol == nRight)
   ::Line( nRow, nCol, nBottom, nRight, oPen )
else
   ::Say(nRow   , nCol, "Ú"+replicate("Ä",nRight-nCol-1)+"¿",NIL,nRight-nCol+1)
   nLen := nBottom-nRow-1
   for i := 1 to nLen
      ::Say(nRow+i, nCol  , "³")
      ::Say(nRow+i, nRight, "³")
   next
   ::Say(nBottom, nCol, "À"+replicate("Ä",nRight-nCol-1)+"Ù",NIL,nRight-nCol+1)
endif
return self

METHOD FillRect(aCols, oBrush)
// can't handle
return self

METHOD _FillRect(aCols, oBrush)
// can't handle
return self
