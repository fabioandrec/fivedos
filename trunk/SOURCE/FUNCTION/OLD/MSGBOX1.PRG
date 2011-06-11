#include "FiveDos.ch"

static nOption

//---------------------------------------------------------------------------//

function GetIcon( nIcon )

    local cIcon

    DEFAULT nIcon := 0

    do case
        case nIcon == ICO_INFO
            cIcon = " 1 1 1Ü1Ü1 1 1 1 1 1 1 1Ü1Ü1 1 1 1 1 1 1 1Û1Û1 1 1 1 1 1 1 1Û1Û1Ü1Ü1 1 1 1 1 1ß1ß1ß1ß1 1 1"
        case nIcon == ICO_QUESTION
            cIcon = " 1 1 1Ü1Ü1Ü1 1 1 1 1 1Û1ß1 1ß1Û1 1 1 1 1 1 1Ü1Û1ß1 1 1 1 1 1 1ß1 1 1 1 1 1 1 1 1ß1 1 1 1 1"
        case nIcon == ICO_HAND
            cIcon = " 1Ú1Â1Â1Â1¿1 1 1 1 1³1³1³1³1³1Ú1¿1 1 1³1 1 1 1À1Ù1³1 1 1³1 1 1 1 1Ú1Ù1 1 1À1Ä1Ä1Ä1Ä1Ù1 1 1"
        case nIcon == ICO_EXCLAMATION
            cIcon = " 1 1 1Ü1Ü1Ü1 1 1 1 1 1 1Û1Û1Û1 1 1 1 1 1 1Û1Û1Û1 1 1 1 1 1 1Ü1Ü1Ü1 1 1 1 1 1 1ß1ß1ß1 1 1 1"
        case nIcon == ICO_STOP
            cIcon = " 1Ú1Â1Â1Â1¿1 1 1 1 1³1³1³1³1³1Ú1¿1 1 1³1 1 1 1À1Ù1³1 1 1³1S1T1O1P1Ú1Ù1 1 1À1Ä1Ä1Ä1Ä1Ù1 1 1"
        otherwise
            cIcon = " 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1"
    endcase

return cIcon

//---------------------------------------------------------------------------//

function nMsgBox( cText, cTitle, acOptions, cColors )

   local n, nLen, oWnd, oBtn, nDesp,;
         nTop        := 6               ,;
         nLeft       := ( MaxCol() / 2 ),;
         nWidth      := 0               ,;
         nOffset     := 2               ,;
         nLenOptions := 0               ,;
         nLabelRect  := nLabelRect( cText )

   nOption := 0

   DEFAULT acOptions := { "&Aceptar" } ,;
           cColors   := "W+/ B, N/W*, W+/B, N/W, W/B"

   for n = 1 to len( acOptions )
        nLenOptions += nLabelLen( acOptions[ n ]  := alltrim( acOptions[ n ] ) ) + 4
   next

   nWidth = 4 + Max( RectWidth( nLabelRect ), nLenOptions )
   nTop   = Min( nTop, ( MaxRow() / 2 ) - ( RectHeight( nLabelRect ) / 2 ) - 3 )
   nLeft  = Min( nLeft, ( MaxCol() / 2 ) - ( nWidth / 2 ) )
   nLen   = Max( 5, RectHeight( nLabelRect ) + 4 )

   DEFINE DIALOG oWnd AT nTop, nLeft          ;
                      SIZE nWidth, nLen + 2   ;
                      TITLE cTitle            ;
                      COLOR cColors

   TLabel():New( 1, 0, cText, cColors,;
                 nWidth - 2, RectHeight( nLabelRect ),;
                 oWnd )

   nDesp   = ( oWnd:nWidth - nLenOptions + 1 ) / ( len( acOptions ) + 1 )
   nOffSet = nDesp
   
   for n = 1 to Len( acOptions )
       @ RectHeight( nLabelRect ) + 2, nOffset BUTTON oBtn PROMPT (acOptions[ n ]) OF oWnd
       oBtn:bAction = SetOption( n, oWnd )
       nOffset += len( acOptions[ n ] ) + nDesp
   next

   ACTIVATE WINDOW oWnd

return nOption

//----------------------------------------------------------------------------//

static function SetOption( n, oWnd )
return {|| oWnd:lEnd := .t., nOption := n }

//----------------------------------------------------------------------------//

function aStr2Array( cText, cSep )

   local n, aTemp := {}

   while ( n := at( cSep, cText ) ) != 0

       aadd( aTemp, substr( cText, 1, n - 1 ) )
       cText = if( n < len( cText ), substr( cText, n + 1, len( cText ) - n ), '' )
   end

   aadd( aTemp, cText )

return aTemp

//---------------------------------------------------------------------------//

function Alert( cText, aOptions )
return nMsgBox( cText, 'Atenci¢n', aOptions, "W+/R, N/W*, W+/R, N/W, W/R" )


function MsgAlert( cText, aOptions )
return nMsgBox( cText, 'Atenci¢n', aOptions, "W+/R, N/W*, W+/R, N/W, W/R" )

function MsgInfo( cText )
return nMsgBox( cText, 'Informaci¢n' )

function MsgStop( cText )
return nMsgBox( cText, 'Atenci¢n: PARE' )

function MsgYesNo( cText )
return if( nMsgBox( cText, 'Responda a la cuesti¢n', { "&Si", "&No" } ) == 1, .t., .f. )


function WinExec( uFunc ) ; return nil
//----------------------------------------------------------------------------//
