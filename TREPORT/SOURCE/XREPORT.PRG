#include "common.ch"
#include "inkey.ch"
#include "report.ch"

function Tb2Rep(oRep,oTb)
local i, nLen, oCol
oRep:bInit := oTb:GoTopBlock       // use this
oRep:bSkip := {|nSkip,x|TbRepEnd(;
                               !((x:=eval(oTb:skipblock,nSkip))==nSkip);
                               ),x}        // and this
* oRep:bEnd  := oTb:GoBottomBlock  // this can't be used, sorry
nLen  := oTB:colcount()
for i := 1 to nLen
   AddTbCol2Rep(oTB:getcolumn( i ))      // add alll columns
next
TbRepEnd(.f.)
return NIL

Function TbRepEnd(lEndNew)
static lEnd := .f.
if ! (lEndNew==NIL)
   lEnd := lEndNew
endif
return lEnd

static Function AddTbCol2Rep(oCol)
DEFAULT oCol:picture TO ""
* this has to be done in a subfunction
RptAddColumn( {{|| oCol:heading}}, , { oCol:block},, {oCol:picture} ,, .F., , )
return NIL
