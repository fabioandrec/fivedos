#include "FiveDos.ch"
#include "FontDef.h"
#include "SysColor.ch"

//---------------------------------------------------------------------------//

CLASS TBtnBar FROM TView

    DATA    nFirst, nClrHot AS NUMERIC INIT 1
    DATA    lFirstChanged   AS LOGICAL INIT .T.

    METHOD AddControl( oChild )
    METHOD Adjust( nRect )
    METHOD Click( nRow, nCol )
    METHOD Flash( cVPTgt )
    METHOD Justify( oWnd, nWidth, nTop )
    METHOD New( oWnd ) CONSTRUCTOR


ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd ) CLASS TBtnBar

    local aSysClr := aSysColor()

    Super:New( 0, 0, VWidth( oWnd:cVPort ), 1 , aSysClr[ CLR_BUTTONBAR ] )

    ::oWnd    = oWnd
    ::nClrHot = aSysClr[ CLR_BUTTONBAR_HI ]

    if !IS_NIL( oWnd )
       oWnd:SetBar( Self )
    endif

return nil

//----------------------------------------------------------------------------//

METHOD AddControl( oChild )

    local nPos := if( empty( ::aChilds ), 1, aTail( ::aChilds ):nRight() ) + 1

    Super:AddChild( oChild )

    if nPos > ::oWnd:nWidth - 2
        if aTail( ::aChilds ):nLeft() < ::oWnd:nWidth() - 3
            ::Say( 0, 0, "", ::nColor )
        end
        oChild:SetPos( 1, nPos ) // Fuera del area visble de la barra
	else
        oChild:SetPos( 0, if( oChild:lGroup, nPos + 1, nPos ) )
    endif
    ::BeginPaint()
    oChild:Refresh()
    ::nPaintCount--

return nil

//---------------------------------------------------------------------------//

METHOD Flash( cVPTgt )

    local oWnd := ::oWnd
    local nClr := if( oWnd:lFocussed, oWnd:nClrHiBox, oWnd:nClrLoBox ) % 16 + int( ::nColor / 16  ) * 16
    
    VSay( VSay( ::cVPort, 0, 0, chr( BORDERLEFT ), nClr ), ;
                      0, RectWidth( ::nClipRect ) - 1, chr( BORDERRIGHT ), nClr )

return Super:Flash( cVPTgt )

//----------------------------------------------------------------------------//

METHOD Justify( oWnd, nWidth, nTop )

    local nPos     := 2 // en 0 va el Borde ...
    local nCurrent := ::nFirst
    local aChilds  := ::aChilds
    local n, oCurrent


    if ::lFirstChanged
        ::lFirstChanged = .f.
        ::oWnd = oWnd

        DEFAULT nTop   := ::nTop(),;
                nWidth := oWnd:nWidth()

        ::BeginPaint()

        VClear( ::cVPort, ::cChar, ::nColor )

        for n = 1 to len( aChilds )

            oCurrent = aChilds[ n ]

            if n < ::nFirst
                oCurrent:SetPos( 1, 0 )
            elseif nPos + oCurrent:nWidth() + if( oCurrent:lGroup , 1 , 0 ) < nWidth - 1
                oCurrent:SetPos( 0, nPos + if( oCurrent:lGroup , 1 , 0 ) )
                nPos += oCurrent:nWidth() + if( oCurrent:lGroup , 1 , 0)
                oCurrent:Flash( ::cVPort )
            else
                nPos = ::nWidth()  // Para que no se cuele el siguiente...
                oCurrent:SetPos( 1, nPos )
            endif

        next

        ::SetPos( nTop, 0 )

        if !empty( ::aChilds ) .and. aTail( ::aChilds ):nRight() > nWidth - 2
            ::Say( 0, 1 ,"", ::nClrHot )
        end

        if ::nFirst > 1
            ::Say( 0, nWidth - 2 , "", ::nClrHot )
        end

        ::EndPaint()
    endif

return nil

//----------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol )

    local nCol    := nMCol - ::nLeft()
    local nWidth  := ::oWnd:nWidth
    local aChilds := ::aChilds

    if nCol <= 1 .AND. ::nFirst < len( aChilds ) .AND. ;
       Atail( aChilds ):nRight() > nWidth

        ::nFirst ++
        ::lFirstChanged = .t.
        ::Justify( ::oWnd, nWidth )

    elseif nCol >= nWidth - 2 .AND. ::nFirst > 1
        --::nFirst
        ::lFirstChanged = .t.
        ::Justify( ::oWnd, nWidth )
    else
        Super:Click( nMRow, nMCol )
        if ::nFirst > 1
            ::Say( 0, nWidth - 2, "", ::nClrHot )
        endif
    endif

return nil

//---------------------------------------------------------------------------//

METHOD Adjust( nRect )

    local nWidth := RectWidth( nRect ), nTop := RectTop( nRect )
    local n, nPos := 0, aChilds := ::aChilds

    if ::nFirst != 1 .or. RectWidth( ::nClipRect ) != nWidth
        ::lFirstChanged = .t.
        ::nFirst = 1
    endif

    ::nClipRect = NewRect( nTop, 0, nWidth , 1 )

    nRect := NewRect(   nTop + 1,;
                        RectLeft( nRect ),;
                        nWidth,;
                        RectHeight( nRect ) - 1 )

    ::Justify( ::oWnd, nWidth, nTop )

return nRect

//---------------------------------------------------------------------------//
