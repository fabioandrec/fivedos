#include "FiveDos.ch"
#include "SysStr.ch"

//----------------------------------------------------------------------------//

function lMsgGet( cTitle, cText, uValue, cPicture, bValid, lPassword )

   local oWnd, nLenGet, nCenterButton
   local nLen    := Max( Len( cTitle ), Max( ( nLenGet := nLabelLen( cText ) + nValLen( uValue ) ) + 4, 40 ) )
   local nAction := 0
   local uTemp   := uValue
   local oGet, oBtn

   DEFAULT bValid       := bTrue(),;
           lPassword    := .f.

   DEFINE DIALOG oWnd AT nil, nil SIZE nLen + 1, 8 ;
          TITLE cTitle

   @ 2, ( nLen - nLenGet ) / 2 GET uTemp PROMPT (cText) ;
            PICTURE (cPicture) ;
            OF oWnd

   aTail( oWnd:oClient:aChilds ):lPassword := lPassword

   nCenterButton := ( ( nLen / 2 ) - len( aSysStr( SST_ACCEPT ) ) ) / 2

   @ 4, nCenterButton BUTTON oBtn PROMPT aSysStr( SST_ACCEPT ) OF oWnd ;
      ACTION ( nAction := 1, uValue := uTemp, oWnd:End() )

   @ 4, ( nLen / 2 ) + Len( aSysStr( SST_CANCEL ) ) / 2 BUTTON aSysStr( SST_CANCEL ) OF oWnd ;
     ACTION oWnd:End()

   ACTIVATE DIALOG oWnd

return nAction == 1

//----------------------------------------------------------------------------//
