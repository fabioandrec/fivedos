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
            cIcon = " 1 1 1󺔛 1 1 1 1 1 1 1󺔛 1 1 1 1 1 1 1󷏙 1 1 1 1 1 1 1󷏙󺔛 1 1 1 1 1􃣡􃣡 1 1"

        case nIcon == ICO_QUESTION
            cIcon = " 1 1 1󺔛�1 1 1 1 1 1󷐁 1􃢹 1 1 1 1 1 1󺔑�1 1 1 1 1 1 1�1 1 1 1 1 1 1 1 1�1 1 1 1 1"

        case nIcon == ICO_HAND
            cIcon = " 1󴆧򪑧�1 1 1 1 1񼆉񼆉񼌏�1 1 1�1 1 1 1򤋝�1 1 1�1 1 1 1 1󴊍 1 1򤈋򰛫򰞽 1 1"

        case nIcon == ICO_EXCLAMATION
            cIcon = " 1 1 1󺔛�1 1 1 1 1 1 1󷏙�1 1 1 1 1 1 1󷏙�1 1 1 1 1 1 1󺔛�1 1 1 1 1 1 1􃣡�1 1 1 1"

        case nIcon == ICO_STOP
            cIcon = " 1󴆧򪑧�1 1 1 1 1񼆉񼆉񼌏�1 1 1�1 1 1 1򤋝�1 1 1�1S1T1O1P1󴊍 1 1򤈋򰛫򰞽 1 1"

        otherwise
            cIcon = " 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1"
    endcase


