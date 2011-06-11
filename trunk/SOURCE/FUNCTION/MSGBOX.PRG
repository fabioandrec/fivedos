#include "FiveDos.ch"
#include "Icons.ch"
#include "SysStr.ch"

#define BUTTONSEP  4

//---------------------------------------------------------------------------//

function nMsgBox( cText, cTitle, acOptions, cColors, nIcon, cClrIcon )

   local n, nLen, oWnd, oBtn, nDesp, oBmp, ;
         nTop        := 6               ,;
         nLeft       := ( ScrMaxCol() / 2 ),;
         nWidth      := 0               ,;
         nOffset     := 2               ,;
         nLenOptions := BUTTONSEP       ,;
         nIcoWidth   := 0,;
         nIcoHeight  := 0,;
         nClrIcon        ,;
         nLabelRect      ,;
         cImage

   cText = cValToChar( cText )
   nLabelRect = nLabelRect( cText )

   DEFAULT acOptions := { aSysStr( SST_OK ) } ,;
           cColors   := "W+/ B, N/W*, W+/B, N/W, W/B"

   if nIcon != nil

        cImage     := GetIcon( nIcon )
        if !empty( cClrIcon )
            cSwapAtt( cImage, 49, nClrIcon := nStrColor( cClrIcon, 1 ) )
        endif
        nIcoWidth  := ICONWIDTH + 2
        nIcoHeight := ICONHEIGHT
   endif

   for n = 1 to len( acOptions )
        nLenOptions += nLabelLen( acOptions[ n ] ) + BUTTONSEP
   next

   nWidth = 4 + Max( nIcoWidth + RectWidth( nLabelRect ), Max( Len( cTitle ), nLenOptions ) )
   nTop   = Min( nTop, ( ScrMaxRow() / 2 ) - ( RectHeight( nLabelRect ) / 2 ) - 3 )
   nLeft  = Min( nLeft, ( ScrMaxCol() / 2 ) - ( nWidth / 2 ) )
   nLen   = Max( 3, max( nIcoHeight, RectHeight( nLabelRect ) ) + 4 )

   DEFINE DIALOG oWnd SIZE nWidth, nLen + 2   ;
                      TITLE cTitle            ;
                      COLOR cColors

   @ 1, nIcoWidth SAY cText COLOR cColors ;
                    SIZE nWidth - ( nIcoWidth + 2 ), max( RectHeight( nLabelRect ), nIcoHeight ) ;
                    CENTERED ;
                    OF oWnd

   if !empty( cImage )
        if nClrIcon != nil
            nClrIcon = int( oWnd:nColor / 16 ) + int( nClrIcon / 16 ) * 16
            cSwapAtt( cImage, 63, nClrIcon )
        endif
        @ 1, 2 BITMAP oBmp RESOURCE cImage  SIZE 9, 5 OF oWnd
   else
        nIcon = 0
   endif

   nDesp   = Max( BUTTONSEP, ( oWnd:nWidth - ( nLenOptions - len( acOptions ) * BUTTONSEP ) + 1 ) / ( len( acOptions ) + 1 ) )
   nOffSet = nDesp + 1
   
   for n = 1 to Len( acOptions )
       @ nLen - 2, nOffset BUTTON oBtn  ;
              PROMPT ( acOptions[ n ] ) ;
              OF oWnd
       oBtn:bAction = SetOption( n, oWnd )
       nOffset += nLabelLen( acOptions[ n ] ) + nDesp
   next

   ACTIVATE WINDOW oWnd ;
                ON PAINT if( nIcon == ICO_EXCLAMATION, Tone( 1000, 0.2 ), ) ;
                VALID .t.

return oWnd:nResult

//----------------------------------------------------------------------------//

static function SetOption( n, oWnd )
return {|| oWnd:End( n ) }

//----------------------------------------------------------------------------//

function nMsgAlert( cText, aOptions )  // Like Clipper Alert()
return nMsgBox( cText, aSysStr( SST_ALERT ), aOptions, "W+/R, N/W*, W+/R, N/W, W/R",;
                ICO_EXCLAMATION, "gr+/bg" )

//----------------------------------------------------------------------------//

function MsgAlert( cText, cTitle )

   DEFAULT cTitle := aSysStr( SST_ALERT )

return nMsgBox( cText, cTitle,, "W+/R, N/W*, W+/R, N/W, W/R",;
                ICO_EXCLAMATION, "gr+/bg" )

//----------------------------------------------------------------------------//

function MsgInfo( cText, cTitle )

   DEFAULT cTitle := aSysStr( SST_INFO )

return nMsgBox( cText, cTitle,,, ICO_INFO, "b+/bg*" )

//----------------------------------------------------------------------------//

function MsgStop( cText, cTitle )

   DEFAULT cTitle := aSysStr( SST_STOP )

return nMsgBox( cText, cTitle,,, ICO_STOP, "gr+/bg" )

//----------------------------------------------------------------------------//

function MsgYesNo( cText, cTitle )
   local aSysStr := aSysStr()

   DEFAULT cTitle := aSysStr[ SST_MSGSELECT ]

return nMsgBox( cText, cTitle, { aSysStr[ SST_YES ], aSysStr[ SST_NO ] },, ;
                ICO_QUESTION, "gr+/bg" ) == 1

//----------------------------------------------------------------------------//

function WinExec( uFunc ) ; return nil

//----------------------------------------------------------------------------//

function MsgBeep() ; return Tone( 900, 2 )

//----------------------------------------------------------------------------//
