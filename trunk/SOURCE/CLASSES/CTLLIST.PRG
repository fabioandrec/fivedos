#include "FiveDos.ch"

//---------------------------------------------------------------------------//

CLASS TCtlList FROM TView

    METHOD New( oPage, bPaint, cColor ) INLINE ;
                    if( empty( cColor ), cColor := "N/BG",),;
                    Super:New( 0, 0, oPage:nWidth, oPage:nHeight, cColor ),;
                    oPage:AddChild( Self ),;
                    ::bPaint := if( ValType( bPaint ) == "B", bPaint, bNil() ),;
                    Self

    METHOD KeyPressed( nKey )

ENDCLASS

//---------------------------------------------------------------------------//

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

//---------------------------------------------------------------------------//

/*
::aClrLabel := { nBack + if( Empty( n := nStrColor( cLabelColors, 1 ) ), ;
                                        aSysClr[ CLR_LABEL ], n ) % 16 ,;
                            nBack + if( Empty( n := nStrColor( cLabelColors, 2 ) ), ;
                                        aSysClr[ CLR_LABEL_HI ], n ) % 16 ,;
                            nBack + if( Empty( n := nStrColor( cLabelColors, 3 ) ), ;
                                        aSysClr[ CLR_LABELHOT ], n ) % 16 ,;
                            nBack + if( Empty( n := nStrColor( cLabelColors, 4 ) ), ;
                                        aSysClr[ CLR_LABELHOT_HI ], n ) % 16 }

*/
