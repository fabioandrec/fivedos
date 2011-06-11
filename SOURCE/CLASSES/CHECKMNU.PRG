#include "FiveDos.ch"
#include "SysColor.ch"

//-------------------------------------------------------------------------//

CLASS TChkMenu FROM TCtrlMenu

   METHOD KeyPressed( nKey ) INLINE ;
          If( !Empty( nKey := Super:KeyPressed( nKey ) ),;
              ::oFocussed:KeyPressed( nKey ), nKey )
// begin mod
   METHOD New( nRow, nCol, acItems, abVars, oWnd, cLabel, cMessage, cColor,;
               bWhen, bValid, bChanged , cFile1, cFile2, acColorLabel )
// end mod

   METHOD Redefine( cMessage, cColor, nHelpId, abVars, acItems, cLabel,;
                    bWhen, bValid, bChanged )

   METHOD SetColors( cColor, n, aSysClr ) INLINE ;  // n, aSysClr = local vars.
          aSysClr     := aSysColor(),;
          ::nColor    := if( Empty( n := nStrColor( cColor, 1 ) ), ;
                            aSysClr[ CLR_CHECKBOX ], n ),;
          ::nClrFocus := if( Empty( n := nStrColor( cColor, 2 ) ), ;
                            aSysClr[ CLR_CHECKBOX_HI ], n ),;
          ::nClrHot   := if( Empty( n := nStrColor( cColor, 3 ) ), ;
                            aSysClr[ CLR_CHECKBOX_HOT ], n ),;
          ::nClrUnSel := if( Empty( n := nStrColor( cColor, 4 ) ), ;
                            aSysClr[ CLR_CHECKBOX_OFF ], n )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nRow, nCol, acItems, abVars, oWnd, cLabel, cMessage, cColor,;
            bWhen, bValid, bChanged, cFile1, cFile2, acColorLabel )

    local n, b, nLabel := if( Empty( cLabel ), 1, 0 )

    DEFAULT acItems := {""}

    AEval( abVars, { | b | if( !IS_LOGICAL( eval( b ) ), eval( b, .f. ), ) } )
    aSize( abVars, len( acItems ) )

    ::Super:New( nRow, nCol, acItems,, oWnd, cLabel, cMessage, cColor,;
                 bWhen, bValid, bChanged, acColorLabel )

    cColor = ::nColor
// begin mod
    AEval( acItems, { | cItem, n | ;
                     TCheckBox():New( n - nLabel, 0, cItem,, cColor, Self,,,;
                                      abVars[ n ] , cFIle1, cFile2) } )
// end mod
return Self

//----------------------------------------------------------------------------//

METHOD Redefine( cMessage, cColor, nHelpId, abVars, acItems, cLabel,;
                 bWhen, bValid, bChanged )

    local nLabel := if( Empty( cLabel ), 1, if( Empty( ::oLabel:cText ), 1, 0 ) ), nWidth := 0

*   BYNAME nHelpId                 INIT NUMERIC
    BYNAME bWhen, bValid, bChanged INIT BLOCK

    if IS_CHARACTER( cLabel )
       ::oLabel:SetText( cLabel )
    endif

    if IS_CHARACTER( cMessage )
       ::oLabel:cMessage = cMessage
    endif

    if !IS_NIL( cColor )
       ::SetColors( cColor )
    endif

    if IS_ARRAY( acItems )
       DEFAULT abVars = {}, cLabel = ''
       AEval( abVars, { | b | if( !IS_LOGICAL( eval( b ) ), eval( b, .f. ), ) } )
       aSize( abVars, len( acItems ) )
       AEval( acItems, { | cItem | nWidth := Max( nWidth, nLabelLen( cItem ) ) } )
       nWidth += 3
       nWidth = max( nWidth, nLabelLen( cLabel ) )
       AEval( acItems, { | cItem, i | acItems[ i ] := Pad( cItem, nWidth ) } )
       cColor = ::nColor
       aSize( ::aChilds, 0 )
       AEval( acItems, { | cItem, n | ;
                        TCheckBox():New( n - nLabel, 0, cItem,, cColor, Self,,,;
                                         abVars[ n ] ) } )
    endif

return Self

//----------------------------------------------------------------------------//

