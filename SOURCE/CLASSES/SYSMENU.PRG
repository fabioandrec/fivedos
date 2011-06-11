#include "FiveDos.ch"
#include "WndStyls.h"
#include "FontDef.h"
#include "SysStr.ch"


//----------------------------------------------------------------------------//

function SysMenu( oWnd, aColors )

    local oMenu := TMenuBox():New()
    local oSysItem := TMenuItem():New( 0, 0, Chr( CLOSELEFT ) + Chr( CLOSERIGHT ) )
    local aSysMsg := aSysStr()
    local nHi, nLo

    if aColors != nil
        oMenu:aColors = aColors
        oSysItem:aColors = aColors
    endif
   
    if oWnd:lDrag
        oMenu:Add( TMenuItem():New( 0, 0, aSysMsg[ SST_MOVE ],,  { || oWnd:KeyMove() } ) )
    endif

    if lAnd( oWnd:nStyle, WND_LGROW )
        oMenu:Add( TMenuItem():New( 0, 0, aSysMsg[ SST_RESTORE ] ,,{ || oWnd:Normal() } ) )
        oMenu:Add( TMenuItem():New( 0, 0, aSysMsg[ SST_SIZE ],, { || oWnd:KeySize() } ) )
        oMenu:Add( TMenuItem():New( 0, 0, aSysMsg[ SST_MAXIMIZE ],, { || oWnd:Maximize() } ) )
    elseif lAnd( oWnd:nStyle, WND_LICONIZE )
        oMenu:Add( TMenuItem():New( 0, 0, aSysMsg[ SST_RESTORE ] ,,{ || oWnd:Normal() } ) )
    endif

    if lAnd( oWnd:nStyle, WND_LICONIZE )
        oMenu:Add( TMenuItem():New( 0, 0, aSysMsg[ SST_MINIMIZE ],, { || oWnd:Minimize() } ) )
    endif
    
    if !empty( oMenu:aChilds  )
        oMenu:Add( TMenuItem():New( 0, 0, "" ) )
    endif

    oMenu:Add( TMenuItem():New( 0, 0, aSysMsg[ SST_CLOSE ] + "Alt-F4 ",,;
              { || oWnd:Close( 0 ) },,, K_ALT_F4 ) )

    oSysItem:SetMenu( oMenu )

    nHi = oWnd:nClrHiTitle
    nLo = oWnd:nClrLoTitle
    oSysItem:aColors := { nHi, nLo,;
                          nHi, nLo,;
                          7,;
                          nHi, nLo }

return oSysItem

//---------------------------------------------------------------------------//
