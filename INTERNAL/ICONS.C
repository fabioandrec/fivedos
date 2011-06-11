#include "FiveDos.ch"


//---------------------------------------------------------------------------//

function GetIcon( nIcon, cColor )
    static cVTemp

    local cIcon, nColor := Asc( "1" )

    if cVTemp == nil
       cVTemp = ViewPortNew( 0, 0, 9, 5, " ", nColor )
    endif

    if ValType( cColor ) == "C"
       nColor = nStrColor( cColor, 1 )
    elseif ValType( cColor ) == "N"
       nColor = cColor
    endif

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


