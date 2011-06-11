#include <ClipApi.h>
#include <dos.h>


extern LPBYTE BaseSegment( void );  // en dpmi.c

void MouseUpdate( void );
BOOL bMousePressed( void );
BYTE bMouseRow( void );
BYTE bMouseCol( void );

#define K_ALTRELEASED 9999
#define K_ALTPRESSED  9998

void _Inkey0( void );

CLIPPER SetKey( void );

LONG lnTicks( void );

typedef void ( * PTIMEREVENT )( LONG );

static LONG near lnInkey( void );

static PCLIPSYMBOL SetKeySym = 0;

static BOOL bIdle = FALSE;

PTIMEREVENT _TimerCallBack = 0;

//---------------------------------------------------------------------------//

BOOL bKeyAlt( void )
{
   return(  BaseSegment()[ 0x0417 ] & 8 );
}

//---------------------------------------------------------------------------//
// Creemeos que Funciona SOLO Con Gate A20 enabled.
BOOL bAnyKeyPressed( void )
{
    WORD wKeyData = (WORD) inport( 0x60 );

    return ( wKeyData > 0 && !( wKeyData & 0x0080 ) );
}

//---------------------------------------------------------------------------//

static void near Link()
{
    SetKey();
}

//---------------------------------------------------------------------------//

LONG lnTicks()
{
   /* catpurar contador de ticts. ( BYTE bajo DX, alto en CX)
   */
   asm {
        mov ah, 00h
        int 1Ah
        mov ax, dx
        mov dx, cx
       }

   return (LONG) MK_FP( _DX, _AX );

}

//---------------------------------------------------------------------------//

/********
*
*   Lo equivalente a Inkey().   (  sin parametros ).
*/
static LONG near lnInkey()
{
   _Inkey0();
   return (LONG) ( _tos-- )->pPointer1;
}

//---------------------------------------------------------------------------//

CLIPPER SysRefresh( void )
{
    if( _TimerCallBack )
        ( _TimerCallBack )( lnTicks() );
}

//---------------------------------------------------------------------------//

CLIPPER nMKeyWait() // ( nWaitSeconds, bAction )
{
   static BOOL bAltPressed  = FALSE;
   static BOOL bAltKeyPress = FALSE;

   LONG   lStart    = lnTicks();
   LONG   lKeyCode  = 0;
   LONG   lTicks    = (LONG) ( ( _parni( 1 ) * 182 ) / 10 );
   PCLIPVAR bAction = _param( 2, BLOCK );
   BYTE   bMRow, bMCol;

   bMRow = bMouseRow();
   bMCol = bMouseCol();
   MouseUpdate();
   
   lKeyCode = lnInkey();

   bIdle = TRUE;

   while( lKeyCode == 0 && !bMousePressed() && bIdle &&
          _pcount && ( lTicks == 0 || ( lnTicks() - lStart ) < lTicks ) )
   {
      if( !bAltPressed )
          bAltPressed = bKeyAlt();

      lKeyCode = lnInkey();

      if( bAltPressed )
      {
          if( bKeyAlt() )
          {
              if( lKeyCode != 0 )
                  bAltKeyPress = TRUE;
          }
          else
          {
              if( ! bAltKeyPress )
                  lKeyCode = K_ALTRELEASED;

              bAltPressed  = FALSE;
              bAltKeyPress = FALSE;
          }
      }

      MouseUpdate();

      if( !( bIdle = ( bMRow == bMouseRow() && bMCol == bMouseCol() ) ) )
      {
          bMRow      = bMouseRow();
          bMCol      = bMouseCol();
      }


      SysRefresh();

      
      if( lKeyCode != 0 )
      {
          if( !SetKeySym )
          {
              SetKeySym = _Get_Sym( "SetKey" );

              // para forzar el lincado de setkey()
              if( !SetKeySym )
                   SetKey();
          }

          // SetKey( lKeyCode ) -> codeblock de setkey( lastKey() )
          _PutSym( SetKeySym );
          ( ++_tos )->wType = 0;
          _PutLN( lKeyCode );
          _xDo( 1 );

          if( _eval->wType & BLOCK ) // es un codeblock
          {
              lKeyCode = 0;
              _cEval0( _eval );
          }
      }

   }

   if( bAction && lTicks && lKeyCode == 0 && bIdle && !bMousePressed() )
       _cEval0( bAction );

   _retnl( lKeyCode );

}

//---------------------------------------------------------------------------//

CLIPPER lIsIdle() { _retl( bIdle ); }

//---------------------------------------------------------------------------//

CLIPPER lKeyAlt( void ) { _retl( bKeyAlt() ); }

//---------------------------------------------------------------------------//

CLIPPER lAnyKeyPre( void ) { _retl( bAnyKeyPressed() ); }

//---------------------------------------------------------------------------//
