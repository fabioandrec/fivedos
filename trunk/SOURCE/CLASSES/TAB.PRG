#include "FiveDos.ch"
#include "FontDef.h"
#include "SysColor.ch"

//----------------------------------------------------------------------------//

CLASS TTab FROM TView

   DATA   cText                                 AS Character
   DATA   nClrFocus, nClrHot, nClrHotFocus, ;
          nClrTab, nClrTabFocus                 AS Numeric
   DATA   lPressed, lAtBottom                   AS Logical


   METHOD New( nRow, nCol, cText, cColor, oWnd, bWhen, bValidl, lAtBottom, lUpdate  )

   METHOD Refresh()

   METHOD SetColors( cColor, n, aSysClr ) INLINE ;  // local vars == n, aSysClr
          aSysClr        := aSysColor(),;
          ::nColor       := if( Empty( n := nStrColor( cColor, 1 ) ), ;
                                aSysClr[ CLR_TABTEXTNORMAL ], n ),;
          ::nClrFocus    := if( Empty( n := nStrColor( cColor, 2 ) ), ;
                                aSysClr[ CLR_TABTEXTFOCUS ], n ),;
          ::nClrHot      := if( Empty( n := nStrColor( cColor, 3 ) ), ;
                                aSysClr[ CLR_TABHOTNORMAL ], n ),;
          ::nClrHotFocus := if( Empty( n := nStrColor( cColor, 4 ) ), ;
                                aSysClr[ CLR_TABHOTFOCUS ], n ),;
          ::nClrTab      := if( Empty( n := nStrColor( cColor, 5 ) ), ;
                                aSysClr[ CLR_TABNORMAL ], n ),;
          ::nClrTabFocus := if( Empty( n := nStrColor( cColor, 6 ) ), ;
                                aSysClr[ CLR_TABFOCUS ], n )


ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cText, cColor, oWnd, bWhen, bValid, lAtBottom ;
            , lUpdate   )

    BYNAME lAtBottom DEFAULT .f.

    ::cText   = if( IS_CHARACTER( cText ), cText, " " )

    if IS_NUMBER( cColor ) .and. oWnd != nil // Colores del padre: TTabMenu()
        ::nClrFocus    = oWnd:nClrFocus
        ::nClrHot      = oWnd:nClrHot
        ::nClrHotFocus = oWnd:nClrUnSel
        ::nClrTab      = oWnd:nClrTab
        ::nClrTabFocus = oWnd:nClrTabFocus
    else
        ::SetColors( cColor )
    endif

    Super:New( nRow, nCol, 2 + nLabelLen( cText ), 1, ::nColor,, oWnd,,;
               bWhen, bValid )

    ::nHotKey = nGetHotKey( ::cText )
    ::lUpdate := lUpdate

return Self

//----------------------------------------------------------------------------//

METHOD Refresh()
    local lPressed := ::lPressed

    ::BeginPaint()
    if ::lAtBottom
        ::Say( 0, 0, chr( TABRIGHT ), ClrReverse( if( lPressed, ::nClrTabFocus, ::nClrTab ) ) )
        ::SayHot( 0, 1, ::cText,;
                    If( lPressed, ::nClrFocus, ::nColor ), ;
                    If( lPressed, ::nClrHotFocus, ::nClrHot ) )
        ::Say( 0, ::nWidth - 1, chr( TABLEFT ), ClrReverse( if( lPressed, ::nClrTabFocus, ::nClrTab ) ) )
    else
        ::Say( 0, 0, chr( TABLEFT ), If( lPressed, ::nClrTabFocus, ::nClrTab ) )
        ::SayHot( 0, 1, ::cText,;
                    If( lPressed, ::nClrFocus, ::nColor ), ;
                    If( lPressed, ::nClrHotFocus, ::nClrHot ) )
        ::Say( 0, ::nWidth - 1, chr( TABRIGHT ), If( lPressed, ::nClrTabFocus, ::nClrTab ) )
    endif
    ::EndPaint()
return nil

//----------------------------------------------------------------------------//
