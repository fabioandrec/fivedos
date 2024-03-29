#include "FiveDos.ch"
#include "SysColor.ch"

#define _GETROW_ 1000
#define _GETCOL_ 1000

//-----------------------------------------------------------------------//

CLASS TGet FROM TControl

    DATA   nClrFocus, nGetPos AS Numeric
    DATA   cBmp, cBmpChars         AS Character
    DATA   cBmp2, cBmpChars2       AS Character
    DATA   cText1, cText2           AS CHARACTER
    DATA   bSetGet            AS Block
    DATA   oGet               AS Object
    // begin mod
    DATA   bControlKey AS OBJECT
    // la idea es un codeblock para controlar las teclas
    // si el codeblock da .t. se incorpora la tecla como si tal cosa
    // si el codeblock da .f. se actualiza el buffer,
    // pero no se admite la tecla, as� se puede manipular
    // el buffer desde fuera...
    // end Mod

    METHOD New( nRow, nCol, bSetget, cColor, cLabel, cMessage, cPicture, ;
                oWnd, bWhen, bValid, cBmp1, cBmp2, lUpdate )

    METHOD Click( nRow, nCol )

    METHOD KeyPressed( nKey )

    METHOD lValid() 

    METHOD ReDefine( cMessage, cColor, nHelpId, bSetGet, cPicture, cLabel,;
                     bWhen, bValid, cBmp1, cBmp2, lUpdate )

    METHOD Refresh()

    METHOD SetColors( cColor, n ) INLINE ;                // n = local var.
           ::nColor    := if( Empty( n := nStrColor( cColor, 1 ) ),;
                              aSysColor( CLR_GET ), n ),;
           ::nClrFocus := if( Empty( n := nStrColor( cColor, 2 ) ),;
                              aSysColor( CLR_GET_HI ), n )
    METHOD SetFocus( lOnOff )

    METHOD cText( uVal ) SETGET

ENDCLASS

//-----------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, cColor, cLabel, cMessage, cPicture, ;
            oWnd, bWhen, bValid, cBmp, cBmp2, lUpdate )

    local n, cTmp := if( IS_NIL( cPicture ), cValtoChar( eval( bSetGet ) ),;
                                        Transform( eval( bSetGet ), cPicture ) )

    ::nGetPos = if( empty( cLabel ), 0, nLabelLen( cLabel ) + 1 )
    ::oGet    = GetNew( _GETROW_, _GETCOL_, bSetGet,, cPicture )
    ::bSetGet = bSetGet
    ::lUpdate := lUpdate

    ::SetColors( cColor )

    BYNAME cBmp          DEFAULT ""
    DEFAULT cBmp2 := ::cBmp
    DEFAULT cLabel := ''
    ::cBmp2 := cBmp2

    ::cBmpChars := cBmp := If( !Empty( cBmp ) .and. File( cBmp ),;
                                ReadBitmap( cBmp ) + " " , "" )

    ::cBmpChars2 := cBmp2 := If( !Empty( cBmp2 ) .and. File( cBmp2 ),;
                                ReadBitmap( cBmp2 ) + " " , "" )

    ::cText1  := cBmp + cLabel
    ::cText2 := cBmp2 + cLabel

    ::nGetPos += len( cBmp )

    Super:New( nRow, nCol, ::nGetPos + len( cTmp ), 1, ::nColor, , oWnd,;
               cMessage, ::cText1 , bWhen, bValid )
    ::lUpdate := lUpdate

    ::oLabel:oWnd = nil
    ::oLabel:ChangeSize( ::nGetPos, 1 )
    ::oLabel:oWnd = Self
    // begin mod
    ::bControlKey := bTrue()

return Self

//---------------------------------------------------------------------------//

METHOD ReDefine( cMessage, cColor, nHelpId, bSetGet, cPicture, cLabel,;
                 bWhen, bValid, lUpdate )

    if !IS_NIL( cColor )
       ::SetColors( cColor )
    endif

*   BYNAME nHelpId                INIT NUMERIC
    BYNAME bWhen, bValid, bSetGet INIT BLOCK
    ::lUpdate := lUpdate

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

return Self

//---------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol ) CLASS TGet

    local nPos, oGet := ::oGet

    if ::lDesign
        return Super:Click( nMRow, nMCol )
    endif

    Super:Click( nMRow, nMCol )

    DO
        nPos = max( 1, min( len( oGet:Buffer ), ;
                            oGet:Pos - ( Col() - nMCol() ) ) )

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
        MUpdate()

    UNTIL !lMPressed()

return nil

//---------------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    if ::lDesign
        return Super:KeyPressed( nKey )
    endif


    // begin mod
    if eval( ::bControlKey )

        // si una tecla >255, probablemente es alt-tecla
        // o si es <0 es una combinaci�n de teclas de funcion
        // en cualquier caso, no debe ir al get ?no??

        if nKey > 0 .and. nKey < 256

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

               case nKey == K_INS
                    Set( _SET_INSERT, ! Set( _SET_INSERT ) )
                    ::SetCursor( If( Set( _SET_INSERT ), 2, 1 ) )
                    ::UpdateOwner()
                    return 0

               case nKey == K_CTRL_U
                    ::oGet:Undo()

               case nKey == K_UP    .or. ;
                    nKey == K_DOWN  .or. ;
                    nKey == K_ENTER .or. ;
                    nKey == K_ESC
                    return nKey

               case ::oGet:Type == "N" .and. ;
                    ( Chr( nKey ) == "." .or. Chr( nKey ) == "," )
                    ::oGet:ToDecPos()

               otherwise
                    if Set( _SET_INSERT )
                       ::oGet:Insert( Chr( nKey ) )
                    else
                       ::oGet:OverStrike( Chr( nKey ) )
                    endif

            endcase

            ::Refresh()

         endif
    else
        ::Refresh()
    endif

return 0

//---------------------------------------------------------------------------//

METHOD lValid()

    if ::oGet:badDate()
       ::oGet:home()
       Alert( "BadDate" )
       return .f.
    endif

    if ::oGet:Changed
       ::oGet:Assign()
    endif

    ::oGet:reset()

return Super:lValid()

//---------------------------------------------------------------------------//

METHOD Refresh()

    local cTemp, nBuffPos, nPos, oGet := ::oGet

    ::BeginPaint()

    super:refresh() // Actualiza el Label


    if ::lFocussed
        nBuffPos = oGet:Pos         // Posici�n en el buffer
        nPos     = Col() - _GETCOL_   // Posici�n en visualizaci�n

        SetPos( ::nOrgTop(), ::nOrgLeft() + ::nGetPos + nPos  )
        ::Say( 0, ::nGetPos, ;
                if( nBuffPos == nPos, ;
                    oGet:Buffer, ;
                    substr( oGet:Buffer, nBuffPos - nPos ) ),;
                ::nClrFocus )
	else
        ::Say( 0, ::nGetPos,;
                  if( IS_NIL( oGet:Picture ), cValtoChar( eval( ::bSetGet ) ),;
                                 Transform( eval( ::bSetGet ), oGet:Picture ) ),;
               ::nColor )
    endif

    ::oLabel:SetText( if( ::lFocussed , ::cText2, ::cText1 ) )
    // acutaliza el label y fuerza un ::UpdateOwner

    ::EndPaint()

return nil

//---------------------------------------------------------------------------//

METHOD SetFocus( lOnOff )

    WAppCurrent()  // Puede estar activa una ventana virtual de Clipper
                   // y estar aun pendiente el Flash() que pondr�a activa
                   // la Ventana de la Aplicaci�n
    Super:SetFocus( lOnOff )

    if lOnOff
        ::oGet:SetFocus()
        // begin mod
        // otro control puede haber modificado el valor de la variable
        ::oGet:Reset()
        // endmod
        ::SetCursor( If( Set( _SET_INSERT ), 2, 1 ) )
    else
        ::SetCursor( 0 )
        ::oGet:Assign()
        ::oGet:KillFocus()
    endif

    ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD cText( uVal )

   if Empty( PCount() )
      uVal = ::oGet:VarGet()
   else
      ::oGet:VarPut( uVal )
      if ::lFocussed
          ::oGet:reset()
      endif
      ::Clear()
   endif

return uVal

//---------------------------------------------------------------------------//

