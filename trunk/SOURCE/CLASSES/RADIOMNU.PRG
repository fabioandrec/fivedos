#include "FiveDos.ch"
#include "SysColor.ch"

//-------------------------------------------------------------------------//

CLASS TRadMenu FROM TCtrlMenu

   DATA bSetGet AS Block

   METHOD Click( nMRow, nMCol )

   METHOD ChangeFocus( nCtrl )

// begin mod
   METHOD New( nRow, nCol, acItems, bSetGet, oWnd, cLabel, cMessage, cColor,;
               bWhen, bValid, bChanged, cFile1, cFile2, acColorLabel, lUpdate )
// end mod

   METHOD Redefine( cMessage, cColor, nHelpId, bSetGet, acItems, cLabel,;
                    bWhen, bValid, bChanged, lUpdate )

   METHOD SetColors( cColor, n, aSysClr ) INLINE ;  // n, aSysClr = local vars.
          aSysClr     := aSysColor(),;
          ::nColor    := if( Empty( n := nStrColor( cColor, 1 ) ), ;
                            aSysClr[ CLR_RADIOMNU ], n ),;
          ::nClrFocus := if( Empty( n := nStrColor( cColor, 2 ) ), ;
                            aSysClr[ CLR_RADIOMNU_HI ], n ),;
          ::nClrHot   := if( Empty( n := nStrColor( cColor, 3 ) ), ;
                            aSysClr[ CLR_RADIOMNU_HOT ], n ),;
          ::nClrUnSel := if( Empty( n := nStrColor( cColor, 4 ) ), ;
                            aSysClr[ CLR_RADIOMNU_OFF ], n )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nRow, nCol, acItems, bSetGet, oWnd, cLabel, cMessage, cColor,;
            bWhen, bValid, bChanged, cFile1, cFile2, acColorLabel, lUpdate )

    local nLabel := if( Empty( cLabel ), 1, 0 )

    ::Super:New( nRow, nCol, acItems, bSetGet, oWnd, cLabel, cMessage, cColor,;
                 bWhen, bValid, bChanged, acColorLabel )
    ::lUpdate := lUpdate

    cColor = ::nColor

    AEval( acItems, { | cItem, n, oRadio | ;
            oRadio := TRadio():New( n - nLabel, 0, cItem, cMessage, cColor, Self,;
            ,,cFile1, cFile2, lUpdate ),bPressed( oRadio ), bNoPressed( oRadio ) } )

    if IS_BLOCK( bSetGet )
        if !IS_NUMBER( nLabel := eval( bSetGet ) )  // Def. var. bSetGet == 1
            eval( bSetGet, ::nFocussed := nLabel := 1 )
        else
            nLabel = Max( 1, nLabel )
        endif
        BYNAME bSetGet
    else
        nLabel = 1
    endif

    ::nFocussed = nLabel

    if !Empty( len( ::aChilds ) )
        ::oFocussed = ::aChilds[ nLabel ]
        ::oFocussed:lPressed = .t.
        ::oFocussed:Refresh()
    endif

return Self

//---------------------------------------------------------------------------//

METHOD Redefine( cMessage, cColor, nHelpId, bSetGet, acItems, cLabel,;
                 bWhen, bValid, bChanged, lUpdate )

    local nLabel := if( Empty( cLabel ), 1, if( Empty( ::oLabel:cText ), 1, 0 ) ), nWidth := 0

    BYNAME bWhen, bValid, bChanged, bSetGet INIT BLOCK

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
       DEFAULT cLabel = ''
       AEval( acItems, { | cItem | nWidth := Max( nWidth, nLabelLen( cItem ) ) } )
       nWidth += 3
       nWidth = max( nWidth, nLabelLen( cLabel ) )
       AEval( acItems, { | cItem, i | acItems[ i ] := Pad( cItem, nWidth ) } )
       cColor = ::nColor
       aSize( ::aChilds, 0 )
       AEval( acItems, { | cItem, n, oRadio | ;
               oRadio := TRadio():New( n - nLabel, 0, cItem, cMessage, cColor,;
                                       Self ),;
                       bPressed( oRadio ), bNoPressed( oRadio ) } )
   
       if IS_BLOCK( bSetGet )
           if !IS_NUMBER( nLabel := eval( bSetGet ) )  // Def. var. bSetGet == 1
               eval( bSetGet, ::nFocussed := nLabel := 1 )
           endif
           BYNAME bSetGet
       else
           nLabel = 1
       endif
   
       ::nFocussed = nLabel
   
       if !Empty( len( ::aChilds ) )
           ::oFocussed = ::aChilds[ nLabel ]
           ::oFocussed:lPressed = .t.
           ::oFocussed:Refresh()
       endif
   
    endif
    ::lUpdate := lUpdate

return Self

//----------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol )

   local n

   if ::lDesign
       return Super:Click( nMRow, nMCol )
   endif

   while lMPressed()
       
       if !Empty( n := ::nAtOver( ::nMRow(), ::nMCol() ) ) .and. ;
          n != ::nFocussed .and. ::oFocussed:lValid() .and. ::aChilds[ n ]:lWhen()
          ::ChangeFocus( n )
       endif
       MUpdate()
   end

return nil

//---------------------------------------------------------------------------//

METHOD ChangeFocus( nCtrl )
    if ::oFocussed:lValid()
        Super:ChangeFocus( nCtrl )
        if ::oFocussed:lWhen()
           ::oFocussed:Refresh()
            eval( ::bSetGet, ::nFocussed )
            eval( ::bChanged )
        endif
    endif

return nil

//---------------------------------------------------------------------------//

static function bPressed( oRadio )
return oRadio:bWhen := {|| oRadio:lPressed := .t. }

//---------------------------------------------------------------------------//

static function bNoPressed( oRadio )
return oRadio:bValid := {|| !( oRadio:lPressed := .f. ) }

//---------------------------------------------------------------------------//
