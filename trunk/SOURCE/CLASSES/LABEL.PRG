#include "FiveDos.ch"
#include "SysColor.ch"

//---------------------------------------------------------------------------//

CLASS TLabel FROM TView

    DATA cText     AS Character   INIT ""
    DATA aColors   AS Array
    DATA nJustify  AS Numeric   // == 0 -> Centrado
                                //  > 0 -> Derecha
                                //  < 0 -> Izquierda

    METHOD ChangeSize( nWidth, nHeight ) INLINE ;
                                         Super:ChangeSize( nWidth, nHeight ),;
                                         ::SetText( ::cText )
    METHOD SetColors( cColor ) INLINE ::aColors := aSetColors( cColor )

    METHOD New( nTop, nLeft, cText, cColor, nWidth, nHeight, oWnd, cMessage,;
                nJustify, lUpdate ) CONSTRUCTOR

    METHOD  ReDefine( cText, cMessage, cColor, nHelpId, nJustify, lUpdate ),;
            Refresh(),;
            SetText( cText ),;
            SetFocus( lOnOff )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, cText, cColor, nWidth, nHeight, oWnd, cMessage,;
            nJustify, lUpdate )

    DEFAULT nWidth  := nLabelLen( cText ), ;
            nHeight := 1

    BYNAME nJustify IFNONIL

    // No queremos llamara al m‚todo sino a la funcion aSetColor
    ::aColors = aSetColors( cColor )
    
    Super:New( nTop, nLeft, nWidth, nHeight, ::aColors[ CLRLBL_NORMAL ],,;
               oWnd, cMessage, bFalse(),, lUpdate )

    ::nPaintCount++
    ::SetText( cText )
    ::nPaintCount--

return Self

//---------------------------------------------------------------------------//

METHOD ReDefine( cText, cMessage, cColor, nHelpId, nJustify )

*   BYNAME nHelpId  INIT NUMERIC
    BYNAME nJustify INIT NUMERIC
    BYNAME cMessage INIT CHARACTER

    if !IS_NIL( cColor )
       ::aColors = aSetColors( cColor )   // no va -> ::SetColors( cColor )
    endif

    if !IS_NIL( cText )
       ::SetText( cText )
    endif

return Self

//---------------------------------------------------------------------------//

METHOD Refresh()

    ::SetText( ::cText )

return nil

//---------------------------------------------------------------------------//

METHOD SetFocus( lOnOff )

    local nRect, aColors := ::aColors

    if !( lOnOff == ::lFocussed )
        nRect = NewRect( 0, 0, ::nWidth(), ::nHeight() )
        ::lFocussed = lOnOff
        // ::lPainted  = .f.
        VSwapAtt( ::cVPort, nRect, aColors[ CLRLBL_NORMAL ],;
                                   aColors[ CLRLBL_HILITE ] )
        if aColors[ CLRLBL_HOTKEY ] != aColors[ CLRLBL_HILITE ]
           VSwapAtt( ::cVPort, nRect, aColors[ CLRLBL_HOTKEY ],;
                                      aColors[ CLRLBL_HOTKEY_HI ] )
        endif
        ::SetMessage( ::cMessage )
        ::UpdateOwner()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD SetText( cText )

    local aColors := ::aColors

    if IS_CHARACTER( cText  )
        BYNAME cText
    else
        ::cText := cText := ""
    endif

    ::nHotKey = nGetHotKey( cText )
    
    if ::lFocussed
       VLabel( ::cVPort, cText, aColors[ CLRLBL_HILITE ]   ,; // ColorText
                                aColors[ CLRLBL_HOTKEY_HI ],; // ColorHot
                                ::nJustify )
    else
       VLabel( ::cVPort, cText, aColors[ CLRLBL_NORMAL ],; // ColorText
                                aColors[ CLRLBL_HOTKEY ],; // ColorHot
                                ::nJustify )
    endif

    ::UpdateOwner()

return nil

//---------------------------------------------------------------------------//

function aSetColors( cColor )

    local n, aColors, aSysClr

    if IS_ARRAY( cColor )
       aColors = cColor
    else
       aColors = array( 4 )
       aSysClr = aSysColor()

       aColors[ CLRLBL_NORMAL ]    = if( Empty( n := nStrColor( cColor, 1 ) ), ;
                                         aSysClr[ CLR_LABEL ], n )
       aColors[ CLRLBL_HILITE ]    = if( Empty( n := nStrColor( cColor, 2 ) ), ;
                                         aSysClr[ CLR_LABEL_HI ], n )
       aColors[ CLRLBL_HOTKEY ]    = if( Empty( n := nStrColor( cColor, 3 ) ), ;
                                         aSysClr[ CLR_LABELHOT ], n )
       aColors[ CLRLBL_HOTKEY_HI ] = if( Empty( n := nStrColor( cColor, 4 ) ), ;
                                         aSysClr[ CLR_LABELHOT_HI ], n )
    endif

return aColors

//---------------------------------------------------------------------------//
