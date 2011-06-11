#include "FiveDos.ch"
#include "Syscolor.ch"
#include "CtlAlign.ch"

external mrow, mcol // avoid link clipper 5.3 mouse module

//----------------------------------------------------------------------------//

CLASS TCtlBrowse FROM TControl, TBrowse

    DATA   hGTW                             AS Numeric
    DATA   oVScroll, oHScroll
    DATA   bLogicLen, bChanged, bDblClick   AS Block INIT bNil()

    METHOD New( nRow, nCol, nWidth, nHeight, oBrowse, cLabel, cMsg, cColors,;
                oWnd, bLogicLen, bChanged, bDblClick, bWhen, bValid, bRight,;
                lUpdate )

    METHOD  ChangeSize( nW, nH ),;
            Click( nRow, nCol ),;
            BrwHide(),;
            BrwDisplay()

    METHOD BrwCol( nCol ) INLINE WCurrent( ::hGTW ),;
                                 nCol := Col(),;
                                 WAppCurrent(),;
                                 nCol

    METHOD BrwRow( nRow )  INLINE WCurrent( ::hGTW ),;
                                  nRow := Row(),;
                                  WAppCurrent(),;
                                  nRow

    METHOD Destroy() INLINE WDestroy( ::hGTW ), ::hGTW := 0

    METHOD Up(), Down(), PageUp(), PageDown(), GoTop(), GoBottom()

    MESSAGE Left()  METHOD _Left()
    MESSAGE Right() METHOD _Right()

    METHOD GoUp()       ALIAS OF Up()
    METHOD GoDown()     ALIAS OF Down()
    METHOD GoLeft()     ALIAS OF Left()
    METHOD GoRight()    ALIAS OF Right()
    METHOD GoPgUp()     ALIAS OF PageUp()
    METHOD GoPgDown()   ALIAS OF PageDown()
    METHOD GoPgLeft()
    METHOD GoPgRight()

    METHOD  Jump( nRelJump ),;
            KeyPressed( nKey ),;
            lEditCol( nCol, uVar, cPicture, bValid, cClr ),; // uVar debe pasarse por referencia
            PanJump( nRelJump ),;
            Refresh()

    METHOD Changed() INLINE eval( ::bChanged, Self )

    METHOD Reset() INLINE ::BrwHide(),;
                          ::oVScroll:SetRange( eval( ::bLogicLen, Self ) ),;
                          ::oVScroll:nOption := 1,;
                          ::TBrowse:GoTop(),;
                          ::oVScroll:Refresh(),;
                          ::Configure(),;
                          ::RefreshAll(),;
                          ::BrwDisplay()              

    METHOD SetFocus( lOnOff ) INLINE Super:SetFocus( lOnOff ),;
                                     ::oVScroll:SetFocus( lOnOff ),;
                                     ::oHScroll:SetFocus( lOnOff )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nRow, nCol, nWidth, nHeight, oBrowse, cLabel, cMsg, cColors,;
            oWnd, bLogicLen, bChanged, bDblClick, bWhen, bValid, bRight,;
            lUpdate )

   static nClassH

   local n, nLen, nBrwWidth, oTmp, lVScroll, lHScroll,;
         nLabel:= if( Empty( cLabel ), 0, 1 )

   DEFAULT oBrowse   := TBrowse():New( nRow, nCol, ;
                                       if( IS_NIL( nHeight ), nRow+10, nHeight ),;
                                       if( IS_NIL( nWidth ), nCol+10, nWidth ) )
   DEFAULT bLogicLen := { || RecCount() },;
           nWidth    := oBrowse:nRight - oBrowse:nLeft + 3,;
           nHeight   := oBrowse:nBottom - oBrowse:nTop + 2

   BYNAME bLogicLen, bRight, bChanged, bDblClick INIT BLOCK

   ::lUpdate := lUpdate

   aCopy( oBrowse, ::Tbrowse )

   if IS_NIL( nClassH )

      nClassH = ::TBrowse:ClassHandle // _ClassHandle( oBrowse:ClassName() )

      // export ForceStable method to cl501 TBRwose
      if Empty( aScan( __ClassSel( ::Tbrowse:ClassH ), "FORCESTABL" ) )
          _GEN_METHOD_ ForceStable() CMETHOD BrwStable()
      endif

   endif

   nLen := eval( bLogicLen, Self )
   
   if nLen > nHeight
      @ nLabel, nWidth - 2 SCROLLBAR ::oVScroll VERTICAL ;
               SIZE  nHeight - nLabel ;
               RANGE nLen                       ;
               PAGESTEP nHeight - 2 - nLabel    ;
               ON UP       ::Up()               ;
               ON DOWN     ::Down()             ;
               ON PAGEUP   ::PageUp()           ;
               ON PAGEDOWN ::PageDown()         ;
               ON THUMBPOS ::Jump( nPos )

      ::oVScroll:oWnd   = Self
      lVScroll        := .t.
      
   else
      ::oVScroll := TNil()
   end

   nLen      = ::ColCount()
   nBrwWidth = len( ::ColSep ) * ( nLen + 1 )

   for n = 1 to nLen
       oTmp      := ::getColumn( n )
       nBrwWidth += max( nValLen( eval( oTmp:block ) ), len( oTmp:heading ) )
   next

   if nBrwWidth > nWidth .and. ::ColCount() > 1
      @ nHeight - 1, 0 SCROLLBAR ::oHScroll HORIZONTAL ;
               SIZE  nWidth - 2                 ;
               RANGE       ::ColCount()         ;
               PAGESTEP 1                       ;
               ON UP       ::Left()             ;
               ON DOWN     ::Right()            ;
               ON PAGEUP   ::GoPgLeft()         ;
               ON PAGEDOWN ::GoPgRight()        ;
               ON THUMBPOS ::PanJump( nPos )

      ::oHScroll:oWnd   = Self
      ::oHScroll:nAlign = ALIGN_BOTTOM
      lHScroll        := .t.
      
   else
      ::oHScroll := TNil()
      ::AutoLite := .f.
   endif

   ::TBrowse:nTop    = nLabel
   ::TBrowse:nLeft   = 0
   ::TBrowse:nBottom = nHeight - 1 - if( lHScroll == nil, 0, 1 )
   ::TBrowse:nRight  = nWidth  - 1 - if( lVScroll == nil, 0, 2 )

   Super:New( nRow, nCol, nWidth, nHeight, cColors, , oWnd, cMsg, cLabel,;
              bWhen, bValid )
   ::lUpdate := lUpdate

   ::oLabel:ChangeSize( nWidth, 1 )

   ::nPaintCount++
   ::Reset()
   ::nPaintCount--

return Self

//---------------------------------------------------------------------------//

METHOD ChangeSize( nWidth, nHeight )

    local n, nBrwWidth, oTmp, nLen, nLabel:= if( Empty( ::oLabel:cText ), 0, 1 )

    nWidth = max( 4, nWidth )
    nHeight = max( nLabel + 2, nHeight )

        ::Destroy()

    Super:ChangeSize( nWidth, nHeight )

    nLen := eval( ::bLogicLen, Self )
   
    if nLen > nHeight
        @ nLabel, nWidth - 2 SCROLLBAR ::oVScroll VERTICAL ;
               SIZE  nHeight - nLabel ;
               RANGE nLen                       ;
               PAGESTEP nHeight - 2 - nLabel    ;
               ON UP       ::Up()               ;
               ON DOWN     ::Down()             ;
               ON PAGEUP   ::PageUp()           ;
               ON PAGEDOWN ::PageDown()         ;
               ON THUMBPOS ::Jump( nPos )

        ::oVScroll:oWnd   = Self
    else
        ::oVScroll := TNil()
    endif


    
    nLen      = ::ColCount()
    nBrwWidth = len( ::ColSep ) * ( nLen + 1 )

    for n = 1 to nLen
       oTmp      := ::getColumn( n )
       nBrwWidth += max( nValLen( eval( oTmp:block ) ), len( oTmp:heading ) )
    next

    if nBrwWidth > nWidth .and. ::ColCount() > 1
        @ nHeight - 1, 0 SCROLLBAR ::oHScroll HORIZONTAL ;
               SIZE  nWidth - 2                 ;
               RANGE       ::ColCount()         ;
               PAGESTEP 1                       ;
               ON UP       ::Left()             ;
               ON DOWN     ::Right()            ;
               ON PAGEUP   ::GoPgLeft()         ;
               ON PAGEDOWN ::GoPgRight()        ;
               ON THUMBPOS ::PanJump( nPos )

        ::oHScroll:oWnd   = Self
        ::AutoLite := .t.
    else
        ::oHScroll = TNil()
        ::AutoLite := .f.
    endif
    ::BrwHide()
    ::oLabel:ChangeSize( nWidth, 1 )

    ::TBrowse:nBottom = nHeight - 1 - if( ::oHScroll:oWnd == Self, 1, 0 )
    ::TBrowse:nRight  = nWidth  - 1 - if( ::oVScroll:oWnd == Self, 2, 0 )

    ::Reset()
    ::Refresh()
    ::BrwDisplay()

return  nil

//---------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol, lDblClick )

    local nAt,;
          oBrowse  := ::Tbrowse,;
          oVScroll := ::oVScroll,;
          nHead    := If( ::HeadSep == nil, 0, 1 ) + ;
                      if( Empty( ::oLabel:cText ), 0, 1 )

    if ::lDesign .or. lMRight()
       return Super:Click( nMRow, nMCol )
    endif

    nMRow := ::nMRow()
    nMCol := ::nMCol()

    if IS_LOGICAL( nAt := oVScroll:lIsOver( nMRow, nMCol ) ) .and. nAt
       oVScroll:Click( nMRow, nMCol )

    elseif IS_LOGICAL( nAt := ::oHScroll:lIsOver( nMRow, nMCol ) ) .and. nAt
       ::oHScroll:Click( nMRow, nMCol )

    elseif lDblClick
           eval( ::bDblClick, Self )

    elseif lMRight()
           eval( ::bRight, Self )

    elseif nMRow > nHead

        while lMPressed()

            nAt = ::nMRow() - nHead

            do case
                case nAt < 1
                    if ! ::HitTop
                        ::BrwHide()
                        if ::RowPos > 1
                           while ::RowPos > 1 .and. ! ::HitTop
                                 oBrowse:Up()
                                 ::Stabilize()
                           end
                        else
                           oBrowse:Up()
                           oVScroll:nOption--
                        endif
                        oVScroll:Refresh()
                        ::BrwDisplay()
                        ::Changed()
                    endif

                case nAt > oBrowse:nBottom - nHead
                    if ! ::HitBottom
                        ::BrwHide()
                        if ::RowPos < oBrowse:nBottom - nHead
                           oVScroll:nOption += oBrowse:nBottom - nHead - ::RowPos

                           while ::RowPos < oBrowse:nBottom - nHead ;
                                     .and. ! ::HitBottom
                                 oBrowse:Down()
                                 ::Stabilize()
                           end
                        else
                           oBrowse:Down()
                           oVScroll:nOption++
                        endif
                        oVScroll:Refresh()
                        ::BrwDisplay()
                        ::Changed()
                    endif

                otherwise

                    if nAt != ::RowPos
                        ::BrwHide()
                        oVScroll:nOption += nAt - ::RowPos
                        if nAt > ::RowPos
                            while ::RowPos < nAt .and. ! ::HitBottom
                                 oBrowse:Down()
                                 ::Stabilize()
                            end
                        else
                            while ::RowPos > nAt .and. ! ::HitTop
                                 oBrowse:Up()
                                 ::Stabilize()
                            end
                        endif
                        oVScroll:Refresh()
                        ::BrwDisplay()
                        ::Changed()
                    endif

            endcase

            MUpdate()

        end

    endif

return nil

//---------------------------------------------------------------------------//

METHOD Jump( nSet )

   eval( ::SkipBlock(), nSet )

   ::RowPos =  1
   
   ::Refresh()
   ::Changed()

return nil

//---------------------------------------------------------------------------//

METHOD PanJump( nColumns )

    local oBrowse := ::Tbrowse

    if nColumns != 0
        ::BrwHide()
        if nColumns > 0
            while nColumns > 0 .and. ::ColPos < ::ColCount
                oBrowse:Right()
                ::Stabilize()
                nColumns--
            end
        else
            while nColumns < 0 .and. oBrowse:ColPos > 1
                oBrowse:Left()
                oBrowse:Stabilize()
                nColumns++
            end
        endif

        ::oHScroll:nOption = oBrowse:ColPos
        ::BrwDisplay()

    endif

return nil

//---------------------------------------------------------------------------//

METHOD Up()

    if !::HitTop
       ::BrwHide()
       ::oVScroll:nOption--
       ::TBrowse:Up()
       ::oVScroll:Refresh()
       ::oVScroll:nOldOption = -1
       ::BrwDisplay()
       ::Changed()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD Down()

    if !::HitBottom
        ::BrwHide()
        ::oVScroll:nOption++
        ::TBrowse:Down()
        ::oVScroll:Refresh()
        ::oVScroll:nOldOption = -1
        ::BrwDisplay()
        ::Changed()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD GoTop()

    if !::HitTop
        ::BrwHide()
        ::oVScroll:nOption = 1
        ::TBrowse:GoTop()
        ::oVScroll:Refresh()
        ::BrwDisplay()
        ::Changed()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD GoBottom()

    if !::HitBottom
        ::BrwHide()
        ::TBrowse:GoBottom()
        ::oVScroll:SetOption( ::oVScroll:nRange )
        ::BrwDisplay()
        ::Changed()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD PageUp()

    if !::HitTop
        ::BrwHide()
        ::oVScroll:nOption -= ::oVScroll:nPage
        ::TBrowse:PageUp()
        ::oVScroll:Refresh()
        ::oVScroll:nOldOption = -1
        ::BrwDisplay()
        ::Changed()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD PageDown()

    if !::HitBottom
        ::BrwHide()
        ::oVScroll:nOption += ::oVScroll:nPage
        ::TBrowse:PageDown()
        ::oVScroll:Refresh()
        ::oVScroll:nOldOption = -1
        ::BrwDisplay()
        ::Changed()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD _Left()

    if ::ColPos > 1
       ::BrwHide()
       ::TBrowse:Left()
       ::oHScroll:SetOption( ::ColPos )
       ::BrwDisplay()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD _Right()

    if ::ColPos < ::ColCount()
       ::BrwHide()
       ::TBrowse:Right()
       ::oHScroll:SetOption( ::ColPos )
       ::BrwDisplay()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD GoPgLeft()

    if ::LeftVisible > 1
        ::BrwHide()
        ::PanLeft()
        ::Stabilize()   // Fuerza la actualizaci¢n de oBrw:ColPos :-((
        ::oHScroll:SetOption( ::ColPos )
        ::BrwDisplay()
    elseif ::ColPos > 1
        ::BrwHide()
        ::PanHome()
        ::Stabilize()   // Fuerza la actualizaci¢n de oBrw:ColPos :-((
        ::oHScroll:SetOption( ::ColPos )
        ::BrwDisplay()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD GoPgRight()

    if ::RightVisible < ::ColCount()
        ::BrwHide()
        ::PanRight()
        ::Stabilize()   // Fuerza la actualizaci¢n de oBrw:ColPos :-((
        ::oHScroll:SetOption( ::ColPos )
        ::BrwDisplay()
    elseif ::ColPos < ::ColCount()
        ::BrwHide()
        ::PanEnd()
        ::Stabilize()   // Fuerza la actualizaci¢n de oBrw:ColPos :-((
        ::oHScroll:SetOption( ::ColPos )
        ::BrwDisplay()
    endif

return nil

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    if ::lDesign
        return Super:KeyPressed( nKey )
    endif

    do case
        case nKey == K_UP
             ::Up()

        case nKey == K_DOWN
             ::Down()

        case nKey == K_HOME
             ::BrwHide()
             ::Home()
             ::oHScroll:SetOption( ::ColPos )
             ::BrwDisplay()

        case nKey == K_END
             ::BrwHide()
             ::End()
             ::oHScroll:SetOption( ::ColPos )
             ::BrwDisplay()

        case nKey == K_ENTER
             eval( ::bDblClick, Self )

        case nKey == K_PGUP
             ::PageUp()

        case nKey == K_PGDN
             ::PageDown()

        case nKey == K_LEFT 
             ::Left()

        case nKey == K_RIGHT 
             ::Right()

        case nKey == K_CTRL_PGUP
             ::GoTop()

        case nKey == K_CTRL_PGDN
             ::GoBottom()

        case nKey == K_CTRL_LEFT
             ::GoPgLeft()

        case nKey == K_CTRL_RIGHT
             ::GoPgRight()

        otherwise

             return Super:KeyPressed( nKey )

    endcase

return 0

//----------------------------------------------------------------------------//

METHOD Refresh()

   ::BrwHide()
   ::oVScroll:SetFocus( ::lFocussed )
   ::oHScroll:SetFocus( ::lFocussed )
   ::RefreshAll()
   ::BrwDisplay()

return nil

//----------------------------------------------------------------------------//

METHOD BrwHide()

    ::BeginPaint()

    if ::hGTW == 0
        ::hGTW = VWCreate( 1000, 1000, ::nWidth(), ::nHeight() )
        WCurrent( ::hGTW )
        SET COLOR TO ( cStrBtw( ::ColorSpec, ",", 1 ) )
        CLS
    else
        WCurrent( ::hGTW )
    endif

return nil

//---------------------------------------------------------------------------//
METHOD BrwDisplay()

   local oBrowse := ::Tbrowse

   oBrowse:ForceStable()

   WToVP( ::cVPort, ::hGTW )
   Super:Refresh()  // Visualiza el Label

   ::oVScroll:UpdateOwner()  // :Refresh()

   // if !Empty( ::oHScroll )
   if ::oHScroll:oWnd == Self
      ::oHScroll:UpdateOwner() // :Refresh()
      VSwapAtt( ::cVPort, ;
                        NewRect( oBrowse:nTop + oBrowse:RowPos + 1, 0, ;
                                 ::nWidth - 2, 1 ),;
                        nStrColor( oBrowse:ColorSpec, 1 ),;
                        max( 1, nStrColor( oBrowse:ColorSpec, 3 ) ) )
   else
       VSwapAtt( ::cVPort, ;
                        NewRect( oBrowse:nTop + oBrowse:RowPos + 1, 0, ;
                                 ::nWidth - 2, 1 ),;
                        nStrColor( oBrowse:ColorSpec, 1 ),;
                        nStrColor( oBrowse:ColorSpec, 2 ) )
   endif

   

   ::EndPaint()  // el m¢dulo de puertos automaticamente selecciona la
                 // la ventana de la aplicacci¢n al hacer el ScreenFlash()

return nil


/*
METHOD BrwDisplay()

   local oBrowse := ::Tbrowse

   oBrowse:ForceStable()

   WToVP( ::cVPort, ::hGTW )
   Super:Refresh()  // Visualiza el Label

   ::oVScroll:UpdateOwner()  // ::Refresh()
   ::oHScroll:UpdateOwner()  // ::Refresh()

   VSwapAtt( ::cVPort, NewRect( oBrowse:nTop + oBrowse:RowPos + 1, 0, ;
                                ::nWidth - 2, 1 ),;
                       nStrColor( oBrowse:ColorSpec, 1 ),;
                       if( IS_CHARACTER( ::oHScroll:cVarName ),;
                           max( 1, nStrColor( oBrowse:ColorSpec, 3 ) ),;
                           nStrColor( oBrowse:ColorSpec, 2 ) ) )

   ::EndPaint()  // el m¢dulo de puertos automaticamente selecciona la
                 // la ventana de la aplicacci¢n al hacer el ScreenFlash()

return nil
*/
//---------------------------------------------------------------------------//
// uVar debe pasarse por refrencia
METHOD lEditCol( nCol, uVar, cPicture, bValid, cClr )

    local oGet, oCol
    local uTemp    := uVar
    local nFocus   := ::oWnd:nFocussed
    local nKey     := 0, lRet

    DEFAULT bValid := bTrue()

    @  ::nTop  + ::BrwRow(), ;
       ::nLeft + ::BrwCol() GET oGet VAR uTemp ;
       COLOR (cClr) OF ::oWnd:oWnd

    oGet:oGet:Picture = cPicture
    oGet:bValid       = bValid

    ::oWnd:SetFocusTo( len( ::oWnd:aChilds ) )

    while .t.
        if nKey > 0
            oGet:KeyPressed( nKey )
        endif
        MUpdate()
        nKey = nMKeyWait( 0 )


        if nKey > 0

            if ( nKey == K_ESC .or. nKey == K_ENTER ) .and. oGet:lValid()
                lRet := nKey == K_ENTER
                EXIT
            endif
        elseif lMPressed()

            if oGet:lIsOver( ::oWnd:nMRow(), ::oWnd:nMCol() )
                oGet:Click( ::nMRow(), ::nMCol() )
            else
                tock()
                while lMPressed()
                    MUpdate()
                end
            endif
        endif
    end

    ::oWnd:ChangeFocus( nFocus )

    asize( ::oWnd:aChilds, len( ::oWnd:aChilds ) - 1 )

    if lRet
        uVar = uTemp
    endif

    ::Refresh()

return lRet

//----------------------------------------------------------------------------//
