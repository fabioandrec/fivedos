#include <ClipApi.h>
#include <Rects.h>
#include <cWindow.h>

// Friend PseudoMethods
//---------------------------------------------------------------------------//

static void near GetInstVar( WORD wInstVar, PCLIPVAR pTarget )
{
    _cAt( _lbase + 1, wInstVar, -1, pTarget );
}

//---------------------------------------------------------------------------//

static LPRCT near GetRect( WORD wInstVar )
{
   GetInstVar( wInstVar, _eval );

   return (LPRCT) IF( _eval->wType & NUM_FLOAT, &( (PCLIPRECT) _eval )->rct, 0 );
}

//---------------------------------------------------------------------------//

static BOOL near IsVisible( void )
{
   return _parl( 0, INS_lVISIBLE );
}

//---------------------------------------------------------------------------//

static void SendOver( WORD wInstObject, WORD wRow, WORD wCol )
{
    static PCLIPSYMBOL plIsOver = 0;

//     LPRCT pRct  = GetRect( INS_nWNDRECT );

    GetInstVar( wInstObject, _eval );

    if( _eval->wType & ARRAY )
    {
        if( ! plIsOver )
            plIsOver = _Get_Sym( "LISOVER" );

        _PutSym( plIsOver );
        _xPushM( _eval );
        _PutQ( wRow ); // - pRct->iTop );   // Coordenadas del hijo.
        _PutQ( wCol ); // - pRct->iLeft );  // Coordenadas del hijo
        _xSend( 2 );
    }
    else
        _retl( FALSE );
}


//---------------------------------------------------------------------------//

/*************************
                           TWindow "C" Methods
*************************/

//---------------------------------------------------------------------------//

CLIPPER TWIsOvClie( void ) // ( nMRow, nMCol )
{
    SendOver( INS_oCLIENT, _parni( 1 ), _parni( 2 ) );
}

//---------------------------------------------------------------------------//

CLIPPER TWIsOvMenu( void ) // ( nMRow, nMCol )
{
    SendOver( INS_oMENU, _parni( 1 ), _parni( 2 ) );
}

//---------------------------------------------------------------------------//

CLIPPER TWIsOvBar( void ) // ( nMRow, nMCol )
{
    SendOver( INS_oBAR, _parni( 1 ), _parni( 2 ) );
}

//---------------------------------------------------------------------------//

CLIPPER TWIsOvVScr( void ) // ( nMRow, nMCol )
{
    SendOver( INS_oVSCROLL, _parni( 1 ), _parni( 2 ) );
}

//---------------------------------------------------------------------------//

CLIPPER TWIsOvHScr( void ) // ( nMRow, nMCol )
{
    SendOver( INS_oHSCROLL, _parni( 1 ), _parni( 2 ) );
}

//---------------------------------------------------------------------------//

CLIPPER TWIsOvTitl( void ) // ( nRow, nCol )
{
    LPRCT pRct  = GetRect( INS_nCLIPRECT );
    int iRow    = _parni( 1 );
    int iCol    = _parni( 2 );
    WORD wStyle = _parni( 0, INS_nSTYLE );

    _retl( iRow == pRct->iTop      &&
           iCol >= pRct->iLeft + 2 &&
           iCol <= RectRight( pRct ) -
                    ( ( wStyle & WND_LGROW ? 2 : 0 ) +
                      ( wStyle & WND_LICONIZE ? 2 : 0 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER TWIsOvResi( void ) // OverResize( nRow, nCol )
{
    if( _parni( 0, INS_nSTYLE ) & WND_LGROW )
    {
        LPRCT pRct = GetRect( INS_nCLIPRECT );
        int iRow   = _parni( 1 );
        int iCol   = _parni( 2 );
        int iRight = RectRight( pRct );

        _retl( iRow == RectBottom( pRct )  &&
               ( iCol == iRight - 1  || iCol == iRight ) );
    }
    else
        _retl( FALSE );
}

//----------------------------------------------------------------------------//

CLIPPER TWIsOvClos( void ) // ( nRow, nCol )
{
    LPRCT pRct = GetRect( INS_nCLIPRECT );
    int iRow   = _parni( 1 );
    int iCol   = _parni( 2 );

    _retl( iRow == pRct->iTop  &&
           ( iCol == pRct->iLeft || iCol == pRct->iLeft + 1 ) );
}

//----------------------------------------------------------------------------//

CLIPPER TWIsOvMaxi( void ) // ( nRow, nCol )
{
    if( _parni( 0, INS_nSTYLE ) & WND_LGROW )
    {
        LPRCT pRct  = GetRect( INS_nCLIPRECT );
        int iRow    = _parni( 1 );
        int iCol    = _parni( 2 );
        int iRight  = RectRight( pRct );

        _retl( iRow == pRct->iTop  &&
               ( iCol == iRight || iCol == iRight - 1 ) );
    }
    else
        _retl( FALSE );
}

//----------------------------------------------------------------------------//

CLIPPER TWIsOvMini( void ) // ( nRow, nCol )
{
    WORD wStyle = _parni( 0, INS_nSTYLE );

    if( wStyle & WND_LICONIZE )
    {
        LPRCT pRct  = GetRect( INS_nCLIPRECT );
        int iRow    = _parni( 1 );
        int iCol    = _parni( 2 );
        int iRight  = RectRight( pRct ) - ( wStyle & WND_LGROW ? 2 : 0 );

        _retl( iRow == pRct->iTop  &&
               ( iCol == iRight || iCol == iRight - 1 ) );
    }
    else
        _retl( FALSE );
}

//----------------------------------------------------------------------------//

// METHOD nTop()    INLINE RectTop( ::nWndRect )
CLIPPER TWnTop( void )
{
    _retni( GetRect( INS_nCLIPRECT )->iTop );
}

//---------------------------------------------------------------------------//

// METHOD nLeft()   INLINE RectLeft( ::nWndRect )
CLIPPER TWnLeft( void )
{
    _retni( GetRect( INS_nCLIPRECT )->iLeft );
}

//---------------------------------------------------------------------------//

// METHOD nWidth()  INLINE RectWidth( ::nWndRect )
CLIPPER TWnWidth( void )
{
    _retni( GetRect( INS_nCLIPRECT )->wWidth );
}

//---------------------------------------------------------------------------//

// METHOD nHeight() INLINE RectHeight( ::nWndRect )
CLIPPER TWnHeight( void )
{
    _retni( GetRect( INS_nCLIPRECT )->wHeight );
}

//---------------------------------------------------------------------------//

// METHOD nBottom() INLINE RectBottom( ::nWndRect )
CLIPPER TWnBottom( void )
{
    _retni( RectBottom( GetRect( INS_nCLIPRECT ) ) );
}

//---------------------------------------------------------------------------//

// METHOD nRight()  INLINE RectRight( ::nWndRect )
CLIPPER TWnRight( void )
{
    _retni( RectRight( GetRect( INS_nCLIPRECT ) ) );
}

//---------------------------------------------------------------------------//
