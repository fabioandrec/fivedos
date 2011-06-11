// class spin

#include 'Fivedos.ch'
#include 'FontDef.h'
#include "Syscolor.ch"

//----------------------------------------------------------------------//

CLASS TSpin FROM TGet

    DATA  nRangeTop, nRangeBotton, nStep, nColorArrow   AS Numeric
    DATA  bAction                                       AS Block

    METHOD New( nRow, nCol, bSetGet, cColor, cLabel, cMessage, cPicture, ;
                oWnd, bWhen, bValid, cBmp, cBmp2 , nRangeTop, nRangeBottom,;
                nStep, bAction, lEdit, acColorLabel, lUpdate  ) CONSTRUCTOR

    METHOD  Up(),;
            Down(),;
            KeyPressed( nKey ),;
            Refresh(),;
            Click( nRow, nCol )
    METHOD cText( uVal )            SETGET
    METHOD SetFocus( lOnOff )       INLINE Super:SetFocus( lOnOff ),;
                                            eval( ::bAction )

ENDCLASS

//---------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, cColor, cLabel, cMessage, cPicture, ;
            oWnd, bWhen, bValid, cBmp, cBmp2 , nRangeTop, nRangeBottom,;
            nStep, bAction, lEdit, acColorLabel, lUpdate  )
    local n

    BYNAME nRangeTop    DEFAULT 10
    BYNAME nRangeBottom DEFAULT 0
    BYNAME nStep        DEFAULT 1
    BYNAME bAction      DEFAULT bNil()

    DEFAULT lEdit := .f.

    Super:New( nRow, nCol, bSetGet, cColor, cLabel, cMessage, cPicture, ;
            oWnd, bWhen, bValid, cBmp, cBmp2, lEdit, acColorLabel )

    ::ChangeSize( ::nWidth +4, 1)

    ::nColorArrow := if( Empty( n := nStrColor( cColor, 3 ) ),;
                              aSysColor( CLR_GET_HI ), n )
    ::lUpdate := lUpdate

return self

//---------------------------------------------------------------------//

METHOD Refresh()

    ::BeginPaint()

    Super:Refresh()

    ::Say( 0, ::nWidth -4, chr( MAXIMIZELEFT )+ chr( MAXIMIZERIGHT ) + ;
            chr( MINIMIZELEFT ) + chr( MINIMIZERIGHT ), ;
            ::nColorArrow )
    ::EndPaint()

return nil

//---------------------------------------------------------------------//

METHOD Up()
    ::cText = Max( ::nRangeBottom, ::oGet:VarGet() - ::nStep )
    eval( ::bAction )
return nil

//---------------------------------------------------------------------//

METHOD Down()
    ::cText = Min( ::nRangeTop, ::oGet:VarGet() + ::nStep )
    eval( ::bAction )
return nil

//--------------------------------------------------------------------//

METHOD KeyPressed( nKey )

    do case
        case nKey = K_UP
            ::UP()
            return 0
        case nKey = K_DOWN
            ::Down()
            return 0
        otherwise
            nKey := Super:KeyPressed( nKey )
    endcase

    if nKey = 0
        eval( ::bAction )
    end

return nKey

//------------------------------------------------------------------//

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
                         Transform( uVal, ::oGet:Picture ) ) ) + 4, 1 )
      ::Clear()
   endif

return uVal

//---------------------------------------------------------------------------//

METHOD Click( nMRow, nMCol )

    local nDelay   := 120

    while lMPressed()
        if nMCol >= ::nWidth - 2

            if nMCol >= ::nWidth
                ::Down()
            else
                ::Up()
            endif

            if nDelay > 20
                MiliDelay( nDelay -= 20 )
            endif

        else

            Super:Click( nMRow, nMCol)

        endif

        MUpdate()

    end
return nil

//---------------------------------------------------------------------------//
