#include "FiveDos.Ch"

//---------------------------------------------------------------------------//

function main()
    local cPassword := space( 7 )

    ? lMsgGet( "Password de entrada", "&Password", @cPassword,,, .t. ), ;
      cPassword

return nil

//---------------------------------------------------------------------------//

function GetPassword( cTitle, cText ) // -> cPassword entered

    local oWnd, nCenterButton, cOldText := cText
    local nLen := Max( Max( Len( cText ) + 12, ;
                            Len( cTitle ) + 4 ),;
                       40 )

    DEFAULT cTitle := ""

    DEFINE DIALOG oWnd ;
        AT 0, 0 ;
        SIZE nLen, 7 ;
        TITLE cTitle ;
        NOSYSMENU

    @ 1, ( nLen - ( Len( cText ) + 8 ) ) / 2 GET cText ;
            PROMPT "&Password" ;
            PASSWORD ;
            OF oWnd

    nCenterButton = ( ( nLen / 2 ) - 8 ) / 2

    @ 3, nCenterButoon BUTTON "   &Ok   " OF oWnd

    @ 3, ( nLen / 2 ) + nCenterButton BUTTON " &Cancel " OF oWnd

    ACTIVATE DIALOG oWnd CENTERED

return cText

//---------------------------------------------------------------------------//
