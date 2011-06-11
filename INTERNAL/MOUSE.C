#include <ClipApi.h>
#include <CurIds.h>

void KeyStuff( WORD );
void MouseInit( BYTE );
void MouseReset( void );
void MouseOn( BYTE );
void MouseOff( void );
BYTE bMouseRow( void );
BYTE bMouseCol( void );
void MouseUpdate( void );
BOOL bMouseLeft( void );
BOOL bMouseCenter( void );
BOOL bMouseRight( void );
void MouseKeyLeft( WORD wKey );
void MouseKeyCenter( WORD wKey );
void MouseKeyRight( WORD wKey );
void MouseChars( LPBYTE );
BOOL bMousePressed( void );
BYTE bMouseCursor( void );
void MouseSetArea( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight );
void MouseSetCursor( WORD wCursor );
void MouseSetPos( WORD wRow, WORD wCol );

extern CLIPPER SysRefresh( void );

//----------------------------------------------------------------------------//

CLIPPER MInit()      { MouseInit( _parl( 1 ) ); }
CLIPPER MReset()     { MouseReset(); }
CLIPPER MOn()        { MouseOn( _parni( 1 ) ); }
CLIPPER MOff()       { MouseOff(); }
CLIPPER nMRow()      { _retni( bMouseRow() ); }
CLIPPER nMCol()      { _retni( bMouseCol() ); }
CLIPPER MUpdate()    { SysRefresh(); MouseUpdate(); }
CLIPPER lMLeft()     { _retl( bMouseLeft() ); }
CLIPPER lMCenter()   { _retl( bMouseCenter() ); }
CLIPPER lMRight()    { _retl( bMouseRight() ); }
CLIPPER lMPressed()  { _retl( bMousePressed() ); }
CLIPPER SetMKLeft()  { MouseKeyLeft( _parni( 1 ) ); }
CLIPPER SetMKRight() { MouseKeyRight( _parni( 1 ) ); }
CLIPPER SetMKCente() { MouseKeyCenter( _parni( 1 ) ); }
CLIPPER SetMChars()  { MouseChars( _parc( 1 ) ); }
CLIPPER SetMPos()    { MouseSetPos( _parni( 1 ), _parni( 2 ) ); }
CLIPPER nMCursor()   { bMouseCursor(); }

//---------------------------------------------------------------------------//

CLIPPER SetMGPos( void ) // ( nGrafRow, nGrafCol
{
   WORD wGrafRow, wGrafCol;

   wGrafRow = _parni( 1 );
   wGrafCol = _parni( 2 );
   _DX = wGrafRow;
   _CX = wGrafCol;
   _AX = 4;
   asm int 0x33;
}
//----------------------------------------------------------------------------//

CLIPPER SetMArea()
{
   MouseSetArea( _parni( 1 ),
                 _parni( 2 ),
                 _parni( 3 ),
                 _parni( 4 ) );
}

//----------------------------------------------------------------------------//

CLIPPER CursorHand()
{
    MouseSetCursor( IDC_HAND );
}

//----------------------------------------------------------------------------//

CLIPPER CursorWait()
{
   MouseSetCursor( IDC_CLOCK );
}

//----------------------------------------------------------------------------//

CLIPPER CursorArro()
{
   MouseSetCursor( IDC_ARROW );
}

//----------------------------------------------------------------------------//

BOOL _gtmGetPos( DWORD p )
{
    return FALSE;
}

CLIPPER MRow()
{
    _gtmGetPos( 0 );
    _retni( bMouseRow() );
}
CLIPPER MCol()
{
    _gtmGetPos( 0 );
    _retni( bMouseCol() );
}


//---------------------------------------------------------------------------//
