
#include "FiveDos.ch"
#include "WndStyls.h"
#include "SysColor.ch"
#include "Error.ch"

#define FDERR_ACTIVATING  44

#define K_ALTRELEASED 9999

static lCuaSet := .f.

static cScreen, cScreenTmp

static bOldErrBlock

static aNodes     := {}
static aScrPort   := {}
static lFlashAll  := .f.
static oCurrent                      // Current Focussed window
static nDispCount := 0

static cTipsImage := ""

//---------------------------------------------------------------------------//

procedure SetCua( lOnOff )

    local nMaxRow

    if lOnOff != lCuaSet
       lCuaSet = lOnOff

       WAppCurrent()

       if lOnOff
           SetBlink( .f. )
           SetCursor( 0 )
           GetMicroRetard()

           cScreenTmp = ScreenPort()
           cScreen    = ScreenPort()
           
           FiveFont()
           SetDac( 56, 32, 32, 32 )          // Color Gris al look Windows
           InKey( 0.2 )

           SET SCOREBOARD OFF
           bOldErrBlock := ErrorBlock( { | e | ErrorDialog( e ) } )
           EightCols()
           MInit()
           MOff()
           
           MOn()
           SetMPos( ( ScrMaxRow() + 1 ) / 2, ( ScrMaxCol() + 1 ) / 2 )

       else
           ErrorBlock( bOldErrBlock )
           SetCursor( 0 )
           MOff()
           MReset()
           FntSystem()
           NineCols()
           SetBlink( .t. )
       endif

    endif

return

//---------------------------------------------------------------------------//

function GetActiveWindow()
return aTail( aNodes )

//---------------------------------------------------------------------------//
/*****
function ScrDispCount( nNewSet )
    local nOld := nDispCount
    if pCount() > 0 .and. IS_NUMBER( nNewSet )
        nDispCount = nNewSet
    endif
return nOld
******/
//---------------------------------------------------------------------------//

function lIsCua()
return lCuaSet

//---------------------------------------------------------------------------//

function SetAppCurrent()

    local oActive, nOldDispCount

    if ! IsAppCurrent()
        oActive = GetActiveWindow()
        if empty( oActive )
           WAppCurrent()
        else
           nOldDispCount = nDispCount
           oActive:ScrFlash()
           nDispCount = nOldDispCount
        endif
    endif

return nil

//---------------------------------------------------------------------------//

static function ShowTips( cVScreen )
    if ! Empty( cTipsImage )
        SetScreen( cVScreen, cTipsImage )
    endif
return nil

//---------------------------------------------------------------------------//

procedure SetTipsTo( nRow, nCol, cText, cColor )

    if !empty( cText )
        cTipsImage = ViewPortNew( nRow, nCol, ;
                                  len( cText ), 1, " ", 7 )
        VSay( cTipsImage, 0, 0, cText, nStrColor( cColor, 1 ) )
    else
        cTipsImage = ""
    endif

    if !empty( aTail( aNodes ) )
        aTail( aNodes ):ScrFlash()
    endif
return

//---------------------------------------------------------------------------//

CLASS TWindow  FROM TView

/* De aqui..... */

    DATA   nStyle, nNode, nOldWndRect, nWndIcon AS Numeric

    DATA   oClient, oMenu, oSysMenu, oBar, oVScroll, oHScroll

    DATA   nClrNormal, nClrHiBox, nClrHiTitle,;
           nClrLoBox, nClrLoTitle               AS Numeric

    DATA   cTitle                               AS Character

    DATA   lEnd, lModal, lDrag, lMinimized, ;
           lMaximized                           AS Logical

/* Hasta aqu¡, NO TOCAR, definiciones de InstVars de acceso a Bajo Nivel... */

    DATA   bMoved, bSized, bClosed              AS Block INIT bNil()
    DATA   nViewPos,;
           lPainting,;
           aShortCut,;       // los 'set key' de la ventana.
           oParent,;
           aWindows,;        // Ventanas hijas
           aViews,;          // Ventanas hijas VISIBLES, por orden de visualizaci¢n
           aPopMenus,;       // objetos PopMenus abiertos.
           aClrLabel         // Colores para los label de los controles.

    DATA   nCursor     AS Numeric
    DATA   cDftMsg     AS Character  // Mensaje por defecto.
    DATA   lMsgChanged AS Logical    // El Mensaje cambi¢


    METHOD TWError() ERROR HANDLER

    METHOD New( nTop, nLeft, nBottom, nRight, nWidth, nHeight, cTitle, cColor,;
                lNoSysMenu, lNoDrag, lNoResize, lNoIconize, lNoMaximize, ;
                lVScroll, lHScroll, oMenu, lNoShadow, oWnd, nStyle, cBrush,;
                cLabelColors ),;
           Activate( cShow, lNoWait, bWhen, bValid, bClick, bMoved, ;
                 bPaint, bSized, bScrollUp, bScrollDown, ;
                 bScrollLeft, bScrollRight, lCenter, bInit, bClosed,;
                 bKeyDown ),;
           AddControl( oCtrl ),;
           AddPopUp( oPopUp ),;
           DelPopUp(),;
           DelAllPop(),;
           Box( nTop, nLeft, nBottom, nRight, cBox, nColor ),;
           Box3D( nTop, nLeft, nBottom, nRight, nColorUpLeft, nColorRightBottom ),;
           ChangeFocus( oChildView ),;
           ChangeOrg( nRows, nCols ),;      // Cambia el origen de oClient.
           ChangePos( nRows, nCols ),;
           ChangeSize( nWidth, nHeight ),;
           Click( nRow, nCol, lDblClick ),;
           Close(),;
           Destroy()

    MESSAGE DispBegin() METHOD TWDispBegin()
    MESSAGE DispEnd()   METHOD TWDispEnd()

    METHOD AddChild( oWnd ) INLINE aadd( ::aWindows, oWnd ), oWnd:oParent := Self
    METHOD End()            INLINE ::Close()   // For FiveWin Compatibility

    METHOD Display(),;
           Hide(),;
           KeyPressed( nKey ),;
           KeyMove(),;
           KeySize(),;
           Maximize(),;
           Minimize(),;
           MouseMove( nMRow, nMCol ),;
           Move(),;
           Normal()

    METHOD lIsOverBar( nMRow, nMCol )      EXTERN TWIsOvBar( nMRow, nMCol )
    METHOD lIsOverClient( nMRow, nMCol )   EXTERN TWIsOvClie( nMRow, nMCol )
    METHOD lIsOverClose( nMRow, nMCol )    EXTERN TWIsOvClos( nMRow, nMCol )
    METHOD lIsOverMaximize( nMRow, nMCol ) EXTERN TWisOvMaxi( nMRow, nMCol )
    METHOD lIsOverMenu( nMRow, nMCol )     EXTERN TWIsOvMenu( nMRow, nMCol )
    METHOD lIsOverMinimize( nMRow, nMCol ) EXTERN TWIsOvMini( nMRow, nMCol )
    METHOD lIsOverResize( nMRow, nMCol )   EXTERN TWIsOvResi( nMRow, nMCol )
    METHOD lIsOverTitle( nMRow, nMCol )    EXTERN TWIsOvTitl( nMRow, nMCol )


    METHOD nTop()    EXTERN TWnTop()
    METHOD nLeft()   EXTERN TWnLeft()
    METHOD nWidth()  EXTERN TWnWidth()
    METHOD nHeight() EXTERN TWnHeight()
    METHOD nBottom() EXTERN TWnBottom()
    METHOD nRight()  EXTERN TWnRight()


    METHOD ClientUp()      INLINE ::ChangeOrg( -1,  0 )
    METHOD ClientDown()    INLINE ::ChangeOrg(  1,  0 )
    METHOD ClientLeft()    INLINE ::ChangeOrg(  0, -2 )
    METHOD ClientRight()   INLINE ::ChangeOrg(  0,  2 )
    METHOD ClientPgUp()    INLINE ::ChangeOrg( - ::nHeight, 0 )
    METHOD ClientPgDown()  INLINE ::ChangeOrg(   ::nHeight, 0 )
    METHOD ClientPgLeft()  INLINE ::ChangeOrg( 0, - ::nWidth )
    METHOD ClientPgRight() INLINE ::ChangeOrg( 0,   ::nWidth )
    METHOD ClientHome()    INLINE ::ChangeOrg( - ::nHeight, - ::nWidth )
    METHOD ClientEnd()     INLINE ::ChangeOrg(   ::nHeight,   ::nWidth )

    METHOD  oGetId( nId ),;
            Paint(),;
            Refresh(),;
            Resize(),;
            Run(),;
            Say( nRow, nCol, cText, cClr ),;
            ScrFlash(),;
            SetBar( oBar ),;
            SetCurrent(),;
            SetFocus( lOnOff ),;
            SetMessage( cMsg ),;
            UpdateOwner()

    METHOD SetColors( cColor, cLabelColors,  n, nBack, aSysClr ); // 3 local vars.
           INLINE ;
           aSysClr := aSysColor(),;
           ::nClrNormal := nBack := if( Empty( n := nStrColor( cColor, 1 ) ), ;
                               aSysClr[ CLR_WNDCLIENT ], n ),;
           ::nClrHiTitle := if( Empty( n := nStrColor( cColor, 2 ) ), ;
                               aSysClr[ CLR_WNDTITLE_HI ], n ),;
           ::nClrHiBox   := if( Empty( n := nStrColor( cColor, 3 ) ), ;
                               aSysClr[ CLR_WNDBORDER_HI ], n ),;
           ::nClrLoTitle := if( Empty( n := nStrColor( cColor, 4 ) ), ;
                               aSysClr[ CLR_WNDTITLE ], n ),;
           ::nClrLoBox   := if( Empty( n := nStrColor( cColor, 5 ) ), ;
                               aSysClr[ CLR_WNDBORDER ], n ),;
                   nBack := int( nBack / 16 ) * 16,;
           ::aClrLabel := { nBack + if( Empty( n := nStrColor( cLabelColors, 1 ) ), ;
                                        aSysClr[ CLR_LABEL ], n ) % 16 ,;
                            nBack + if( Empty( n := nStrColor( cLabelColors, 2 ) ), ;
                                        aSysClr[ CLR_LABEL_HI ], n ) % 16 ,;
                            nBack + if( Empty( n := nStrColor( cLabelColors, 3 ) ), ;
                                        aSysClr[ CLR_LABELHOT ], n ) % 16 ,;
                            nBack + if( Empty( n := nStrColor( cLabelColors, 4 ) ), ;
                                        aSysClr[ CLR_LABELHOT_HI ], n ) % 16 }

    METHOD  SetCursor( nCursor )  INLINE ::nCursor := nCursor

    MESSAGE SetKey( nKey, bAction ) METHOD _SetKey( nKey, bAction )


    MESSAGE SetPos( nRow, nCol ) METHOD __SetPos( nRow, nCol )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, nWidth, nHeight, cTitle, cColor,;
            lNoSysMenu, lNoDrag, lNoResize, lNoIconize, lNoMaximize, ;
            lVScroll, lHScroll, oMenu, lNoShadow, oWnd, nStyle, cBrush, cLabelColors )

    local nNewRow := 0, oClient
    local nClientWidth, nClientHeight, nSubHeight := 0

    DEFAULT nStyle := 0

    ::cTitle    = if( IS_CHARACTER( cTitle ), cTitle, "" )
    ::lEnd      = .t.
    ::aWindows  = {}
    ::aViews    = {}
    ::aPopMenus = {}
    ::aShortCut = {}

    if !IS_NIL( oWnd )
       oWnd:AddChild( Self )
    endif

    ::SetColors( cColor, cLabelColors )

    ::lDrag  = ! lNoDrag

    ::nStyle = nStyle := nOR( nStyle,;
                    if( lNoSysMenu,     0, WND_LCLOSE       ),;
                    if( lNoResize,      0, WND_LGROW        ),;
                    if( lNoIconize,     0, WND_LICONIZE     ),;
                    if( lNoMaximize,    0, WND_LZOOM        ),;
                    if( lNoShadow,      0, WND_LSHADOW      ),;
                    if( lHScroll,       WND_LHSCROLL,   0   ),;
                    if( lVScroll,       WND_LVSCROLL,   0   ) )
    if IS_NIL( nBottom ) .and. IS_NIL( nRight )

       DEFAULT nHeight := 15, nWidth := 60

       if IS_NIL( nTop ) .and. IS_NIL( nLeft )
          nTop  = Int( ( ScrMaxRow() / 2 ) - ( nHeight / 2 ) )
          nLeft = Int( ( ScrMaxCol() / 2 ) - ( nWidth / 2 ) )
       endif

       nBottom       = nTop  + nHeight - 1
       nRight        = nLeft + nWidth  - 1
       nClientWidth  = nWidth
       nClientHeight = nHeight
    else
       // Hacer un TView mas grande para oClient.
       nClientWidth  = nWidth
       nClientHeight = nHeight
       nWidth        = nRight  - nLeft + 1
       nHeight       = nBottom - nTop  + 1
       // Si no se defini¢ los 6 par metros de coordenadas.
       if IS_NIL( nClientWidth ) .or. IS_NIL( nClientHeight )
          nClientWidth  = nWidth
          nClientHeight = nHeight
       endif

    endif

    // Crea el View de Window.
    if lAnd( nStyle, WND_LGROW )
       Super:New( nTop, nLeft, ScrMaxCol() + 1, ScrMaxRow() + 1 )
    else
       Super:New( nTop, nLeft, nWidth, nHeight )
    endif

    // Crea ClipRect de Window.
    ::nClipRect = NewRect( nTop, nLeft, nWidth, nHeight )

    ::nColor   = ::nClrNormal
    ::lVisible = .f.               // TView:New() lo pone TRUE

    // oSysMenu ************************************************************
    if lAnd( nStyle, WND_LCLOSE )
       if IS_NIL( oMenu )
          oMenu = TMenuBar():New( 0, 0, 0, 0 ) // Un Menu Fantasma....
       endif
       ::oSysMenu = SysMenu( Self, oMenu:aColors )
    endif

    // oMenu   ************************************************************
    if !IS_NIL( oMenu )
       oMenu:ChangeSize( Super:nWidth(), 1 + len( oMenu:aChilds ) )

       if ::oSysMenu != nil
          ::oSysMenu:lFocussed = .t. // Enga¤o para que se pinte bien hasta
                                     // que el control de focus de ventanas entre
                                     // en juego.
          oMenu:SetSysMenu( ::oSysMenu )
       endif
       oMenu:SetWindow( Self )
       oMenu:Organize( Self, ::nWidth() - 2 )
       ::oMenu = oMenu
       aAdd( ::aChilds, oMenu )
       nNewRow    = RectHeight( oMenu:nClipRect )
       nSubHeight = RectHeight( oMenu:nClipRect )
    endif

    // oBar   ************************************************************
    if !IS_NIL( ::oBar )
       ::oBar:SetPos( nNewRow, 1 )
       nNewRow    += ::oBar:nHeight()
       nSubHeight += ::oBar:nHeight()
    endif
/*
    // oHScroll   ************************************************************
    if lHScroll
       @ nHeight - 1, 1 SCROLLBAR ::oHScroll HORIZONTAL ; // OF Self ;
            SIZE  nWidth                     ;
            RANGE nWidth                     ;
            PAGESTEP nClientWidth - nWidth   ;          
            ON UP       ::GoLeft()           ;
            ON DOWN     ::GoRight()          ;
            ON PAGEUP   ::GoPgLeft()         ;
            ON PAGEDOWN ::GoPgRight()        ;
            ON THUMBPOS Beep()
        
       aAdd( ::aChilds, ::oHScroll )
       ::oHScroll:oWnd = Self
    endif

    // oVScroll   ************************************************************
    if lVScroll
       @ nNewRow, nWidth - 3 SCROLLBAR ::oVScroll VERTICAL ; // OF Self  ;
            SIZE  nHeight ;
            RANGE nHeight ;
            PAGESTEP nClientHeight - nHeight ;
            ON UP       ::GoUp()             ;
            ON DOWN     ::GoDown()           ;
            ON PAGEUP   ::GoPgUp()           ;
            ON PAGEDOWN ::GoPgDown()         ;
            ON THUMBPOS Beep()
            
       aAdd( ::aChilds, ::oVScroll )
       ::oVScroll:oWnd = Self
    endif
*/
    // oClient    ************************************************************
    if lAnd( nStyle, WND_LGROW )
       nClientWidth  = max( ScrMaxCol() - 1, nClientWidth )
       nClientHeight = max( ScrMaxRow() - 1, nClientHeight )
    endif

    ::oClient:= oClient:= TView():New( 1, 1, nClientWidth, nClientHeight,;
                                       ::nClrNormal, cBrush )
                                       
    aAdd( ::aChilds, oClient )
    oClient:oWnd = Self
    oClient:SetPos( nNewRow, 1 )
    oClient:nClipRect = NewRect( nNewRow, 1, nWidth - 2, nHeight - 1 - nSubHeight )

    ::oFocussed = oClient

return Self

//---------------------------------------------------------------------------//

METHOD AddControl( oCtrl )
return ::oClient:AddChild( oCtrl )

//---------------------------------------------------------------------------//

METHOD AddPopUp( oPopUp )
return aadd( ::aPopMenus, oPopUp )

//---------------------------------------------------------------------------//

METHOD DelPopUp()
return aSize( ::aPopMenus, Len( ::aPopMenus ) - 1 )

//---------------------------------------------------------------------------//

METHOD Activate( cShow, lNoWait, bWhen, bValid, bClick, bMoved, ;
                 bPaint, bSized, bScrollUp, bScrollDown, ;
                 bScrollLeft, bScrollRight, lCenter, bInit, bClosed,;
                 bKey )

    static lActivating := .f.

    local n, oOldCurrent, nOldDispCount, nClipDispCount := DISPCOUNT()

    if lActivating
        // Altd()
        tone(1000,5)
        tone(200,1)
        _ClsSetError( FDERR_ACTIVATING )
        return nil
    endif

    DEFAULT lNoWait := .f., cShow := "NORMAL", lCenter := .f.

    BYNAME bWhen, bValid INIT BLOCK

    ::oClient:bPaint = if( IS_BLOCK( bPaint ), ;
                                bPaint, ;
                                bNil() )

    ::oClient:bClick = if( IS_BLOCK( bClick ), bClick, bNil() )

    ::lModal = !lNoWait

    if ! ::lWhen() .or. ! ::lEnd
       return nil
    endif

    BYNAME bMoved, bSized, bClosed, bKey INIT BLOCK

    ::lEnd   = .f.

    if lCenter
       ::SetPos( Int( ( ScrMaxRow() / 2 ) - ( ::nHeight / 2 ) ),;
                 Int( ( ScrMaxCol() / 2 ) - ( ::nWidth / 2 ) ) )
    endif

    if cShow == "ICONIZED"
       ::Minimize()
    elseif cShow == "MAXIMIZED"
       ::Maximize()
    elseif cShow == "NORMAL" .and. ( ::lMinimized .or. ::lMaximized )
       ::Normal()
    endif

    if lNoWait
        if IS_NIL( ::oParent ) .and. !empty( aNodes )
            aTail( aNodes ):AddChild( Self )
        endif

        lFlashAll = .t.
        ::Display( .f. )
        ::SetCurrent()

        if( IS_BLOCK( bInit ), Eval( bInit ), )

    else

        // OJO
        ::oParent   = nil

        lActivating = .t.

        if empty( aScrPort )
           SetCua( .t. )
           aScrPort  = {}
           aNodes    = {}
           lFlashAll = .t. // El Primer Display debe provocar flash Global()
        endif

        oOldCurrent   = oCurrent
        nOldDispCount = nDispCount
        nDispCount    = 0

        if oCurrent != nil
            oCurrent:SetFocus( .f. )
        endif

        oCurrent = nil

        ::Display( .t. )

        lActivating = .f.

        if IS_BLOCK( bInit )
            MUpdate()
            eval( bInit )
        endif

        if( Empty( ::aWindows ), ::SetCurrent(),;
                                 atail( ::aWindows ):SetCurrent() )

        for n = 1 to nClipDispCount
            DispEnd()
        next
        MUpdate()

        ::Run()

        lActivating = .t.

        
        ::Hide()

        if IS_NIL( oOldCurrent )
            ScreenFlash( aTail( aScrPort ) )
        endif

        aNodes   = aSize( aNodes, len( aNodes ) - 1 )
        aScrPort = aSize( aScrPort, len( aScrPort ) - 1 )

        lActivating = .f.

        if !IS_NIL( oOldCurrent )

            if !empty( aScrPort )

                /* Estas dos equivalen a algo como SetCurrent() con Cambio de NODO
                */
                CopyPort( cScreen, aTail( aScrPort ) )
                oOldCurrent:SetCurrent()
            endif
        else
           oCurrent = nil
        endif

        nDispCount = nOldDispCount

        if empty( aScrPort )
           SetCua( .f. )
        endif

        for n = 1 to nClipDispCount
            DispBegin()
        next

    endif

return nil

//---------------------------------------------------------------------------//

METHOD Box( nTop, nLeft, nBottom, nRight, cBox, nColor )

    DEFAULT nColor := ::nClrNormal

    ::oClient:Box( nTop, nLeft, nBottom, nRight, cBox, nColor )

return nil

//---------------------------------------------------------------------------//

METHOD Box3D( nTop, nLeft, nBottom, nRight, nClrLeft, nClrRit )

    DEFAULT nClrLeft := ::nClrHiBox, nClrRit := ::nClrNormal

    ::oClient:Box3D( nTop, nLeft, nBottom, nRight, nClrLeft, nClrRit )

return nil

//---------------------------------------------------------------------------//

METHOD ChangeFocus( oView )

    if oView != nil .and. !( ::oFocussed == oView )
        ::BeginPaint()
        if ::oFocussed != nil
            ::oFocussed:SetFocus( .f. )
        endif
        ::cMessage  = ::cDftMsg
        ::oFocussed = oView
        oView:SetFocus( .t. )
        ::EndPaint()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD ChangeOrg( nRows, nCols )

    local oClient     := ::oClient
    local nClientRect := oClient:nClipRect
    local nNewRow := min( RectTop( nClientRect ), oClient:nTop + nRows )
    local nNewCol := min( RectLeft( nClientRect ), oClient:nLeft + nCols )

    nNewRow = max( nNewRow, RectTop( nClientRect ) + RectHeight( nClientRect ) - oClient:nHeight )
    nNewCol = max( nNewCol, RectLeft( nClientRect ) + RectWidth( nClientRect ) - oClient:nWidth )

    oClient:SetPos( nNewRow, nNewCol )
    oClient:nClipRect = nClientRect
    ::Update( oClient )

return nil

//---------------------------------------------------------------------------//

METHOD ChangePos( nRows, nCols )

    local nTop  := max( 0, min( ScrMaxRow(), ::nTop() + nRows ) )
    local nLeft := max( 5 - ::nWidth(), min( ScrMaxCol(), ::nLeft() + nCols ) )

    if ::nTop() != nTop .or. ::nLeft() != nLeft
        if ::nCursor > 0
            SetPos( Row() + nRows, Col() + nCols ) // Posicionamos el cursor...
        endif

        ::SetPos( nTop, nLeft )
    endif

return nil

//---------------------------------------------------------------------------//

METHOD ChangeSize( nWidth, nHeight )
    local nClientHeight
    local nClientWidth   := max( 4, min( ::oClient:nWidth(), nWidth - 2 ) )
    local nClientTop     := 1
    local nMinHeight     := 2
    local nMinWidth      := 2
    local nVScrollWidth  := 0
        
    ::BeginPaint()

    if !IS_NIL( ::oMenu )
       ::oMenu:Organize( Self, nClientWidth )
       nClientTop := RectHeight( ::oMenu:nClipRect )
       nMinHeight += nClientTop - 1
    endif

    if !IS_NIL( ::oBar )
       ::oBar:Organize( Self, nClientWidth + 2, nClientTop )
       nClientTop += ::oBar:nHeight()
       nMinHeight += ::oBar:nHeight()
    endif

    if !IS_NIL( ::oHScroll )
       ::oHScroll:ChangeSize( nClientWidth, 1 )
       ++nMinHeight
    endif

    nHeight = max( nMinHeight, min( nMinHeight + ::oClient:nHeight, nHeight ) )
    nClientHeight = max( 0, nHeight - nMinHeight )

    if !IS_NIL( ::oVScroll )
       nVScrollWidth = 1
       ::oVScroll:ChangeSize( 2, nClientHeight )
       ++nMinWidth
    endif

    nWidth := max( 6, min( nMinWidth + ::oClient:nWidth, nWidth ) )

    ::nClipRect := NewRect( ::nTop(), ::nLeft(), nWidth, nHeight )

    ::oClient:nClipRect = NewRect( nClientTop, 1, max( 0, nWidth - nMinWidth ),;
                                   nClientHeight )

    ::oClient:SetPos( nClientTop, 1 )

    ::Refresh()

    ::EndPaint()


return nil

//---------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol, lDblClick )

    local _nMRow, _nMCol

    if !::lFocussed         // Mirar.
       ::SetCurrent()
    endif

    do case
       case ::lMinimized

           ::ChangeFocus( ::oMenu )

           if ::lIsOverClose( nMRow, nMCol )
              if lDblClick
                 ::Close()
              elseif !IS_NIL( ::oMenu )
                 ::oMenu:Click( ::nMRow(), ::nMCol(), lDblClick )
              endif
           elseif ::lIsOverMenu( nMRow, nMCol )
               ::oMenu:Click( ::nMRow(), ::nMCol(), lDblClick )
           elseif lDblClick
               ::Normal()
           else
               if !IS_NIL( ::oMenu )
                   ::oMenu:Close()
               endif
               ::Move()
           endif

       case lDblClick .and. !IS_NIL( ::oSysMenu ) .and. ::lIsOverClose( nMRow, nMCol )
            ::Close()

       case ::lIsOverMenu( _nMRow := ::nMRow(), _nMCol:= ::nMCol() )
            ::ChangeFocus( ::oMenu )
            ::oMenu:Click( _nMRow, _nMCol, lDblClick )

       otherwise

           ::oFocussed:Close()  // Cierra el Menu

           do case
               case ::lIsOverClient( _nMRow, _nMCol )
                    ::ChangeFocus( ::oClient )
                    ::oClient:Click( _nMRow, _nMCol, lDblClick )

               case ::lIsOverBar( _nMRow, _nMCol )
                    ::oBar:Click( _nMRow, _nMCol, lDblClick )

               case ::lIsOverTitle( nMRow, nMCol ) 
                    if lDblClick .and. lAnd( ::nStyle, WND_LGROW )
                       if ::lMaximized
                           ::Normal()
                       else
                           ::Maximize()
                       endif
                   elseif ! ::lMaximized .and. ::lDrag
                       ::Move()
                   endif

               case ::lIsOverMaximize( nMRow, nMCol )
                    if ::lMaximized
                        ::Normal()
                    else
                        ::Maximize()
                    endif

               case ::lIsOverMinimize( nMRow, nMCol )
                    ::Minimize()

               case ::lIsOverResize( nMRow, nMCol ) .and. ! ::lMaximized
                    ::Resize()

               case IS_NIL( ::oHScroll ) .and. nMRow == ::nBottom() .and.;
                    ! ::lMaximized .and. lAnd( ::nStyle, WND_LGROW )
                    ::Resize( IDC_SIZENS )

               case IS_NIL( ::oVScroll ) .and. nMCol == ::nRight() .and. ;
                    _nMRow > 0 .and. ! ::lMaximized .and. lAnd( ::nStyle, WND_LGROW )
                    ::Resize( IDC_SIZEWE )
           endcase
    endcase

return nil

//---------------------------------------------------------------------------//

METHOD Close()

    if ( ::lEnd := ::lValid() )
        while !empty( ::aWindows ) .and. ;
              ( ::lEnd := aTail( ::aWindows ):Close() )
        end
    endif

    if ::lEnd
       ::Hide()
       ::Destroy()
       if IS_BLOCK( ::bClosed )
          eval( ::bClosed )
       endif
       return .t.
    endif

return .f.

//---------------------------------------------------------------------------//

METHOD Destroy()

    local nAt

    if ::oParent != nil .and. ;
        ( nAt := ascan( ::oParent:aWindows, { |o| o == Self } ) ) > 0
        aDel( ::oParent:aWindows, nAt )
        aSize( ::oParent:aWindows, len( ::oParent:aWindows ) - 1 )
    endif

    Super:Destroy()

return nil

//---------------------------------------------------------------------------//

METHOD TWDispBegin()
return ++nDispCount

//---------------------------------------------------------------------------//

METHOD TWDispEnd()
return if( --nDispCount <= 0, ::ScrFlash( nDispCount := 0 ), )

//---------------------------------------------------------------------------//

METHOD DelAllPop()

    while !Empty( ::aPopMenus )
          aTail( ::aPopMenus ):oParent:Close()
    end

return nil

//---------------------------------------------------------------------------//

METHOD Display( lWait )

    static oCmdDisp

    local n, oModal

    if !::lVisible

        ::lVisible = .t.

        if lWait
            aadd( aNodes, Self )
            MOff()
            aadd( aScrPort, ScreenPort() )
            MOn()
            CopyPort( cScreen, aTail( aScrPort ) )
            ::nViewPos = 0
        else
            oModal := aTail( aNodes )
            Aadd( oModal:aViews, Self )
            ::nViewPos = len( oModal:aViews )
        endif

        ::nNode = Len( aNodes )

        if IS_NIL( oCmdDisp )
           oCmdDisp = Command():DISPLAY
        endif

        if lWait
           ::DispBegin()
           oCmdDisp:aSend( ::aWindows,  .f. )
           ::DispEnd()
        else
           ::ScrFlash()
        endif


    endif

return nil

//---------------------------------------------------------------------------//

METHOD Hide()

    local n, aView := aNodes[ ::nNode ]:aViews

    if ::lVisible
        ::DispBegin()

        ::SetFocus( .f. )

        if ::nViewPos > 0

            Adel( aView, ::nViewPos )
            aView := aNodes[ ::nNode ]:aViews := asize( aView, len( aView ) - 1 )
            for n = 1 to len( aView )
                aView[ n ]:nViewPos = n
            next

            if ( oCurrent := aTail( aView ) ) == nil // si len( aView ) == 0
                oCurrent = aNodes[ ::nNode ]
            endif

            oCurrent:SetFocus( .t. )

        else
            ::aViews = aSize( ::aViews, 0 )

        endif

        lFlashAll = .t.
        ::DispEnd()
        ::lVisible = .f.
        ::oClient:Destroy()  // Puede tener objetos GTW

    endif

return nil

//---------------------------------------------------------------------------//

METHOD KeyMove()

    local nKey      := 0
    local nNewRow   := 0
    local nNewCol   := 0
    local nOldColor := ::nClrHiBox
    local lMoved    := .f.

    if !::lDrag() .or. ::lMaximized
        return nil
    endif

    ::nClrHiBox := nOldColor % 16 + ( nOldColor % 16  ) * 16

    SetMPos( ::nTop(), ::nLeft() + 3 )
    SetMCursor( IDC_CROSS )
    ::Refresh() // Redibuja el marco con el nuevo color.

    while nKey != K_ESC .and. nKey != K_RETURN .and. ! lMPressed()

        do case
            case nKey == K_LEFT
                 nNewRow =  0
                 nNewCol =  -2
            case nKey == K_RIGHT
                 nNewRow =  0
                 nNewCol =  2
            case nKey == K_UP
                 nNewRow =  -1
                 nNewCol =  0
            case nKey == K_DOWN
                 nNewRow =  1
                 nNewCol =  0
        endcase

        if nNewRow != 0 .or. nNewCol != 0

            while lAnyKeyPressed()
                ::ChangePos( nNewRow, nNewCol )
                SetMPos( ::nTop(), ::nLeft() + 3 )
                ::ScrFlash()
            end
            nNewRow = 0
            nNewCol = 0
            lMoved  = .t.

        endif

        nKey = nMKeyWait( 0 )

    end

    ::nClrHiBox = nOldColor
    ::Refresh()
    ::MouseMove( nMRow(), nMCol() )
    if lMoved
       eval( ::bMoved )
    endif

return nil

//---------------------------------------------------------------------------//

METHOD KeySize()

    local nKey       := 0
    local nNewWidth  := 0
    local nNewHeight := 0
    local nOldColor  := ::nClrHiBox
    local lResized   := .f.

    // if !lAnd( ::nStyle, WND_LGROW ) .or. ::lMaximized .or. ::lMinimized
    if ::lMaximized .or. ::lMinimized
        return nil
    endif

    ::nClrHiBox := nOldColor % 16 + int( nOldColor % 16  ) * 16

    SetMPos( ::nBottom(), ::nRight() )
    SetMCursor( IDC_SIZENWSE )

    if ::lFocussed
        ::oFocussed:SetFocus( .f. )
    else
        ::Refresh() // Redibuja el marco con el nuevo color.
    endif

    while nKey != K_ESC .and. nKey != K_RETURN .and. ! lMPressed()

        do case
            case nKey == K_LEFT
                 nNewWidth = -1
            case nKey == K_RIGHT
                 nNewWidth =  1
            case nKey == K_UP
                 nNewHeight = - 1
            case nKey == K_DOWN
                 nNewHeight = 1
        endcase

        if !Empty( nNewWidth ) .or. !Empty( nNewHeight )

            while lAnyKeyPressed()
                ::BeginPaint()
                ::ChangeSize( ::nWidth() + nNewWidth, ::nHeight + nNewHeight )
                SetMPos( ::nBottom(), ::nRight() )
                ::EndPaint()
            end
            nNewWidth  = 0
            nNewHeight = 0
            lResized   = .t.

        endif

        nKey = nMKeyWait( 0 )

    end

    ::nClrHiBox = nOldColor

    if ::lFocussed
       ::oFocussed:SetFocus( .t. )
    else
       ::Refresh() // Redibuja el marco con el nuevo color.
    endif

    ::MouseMove( nMRow(), nMCol() )

    if lResized
       eval( ::bSized )
    endif

return nil

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    local oMenu := ::oMenu
    local lAlt  := lKeyAlt() // .and. nkey > 256

    if !::lFocussed
       ::SetCurrent()
    endif


    if ( nKey == K_ALTRELEASED .or. lAlt ) ;
       .and. oMenu != nil

        if !lAlt
            ::ChangeFocus( oMenu )
            if ::lMinimized .and. ! oMenu:lOpen
                ::oSysMenu:Open()
                 oMenu:lOpen = .t.
            endif
            nKey = 0
        else
            if nKey == K_SPACE .and. !::oMenu:lOpen  // Inkey() de Alt-Space devuelve 32
                ::ChangeFocus( oMenu )
            endif
            nKey = oMenu:KeyPressed( nKey )

            if nKey != 0
                nKey = ::oFocussed:KeyPressed( nKey )
            endif
            if nKey != 0
                nKey = ::nKeyEval( nKey )
            endif
        endif
    else
        nKey := ::oFocussed:KeyPressed( nKey )
        if nKey != K_ESC .and. nKey != 0
            ::nKeyEval( nKey )
            nKey = 0
        endif
    endif

    if nKey == K_ESC
        nKey = 0
        ::Close()
    endif

return nKey
//---------------------------------------------------------------------------//

METHOD Maximize()

   if ! ::lMaximized .and. lAnd( ::nStyle, WND_LGROW )

      ::lMaximized = .t.
      if ::lMiniMized
          ::lMinimized = .f.
          aeval( ::aWindows, { |o| if( o:lVisible, aadd( ::aViews, o ), ) } )
          aSort( ::aViews,,, { |o1,o2| o1:nViewPos < o2:nViewPos } )

      endif

      ::nOldWndRect = ::nClipRect

      ::SetPos( 0, 0 )

      ::BeginPaint()
      ::ChangeFocus( ::oClient )
      ::ChangeSize( ScrMaxCol() + 1, ScrMaxRow() + 1 )
      ::EndPaint()

      eval( ::bSized )
   endif
   ::MouseMove( nMRow(), nMCol() )

return nil

//---------------------------------------------------------------------------//

METHOD Minimize()

    static nCol := 0

    if ! ::lMinimized .and. lAnd( ::nStyle, WND_LICONIZE )

        ::lMinimized = .t.

        if ! ::lMaximized
            ::nOldWndRect = ::nClipRect
        endif
        if ::nWndIcon == 0
            ::nWndICon = NewRect( ScrMaxRow() - 2, nCol, max( 4, len( ::cTitle ) ), 3 )
            if ( nCol += 3 ) > 72
               nCol = 0
            endif
        endif

        ::nClipRect = ::nWndIcon
        ::BeginPaint()
         ::ChangePos( 1, 0 )
         ::ChangePos( -1, 0 )
         ::aViews = aSize( ::aViews, 0 )
         ::ChangeFocus( ::oMenu )
         lFlashAll = .t.
         ::Refresh()
        ::EndPaint()
        eval( ::bSized )
    endif
    ::MouseMove( nMRow(), nMCol() )

return nil

//---------------------------------------------------------------------------//

METHOD MouseMove( nMRow, nMCol )

    local lMaximized

    do case               // FPL_
        case ::lMinimized .and. ::lIsOver( nMRow, nMCol )
            if ::lIsOverClose( nMRow, nMCol ) .or. !::lDrag ;
                .or. ::lIsOverMenu( nMRow, nMCol )
                SetMCursor( IDC_ARROW )
            else
                SetMCursor( IDC_CROSS )
            endif

        case ::lIsOverMenu( ::nMRow, ::nMCol )
            ::oMenu:MouseMove( ::nMRow, ::nMCol )

        case !( lMaximized := ::lMaximized ) .and. ::lIsOverTitle( nMRow, nMCol )
            if ::lIsOverClose( nMRow, nMCol ) .or. !::lDrag
                SetMCursor( IDC_ARROW )
            else
                SetMCursor( IDC_CROSS )
                ::SetMessage( nil )
            endif

        case !lMaximized .and. ::lIsOverResize( nMRow, nMCol )
            SetMCursor( IDC_SIZENWSE )

        case nMRow == ::nBottom() .and. IS_NIL( ::oHScroll ) ;
             .and. !lMaximized .and. lAnd( ::nStyle, WND_LGROW )
            SetMCursor( IDC_SIZENS )

        case nMCol == ::nRight() .and. IS_NIL( ::oVScroll ) ;
             .and. lAnd( ::nStyle, WND_LGROW ) ;
             .and. !lMaximized .and. ::nMRow() >= RectTop( ::oClient:nClipRect )
            SetMCursor( IDC_SIZEWE )

        otherwise
            Super:MouseMove( nMRow, nMCol )
            if nMRow == ::nTop()
                ::SetMessage( nil )
            endif
    endcase

    if ::lMsgChanged .and. ::lPainted
        ::lMsgChanged = .f.
        ::Refresh()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD Move()

    local nMRow     := nMRow(), ;
          nMCol     := nMCol(), ;
          nOldColor := ::nClrHiBox, ;
          lMoved    := .f.,;
          nNewRow, nNewCol

    ::nClrHiBox = nOldColor % 16 + int( nOldColor % 16  ) * 16

    ::Refresh() // Redibuja el marco con el nuevo color.

    while lMPressed()
        nNewRow = nMRow()
        nNewCol = nMCol()

        if nMRow != nNewRow .or. nMCol != nNewCol

            ::ChangePos( nNewRow - nMRow, nNewCol - nMCol )

            ::ScrFlash()
            lMoved = .t.
        endif
        nMRow = nNewRow
        nMCol = nNewCol
        MUpdate()

    end

    ::nClrHiBox = nOldColor
    ::Refresh()

    if lMoved
       eval( ::bMoved )
    endif

return nil

//---------------------------------------------------------------------------//

static function MouseOver( oNode, nMRow, nMCol )

    static oCmdIsOver

    local n, oMouseOver

    if IS_NIL( oCmdIsOver )
       oCmdIsOver = Command():LISOVER
    endif

    if !empty( oCurrent:aPopMenus ) .and. ;
        if( oCurrent:lMinimized, ;
            oCurrent:oSysMenu:lIsOver( nMRow, nMCol ) .or. ;
                oCurrent:lIsOver( nMRow, nMCol ),;
            oCurrent:lIsOverMenu( oCurrent:nMRow(), oCurrent:nMCol() ) )
        oMouseOver = oCurrent
    else
        if ( n := oCmdIsOver:RaScan( oNode:aViews, nMRow, nMCol ) ) > 0
            oMouseOver = oNode:aViews[ n ]
        elseif oNode:lIsOver( nMRow, nMCol )
            oMouseOver = oNode
        endif
    endif

return oMouseOver

//---------------------------------------------------------------------------//

METHOD Normal()

   if ::lMaximized .or. ::lMinimized // .and. lAnd( ::nStyle, WND_LGROW )

      ::lMaximized = .f.

      if ::lMinimized
         ::nWndIcon = ::nClipRect
         ::lMinimized = .f.
         aeval( ::aWindows, { |o| if( o:lVisible, aadd( ::aViews, o ), ) } )
         aSort( ::aViews,,, { |o1,o2| o1:nViewPos < o2:nViewPos } )

      endif

      ::SetPos( RectTop( ::nOldWndRect ), RectLeft( ::nOldWndRect ) )
      ::BeginPaint()
      ::ChangeFocus( ::oClient )
      ::ChangeSize( RectWidth( ::nOldWndRect ), RectHeight( ::nOldWndRect ) )
      ::EndPaint()
      eval( ::bSized )
   endif
   ::MouseMove( nMRow(), nMCol() )

return nil

//---------------------------------------------------------------------------//

METHOD oGetId( nId )

   local nCtrl, aoCtrls 

   if IS_NUMBER( nId )
      nCtrl = aScan( aoCtrls := ::oClient:aChilds, { |o| o:nId == nId } )
      return if( !Empty( nCtrl ), aoCtrls[ nCtrl ],;
                 Alert( 'Identificador : ' + Str( nId ) + ' no encontrado.' ) )
   elseif IS_OBJECT( nId )
          return nId
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Paint( cVPTgt )

    local nClrBox, nClrTit

    if ::lVisible
        
        nClrTit = if( ::lFocussed, ::nClrHiTitle, ::nClrLoTitle )

        if ::lMinimized

            nClrBox = if( ::lFocussed, ::nClrHiBox, ::nClrLoBox )

            VMBoxDisplay( cVPTgt, ::nClipRect, nClrBox, nClrBox )
            VSay( cVPTgt, ::nBottom, ::nLeft, ::cTitle, nClrTit )

            if !IS_NIL( ::oSysMenu )
               VSay( cVPTgt, ::nTop, ::nLeft, ::oSysMenu:cItem, nClrTit )
            endif

        else
            
            Super:Paint( cVPTgt )

            VWndShadow( cVPTgt, ::nClipRect, ::cMessage, nClrTit )

            if ::nCursor > 0
                SetCursor( if( ::lFocussed .and. ::lIsOver( Row(), Col() ), ;
                           ::nCursor, 0 ) )
            endif

        endif

    endif

return nil

//---------------------------------------------------------------------------//


METHOD Run()

    local nKey , ;
          nMRow, ;
          nMCol, ;
          nOldMRow := 0, ;
          nOldMCol := 0, ;
          nMoveRow := 0, ;
          nMoveCol := 0, ;
          oMouseOver, ;
          nSeconds, ;
          nLastClick := 0

    SetMCursor( IDC_ARROW )

    while ! ::lEnd

        if ( nKey := nMKeyWait( 0 ) ) == 0

            nMRow = nMRow()
            nMCol = nMCol()

            oMouseOver = MouseOver( Self, nMRow, nMCol )

            if lMPressed()

                nSeconds = Seconds() - nLastClick

                if !IS_NIL( oMouseOver )

                    if nSeconds < 0.4 .and. ;
                        nMRow == nOldMRow .and. nMCol == nOldMCol
                        oMouseOver:Click( nMRow, nMCol, .t. )
                    else
                        nLastClick  = Seconds()
                        oMouseOver:Click( nOldMRow := nMRow, nOldMCol := nMCol, .f. )
                    endif

                else
                    Tock()
                endif

                while lMPressed() ; MUpdate() ; end

                // Un Trapping a podido sacar el cursor del area que definia un
                // tipo de cursor
                oMouseOver = MouseOver( Self, ;
                                        nMRow := nMRow(), ;
                                        nMCol := nMCol() )
            endif

            if !( nMRow == nMoveRow .and. nMCol == nMoveCol )
                nMoveRow = nMRow
                nMoveCol = nMCol
                if !IS_NIL( oMouseOver )
                    oMouseOver:MouseMove( nMRow, nMCol )
                else
                    SetMCursor( IDC_ARROW )
                endif
            endif

        else  // Procesado de teclas

            if nKey == K_F6
                ::SetCurrent()
            elseif nKey == K_ALT_F6 .and. ! Empty( ::aViews )
                ::aViews[ 1 ]:SetCurrent()
            else
                if nKey == 297   // Spanish Alt-BackSlash
                    nKey = 92    // Ascii BackSlash
                endif
                nKey = oCurrent:KeyPressed( nKey )
                if nKey > 0
                   ::KeyPressed( nKey )
                endif
            endif

        endif
    end

return nil

//---------------------------------------------------------------------------//

METHOD Resize( nSelect )
    
    local nMRow     := ::nBottom(), nMCol := ::nRight()
    local nOldColor := ::nClrHiBox
    local lResized := .f.

    ::nClrHiBox = nOldColor % 16 + int( nOldColor % 16  ) * 16

    if ::lFocussed
       ::oFocussed:SetFocus( .f. )
    endif

    ::Refresh() // Redibuja el marco con el nuevo color.

    while lMPressed()

        if IS_NIL( nSelect )
            nMRow = max( ::nTop + 1, nMRow() )
            nMCol = max( ::nLeft + 5, nMCol() )
        elseif nSelect == IDC_SIZENS
            nMRow = max( ::nTop + 1, nMRow() )
        elseif nSelect == IDC_SIZEWE
            nMCol = max( ::nLeft + 5, nMCol() )
        endif

        if nMRow != ::nBottom() .or. nMCol != ::nRight()
            ::ChangeSize( ::nWidth()  - ( ::nRight()  - nMCol ), ;
                          ::nHeight() - ( ::nBottom() - nMRow ) )
            lResized = .t.
        endif

        MUpdate()

    end

    ::nClrHiBox = nOldColor

    if ::lFocussed
       ::oFocussed:SetFocus( .t. )
    endif

    ::Refresh() // Redibuja el marco con el nuevo color.

    if lResized
       eval( ::bSized )
    endif
    

return nil

//---------------------------------------------------------------------------//

METHOD Refresh()

    local nClrBox := if( ::lFocussed, ::nClrHiBox, ::nClrLoBox )

    ::BeginPaint()

    VWndDraw( ::cVPort, ::nClipRect, nClrBox )

    Super:Refresh()

    if IS_NIL( ::oMenu )
        VMnBarDraw( ::cVPort, ::nWidth(), 1, ::nStyle, nClrBox, ;
                                if( ::lFocussed, ::nClrHiTitle, ::nClrLoTitle ), ;
                                ::cTitle, ::lMaximized )
    endif

    ::EndPaint()

return nil

//---------------------------------------------------------------------------//

METHOD Say( nRow, nCol, cText, cColor )

    ::oClient:Say( nRow, nCol, cText,;
            if( IS_CHARACTER( cColor ), nStrColor( cColor, 1 ), ;
                if( IS_NUMBER( cColor ), cColor, ::nClrNormal ) ) )
return nil

//---------------------------------------------------------------------------//

METHOD ScrFlash()

    static oCmdPaint

    local n, i, nNode, oNode, lWndTop, aView

    if ::lVisible

        oNode := aNodes[ ( nNode := ::nNode ) ]

        if nDispCount <= 0

            lWndTop = ( nNode      == len( aNodes ) ) .and.  ;
                      ( ::nViewPos == len( oNode:aViews ) )
            if IS_NIL( oCmdPaint )
                oCmdPaint = Command():PAINT
            endif

            if lWndTop .and. !lFlashAll
                CopyPort( cScreenTmp, cScreen )
                ::Paint( cScreen )
                oCmdPaint:aSend( ::aPopMenus, cScreen )
                oCmdPaint:aSend( oNode:aPopMenus, cScreen )
                ShowTips( cScreen )
                ScreenFlash( cScreen )
                CopyPort( cScreen, cScreenTmp )
            else

                lFlashAll = .f.

                CopyPort( cScreen, aScrPort[ nNode ] )

                for n = nNode to Len( aNodes )
                    oNode := aNodes[ n ]
                    aView := oNode:aViews

                    if n > nNode
                        CopyPort( aScrPort[ n ], cScreen )
                    endif

                    if n == len( aNodes )
                        if !empty( aView )
                            oNode:Paint( cScreen )
                            for i = 1 to len( aView ) - 1
                                aView[ i ]:Paint( cScreen )
                                oCmdPaint:aSend( aView[ i ]:aPopMenus, cScreen )
                            next
                            CopyPort( cScreenTmp, cScreen )
                            aTail( aView ):Paint( cScreen )
                            oCmdPaint:aSend( aTail( aView ):aPopMenus, cScreen )
                            oCmdPaint:aSend( oNode:aPopMenus, cScreen )
                            ShowTips( cScreen )
                            ScreenFlash( cScreen )
                            CopyPort( cScreen, cScreenTmp )
                        else
                            CopyPort( cScreenTmp, cScreen )
                            oNode:Paint( cScreen )
                            oCmdPaint:aSend( oNode:aPopMenus, cScreen )
                            ShowTips( cScreen )
                            ScreenFlash( cScreen )
                            CopyPort( cScreen, cScreenTmp )
                        endif
                    else
                        oNode:Paint( cScreen )
                        oCmdPaint:aSend( aView, cScreen)
                        oCmdPaint:aSend( oNode:aPopMenus, cScreen )
                    endif

                next

            endif

        endif

    endif

return nil

//---------------------------------------------------------------------------//


METHOD SetBar( oBar )

   if !IS_NIL( oBar )
      Aadd( ::aChilds, oBar )
      ::oBar := oBar

      ::nPaintCount++
      ::ChangeSize( ::nWidth(), ::nHeight() )
      ::lPainted = .f.
      ::oClient:lPainted = .f.
      ::nPaintCount--

   endif

return nil


//---------------------------------------------------------------------------//

METHOD SetCurrent()

    local oNode := aNodes[ ::nNode ]
    local n, aView := oNode:aViews

    // if oCurrent == nil .or. !( oCurrent == Self )
    if !( oCurrent == Self )

        if ::nNode == Len( aNodes ) .and. ::nViewPos > 0

            if ::nViewPos < len( aView )
                aView = Adel( aView, ::nViewPos )

                aView[ Len( aView ) ] = Self

                for n = 1 to len( aView )
                    aView[ n ]:nViewPos = n
                next
            endif

        endif

        if ! ::lFocussed
           ::DispBegin()
           lFlashAll = .t.
           if !IS_NIL( oCurrent )
              oCurrent:SetFocus( .f. )
           endif
           ::SetFocus( .t. )
           oCurrent  := Self
           ::DispEnd()
        endif

    elseif! ::lFocussed
        ::DispBegin()
        lFlashAll = .t.
        oCurrent:SetFocus( .f. )
        ::SetFocus( .t. )
        oCurrent = Self
        ::DispEnd()

    endif

return nil

//---------------------------------------------------------------------------//

METHOD SetFocus( lOnOff )

    if ::lFocussed != lOnOff
        ::BeginPaint()

        ::oFocussed:SetFocus( ::lFocussed := lOnOff )

        if !IS_NIL( ::oSysMenu )
            if !lOnOff
               ::oSysMenu:SetFocus( .t. )
            else
               ::oSysMenu:SetFocus( ::oMenu:lFocussed .and. ::oMenu:nFocussed == 1 )
            endif
        endif

        ::Refresh()
        lFlashAll = .t.
        ::EndPaint()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD _SetKey( nKey, bAction )

    local nPos := ascan( ::aShortCut, nKey )

    if PCount() > 1   // Set.. Add ¢ Delete

        if ValType( bAction ) == "B"

            if nPos != 0                        // Set
                ::aShortCut[ nPos + 1 ] = bAction
            else                                // Add
                Aadd( ::aShortCut, nKey )
                Aadd( ::aShortCut, bAction )
            endif

        elseif nPos != 0                        // Delete
            ADel( ::aShortCut, nPos )
            ADel( ::aShortCut, nPos )
            ASize( ::aShortCut, Len( ::aShortCut ) - 2 )
        endif
    elseif nPos != 0
        bAction = ::aShortCut[ nPos + 1 ]
    else
        bAction = nil
    endif
return bAction

//---------------------------------------------------------------------------//

METHOD SetMessage( cMsg )

    if ! ( ::cMessage == if( empty( cMsg ), cMsg := ::cDftMsg, cMsg ) )
       ::lMsgChanged = .t.
       ::cMessage    = cMsg
    endif

return nil

//---------------------------------------------------------------------------//

METHOD __SetPos( nNewRow, nNewCol )

    ::nClipRect = RectChange( ::nClipRect, nNewRow, nNewCol )

return Super:SetPos( nNewRow, nNewCol )

//---------------------------------------------------------------------------//


//---------------------------------------------------------------------------//

METHOD UpdateOwner()

    if ::nPaintCount <= 0
        if !IS_NIL( ::oWnd )
           ::oWnd:Update( Self )
        else
           ::ScrFlash()
        endif
    endif

return nil

//---------------------------------------------------------------------------//

function Tock()

    local i := 976

    Sound( i )
    while i > 243
        sound( ( i -= 122 ) )
    end
    SoundOff()

return nil

//---------------------------------------------------------------------------//

METHOD TWError( cMethod, nError )

    local oError := _GenError( nError, ::ClassName, cMethod )

    if nError == FDERR_ACTIVATING
        oError:severity    = ES_CATASTROPHIC
        oError:subsystem   = "FiveDos"
        oError:Description = "Recursive Activate "

        SetCua( .f. )

    endif

    _ClsSetError( oError )

return nil

//---------------------------------------------------------------------------//

