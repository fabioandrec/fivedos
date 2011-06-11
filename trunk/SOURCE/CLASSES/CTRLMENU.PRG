#include "FiveDos.ch"

external TView

//----------------------------------------------------------------------------//

CLASS TCtrlMenu FROM TControl

    DATA bChanged                       AS Block INIT bNil()
    DATA nClrFocus, nClrHot, nClrUnSel  AS Numeric


    METHOD  New( nRow, nCol, aItems, bSetGet, oWnd, cLabel, cMsg, cColor,;
                 bWhen, bValid, bChanged, lVertical, acColorLabel ),;
            KeyPressed( nKey ),;
            SetFocus( lOnOff ),;
            SetMessage( cMsg )

    METHOD AddControl( oCtrl ) ALIAS OF AddChild( oCtrl )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, acItems, bSetGet, oWnd, cLabel, cMsg, cColor,;
            bWhen, bValid, bChanged, lVertical, acColorLabel )

   local oLabel, nWidth := 1, nHeight := 1

   DEFAULT lVertical := .t.

   BYNAME bChanged IFNONIL

   if lVertical
        AEval( acItems, { | cItem | nWidth := Max( nWidth, nLabelLen( cItem ) ) } )
        nWidth += 3
        nWidth = max( nWidth, nLabelLen( cLabel ) )
        AEval( acItems, { | cItem, i | acItems[ i ] := Pad( cItem, nWidth ) } )
        nHeight := len( acItems ) + if( Empty( cLabel ), 0, 1 )
    else
        AEval( acItems, { | cItem | nWidth += nLabelLen( cItem ) + 3 } )
        nHeight := 1 + if( Empty( cLabel ), 0, 1 )
   endif

   ::SetColors( cColor )

   Super:New( nRow, nCol, nWidth, min( RectHeight( oWnd:nClipRect ), nHeight ),;
              ::nColor,, oWnd, cMsg, cLabel, bWhen, bValid, acColorLabel )

   if empty( cLabel )
      ::oLabel:SetPos( 500, 500 )
   else
      (oLabel := ::oLabel):nJustify = 0
      oLabel:oWnd = nil
      oLabel:ChangeSize( ::nWidth, 1 )
      oLabel:oWnd = Self
   endif

return Self

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    local nNewOption

    if ::lDesign
        return Super:KeyPressed( nKey )
    endif

    do case
        case nKey == K_UP .or. nKey == K_LEFT
            ::GoPrevius( K_UP )

        case nKey == K_DOWN .or. nKey == K_RIGHT
            ::GoNext( K_DOWN )

        case nKey == K_TAB .or. nKey == K_SH_TAB
            return nKey

        case nKey == K_HOME
            ::ChangeFocus( 1 )

        case nKey == K_END
            ::ChangeFocus( Len( ::aChilds ) )

        case ( nNewOption := ::nHotAt( nUpperKey( nKey ) ) ) > 0
            ::ChangeFocus( nNewOption )
        otherwise

            return Super:KeyPressed( nKey )

    endcase

return 0

//---------------------------------------------------------------------------//

METHOD SetFocus( lOnOff )

   ::BeginPaint()
   ::oLabel:SetFocus( lOnOff )
   ::TView:SetFocus( lOnOff )
   ::Refresh()
   ::EndPaint()

return nil

//---------------------------------------------------------------------------//

METHOD SetMessage( cMsg )
  local oWnd := ::oWnd
return if( oWnd != nil,;
           oWnd:SetMessage( if( Empty( cMsg ), ::oLabel:cMessage, cMsg ) ), )

//----------------------------------------------------------------------------//

