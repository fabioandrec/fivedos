#include "FiveDos.ch"
#include "pen.ch"
// Note:   nStyle is reatly caracter, compatible system with fivewin
//----------------------------------------------------------------------------//

CLASS TPen

   DATA   hPen
   DATA   nStyle, nWidth, nColor
   DATA   cStyle

   METHOD New( nStyle, nWidth, nColor, oDevice ) CONSTRUCTOR
   METHOD Release() VIRTUAL
   METHOD End()     VIRTUAL

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nStyle, nWidth, nColor, oDevice ) CLASS TPen

     BYNAME nStyle DEFAULT 1
     BYNAME nColor

     ::nWidth   = 1
     ::hPen     = nStyle
     if ::nStyle > 0 .and. ::nsTyle <= P_STYLES
         ::cStyle   := { P_SINGLE, P_DOUBLE, P_SINGLE_DOUBLE, P_DOUBLE_SINGLE,;
            P_SHADOW1,P_SHADOW2,P_SHADOW3,P_BOLD}[ ::nStyle ]
     end

return nil

//----------------------------------------------------------------------------//
