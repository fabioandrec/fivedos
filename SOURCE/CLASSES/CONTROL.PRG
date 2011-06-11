#include "FiveDos.ch"

#define _LABELROW_ 1000
#define _LABELCOL_ 1000
//----------------------------------------------------------------------------//

// Un TControl es un View que es portador de un TLabel para indicar su
// Estado de Focus y su HotKey


CLASS TControl FROM TView

    DATA oLabel

    METHOD New( nTop, nLeft, nWidth, nHeight, cColor, cChar, oWnd, cMessage,;
               cLabel, bWhen, bValid, acLabelClrs )

    METHOD Refresh(),;
           SetFocus( lOnOff ),;
           Redefine( cMessage, cLabel, cColor, bWhen, bValid )

    DELEGATE MESSAGE IsHotKey( nKey ), cMessage, _cMessage TO oLabel

ENDCLASS

//--------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cColor, cChar, oWnd, cMessage,;
            cLabel, bWhen, bValid, acLabelClrs )

    Super:New( nTop, nLeft, nWidth, nHeight, cColor, cChar, oWnd,,;
               bWhen, bValid )

    if IS_NIL( acLabelClrs ) .and. !IS_NIL( oWnd )
       acLabelClrs = oWnd:aClrLabel
    endif

    ::oLabel      = TLabel():New( 0, 0, cLabel, acLabelClrs,,,, cMessage, -1 )
    ::oLabel:oWnd = Self
    if Empty( cLabel )
       ::oLabel:SetPos( _LABELROW_, _LABELCOL_ )
    end

return Self

//---------------------------------------------------------------------------//

METHOD Redefine( cMessage, cLabel, cColor, bWhen, bValid )

    BYNAME bWhen, bValid INIT BLOCK

    if IS_CHARACTER( cLabel )
       ::oLabel:SetText( cLabel )
*       ::oLabel:ChangeSize( ::nWidth(), 1 )
*       ::oLabel:setpos( 0, 0 )
*       ::oLabel:nHotKey = nGetHotKey( cLabel )
    endif

    if IS_CHARACTER( cMessage )
       ::oLabel:cMessage = cMessage
    endif

    if !IS_NIL( cColor )
       ::oLabel:SetColors( cColor )
    endif

return Self

//---------------------------------------------------------------------------//

METHOD Refresh()

    ::BeginPaint()

    Super:Refresh()

    if ::lFocussed != ::oLabel:lFocussed
       ::oLabel:SetFocus( ::lFocussed )
    else
       ::oLabel:Flash( ::cVPort )
    endif

    ::EndPaint()

return nil

//---------------------------------------------------------------------------//

METHOD SetFocus( lOnOff )
return ::oLabel:SetFocus( ::lFocussed := lOnOff )

//---------------------------------------------------------------------------//
