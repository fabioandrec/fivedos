#include "FiveDos.ch"
#include "SysColor.ch"
#include "CtlAlign.ch"

#define _LABELROW_ 1000
#define _LABELCOL_ 1000

//----------------------------------------------------------------------------//

CLASS TListBox FROM TControl

    DATA nFirst, nOption, nClrFocus, nClrNoFocus, nLabel AS Numeric
    // begin mod
    DATA nClrMark, nClrMarkFocus, nClrMNoFocus           AS Numeric
    // end mod
    DATA oScrBar                                         AS Object
    DATA bSelect, bSetGet, bChanged                      AS Block INIT bNil()
    // begin mod
    DATA acItems, aSelected                              AS Array
    DATA lMultiSel                                       AS Logic

    METHOD Click( nMRow, nMCol, lDblClic )
    METHOD ChangeSize( nWidth, nHeight )
    METHOD Changed()
    METHOD DeHilite()

    METHOD GoUp()
    METHOD GoDown()
    METHOD GoPgUp()
    METHOD GoPgDown()
    METHOD GoTop()
    METHOD GoBottom()
    METHOD GoTo( nPos )

    METHOD Hilite()

    METHOD KeyPressed( nKey )
    // begin mod
    METHOD aSelection()
    METHOD aSelNumbers()
    METHOD New( nRow, nCol, nWidth, nHeight, bSetGet, acItems, cLabel, cMessage,;
                cColor, oWnd, bWhen, bValid, bChanged, bSelect, bRight, lMultiSel, ;
                acColorLabel, lUpdate )
    // end mod

    METHOD ReDefine( cMessage, cColor, nHelpId, bSetGet, acItems, cLabel,;
                     bWhen, bValid, bChanged, bSelect, bRight, lUpdate )

    METHOD Refresh()
    METHOD Reset()

    // begin mod
    METHOD Selected() INLINE Eval( ::bSelect ),;
         if(::lMultiSel , ;
            ::aSelected[ ::nOption ] := !::aSelected[ ::nOption ],),;
            ::Hilite()

    // end mod

    METHOD SetColors( cColor,  n, aSysClr ) INLINE ;  // local var. == n, aSysClr.
           aSysClr := aSysColor(),;
           ::nColor        := if( Empty( n := nStrColor( cColor, 1 ) ), ;
                               aSysClr[ CLR_LISTBOX ], n ),;
           ::nClrFocus     := if( Empty( n := nStrColor( cColor, 2 ) ), ;
                               aSysClr[ CLR_LISTBOX_SEL_HI ], n ),;
           ::nClrNoFocus   := if( Empty( n := nStrColor( cColor, 3 ) ), ;
                               aSysClr[ CLR_LISTBOX_SEL ], n ) ,;
           ::nClrMark      := if( Empty( n := nStrColor( cColor, 4 ) ), ;
                               aSysClr[ CLR_LISTBOX_MARK ], n ),;
           ::nClrMarkFocus := if( Empty( n := nStrColor( cColor, 5 ) ), ;
                               aSysClr[ CLR_LISTBOX_MSEL ], n ),;
           ::nClrMNoFocus  := if( Empty( n := nStrColor( cColor, 6 ) ), ;
                               aSysClr[ CLR_LISTBOX_MNOFOCUS ], n )

    METHOD SetFocus( lOnOff )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, nWidth, nHeight, bSetGet, acItems, cLabel, cMessage,;
            cColor, oWnd, bWhen, bValid, bChanged, bSelect, bRight, lMultisel, ;
            acColorLabel, lUpdate )

    local n

    BYNAME bSetGet, bChanged, bSelect, bRight INIT BLOCK
    // begin mod
    BYNAME lMultisel INIT LOGICAL
    // End Mod

    ::acItems  = if( IS_ARRAY( acItems ),  acItems,  {""} )
    ::nLabel   = if( Empty( cLabel ), 0, 1 )
    ::nOption := n := if( IS_NUMBER( n := eval( bSetGet ) ), n, 1 )
    ::nFirst   = n
    // begin mod
    ::aSelected := afill( array(len(::acitems)), .f. )
    ::lUpdate := lUpdate

    if IS_NIL( nWidth )
       nWidth = 0
       aEval( acItems, { |e| nWidth := max( nWidth, len( e ) ) } )
       nWidth = max( nWidth += 2, nLabelLen( cLabel ) )
    endif

    DEFAULT nHeight := len( ::acItems )

    ::SetColors( cColor )

    Super:New( nRow, nCol, nWidth, nHeight, ::nColor, "",;
               oWnd, cMessage, cLabel, bWhen, bValid, acColorLabel )

    @ ::nLabel, nWidth - 2 SCROLLBAR ::oScrBar VERTICAL ;
                RANGE       len( acItems )          ;
                SIZE        nHeight - ::nLabel      ;
                PAGESTEP    nHeight - ::nLabel      ;
                ON UP       ::GoUp()                ;
                ON DOWN     ::GoDown()              ;
                ON PAGEUP   ::GoPgUp()              ;
                ON PAGEDOWN ::GoPgDown()            ;
                ON THUMBPOS ::Goto( nPos + ::nOption )

    ::oScrBar:oWnd    = Self
    ::oScrBar:nOption = n
    ::oScrBar:nAlign = ALIGN_RIGHT


    if ::nLabel = 1
       ::oLabel:ChangeSize( ::nWidth(), 1 )
       ::oLabel:SetPos( 0, 0 )
    else
       ::oLabel:SetPos( _LABELROW_, _LABELCOL_ ) // al limbo ....
    endif

    ::Clear()

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( cMessage, cColor, nHelpId, bSetGet, acItems, cLabel,;
                 bWhen, bValid, bChanged, bSelect, bRight, lUpdate )

    local n

    BYNAME acItems  INIT ARRAY
    BYNAME bSetGet, bChanged, bSelect, bWhen, bValid, bRight INIT BLOCK

    ::nOption := n := if( IS_NUMBER( n := eval( bSetGet ) ), n, 1 )
    ::nFirst   = n
    ::lUpdate := lUpdate

    ::oScrBar:SetOption( n )
    ::oScrBar:SetRange( len( ::acItems ) )

    if !IS_NIL( cColor )
       ::SetColors( cColor )
    endif

    if IS_CHARACTER( cLabel ) .and. !Empty( cLabel )
       ::nLabel = 1
       ::oLabel:SetText( cLabel )
       ::oLabel:ChangeSize( ::nWidth(), 1 )
       ::oLabel:setpos( 0, 0 )
    else
       ::nLabel = 0
    endif

    if IS_CHARACTER( cMessage )
       ::oLabel:cMessage = cMessage
    endif

    ::Clear()
    ::lUpdate := lUpdate

return Self

//----------------------------------------------------------------------------//

METHOD Changed()

   Eval( ::bSetGet, ::nOption )
   Eval( ::bChanged )

return nil

//----------------------------------------------------------------------------//

METHOD ChangeSize( nWidth, nHeight )

    ::BeginPaint()
    Super:ChangeSize( nWidth, nHeight )

    if !Empty( ::nLabel )
       ::oLabel:ChangeSize( nWidth, 1 )
    endif

    // ::oScrBar:SetPos( ::nLabel, nWidth - 2 )
    // ::oScrBar:Resized( NewRect( ::nTop, ::nLeft, nWidth, nHeight ) )
    ::oScrBar:Adjust( NewRect( ::nLabel, 0, nWidth, nHeight - ::nLabel ) )
    ::Clear()

    ::EndPaint()

return nil

//----------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol, lDblClick  )
    // begin mod
    // Para la selecci¢n on the fly
    local nMOldRow
    // end mod

    if ::lDesign .or. lMRight()
        return Super:Click( nMRow, nMCol )
    endif

    nMCol -= ::nLeft()
    nMRow -= ::nTop()

    do case
        case ::nLabel > 0 .and. nMRow <= 0
            return nil                       // <------------------
        case  nMCol >= ::nWidth() - 2
            ::oScrBar:Click( nMRow, nMCol, lDblClick )
            return nil
        case lDblClick
            ::Selected()
            return nil                      // <------------------
        otherwise

            nMRow -= ::nLabel
            nMOldRow := nMRow
            DO
                do case

                    case nMRow < 0
                        // begin mod
                        if ::lMultisel
                          ::aSelected[ ::nOption ] := !::aSelected[ ::nOption ]
                        end
                        // end mod
                        ::GoUp()

                    case nMRow >= ::nHeight() - ::nLabel
                        // begin mod
                        if ::lMultisel
                            ::aSelected[ ::nOption ] := !::aSelected[ ::nOption ]
                        end
                        // end mod
                         ::GoDown()

                    otherwise
                        if ::nOption != ::nFirst + nMRow
                            ::BeginPaint()
                            ::Dehilite()
                            ::nOption := min( ::nFirst + nMRow, len( ::acItems ) )
                            // begin mod
                            if nMOldRow != nMRow .and. ::lMUltisel
                                ::aSelected[ ::nOption ] := !::aSelected[ ::nOption ]
                                if nMOldRow > 0
                                   ::aSelected[ nMOldRow ] := !::aSelected[ nMOldRow ]
                                    nMOldRow := 0
                                end
                            end

                            // end mod
                            ::Hilite()
                            ::oScrBar:SetOption( ::nOption )
                            ::EndPaint()
                            ::Changed()
                        endif
                endcase

                mUpdate()

                nMRow = ::nMRow() - ::nLabel

            UNTIL ! lMPressed()

    endcase

return nil

//----------------------------------------------------------------------------//

METHOD DeHilite()

    local n := ::nOption

    ::Say( n - ::nFirst + ::nLabel, 0, pad( cAll2Char( ::acItems[ n ] ), ::nWidth - 2 ),;
           if( ::aSelected[ n ], ::nClrMark,::nColor ) )

return nil

//----------------------------------------------------------------------------//

METHOD Hilite()

    local n := ::nOption

    ::Say( n - ::nFirst + ::nLabel, 0, pad( cAll2Char( ::acItems[ n ] ), ::nWidth - 2 ),;
         if( ::lFocussed, if( ::aSelected[ n ], ::nClrMarkFocus, ::nClrFocus),;
                    if( ::aSelected[ n ], ::nClrMNoFocus, ::nClrNoFocus ) ) )

return nil

//----------------------------------------------------------------------------//

METHOD aSelection()
    Local aRet := {}, nIndex, cTemp
    if ::lMultisel
        for nIndex:= 1 to len( ::acItems )
            if ::aSelected[ nIndex ]
                cTemp := cAll2Char( ::acItems[ nIndex ] ) // no reference, new element
                aadd( aRet, cTemp )
             end
         next
     end
return aRet

//----------------------------------------------------------------------------//
METHOD aSelNumbers()
    Local aRet := {}, nIndex
    if ::lMultisel
        for nIndex:= 1 to len( ::acItems )
            if ::aSelected[ nIndex ]
                aadd( aRet, nIndex )
             end
         next
     end
return aRet

//----------------------------------------------------------------------------//

METHOD Refresh()

    // begin mod
    local n
    local l       := ::nLabel
    local i       := ::nFirst
    local acItems := ::acItems, aSelected := ::aSelected
    local nWidth  := ::nWidth - 2
    local nColor  := ::nColor, nColorMark := ::nClrMark
    local nLen    := max( 0, min( Len( acItems ), i + ::nHeight - 1 - ::nLabel ) )

    ::BeginPaint()

    for n = i to nLen
        ::Say( l++, 0, pad( cAll2Char( acItems[ n ] ), nWidth ),;
            if( aSelected[ n ],nColorMark, nColor ) )
    next
    // endmod
    ::Hilite()

    Super:Refresh()
    ::oScrBar:Refresh()

    ::EndPaint()

return nil

//----------------------------------------------------------------------------//

METHOD GoUp()

   local nOption := ::nOption

   if nOption > 1

      ::BeginPaint()

      if --nOption < ::nFirst
         ::nFirst  = nOption
         ::nOption = nOption
         ::Refresh()
      else
         ::DeHilite()
         ::nOption = nOption
         ::Hilite()
      endif

      ::oScrBar:SetOption( nOption )

      ::EndPaint()

      ::Changed()

   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoDown()

   local nOption := ::nOption

   if nOption < len( ::acItems )

      ::BeginPaint()

      if ++nOption - ::nFirst > ::nHeight - 1 - ::nLabel  // nMax
         ::nFirst++
         ::nOption = nOption
         ::Refresh()
      else
         ::DeHilite()
         ::nOption = nOption
         ::Hilite()
      endif

       ::oScrBar:SetOption( nOption )

       ::EndPaint()

       ::Changed()

   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoTop()

    ::nFirst  = 1
    ::nOption = 1
    ::Refresh()
    ::oScrBar:SetOption( 1 )
    ::Changed()

return nil

//----------------------------------------------------------------------------//

METHOD GoBottom()

    local nOption := Len( ::acItems )
    local nMax

    if nOption > ( nMax := ( ::nHeight - 1 - ::nLabel ) )
       ::nFirst  = nOption - nMax
       ::nOption = nOption
       ::Refresh()
    else
       ::DeHilite()
       ::nOption = nOption
       ::Hilite()
    endif

    ::oScrBar:SetOption( nOption )
    ::Changed()

return nil

//----------------------------------------------------------------------------//

METHOD GoTo( nPos )

    local nLen := Len( ::acItems )
    local nMax := ::nHeight - 1 - ::nLabel

    nPos      = max( 1, min( nLen, nPos ) )
    ::nFirst  = if( nPos + nMax > nLen, max( 1, nLen - nMax ), nPos )
    ::nOption = nPos
    ::Refresh()
    ::oScrBar:SetOption( nPos )
    ::Changed()

return nil

//----------------------------------------------------------------------------//

METHOD GoPgDown()

   local nOption := ::nOption
   local nLen    := len( ::acItems )
   local nHeight, nLabel, nMax

   if nOption < nLen
      nMax = ( nHeight := ::nHeight ) - ( nLabel := ::nLabel )
      ::nOption := nOption := max( 1, min( nOption + nMax, nLen ) )
      ::nFirst = max( 1, min( ::nFirst + nMax, nLen - nHeight + nLabel + 1 ) )
      ::Refresh()
      ::oScrBar:SetOption( nOption )
      ::Changed()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoPgUp()

   local nOption := ::nOption
   local nMax    := ::nHeight - ::nLabel

   if nOption > 1
      ::nOption := nOption := max( 1, min( len( ::acItems ), nOption - nMax ) )
      ::nFirst  = max( 1, ::nFirst - nMax )
      ::Refresh()
      ::oScrBar:SetOption( nOption )
      ::Changed()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Reset()
    local nSelLen
    ::nOption = 1
    ::nFirst  = 1
    ::oScrBar:nOption = 1
    ::oScrBar:SetRange( len( ::acItems ) )
    if len( ::acItems ) != ( nSelLen := Len( ::aSelected ) )
        asize( ::aSelected, len( ::acItems ) )
        if len( ::acItems ) >  nSelLen
            afill( ::aSelected, .f., nSelLen )
        endif
    endif
    ::Clear()  // Provoca un ::Refresh()
    ::Changed()

return nil

//----------------------------------------------------------------------------//

METHOD SetFocus( lOnOff )

    ::BeginPaint()
    Super:SetFocus( ::lFocussed := lOnOff )
    ::oScrBar:SetFocus( lOnOff )
    ::Hilite()
    ::EndPaint()

return nil

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

   local nFound, nPos


   if ::lDesign
       return Super:KeyPressed( nKey )
   endif

   do case

      case nKey == K_ENTER
            ::Selected()

      case nKey == K_DOWN
           ::GoDown()

      case nKey == K_UP
           ::GoUp()

      case nKey == K_HOME
           ::GoTop()

      case nKey == K_END
           ::GoBottom()

      case nKey == K_PGUP
           ::GoPgUp()

      case nKey == K_PGDN
           ::GoPgDown()

      case nKey > 32 .and. nKey< 256
           nFound = 0
           nPos   = ::nOption
           while ++nPos <= Len( ::acItems )
               if Asc( Upper( Left( cAll2Char( ::acItems[ nPos ] ), 1 ) ) ) == nUpperKey( nKey )
                    nFound = nPos
                    EXIT
               endif
           end
           if nFound != 0
               ::GoTo( nPos )
           else
               return Super:Keypressed( nKey )
           endif

      otherwise

           return Super:Keypressed( nKey )

   endcase

return 0

//---------------------------------------------------------------------------//
// function cAll2char
// proposito:
// completar la funcion cValtoChar con el tratamiento de
// codeblocks , por lo que puede ser recursiva ...
// y hacer maravillas en un listbox
//
// No se debe bajar este concepto a cValtoChar()
//

static function cAll2Char( uVal )
return if( IS_BLOCK( uVal ), cAll2Char( eval( uVal ) ), cValToChar( uVal ) )

//---------------------------------------------------------------------------//
