#include "FiveDos.ch"

//----------------------------------------------------------------------------//

CLASS TPen

   DATA   hPen
   DATA   nStyle, nWidth, nColor

   METHOD New( nStyle, nWidth, nColor, oDevice ) CONSTRUCTOR
   METHOD Release() INLINE  DeleteObject( ::hPen ), ::hPen := 0
   METHOD End()     INLINE  DeleteObject( ::hPen ), ::hPen := 0

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nStyle, nWidth, nColor, oDevice ) CLASS TPen

   DEFAULT nStyle := PS_SOLID ,;
           nWidth := 1        ,;
           nColor := CLR_BLACK

   // ::hPen   = CreatePen( nStyle, nWidth, nColor )
   ::nStyle = nStyle
   ::nWidth = nWidth
   ::nColor = nColor


   if oDevice != nil
      ::nWidth = ( oDevice:nLogPixelsY() / 72 ) * ::nWidth
   endif


return nil

//----------------------------------------------------------------------------//
