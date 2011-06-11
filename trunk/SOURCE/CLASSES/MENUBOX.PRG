#include "FiveDos.ch"

#define CLR_BORDERLEFT  6
#define CLR_BORDERRIGHT 7

//---------------------------------------------------------------------------//

CLASS TMenuBox FROM TMenu

    METHOD New( nTop, nLeft, nWidth, nHeight, cColors ) CONSTRUCTOR

    METHOD  Organize(),;
            Paint( cVPTgt ),;
            Update( oChild )

    METHOD  Display()       INLINE  ::lVisible := .t., ;
                                    ::Organize(), ;
                                    ::AddPopUp( Self )

    METHOD  Hide()          INLINE  ::lVisible := ::lOpen := .f.,;
                                    ::DelPopUp()

    METHOD  UpdateOwner()   INLINE  ::oWindow:ScrFlash()
    
    MESSAGE SetPos( nTop, nLeft ) METHOD __SetPos( nTop, nLeft )

    DELEGATE MESSAGE AddPopUp( oPopUp ), ;
                     DelPopUp() TO oWindow

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cColors ) CLASS TMenuBox

    DEFAULT nTop := 0, nLeft := 0, nWidth := 1, nHeight := 1

    Super:New( nTop, nLeft, nWidth, nHeight, cColors )

return nil

//---------------------------------------------------------------------------//

METHOD Organize()

    local nWidth := 0

    if ! ::lOrganized
        aeval( ::aChilds, { | o | nWidth := max( nWidth, o:nWidth() + 1 ) } )
        ::ChangeSize( nWidth + 2, len( ::aChilds ) + 2 )
        aeval( ::aChilds, { | o, i | o:ChangeSize( nWidth, 1 ), ;
                                 o:SetPos( i, 1 ) } )
        ::lOrganized := .t.
        VMBoxDisplay( ::cVPort, ;
                               NewRect( 0, 0, nWidth + 2, ::nHeight ), ;
                               ::aColors[ CLR_BORDERLEFT ], ;
                               ::aColors[ CLR_BORDERRIGHT ] )
    endif

return nil

//---------------------------------------------------------------------------//

METHOD Paint( cVPTgt )
return VWndShadow( Super:Paint( cVPTgt ), ::nClipRect )

//---------------------------------------------------------------------------//

METHOD __SetPos( nNewRow, nNewCol )

    ::nClipRect := NewRect( nNewRow, nNewCol, ::nWidth(), ::nHeight )

    Super:SetPos( nNewRow, nNewCol )

return nil

//---------------------------------------------------------------------------//

METHOD Update( oChild )

    oChild:Flash( ::cVPort )
    if ::nPaintCount <= 0 .and. ::oParent != nil
        ::oWindow:ScrFlash()
    endif

return nil

//---------------------------------------------------------------------------//
