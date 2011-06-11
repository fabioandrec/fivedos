#include "FiveDos.ch"
#include "SysColor.ch"

//-------------------------------------------------------------------------//

CLASS TTabMenu FROM TCtrlMenu

   DATA bSetGet AS Block
   DATA nClrTab, nClrTabFocus  AS Numeric

   METHOD ChangeFocus( nCtrl )

   METHOD Click( nMRow, nMCol )

   METHOD New( nRow, nCol, acItems, bSetGet, oWnd, cColor,;
               bWhen, bValid, bChanged, lAtBottom, acColorLabel )


   METHOD lWhen( nSinAlt ) INLINE ( lAltChr( LastKey(), @nSinAlt ) .or. lMPressed() ) ;
                                  .and. Super:lWhen()


   METHOD IsHotKey( nChar )

   METHOD SetColors( cColor, n, aSysClr ) INLINE ;  // local vars == n, aSysClr
          aSysClr        := aSysColor(),;
          ::nColor       := if( Empty( n := nStrColor( cColor, 1 ) ), ;
                                aSysClr[ CLR_TABTEXTNORMAL ], n ),;
          ::nClrFocus    := if( Empty( n := nStrColor( cColor, 2 ) ), ;
                                aSysClr[ CLR_TABTEXTFOCUS ], n ),;
          ::nClrHot      := if( Empty( n := nStrColor( cColor, 3 ) ), ;
                                aSysClr[ CLR_TABHOTNORMAL ], n ),;
          ::nClrUnSel    := if( Empty( n := nStrColor( cColor, 4 ) ), ;
                                aSysClr[ CLR_TABHOTFOCUS ], n ),;
          ::nClrTab      := if( Empty( n := nStrColor( cColor, 5 ) ), ;
                                aSysClr[ CLR_TABNORMAL ], n ),;
          ::nClrTabFocus := if( Empty( n := nStrColor( cColor, 6 ) ), ;
                                aSysClr[ CLR_TABFOCUS ], n )



ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nRow, nCol, acItems, bSetGet, oWnd, cColor,;
            bWhen, bValid, bChanged, lAtBottom, acColorLabel )

    local nPos := 0

    ::Super:New( nRow, nCol, acItems, bSetGet, oWnd,,, cColor,;
                 bWhen, bValid, bChanged, .f., ; // lVertical = .f.
                 acColorLabel )

    ::nPaintCount++
    ::Clear( " ", ::oWnd:nColor )
    ::nPaintCount--

    AEval( acItems, { | cItem, oTab | ;
                    oTab := TTab():New( 0, nPos, cItem, ::nColor, Self,,, lAtBottom ),;
                    nPos += oTab:nWidth()  } )

    if IS_BLOCK( bSetGet )
        if !IS_NUMBER( nPos := eval( bSetGet ) )  // Def. var. bSetGet == 1
            eval( bSetGet, nPos := 1 )
        endif
        BYNAME bSetGet
    else
        nPos = 1
    endif

    ::nFocussed = nPos

    if !Empty( len( ::aChilds ) )
        ::oFocussed = ::aChilds[ nPos ]
        ::oFocussed:lPressed = .t.
        ::oFocussed:Refresh()
    endif

return Self

//---------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol )

   local n

   if ::lDesign
       return Super:Click( nMRow, nMCol )
   endif

   if !Empty( n := ::nAtOver( ::nMRow(), ::nMCol() ) ) .and. n == ::nFocussed
      eval( ::bChanged )
      MUpdate()
   endif

   while lMPressed()
       
       if !Empty( n := ::nAtOver( ::nMRow(), ::nMCol() ) ) .and. n != ::nFocussed
          ::ChangeFocus( n )
       endif
       MUpdate()
   end

return nil

//---------------------------------------------------------------------------//

METHOD ChangeFocus( nCtrl )
    if ::oFocussed:lValid()
        ::oFocussed:lPressed = .f.
        Super:ChangeFocus( nCtrl )
        ::oFocussed:lPressed = .t.
        if ::oFocussed:lWhen()
           ::oFocussed:Refresh()
            eval( ::bSetGet, ::nFocussed )
            eval( ::bChanged )
        endif
    endif

return nil

//---------------------------------------------------------------------------//

METHOD IsHotKey( nChar )
return ::nHotAt( nChar ) > 0

//---------------------------------------------------------------------------//
