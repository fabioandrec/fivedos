#include "FiveDos.ch"
#include "SysColor.ch"

//---------------------------------------------------------------------------//

CLASS TPage FROM TView

    DATA aClrLabel
    DATA bAction AS Block INIT bNil()

    METHOD New( oBook, bPaint, cColor, bAction ) INLINE ;
                ::aClrLabel := if( empty( cColor ), ;
                                    oBook:aClrLabel, ;
                                    aSetColors( cColor ) ),; // public in Label.prg
                Super:New( 0, 0, oBook:nWidth, oBook:nHeight, ;
                           ::aClrLabel[ CLRLBL_NORMAL ] ),;
                oBook:AddChild( Self ),;
                if( IS_BLOCK( bPaint ), ::bPaint := bPaint, ),;
                if( IS_BLOCK( bAction ), ::bAction := bAction, ),;
                Self

    METHOD KeyPressed( nKey )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    local nSinAlt

    if nKey == K_TAB
        if ::nFocussed == len( ::aChilds )
            return nKey
        endif
    elseif nKey == K_SH_TAB
        if ::nFocussed == 1
            return nKey
        endif

    elseif lAltChr( LastKey(), @nSinAlt ) ;
           .and. nSinAlt == nKey

           nKey = LastKey()

    endif

return Super:KeyPressed( nKey )

//---------------------------------------------------------------------------//
