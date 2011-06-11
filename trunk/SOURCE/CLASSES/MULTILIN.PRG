#include "FiveDos.ch"
#include "SysColor.ch"

//--------------------------------------------------------------------//

CLASS TMultilin FROM tListBox

    DATA    nPos                     AS Numeric

    DATA    cText                           AS Character


    METHOD New( nRow, nCol, nWidth, nHeight, bSetGet, cLabel;
               cMessage, cColor, oWnd, bWhen, bValid, ;
               bChanged, bSelect ) CONSTRUCTOR


    METHOD Refresh()

    METHOD Changed()  


    Method Hilite() inline (super:hilite(), ::pos())
    method delchar()
    method bschar()
    method Click( nMRow, nMCol, lDblClick  )
    method goleft()
    method goright()
    METHOD InsertChar ( nKey )
    Method KeyPressed( nKey )
    Method Pos()
    method setfocus()
    METHOD SplitLine()
    METHOD DelLine()
    METHOD AdjustLine()
ENDCLASS

//-------------------------------------------------------------------------//


METHOD New( nRow, nCol, nWidth, nHeight, bSetGet, cLabel, cMessage, cColor,;
             oWnd, bWhen, bValid, bChanged, bSelect )

     local nMax := 0, n, aSysClr := aSysColor(), nLen

    ::cText := eval( bSetGet )
    ::acItems := {}
    nLen := max(mlcount( ::cText, nWidth -2 ),1)
    for n := 1 to nLen
        aadd( ::acItems , memoline( ::cText, nWidth -2 , n ) )
    next

    Super:New( nRow, nCol, nWidth, nHeight, bSetGet, ::acItems, cLabel,;
               cMessage, cColor, oWnd, bWhen, bValid, ;
               bChanged, bSelect )

    ::nPos := 1
return Self

//--------------------------------------------------------------------//

METHOD  CHANGED()
local n, cTExt := ''

    for n:=1 to len( ::acItems )
        cText := cText + ::acItems[ n ] +CRLF
    next

    Eval( ::bSetGet, cText )
    Eval( ::bChanged )

return nil

//--------------------------------------------------------------------//
Method Click( nMRow, nMCol, lDblClick  )

    Super:Click( nMRow, nMCol, lDblClick )

    nMCol -= ::nLeft() -1 // empieza en 0

    if nMCol >0 .and. nMCol <= ::nWidth -3
        // est  dentro
        :: nPos := min( nMCol, len( ::acItems[ ::nOption ] ) )
        ::Hilite()
    end
return nil



//--------------------------------------------------------------------//

METHOD KeyPressed( nKey ) CLASS TListBox
   local nRetKey := 0

   if ::lDesign
       return Super:KeyPressed( nKey )
   endif


   do case

      case nKey == K_ENTER
            ::splitLine(::nPos, ::nOption)
            ::Godown()
            ::nPos := 1
            ::hilite()
            //::Selected()

      case nKey == K_DOWN
           ::GoDown()

      case nKey == K_UP
           ::GoUp()

      case nKey == K_END
           ::GoBottom()

      case nKey == K_PGUP
           ::GoPgUp()

      case nKey == K_PGDN
           ::GoPgDown()

      case nKey == K_DEL
           ::DelChar()
      case nKey == K_BS
           ::BsChar()
      case nKey == K_LEFT
            ::goleft()
      case nKey == K_RIGHT
            ::goright()
      case nKey == K_INS
           Set( _SET_INSERT, ! Set( _SET_INSERT ) )
           ::SetCursor( If( Set( _SET_INSERT ), 2, 1 ) )
           ::UpdateOwner()

      case nKey == K_HOME
           if ::nPos >1
               ::nPos:= 1
           else
                Super:GoTop()
           endif
           ::pos()

      case nKey == K_CTRL_Y
            ::DelLine()

      otherwise
           if nKey >31 .and. nKey<256
               ::insertchar( nKey )
             else
               nRetKey := nKey
            endif

   endcase

return nRetKey

//--------------------------------------------------------------------//
Method goleft()
     ::nPos--
     if ::nPos < 1
         if ::nOption > 1
             ::GoUp()
             ::nPos := len( trim( ::acitems[ ::nOption ] ) )+1
         else
             ::nPos := 1
         end
      end
    ::Hilite()
return nil
//--------------------------------------------------------------------//

method goright()
     ::nPos++
     //if ::nPos >= ::nWidth - 2
     if ::nPos >= len( trim( ::acitems[ ::nOption ] ) )
         if ::nOption < len( ::acItems )

             ::GoDown()
             ::nPos := 1
         else
             ::nPos --
         end
      end
     ::Hilite()
return nil
//--------------------------------------------------------------------//

METHOD  Refresh()
    Super:Refresh()
    ::Pos()
return nil

//-----------------------------------------------------------------------//

METHOD DelChar()
    local cTemp
       if ::nPos =1 .and. Len( trim( ::acItems[ ::nOption ]))= 0
            ::delLine()
          else
            ::acItems[ ::nOption ]:= stuff( ::acItems[ ::nOption ], ::nPos, 1, '')
            // para arrastrar ...
           if ::nOption< Len( ::acItems )
                cTemp :=trim(::acItems[ ::nOption ] ) + ' '+ ;
                    TRIM( ::acItems[ ::nOption + 1 ] )
                ::goDown()
                ::DelLine()
                ::GoUp()
                ::acItems[ ::nOption ]:= cTemp
                ::AdjustLine()
             else
                ::Hilite()
             end
        end
return nil

//-----------------------------------------------------------------------//

method BSCHAR()
        ::goleft()
        ::delchar()
return nil
//-----------------------------------------------------------------------//

METHOD InsertChar( nKey )
    ::acItems[ ::nOption ] := stuff( ::acItems[ ::nOption ], ::nPos ,;
              if( readinsert() , 0, 1 ), chr( nKey ) )
    ::nPos ++
    tock()
    ::AdjustLine()
return nil

//-----------------------------------------------------------------------//
METHOD AdjustLine()
    local n, nDesp
    if len( trim(::acItems[ ::nOption ] )) > ::nWidth -2
        n:= ::nWidth -2
        While n> 0
            if substr( ::acItems[ ::nOption ] ,n ,1 ) = ' '
                exit
            end
            n--
         end
        nDesp := len(rtrim( ::acItems[ ::nOption ] ) ) -n
            if n>0
                alert('llamo a Slitline con n:='+tran(n,'999'))
                ::SplitLine( n, ::nOption )
              else
                alert('llamo a Slitline con ::npos:='+tran(::nPOs,'999'))
                ::SplitLine( ::nPos, ::nOption )
            end
            if ::nPos > ::nWidth -2
                ::dehilite()
                ::GoDown()
                ::nPos := nDesp + 1
            end
         ::oScrBar:nRange := len( ::acItems )
         ::oScrBar:setoption( ::nOption )
     end
     ::Hilite()
return nil
//---------------------------------------------------------------//

Method SplitLine( nPos, nLine)
    local n, nLen, cCar, aTemp

    // ::acItems := aSize( ::acItems, len(::acItems)+1 )

    cCar := alltrim( substr( ::acItems[ nLine ], nPos, 2000 )) // lo que quede
    ::acItems[ nLine] :=  substr( ::acItems[ nLine ], 1, nPos -1)
    aTemp:=::acItems
    aadd( ::acItems,"" )
    aadd( ::aSelected, .f. )
    ains( ::acItems , nLine +1 )
    ::acItems[ nLine+1 ] := cCar
    ::oScrBar:SetRange( len( ::acItems ) )
    ::refresh()

return nil



//---------------------------------------------------------------//
Method pos()

    if ::lFocussed
        //TONE(10,.1)
        //::say(  ::nOption - ::nFirst +::nLabel, ::nPos - 1,;
        //     substr( ::acItems[ ::nOption ] , ::nPos ,1) , ::nClrNoFocus )
        ::SetCursor( If( Set( _SET_INSERT ), 2, 1 ) ) // fuerza el cursor
        SetPos( ::nOrgTop() + ::nOption - ::nFirst +::nLabel , ::nOrgLeft();
         + ::nPos - 1 )

    endif

return nil

//--------------------------------------------------------------------//
method setfocus(lOnOff)
    if lOnOff
      else
        ::SetCursor( 0 )
        setcursor(0)
    end
    super:setfocus(lOnOff)
    ::refresh()
return nil

//--------------------------------------------------------------------//

Method DelLine()
    local nLen:=len( ::acItems )
    if nLen >1
        ::acItems := aDel( ::acItems, ::nOption )
        ::acItems := aSize( ::acItems, nLen -1 )
        if ::nOption > nLen -1
            ::nOption --
        end
        ::oScrBar:nRange := nLen -1
        ::oScrBar:SetOption( ::nOption )
      else
        ::acItems:={""}
    endif
    ::Clear()
return nil
