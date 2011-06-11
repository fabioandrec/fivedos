/*
* Functions to simulate device context handling, Font handling, Penhandling...
* You now can use Brush.prg, font.prg and Pen.prg (and probably others too)
* from FiveWin without changes under FiveDos !
* that way, you can use the FiveWin report classes without big changes.
* Just use tDevice instead of the FW Printer Class for output.
*
* It may also help to use other Fivewin Classes unmodified as well.
*
* The program simulates some basic Windows API Functions.
* It makes the Application ignore settings of brushes, pens, fonts and
* deviceContexts, hopefully in an inteligent way.
*
* The program is UNTESTED (!), so may still need some work.
* No guarantees for anything.
*
* Also, you can modify this program to implement some of
* these Windows features under Dos too, if you like.
* As the source is very simple, it should be a good foundation to do it.
*
* BTW, as this program doesn't require anything else except Clipper 5.2,
* it can also be used without FiveXXX, e.g. for Clip4Win Programmers.
*/

// include the plain old \clipper5\include\common.ch
// wich comes with Clipper 5.2
// No special FiveXXX stuff needed in this Prg

#include "common.ch"

#define DC_HWIN  1
#define DC_FONT  5
#define DC_PEN   6
#define DC_BRUSH 7

#define nDCMAX  6 // maximal 6 device contexts under windows
                  // allowed at the same time ! (Total, NOT per application!)
static aDc  := {,,,,,} // Device Contexts - Number of Elements should be same
                       // as nDCMAX, so we have 6 elements (see above)

static aRes := {}      // allocated Ressources (like Font, Bitmaps etc)

// define some ids to distinguish between Fonts, Pens and Brushes
// this is not windows related, just an internal implementation
// Dont't count on the Id-Values ! Use them as handles only!
static nFonts  := 30000 // Fonts   have internal Ids from 30001 upwards
static nPens   := 10000 // Pens    have internal Ids from 10001-29999
                        // assumes that Application issues maximum 20000 times
                        // a createPen(). Otherwise, change nFonts value !
static nBrushs :=  5000 // Brushes have internal Ids from  5001- 9999
                        // assumes that Application issues maximum 5000 times
                        // a createxxxBrush(). Otherwise, change nPens value !


Function Getdc(hWind )
local nPos := 0
 if ! (hWind == NIL)
   nPos := FindWinDc(hWind,.t.)
 endif
return nPos

Function ReleaseDC( hWnd, hDC )
   DeleteDc(hDc)
return NIL

Function CreateDc(cDriver, cDevice, cPort )
local nPos
nPos := FindFreeDc()
if nPos > 0
   aDc[nPos] := dcNew(NIL,cDriver, cDevice, cPort)
endif
return nPos

Function DeleteDc(hDc)
if ! empty(hDc)
   aDc[hDc] := NIL
endif
return NIL

Function GetPrintDC(hWind)
return Getdc(hWind )

static Function dcNew(hWind,cDriver, cDevice, cPort, hFont, hPen, hBrush)
return               {hWind,cDriver, cDevice, cPort, hFont, hPen, hBrush}

static Function FindWinDc(hWin,lAdd)
   local nRet := 0, i
   DEFAULT lAdd TO .f.
   for i := 1 to nDCMAX
      if ! (aDc[i] == NIL)
         if aDc[i,DC_HWIN] == hWin
            nRet := i
            exit
         endif
      endif
   next
   if lAdd .and. nRet < 1
      for i := 1 to nDCMAX
         if (aDc[i] == NIL)
            aDc[i] := dcNew(hWin)
            nRet := i
            exit
         endif
      next
   endif
return nRet

static Function FindFreedc()
local nRet := 0, i
for i := 1 to nDCMAX
   if aDc[i] == NIL
      nRet := i
      exit
   endif
next
return nRet

Function SelectObject(hDc, hObj) // hObj is hFont or hPen
if ! empty(hDc)
   if IsFont(hObj)
      aDc[hDc,DC_FONT] := hObj
   elseif IsPen(hObj)
      aDc[hDc,DC_PEN] := hObj
   elseif IsBrush(hObj)
      aDc[hDc,DC_BRUSH] := hObj
   endif
endif
return NIL

Function DeleteObject(hObj) // hObj is any ressource like hIcon, hFont ,hBmp
local nPos
if ! empty(hObj)
   if (nPos:=ascan(aRes,{|e|e[1]==hObj})) > 0
      adel(aRes,nPos)
      asize(aRes,len(aRes)-1)
   endif
endif
hObj := NIL
return NIL

Function _ReadBitmap(x, cFile)
// Just a Stubb
return 0 // 0 if not Ok ?

Function LoadBitmap(x, cBmpRes)
// Just a Stubb - we don't support ressources in DOS
return 0 // 0 if not Ok ?

Function CreateFont(aFont)
nFonts++
aadd(aRes,{nFonts,aFont})
return nFonts

Function CreatePen(nStyle, nWidth, nColor)
nPens++
aadd(aRes,{nPens,{nStyle, nWidth, nColor}})
return nPens

Function CreateSolidBrush( nRGBColor )
nBrushs++
aadd(aRes,{nBrushs,{nRgbColor,,}})
return nBrushs

Function CreatePatternBrush( hBitmap )
nBrushs++
aadd(aRes,{nBrushs,{,,hBitmap}})
return nBrushs

Function CreateHatchBrush( nStyle, nRGBColor )
nBrushs++
aadd(aRes,{nBrushs,{nRgbColor,nStyle,}})
return nBrushs

Function CreateStockObject( x )
nBrushs++
aadd(aRes,{nBrushs,{,,}})
return nBrushs

static Function IsPen(hObj)
return (!empty(hObj).and. hObj>10000.and. hObj<30000)

static Function IsFont(hObj)
return (!empty(hObj).and. hObj>30000)

static Function IsBrush(hObj)
return (!empty(hObj).and. hObj>5000.and. hObj<10000)
