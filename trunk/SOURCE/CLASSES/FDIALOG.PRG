#include "FiveDos.ch"
#include "Syscolor.ch"
#include "fontdef.h"
//---------------------------------------------------------------------------//

CLASS TFDIALOG FROM TView

    METHOD New( oFolder, bPaint, cColor , cPrompt) Constructor

//    METHOD REFRESH()

    METHOD KeyPressed( nKey )

ENDCLASS


//---------------------------------------------------------------
METHOD New( oFolder, bPaint, cColor, cPrompt )
     if( empty( cColor ), cColor := "N/BG",)
     SUPER:New( 3, 1, oFolder:nWidth-2, oFolder:nHeight-4, cColor )
      oFolder:AddChild( Self )
      ::bPaint := if( ValType( bPaint ) == "B", bPaint, bNil() )

     default cPrompt := '&Nuevo'
     aadd(oFolder:aPrompts, cPrompt )
//     oFolder:nPaintCount++
//     oFolder:Organize()
//     oFolder:nPaintCount--

return Self



//-------------------------------------------------------------------------
/*METHOD Refresh()
        ::BeginPaint()
        ::say(::nHeight-4,0,  replicate( chr( BORDERBOTTOM ),;
        ::nWidth - 2 ), ::oWnd:aColors[ CLRLBL_NORMAL ])
        Super:Refresh()
        ::EndPAint()
return nil
  */

METHOD KeyPressed( nKey )

    local cSinAlt

    if nKey == K_TAB
        if ::nFocussed == len( ::aChilds )
            return nKey
        endif
    elseif nKey == K_SH_TAB
        if ::nFocussed == 1
            return nKey
        endif

    elseif lAltChr( LastKey(), @cSinAlt ) ;
           .and. Asc( cSinAlt ) == nKey

           nKey = LastKey()

    endif

return Super:KeyPressed( nKey )

