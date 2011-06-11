#include "FiveDos.Ch"

//---------------------------------------------------------------------------//

function main()

    local cPassword := space( 7 )

    ? lMsgGet( "Password de entrada", "&Password", @cPassword,,, .t. ), ;
      cPassword

return nil

//---------------------------------------------------------------------------//
