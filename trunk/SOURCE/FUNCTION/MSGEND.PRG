#include "FiveDos.ch"
#include "Icons.ch"
#include "SysStr.ch"

//----------------------------------------------------------------------------//

function lMsgEnd()
    local aSysStr := aSysStr()

return nMsgBox( aSysStr[ SST_WANTEND ], ;
                aSysStr[ SST_ALERT ], { aSysStr[ SST_ACCEPT ], aSysStr[ SST_CANCEL ] },;
                "W+/BR, N/W*, W+/BR, N/W, W/BR",;
                ICO_QUESTION, "gr+/b" ) == 1

//----------------------------------------------------------------------------//
