#include "FiveDos.ch"
#include "FontDef.h"
#include "CtlAlign.ch"
/*
#define ALIGN_NONE      0
#define ALIGN_TOP       1
#define ALIGN_RIGHT     2
#define ALIGN_BOTTOM    3
#define ALIGN_LEFT      4
#define ALIGN_CLIENT    5
*/

#define BOXSINGLE "ÚÄ¿³ÙÄÀ³"

#define BOX3DS    chr( POINT_SE ) + chr( BORDERBOTTOM ) + chr( POINT_SW )  + chr( BORDERLEFT ) + chr( POINT_NW )  + chr( BORDERTOP ) + chr( POINT_NE )  + chr( BORDERRIGHT )

static oCmdErase, oCmdDestroy, oCmdIsOver, oCmdPaint

//---------------------------------------------------------------------------//

CLASS TView

/* DE AQUI............... */

    DATA cVPort, ;
         oWnd, ;
         aChilds, ;
         oFocussed,;
         nID, ;
         cVarName,;
         Cargo,;
         nColor, ;
         cChar, ;
         cMessage,;
         nClipRect

    DATA nFocussed, ; // Child con focus
         nPaintCount, ;
         nHelpId,;
         nHotKey,;
         nAlign    INIT 0

    DATA lPainted, ;
         lFocussed, ;
         lDesign    INIT .F.

    DATA lVisible               INIT .T.
    DATA bWhen, bValid          AS Block INIT bTrue()
    DATA bPaint, bClick, bRight AS Block INIT bNil()
    DATA bKey                   AS Block
    DATA nMouseCursor           INIT IDC_ARROW
    DATA lUpdate                INIT .f. // for update selective

/* Hasta AQUI: NO TOCAR. ************/

    METHOD Box( nTop, nLeft, nBottom, nRight, cBox, nClr ) ;
           EXTERN TVBox( nTop, nLeft, nBottom, nRight, cBox, nClr )

    METHOD Box3D( nTop, nLeft, nBottom, nRight, nLeftClr, nRitClr ) INLINE ;
           VMBoxDisplay( ::cVPort, NewRect( nTop, nLeft, nRight - nLeft + 1, nBottom - nTop + 1 ), nLeftClr, nRitClr, BOX3DS ), ;
           ::UpdateOwner()
    METHOD ChangeSize( nWidth, nHeight ) INLINE ;
                      ::lPainted := .f.,;
                      ::cVPort   := ViewPortNew( ::nTop, ::nLeft, ;
                                                 nWidth, nHeight,;
                                                 ::cChar, ::nColor )
                      

    METHOD Clear( cChar, nColor ) INLINE ::EraseBackGround( cChar, nColor ),;
                                         ::Refresh()

    METHOD Close()                      VIRTUAL

    METHOD  AddChild( oCtrl ),;
            Adjust( nParentRect ),;
            ChangeFocus( nChild ),;
            Click( nMRow, nMCol, lDblClick ),;
            Destroy(),;
            DragOver(),;
            EraseBackGround( cChar, nColor ),;
            Flash( cVTargetPort ),; // -> cVTargetPort
            GetNext(),;
            GetPrevius(),;
            GoNext( nKeyPressed ),;
            GoPrevius( nKeyPressed )

    // TWindow overload this method to redirect this to oClient
    METHOD AddControl( oChild ) ALIAS OF AddChild

    METHOD BeginPaint() EXTERN TVBeginPaint() // INLINE ++::nPaintCount
    METHOD EndPaint()   EXTERN TVEndPaint()   // INLINE if( --::nPaintCount <= 0, ::UpdateOwner( ::nPaintCount := 0 ), )
            
    METHOD Display()        INLINE ::lVisible := .t., ::Refresh()
    METHOD Hide()           INLINE ::lVisible := .f., ::UpdateOwner()

    METHOD  IsHotKey( nChar ),;
            KeyPressed( nKey ),;
            lValid(),;
            lWhen(),;
            MouseMove( nMRow, nMCol ),;
            nAtOver( nMRow, nMCol ),;
            nHotAt( nHotKey ),;
            nKeyEval( nKey )

    METHOD nMRow()      EXTERN TVnMRow()
    METHOD nMCol()      EXTERN TVnMCol()
    METHOD nOrgTop()    EXTERN TVOrgTop()
    METHOD nOrgLeft()   EXTERN TVOrgLeft()
    METHOD nTop()       EXTERN TVTop()
    METHOD nLeft()      EXTERN TVLeft()
    METHOD nBottom()    EXTERN TVBottom
    METHOD nRight()     EXTERN TVRight()
    METHOD nHeight()    EXTERN TVHeight()
    METHOD nWidth()     EXTERN TVWidth()

    METHOD lIsOver( nMRow, nMCol )          EXTERN TVIsOver( nMRow, nMCol )
    METHOD lIsOverResize( nMRow, nMCol )    EXTERN TVIsOverRe( nMRow, nMCol )

    METHOD  nGetId( nId ),;
            nGetNewId( nId )

    METHOD New( nTop, nLeft, nWidth, nHeight, cColor, cChar, oWnd, cMessage,;
                bWhen, bValid, lUpdate )

    METHOD  Paint( cVPTarget, nClipRect ),;  // -> cVPTarget
            Redefine():VIRTUAL,;
            Refresh(),;
            Resize(),;
            Resized(),;
            SetColors( nColor ):VIRTUAL,;
            SetFocus( lOnOff ),;
            SetFocusTo( nChild ),;
            SetMessage( cMsg )


    METHOD Say( nRow, nCol, cText, nClr ) ;
           EXTERN TVSay( nRow, nCol, cText, nClr )

    METHOD SayHot( nRow, nCol, cText, nClr, nClrHot ) ;
           EXTERN TVSayHot( nRow, nCol, cText, nClr, nClrHot )

    MESSAGE SetCursor( nCursor ) METHOD _SetCursor( nCursor )

    METHOD SetDesign( lDesign ) INLINE ::lDesign := lDesign, ::lPainted := .f.

    METHOD SetPos( nTop, nLeft )  EXTERN TVSetPos( nTop, nLeft )
    METHOD Ch_Update( oChild )       EXTERN TVUpdate( oChild )
    METHOD UpdateOwner()          EXTERN TVUpdateOw()
    METHOD UPDATE()

    DELEGATE MESSAGE DispBegin() TO oWnd
    DELEGATE MESSAGE DispEnd()   TO oWnd

    oCmdErase   = Command():ERASEBACKG
    oCmdDestroy = Command():DESTROY
    oCmdIsOver  = Command():LISOVER
    oCmdPaint   = Command():PAINT

ENDCLASS

//---------------------------------------------------------------------------//

METHOD _SetCursor( nCursor )
return if( ::oWnd != nil, ;
           ::oWnd:SetCursor( if( ::lDesign, 0, nCursor ) ), )

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cColor, cChar, oWnd, cMessage, ;
            bWhen, bValid, lUpdate )

    local n

    DEFAULT nTop    := 0    ,;
            nLeft   := 0    ,;
            nWidth  := 10   ,;
            nHeight := 10

    BYNAME cMessage      INIT CHARACTER
    BYNAME bWhen, bValid INIT BLOCK
    BYNAME lUpdate INIT .f.

    ::cChar  := cChar  := if( IS_CHARACTER( cChar ), cChar, " " )
    ::nColor := cColor := if( IS_NUMBER( cColor ), cColor,;
                              if( Empty( n := nStrColor( cColor, 1 ) ),;
                              if( !IS_NIL( oWnd ), oWnd:nColor, 7 ), n ) )

    ::cVPort = ViewPortNew( nTop, nLeft, nWidth, nHeight, cChar, cColor )

    ::aChilds   = {}
    ::cVarName  = ::ClassName()

    if !IS_NIL( oWnd )
       oWnd:AddControl( Self )
    endif

return Self

//---------------------------------------------------------------------------//

METHOD AddChild( oCtrl )
    aadd( ::aChilds, oCtrl )
return ( oCtrl:oWnd := Self )

//---------------------------------------------------------------------------//

METHOD Adjust( nParentRect )

    local nAlign := ::nAlign, lChanged := .t.

    do case
        case nAlign == ALIGN_NONE
             lChanged := .f.

        case nAlign == ALIGN_TOP
             ::SetPos( RectTop( nParentRect ), RectLeft( nParentRect ) )
             ::ChangeSize( RectWidth( nParentRect ), ::nHeight )

             nParentRect := NewRect( RectTop(    nParentRect ) + ::nHeight,;
                                     RectLeft(   nParentRect ),;
                                     RectWidth(  nParentRect ),;
                                     Max( 0, RectHeight( nParentRect ) - ::nHeight ) )
        case nAlign == ALIGN_RIGHT
             ::SetPos( RectTop( nParentRect ), ;
                       Max( RectLeft( nParentRect ), ;
                            RectRight( nParentRect ) - ::nWidth + 1 ) )
             ::ChangeSize( ::nWidth, RectHeight( nParentRect ) )

             nParentRect := NewRect( RectTop(    nParentRect ),;
                                     RectLeft(   nParentRect ),;
                                     Max( 0, RectWidth(  nParentRect ) - ::nWidth ),;
                                     RectHeight( nParentRect ) )
        case nAlign == ALIGN_BOTTOM
             ::SetPos( Max( RectTop( nParentRect ), ;
                            RectBottom( nParentRect ) - ::nHeight + 1 ), ;
                       RectLeft( nParentRect ) )
             ::ChangeSize( RectWidth( nParentRect ), ::nHeight )

             nParentRect := NewRect( RectTop(    nParentRect ),;
                                     RectLeft(   nParentRect ),;
                                     RectWidth(  nParentRect ),;
                                     Max( 0, RectHeight( nParentRect ) - ::nHeight  ) )
        case nAlign == ALIGN_LEFT
             ::SetPos( RectTop( nParentRect ), RectLeft( nParentRect ) )
             ::ChangeSize( ::nWidth, RectHeight( nParentRect ) )

             nParentRect := NewRect( RectTop(    nParentRect ),;
                                     RectLeft(   nParentRect ) + ::nWidth,;
                                     Max( 0, RectWidth(  nParentRect ) - ::nWidth ),;
                                     RectHeight( nParentRect ) )
        case nAlign == ALIGN_CLIENT
             ::SetPos( RectTop( nParentRect ), RectLeft( nParentRect ) )
             ::ChangeSize( RectWidth( nParentRect ), RectHeight( nParentRect ) )

        otherwise
            lChanged := .f.
    endcase

    // cualquier control hijo puede necesitar ajustarse a la nueva sistuaci¢n.
    if lChanged
        ::Resized()
    endif

return nParentRect

//---------------------------------------------------------------------------//

METHOD ChangeFocus( nCtrl )

    local oNewFocussed, lClear := .f.

    if !Empty( nCtrl ) .and. !( ::nFocussed == nCtrl )

        oNewFocussed = ::aChilds[ nCtrl ]

        ::BeginPaint()

        if !IS_NIL( ::oFocussed )
           ::oFocussed:SetFocus( .f. )
           lClear = ::oFocussed:lDesign
        endif

        ::nFocussed = nCtrl
        oNewFocussed:SetFocus( .t. )

        if lClear .or. oNewFocussed:lDesign
           ::Clear()
        endif

        ::oFocussed = oNewFocussed

        ::EndPaint()

    endif

return nil

//---------------------------------------------------------------------------//

METHOD EraseBackGround( cChar, nColor )


    DEFAULT cChar  := ::cChar,;
            nColor := ::nColor

    ::BeginPaint()

    ::lPainted = .f.
    VClear( ::cVPort, cChar, nColor )

    oCmdErase:aSend( ::aChilds )

    ::nPaintCount--

return nil

//---------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol, lDblClick )

    local n, oChild

    if PCount() < 3
        lDblClick = .f.
    endif

    nMRow -= ::nTop()  // de coordenadas padre a coordenadas de view
    nMCol -= ::nLeft()
    if !IS_NIL( ::oFocussed ) .and. ::oFocussed:lIsOver( nMRow, nMCol )
       n = ::nFocussed
    else
       n = ::nAtOver( nMRow, nMCol )
    endif

    if n > 0
        oChild = ::aChilds[ n ]
    endif

    // si estamos en modo dise¤o no se procesan los click de los hijitos...
    if !IS_NIL( oChild ) .and. !::lDesign

        if oChild:lDesign

            ::ChangeFocus( n )
            oChild:Click( nMRow, nMCol, lDblClick )

        else
            if ::nFocussed > 0 .and. n != ::nFocussed ;

                if ::oFocussed:lValid() .and. oChild:lWhen()
                    ::ChangeFocus( n )
                    oChild:Click( nMRow, nMCol, lDblClick )
                endif
            else
                oChild:Click( nMRow, nMCol, lDblClick )
            endif

        endif
    else
        if lMRight()
            eval( ::bRight )
        else
            if ::lDesign
                if ::lIsOverResize( ::oWnd:nMRow, ::oWnd:nMCol )
                    ::Resize()
                else
                    ::DragOver()
                endif
            else
                eval( ::bClick, nMRow, nMCol )
            endif
        endif
    endif

return nil

//---------------------------------------------------------------------------//

METHOD Destroy()

    oCmdDestroy:aSend( ::aChilds )

return nil

//---------------------------------------------------------------------------//

METHOD DragOver()

    local nMRow := nMRow(), nMCol := nMCol()
    local nNewRow, nNewCol
    local oWnd  := ::oWnd
    local cTemp

    if !IS_NIL( oWnd )
        oWnd:BeginPaint()
        ::SetFocus( .t. )
        ::lVisible = .f.
        oWnd:Clear()
        cTemp = VGetImage( oWnd:cVPort )
        ::Flash( oWnd:cVPort )
        oWnd:EndPaint()

        SetMArea( Max( oWnd:nOrgTop, 0 ), Max( oWnd:nOrgLeft, 0 ), ;
          Min( ScrMaxRow(), oWnd:nOrgTop + RectHeight( oWnd:nClipRect ) - 1 ),;
          Min( ScrMaxCol(), oWnd:nOrgLeft + RectWidth( oWnd:nClipRect ) - 1 ) )

        while lMPressed()
            nNewRow := nMRow()
            nNewCol := nMCol()

            if nMRow != nNewRow .or. nMCol != nNewCol

                ::SetPos( ::nTop()  + nNewRow - nMRow, ;
                          ::nLeft() + nNewCol - nMCol )

                VSetImage( oWnd:cVPort, cTemp )
                ::Flash( oWnd:cVPort )
                oWnd:UpdateOwner()

            endif

            nMRow = nNewRow
            nMCol = nNewCol
            
            MUpdate()

        end
        ::lVisible := .t.
        oWnd:Clear()
        SetMArea( 0, 0, ScrMaxRow(), ScrMaxCol() )

    endif

return nil

//---------------------------------------------------------------------------//

METHOD Flash( cVPTgt )

    if ::lDesign .and. ::lFocussed
       VBox( cVPTgt, ::nTop - 1, ::nLeft - 1, ::nBottom + 1, ::nRight + 1,;
             BOXSINGLE, 14 + ( int( if( !IS_NIL( ::oWnd ), ::oWnd:nColor, ::nColor ) / 16 ) * 16 ) )
    endif

return if( IS_NIL( ::nClipRect ), SetScreen( cVPTgt, ::cVPort ),;
                                  SetScrRect( cVPTgt, ::cVPort, ::nClipRect ) )

//---------------------------------------------------------------------------//

METHOD GetNext()

    local nNext    := ::nFocussed
    local nInitial := nNext

    if ::oFocussed:lValid() .and. nNext > 0
        DO
           nNext = If( nNext >= Len( ::aChilds ), 1, nNext + 1 )
        UNTIL nInitial == nNext .or. ;
              ::aChilds[ nNext ]:lDesign .or. ;
              ::aChilds[ nNext ]:lWhen()
    endif

return nNext

//---------------------------------------------------------------------------//

METHOD GetPrevius()

    local nNext    := ::nFocussed
    local nInitial := nNext

    if ::oFocussed:lValid()
        DO
           nNext := If( nNext <= 1, Len( ::aChilds ), nNext - 1 )
        UNTIL nInitial == nNext .or. ;
              ::aChilds[ nNext ]:lDesign .or. ;
              ::aChilds[ nNext ]:lWhen()
    endif

return nNext

//---------------------------------------------------------------------------//

METHOD GoNext( nKey )

    local lKeyTrap := .f.

    DEFAULT nKey := LastKey()

    DO
        if lKeyTrap
            Inkey()
        else
            lKeyTrap = .t.
        endif
        ::ChangeFocus( ::GetNext() )

    UNTIL NextKey() != nKey

return nil

//---------------------------------------------------------------------------//

METHOD GoPrevius( nKey )

    local lKeyTrap := .f.

    DEFAULT nKey := LastKey()

    ::ChangeFocus( ::GetPrevius() )

    while NextKey() == nKey
        Inkey()
        ::ChangeFocus( ::GetPrevius() )
    end

return nil

//---------------------------------------------------------------------------//

METHOD IsHotKey( nChar )

return ::nHotKey == nChar

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    local nRetKey := 0
    local nNewOption
    local nSinAlt, oWnd

    if ::lDesign .and. !IS_NIL( ::oWnd )


        if nKey == K_LEFT  .or. ;
           nKey == K_RIGHT .or. ;
           nKey == K_DOWN  .or. ;
           nKey == K_UP

            oWnd := ::oWnd

            ::SetPos( ::nTop()  + if( nKey == K_UP, -1, ;
                                      if( nKey == K_DOWN, 1, 0 ) ),;
                      ::nLeft() + if( nKey == K_LEFT, -1, ;
                                      if( nKey == K_RIGHT, 1, 0 ) ) )

            oWnd:BeginPaint()
            oWnd:Clear()
            ::Flash( oWnd:cVPort )
            oWnd:EndPaint()
            return 0

        elseif nKey == K_CTRL_LEFT  .or. ;
               nKey == K_CTRL_RIGHT .or. ;
               nKey == K_CTRL_DOWN  .or. ;
               nKey == K_CTRL_UP

            ::ChangeSize( ::nWidth() + if( nKey == K_CTRL_LEFT, -1, ;
                                           if( nKey == K_CTRL_RIGHT, 1, 0 ) ),;
                          ::nHeight() + if( nKey == K_CTRL_UP, -1, ;
                                           if( nKey == K_CTRL_DOWN, 1, 0 ) ) )
            ::lPainted := .f.
            ::oWnd:Clear()
            return 0
        endif
    endif

    if ( nKey := ::nKeyEval( nKey ) ) == 0
        return 0
    endif

    do case
        case IS_NIL( ::oFocussed ) // NO tiene controles.
            nRetKey = if( !empty( ::nHotKey ) .and. ::IsHotKey( nKey ),;
                          0,; // Por defecto un control procesa su hotkey, aunque no haga nada...
                          nKey )

        case lAltChr( nKey, @nSinAlt )
            nNewOption := ::nHotAt( nSinAlt )
            if nNewOption > 0 .and. ::oFocussed:lValid() ;
                .and. ::aChilds[ nNewOption ]:lWhen()
                ::ChangeFocus(  nNewOption )
                nRetKey := ::oFocussed:KeyPressed( nSinAlt )
            else
                nRetKey = nKey // No procesamos la tecla
            endif

        otherwise

            nRetKey = ::oFocussed:KeyPressed( nKey )

            if nRetKey > 0  // Comportamiento XBASE

                if nRetKey == K_TAB
                    ::GoNext( K_TAB )
                    return 0
                elseif nRetKey == K_SH_TAB
                    ::GoPrevius( K_SH_TAB )
                    return 0
                elseif nRetKey == K_UP
                    ::GoPrevius( K_UP )
                    return 0
                elseif nRetKey == K_DOWN .or. nRetKey == K_RETURN
                    ::GoNext( nRetKey )
                    return 0
                endif

            endif

    endcase

return nRetKey

//---------------------------------------------------------------------------//

METHOD nKeyEval( nKey )

    if ValType( ::bKey ) == "B"
        nKey = eval( ::bKey,  nKey )
    endif

return if( ValType( nKey ) != "N", 0, nKey )

//---------------------------------------------------------------------------//

METHOD lValid()
return eval( ::bValid )

//---------------------------------------------------------------------------//

METHOD lWhen()
return eval( ::bWhen ) .or. ::lDesign

//---------------------------------------------------------------------------//

METHOD MouseMove( nMRow, nMCol )

    local n

    if ::lDesign
        if ::lIsOverResize( nMRow, nMCol )
            SetMCursor( IDC_SIZENWSE )
        else
            SetMCursor( IDC_CROSS )
        endif

        return nil
    endif

    if !empty( ::aChilds )
        nMRow -= ::nTop()  // de coordenadas padre a coordenadas de view
        nMCol -= ::nLeft()
        if ( n := ::nAtOver( nMRow, nMCol ) ) > 0
            ::aChilds[ n ]:MouseMove( nMRow, nMCol )
            return nil      // <<<<----------- OJO
        endif

    endif

    ::SetMessage( ::cMessage )
    SetMCursor( ::nMouseCursor )

return nil

//---------------------------------------------------------------------------//

METHOD nAtOver( nMRow, nMCol )

return oCmdIsOver:RaScan( ::aChilds, nMRow, nMCol )

//---------------------------------------------------------------------------//

METHOD nHotAt( nHotKey )

return AScan( ::aChilds, { | oItem | oItem:IsHotKey( nHotKey  ) } )

//---------------------------------------------------------------------------//

METHOD nGetID( nID )

   if IS_NIL( ::nID )
      ::nID = ::nGetNewId( nID )
   endif

return ::nID

//----------------------------------------------------------------------------//

METHOD nGetNewID( nID )

   static oMnuItem

   local oWin := ::oWnd, anID:= {}

   //  Es el objecto una ventana?.
   if !IS_NIL( oWin )     // Si no lo es...
      // Found the Windows of the object.
      while !IS_NIL( oWin:oWnd )
            oWin = oWin:oWnd
      end
   endif

   if IS_NIL( oMnuItem )
      oMnuItem = TMenuItem()
   endif

   if ::ChildLevel( oMnuItem ) > 0
      aGetItemId( oWin:oMenu, anID )
   else
      aGetID( oWin:oClient, anID )
   endif

   if !IS_NIL( nID )   // hay nId por defecto.
      // Si hay nId igual, anula el nId por defecto.
      aEval( anID, { | _nID | if( nID == _nID, nID := nil, ) } )
   endif

   if IS_NIL( nID )   // no hay nId por defecto ¢ fue anulado.
      nID = 0
      aEval( anID, { | _nID | nID := Max( _nID, nID ) } )
      nID += 10
   endif

return nID

//----------------------------------------------------------------------------//
// Funcion Recursiva.

function aGetId( oObj, anID )

    local i, aTmp := oObj:aChilds

    for i = 1 to Len( aTmp )
        if !Empty( aTmp[i]:aChilds )
           aGetId( aTmp[i], anID )
        endif
        if !IS_NIL( aTmp[i]:nId )
           aAdd( anID, aTmp[i]:nId )
        endif
    next

return anID

//---------------------------------------------------------------------------//

function aGetItemId( oMenu, anID )

    local i, aTmp := oMenu:aChilds

    for i = 1 to Len( aTmp )
        if !Empty( aTmp[i]:oSubMenu )
           aGetId( aTmp[i]:oSubMenu, anID )
        endif
        if !IS_NIL( aTmp[i]:nId )
           aAdd( anID, aTmp[i]:nId )
        endif
    next

return anID

//---------------------------------------------------------------------------//

METHOD Paint( cVPTgt, nClipRect )

    if ::lVisible
        if !::lPainted
            ::nPaintCount++
            ::Refresh()
            ::lPainted = .t.
            ::nPaintCount--
        endif

        return if( IS_NIL( nClipRect ), ::Flash( cVPTgt ),;
                                 SetScrRect( cVPTgt, ::cVPort, nClipRect ) )
    endif

return cVPTgt

//---------------------------------------------------------------------------//

METHOD Refresh()

    ::BeginPaint()

    if !::lPainted
       eval( ::bPaint )
    endif

    oCmdPaint:aSend( ::aChilds, ::cVPort )

    ::EndPaint()

return nil

//---------------------------------------------------------------------------//

METHOD Resize( nMinWidth, nMinHeight )

    local nMRow, nMCol
    local oWnd  := ::oWnd
    local nBoxClr
    local nOldRow, nOldCol
    local cTemp

    DEFAULT nMinWidth  := 3,;
            nMinHeight := 1

    nMinWidth  = max( 3, nMinWidth  )
    nMinHeight = max( 1, nMinHeight )

    if !IS_NIL( oWnd )

        nBoxClr = 14 + ( int( oWnd:nColor / 16 ) * 16 )
        cTemp   = VGetImage( oWnd:cVport )

        SetMArea( oWnd:nOrgTop, oWnd:nOrgLeft, ;
                  oWnd:nOrgTop  + RectHeight( oWnd:nClipRect ) - 1, ;
                  oWnd:nOrgLeft + RectWidth( oWnd:nClipRect )  - 1 )

        nOldCol = ::nWidth() - 1
        nOldRow = ::nHeight() - 1

        while lMPressed()

            nMRow = max( nMinHeight - 1, ::nMRow() )
            nMCol = max( nMinWidth - 1,  ::nMCol() )

            if nMRow != nOldRow .or. nMCol != nOldCol

                VSetImage( oWnd:cVPort, cTemp )
                oWnd:Box( ::nTop - 1, ::nLeft - 1, ;
                          ::nTop + nMRow + 1, ::nLeft + nMCol + 1,;
                          BOXSINGLE, nBoxClr )
                nOldRow = nMRow
                nOldCol = nMCol

            endif

            MUpdate()

        end

        ::ChangeSize( nOldCol + 1,  nOldRow + 1 )
        ::lPainted := .f.
        oWnd:Clear()
        SetMArea( 0, 0, ScrMaxRow(), ScrMaxCol() )

        ::Resized()

    endif

return nil

//---------------------------------------------------------------------------//

METHOD Resized( nRect )

    local n, aChilds := ::aChilds

    if IS_NIL( nRect )
        nRect = NewRect( ::nTop, ::nLeft, ::nWidth, ::nHeight )
    endif

    for n = 1 to len( aChilds )
        nRect := aChilds[ n ]:Adjust( nRect )
    next

return nRect

//---------------------------------------------------------------------------//

METHOD SetFocus( lOnOff )

    local n, oFocussed

    ::lFocussed = lOnOff

    if Empty( ::aChilds )

        if lOnOff
            ::SetMessage( ::cMessage )
        endif
        ::Refresh()

    elseif ( oFocussed := ::oFocussed ) == nil

        if ( n := ascan( ::aChilds, ;
                    { | oCtrl | oCtrl:lDesign .or. oCtrl:lWhen() } ) ) > 0
            ::oFocussed := oFocussed := ::aChilds[ n ]
            ::nFocussed = n
            oFocussed:SetFocus( .t. )
        else
            ::Refresh()
        endif
    else
        oFocussed:SetFocus( lOnOff )
    endif

return nil

//---------------------------------------------------------------------------//

METHOD SetFocusTo( nChild )

    local oChild

    if !empty( ::aChilds ) .and. nChild > 0

        oChild := ::aChilds[ nChild ]

        if ::nFocussed > 0 .and. nChild != ::nFocussed ;

            if ::oFocussed:lValid() .and. oChild:lWhen()
                ::ChangeFocus( nChild )
            endif
        else
            oChild:SetFocus( .t. )
        endif
    endif

return nil

//---------------------------------------------------------------------------//

METHOD SetMessage( cMsg )
return if( ::oWnd != nil, ::oWnd:SetMessage( cMsg ), )

//---------------------------------------------------------------------------//
METHOD UPDATE CLASS tView
    local n
    for n:=1 to len(::aChilds)
//        alert(::aChilds[n]:className()+':'+valtype(::aChilds[n]:lUpdate))
        // tBrowse no contiene llUpdate !!
        if valtype(::aChilds[n]:lUpdate)='L' .and. ::aChilds[n]:lUpdate
            ::aChilds[n]:refresh()
        end
    next
return nil
//---------------------------------------------------------------------------//

FUNCTION nGetHotKey( cText )
    local nKey := Asc( Upper( cGetHotKey( cText ) ) )

return if( nKey == 0, 999999, nKey )

//---------------------------------------------------------------------------//

// Null Class : any message is alowed...
// Clase nula : se le puede mandar cualquier mensage. Jam s Peta.
//              solo hay un problema, siempre nos retorna self, tanto en
//              datos como en mensajes.
/*
#include "Objects.ch"

CLASS TNil
    METHOD TNilError() ERROR HANDLER
ENDCLASS

//---------------------------------------------------------------------------//

METHOD TNilError
return Self
*/
//---------------------------------------------------------------------------//
