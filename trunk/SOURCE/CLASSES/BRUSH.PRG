// a sample brush class

#include 'FiveDos.ch'


// es poco m s que un prototipo de clase ...

CLASS tBrush

    Data cBrush, nColor, nStyle

    method New( nStyle ) Constructor

endclass

//---------------------------------------------------------------------------//

Method New( nStyle )  class tBrush

     BYNAME nStyle DEFAULT 1
    alert('Stype :='+valtype(nStyle))

    if ::nStyle >=0 .and. ::nStyle <= 4
        ::cStyle := substr( '°±²Û ',::nStyle+1,1)
        else
        // default style
        ::cStyle :='°'
    endif

return self

