#include "FiveDos.ch"

//---------------------------------------------------------------------------//

CLASS TNBook FROM TView

    DATA aoPages, aLabelClr      AS Array
    DATA nIndex, nParentIndex    AS Numeric

    METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR

    METHOD AddChild( oCtrl ) INLINE if( empty( ::aChilds ), ;
                                        ( aadd( ::aChilds, ::oFocussed := oCtrl ),;
                                          ::nFocussed := 1 ), ),;
                                    aadd( ::aoPages, oCtrl ), ;
                                    oCtrl:oWnd := Self

    METHOD AddControl( oCtl ) INLINE if( !empty( ::aoPages ),;
                                         aTail( ::aoPages ):AddChild( oCtl ), )
    METHOD SetPage( nPage, lFocus )

    METHOD aClrLabel() INLINE if( !empty( ::aoPages ),;
                                    aTail( ::aoPages ):aClrLabel,;
                                    ::aLabelClr )

    METHOD IsHotKey( nChar )

    DELEGATE MESSAGE KeyPressed TO oFocussed

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, oWnd, cColor )

    DEFAULT nTop := 1, nLeft := 1, nBottom := nTop + 9, nRight := nLeft + 19

    ::aoPages = {}

    Super:New(  nTop, nLeft, ;
                nRight - nLeft + 1, ;
                nBottom - nTop + 1,,, oWnd )

    ::nParentIndex := ascan( ::oWnd:aChilds, {|x| x == Self } )

    if empty( cColor )
        ::aLabelClr := ::oWnd:oWnd:aClrLabel
    else
        ::aLabelClr := aSetColors( cColor )  // public in Label.prg
    endif

return Self

//---------------------------------------------------------------------------//

METHOD SetPage( nPage, lFocus )

    local n

    DEFAULT lFocus := .f.


    if nPage > 0 .and. ;
       nPage <= len( ::aoPages ) .and. ;
       !empty( ::aChilds )

       ::BeginPaint()

        if nPage != ::nIndex
            // ::nFocussed siempre es 1
            ::aChilds[ 1 ] := ::oFocussed := ::aoPages[ ::nIndex := nPage ]
        endif

        // evalua la accion, si existe
        eval( ::oFocussed:bAction )

        if lFocus .and. ::nParentIndex > 0
            ::oWnd:ChangeFocus( ::nParentIndex )
        endif

        ::Refresh()
        ::EndPaint()

    endif

return nil

//---------------------------------------------------------------------------//

METHOD IsHotKey( nChar )
return ::oFocussed:nHotAt( nChar ) > 0

//---------------------------------------------------------------------------//
