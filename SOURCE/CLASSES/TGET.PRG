#include "FiveDos.ch"
#include "SysColor.ch"
#include "SysStr.ch"

#define _GETROW_ 1000
#define _GETCOL_ 1000

external SETCURSOR  // workaraound for a Blinker Bug

//-----------------------------------------------------------------------//

CLASS TGet FROM TControl

    DATA   nClrFocus, nGetPos       AS Numeric
    DATA   cBmp, cBmpChars,;
           cBmp2, cBmpChars2        AS Character
    DATA   cText1, cText2           AS CHARACTER
    DATA   oGet                     AS Object
    DATA   lPassword                AS LOGICAL
    DATA   lEdit                    AS LOGICAL INIT .T.
    DATA   nPasswordChar            INIT Asc( "*" )


    DATA bPreKey, bPostKey AS BLOCK INIT { |x| x }
    // codeblock bPreKey de control externo para el buffer
    // recibe la tecla y el objeto
    // retorna la tecla a procesar, si retorna cero no se procesa nada
    // pero si se hace refresh()
    // as¡ se puede manipular el buffer desde fuera
    // bPostKey es como el anterior pero tras cada tecla..
    // recibe self, Buffer
    // begin mod
    // end mod
    METHOD New( nRow, nCol, bSetget, cColor, cLabel, cMessage, cPicture, ;
                oWnd, bWhen, bValid, cBmp1, cBmp2, lEdit, lPassword, lUpdate  )

    METHOD Click( nRow, nCol )

    METHOD KeyPressed( nKey )

    METHOD lValid() 

    METHOD ReDefine( cMessage, cColor, nHelpId, bSetGet, cPicture, cLabel,;
                     bWhen, bValid, cBmp1, cBmp2, lUpdate  )

    METHOD Refresh()

    METHOD SetColors( cColor, n ) INLINE ;                // n = local var.
           ::nColor    := if( Empty( n := nStrColor( cColor, 1 ) ),;
                              aSysColor( CLR_GET ), n ),;
           ::nClrFocus := if( Empty( n := nStrColor( cColor, 2 ) ),;
                              aSysColor( CLR_GET_HI ), n )
    METHOD SetFocus( lOnOff )

    METHOD SetCursorPos( nPos )
    // permite posicionar el cursor
    // Ya tenemos un m‚todo que se llama setpos, por lo que no puede
    // llamarse as¡ ( como en FiveWin )

    METHOD cText( uVal ) SETGET

ENDCLASS

//-----------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, cColor, cLabel, cMessage, cPicture, ;
            oWnd, bWhen, bValid, cBmp, cBmp2, lEdit, lPassword, lUpdate  )

    local n, cTmp := if( IS_NIL( cPicture ), ;
                         cValToChar( eval( bSetGet ), .t. ),;
                         Transform( eval( bSetGet ), cPicture ) )

    DEFAULT cLabel := ""

    ::nGetPos = if( empty( cLabel ), 0, nLabelLen( cLabel ) + 1 )

    ::oGet    = if( IS_NIL( cPicture ),;
                    GetNew( _GETROW_, _GETCOL_, bSetGet),;
                    GetNew( _GETROW_, _GETCOL_, bSetGet,, cPicture ) )

    ::SetColors( cColor )

    BYNAME cBmp         IFNONIL
    BYNAME lEdit        IFNONIL
    BYNAME lPassword    IFNONIL

    DEFAULT cBmp2   := ::cBmp
    ::cBmp2         := cBmp2

    ::cBmpChars := cBmp := If( !Empty( cBmp ) .and. File( cBmp ),;
                                ReadBitmap( cBmp ) + " " , "" )

    ::cBmpChars2 := cBmp2 := If( !Empty( cBmp2 ) .and. File( cBmp2 ),;
                                ReadBitmap( cBmp2 ) + " " , "" )

    ::cText1  := cBmp + cLabel
    ::cText2  := cBmp2 + cLabel

    ::nGetPos += len( cBmp )

    Super:New( nRow, nCol, ::nGetPos + len( cTmp ), 1, ::nColor, , oWnd,;
               cMessage, ::cText1 , bWhen, bValid )

    ::oLabel:oWnd = nil
    ::oLabel:ChangeSize( ::nGetPos, 1 )
    ::oLabel:oWnd = Self
    ::lUpdate := lUpdate

return Self

//---------------------------------------------------------------------------//

METHOD ReDefine( cMessage, cColor, nHelpId, bSetGet, cPicture, cLabel,;
                 bWhen, bValid, lUpdate  )

    if !IS_NIL( cColor )
       ::SetColors( cColor )
    endif

*   BYNAME nHelpId                INIT NUMERIC
    BYNAME bWhen, bValid INIT BLOCK

    if IS_BLOCK( bSetGet )
       ::oGet:Block = bSetGet
    endif

    if IS_CHARACTER( cPicture )
       ::oGet:Picture = cPicture
    endif

    if IS_CHARACTER( cLabel )
       ::nGetPos = nLabelLen( cLabel ) + 1
       ::oLabel:oWnd = nil
       ::oLabel:ChangeSize( ::nGetPos, 1 )
       ::oLabel:SetText( cLabel )
       ::oLabel:oWnd = Self
    endif

    if IS_CHARACTER( cMessage )
       ::oLabel:cMessage = cMessage
    endif
    ::lUpdate := lUpdate

return Self

//---------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol ) CLASS TGet

    local oGet := ::oGet, nDelay := 100

    if ::lDesign .or. lMRight()
        return Super:Click( nMRow, nMCol )
    endif

    while lMPressed()
        ::SetCursorPos(  max( 1, min( len( oGet:Buffer ), ;
                              oGet:Pos - ( Col() - nMCol() ) ) ) )
        MiliDelay( nDelay := if( nDelay > 20, nDelay - 20, 1 ) )
        MUpdate()
    end

return nil

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    local nSinAlt

    if ::lDesign
        return Super:KeyPressed( nKey )
    endif

    nKey := eval( ::bPreKey, nKey, Self )

    if nKey != 0

        do case
           case nKey == K_LEFT
                ::oGet:Left()

           case nKey == K_RIGHT
                ::oGet:Right()

           case nKey == K_HOME
                ::oGet:Home()

           case nKey == K_END
                ::oGet:End()

           case nKey == K_CTRL_LEFT
                ::oGet:WordLeft()

           case nKey == K_CTRL_RIGHT
                ::oGet:WordRight()

           case nKey == K_BS
                ::oGet:BackSpace()

           case nKey == K_DEL
                ::oGet:Delete()

           case nKey == K_CTRL_T
                ::oGet:DelWordRight()

           case nKey == K_CTRL_Y
                ::oGet:DelEnd()

           case nKey == K_CTRL_BS
                ::oGet:DelWordLeft()

           case nKey == K_INS .and. ::lEdit
                Set( _SET_INSERT, ! Set( _SET_INSERT ) )
                ::SetCursor( If( Set( _SET_INSERT ), 2, 1 ) )
                ::UpdateOwner()

           case nKey == K_CTRL_U
                ::oGet:Undo()
            // begin mod
           case nKey == K_UP    .or. ;
                nKey == K_DOWN  .or. ;
                nKey == K_ENTER .or. ;
                nKey == K_ESC   .or. ;
                nKey == K_TAB   .or. ; // K_SH_TAB es = 271 ;
                nKey < 32       .or. ; // que pasa con el espacio ?
                nKey > 256
                return Super:KeyPressed( nKey )

           case ::lEdit .and. ::oGet:Type == "N" .and. ;
                ( Chr( nKey ) == "." .or. Chr( nKey ) == "," )
                ::oGet:ToDecPos()

           case ::lEdit .and. ( nKey := Super:KeyPressed( nKey ) ) != 0 .and. ;
                !( lAltChr( LastKey(), @nSinAlt ) .and. nSinAlt == nKey )
                if Set( _SET_INSERT )
                   ::oGet:Insert( Chr( nKey ) )
                else
                   ::oGet:OverStrike( Chr( nKey ) )
                endif
       // end mod
        endcase

        ::Refresh()

        eval( ::bPostKey, Self, ::oGet:Buffer )

     endif


return 0

//---------------------------------------------------------------------------//

METHOD lValid()

    if ::oGet:badDate()
       ::oGet:home()
       Alert( aSysStr( SST_BADDATE ) )
       return .f.
    endif

    if ::oGet:Changed
       ::oGet:Assign()
    endif

    ::oGet:Reset()
    ::Refresh()

return Super:lValid()

//---------------------------------------------------------------------------//

METHOD Refresh()

    local cTemp, nTemp, nBuffPos, nPos, oGet := ::oGet

    ::BeginPaint()

    // Super:Refresh() // Actualiza el Label
    ::oLabel:SetText( if( ::lFocussed , ::cText2, ::cText1 ) )
    // actualiza el label y fuerza un ::UpdateOwner


    if ::lFocussed
        nBuffPos = oGet:Pos                    // Posici¢n en el buffer
        nPos     = Col() - _GETCOL_            // Posici¢n en visualizaci¢n


        cTemp := if( ::lPassword, ;
                        PasswordStr( oGet:Buffer, ::nPasswordChar ), ;
                        oGet:Buffer )


        if nPos >= 0
            SetPos( ::nOrgTop(), ::nOrgLeft() + ::nGetPos + nPos  )

        else // se supone que el cursor ya est  bien puesto...
             // calculamos nPos en funcion de Col()
            nPos = Col() - ( ::nOrgLeft() + ::nGetPos )
        endif

        ::Say( 0, ::nGetPos, ;
                    if( nBuffPos == nPos, ;
                        cTemp, ;
                        substr( cTemp, nBuffPos - nPos ) ),;
                    ::nClrFocus )

	else
        cTemp := if( ::lPassword, ;
                        PasswordStr( eval( oGet:Block ), ::nPasswordChar ), ;
                        eval( oGet:Block ) )

        ::Say( 0, ::nGetPos,;
               if( IS_NIL( oGet:Picture ), ;
                    cValToChar( cTemp, .t. ),;
                    Transform( cTemp, oGet:Picture ) ),;
               ::nColor )
    endif

    ::EndPaint()

return nil

//---------------------------------------------------------------------------//

METHOD SetFocus( lOnOff )

    WAppCurrent()  // Puede estar activa una ventana virtual de Clipper
                   // y estar aun pendiente el Flash() que pondr¡a activa
                   // la Ventana de la Aplicaci¢n
    ::BeginPaint()

    if lOnOff
        // begin mod
        if ::lEdit
            ::SetCursor( If( Set( _SET_INSERT ), 2, 1 ) )
            else
            ::SetCursor(0)
        end
        ::oGet:SetFocus()
        // end mod
    else
        ::SetCursor( 0 )
        ::oGet:Assign()
        ::oGet:KillFocus()
    endif
    Super:SetFocus( lOnOff )

    ::Refresh()
    ::EndPaint()

return nil

//---------------------------------------------------------------------------//

METHOD SetCursorPos( nPos )

    local oGet := ::oGet

    if oGet:Pos > nPos
        while oGet:Pos > nPos
            oGet:Left()
        end
        ::Refresh()
    elseif oGet:Pos < nPos
        while oGet:Pos < nPos
            oGet:Right()
        end
        ::Refresh()
    endif

return nil

//----------------------------------------------------------------------------//

METHOD cText( uVal )

   if Empty( PCount() )
      uVal = ::oGet:VarGet()
   else
      ::oGet:VarPut( uVal )
      if ::lFocussed
          ::oGet:Reset()
          ::oGet:Home()
      endif

      ::ChangeSize( ::nGetPos + len( if( empty( ::oGet:Picture ), ;
                         cValToChar( uVal, .t. ),;
                         Transform( uVal, ::oGet:Picture ) ) ), 1 )
      ::Clear()
   endif

return uVal

//---------------------------------------------------------------------------//

