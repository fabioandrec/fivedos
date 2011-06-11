#include <ClipApi.h>

typedef struct _RCT_
{
    int  iTop;
    int  iLeft;
    WORD wWidth;
    WORD wHeight;
} RCT;

typedef RCT far  * LPRCT;
typedef RCT near * PRCT;

typedef struct
{
    WORD wType;
    LONG lDummy;
    RCT  rct;
} CLIPRECT;

typedef CLIPRECT near * PCLIPRECT;
typedef CLIPRECT far * LPCLIPRECT;

static PCLIPRECT near GetRect( void );

//---------------------------------------------------------------------------//

static int near Abs( int Number )
{
   asm mov ax, Number;

   if( _AX > 0x7FFF )
   {
      asm neg ax;
   }
   
   return _AX;
}

//---------------------------------------------------------------------------//

void SetRect( LPRCT pRct, int iTop, int  iLeft,
                          WORD wWidth, WORD wHeight )
{
    pRct->iTop    = iTop;
    pRct->iLeft   = iLeft;
    pRct->wWidth  = wWidth;
    pRct->wHeight = wHeight;
}

//---------------------------------------------------------------------------//

void ScreenRect( LPRCT pRct )
{

    WORD wRows, wCols;
    _gtScrDim( &wRows, &wCols );

    SetRect( pRct, 0, 0, wCols, wRows );
}

//---------------------------------------------------------------------------//

int RectRight( LPRCT pRct )
{
    return pRct->iLeft + pRct->wWidth - 1;
}

//---------------------------------------------------------------------------//

int RectBottom( LPRCT pRct )
{
    return pRct->iTop + pRct->wHeight - 1;
}

//---------------------------------------------------------------------------//

BOOL bOverRect( LPRCT pRct, int iRow, int iCol )
{
    return ( iRow >= pRct->iTop    &&
             iRow <= RectBottom( pRct ) &&
             iCol >= pRct->iLeft   &&
             iCol <= RectRight( pRct ) );
}

//---------------------------------------------------------------------------//

BOOL bIntoRect( LPRCT pRct, int iRow, int iCol )
{
    return ( iRow > pRct->iTop    &&
             iRow < RectBottom( pRct ) &&
             iCol > pRct->iLeft   &&
             iCol < RectRight( pRct ) );
}

//---------------------------------------------------------------------------//

BOOL bBorderRect( LPRCT pRct, int iRow, int iCol )
{
    return ( bOverRect( pRct, iRow, iCol ) &&
             ! bIntoRect( pRct, iRow, iCol ) );
}

//---------------------------------------------------------------------------//

BOOL bIntersecRect( LPRCT pTgt, LPRCT pSrc, LPRCT pResult )
{
    pResult->iTop  = MAX( 0, pSrc->iTop );
    pResult->iLeft = MAX( 0, pSrc->iLeft );

    pResult->wWidth  = ( pSrc->iLeft >=  0
      ? MIN( pSrc->wWidth - MIN( pSrc->iLeft   , pSrc->wWidth ), pTgt->wWidth )
      : MIN( pTgt->wWidth - MIN( Abs( pSrc->iLeft ), pTgt->wWidth ), pSrc->wWidth ) );

    pResult->wHeight = ( pSrc->iTop >=  0
      ? MIN( pSrc->wHeight - MIN( pSrc->iTop   , pSrc->wHeight ), pTgt->wHeight )
      : MIN( pTgt->wHeight - MIN( Abs( pSrc->iTop ), pTgt->wHeight ), pSrc->wHeight ) );

    return ( pResult->wHeight && pResult->wWidth );
}

//---------------------------------------------------------------------------//

LPRCT GetRectParam( WORD wParam )
{
    PCLIPRECT Rect = (PCLIPRECT) ( _lbase + 1 + wParam );

    if( ! Rect->wType & NUM_FLOAT )
    {
        if( Rect->wType & BY_REF ) // Local/Static Ref
            Rect = (PCLIPRECT) ( (PCLIPVAR) Rect )->pPointer1;
        else
            return 0;
    }

    return &Rect->rct;
}

//---------------------------------------------------------------------------//

void RectNew( PCLIPRECT pVar, int iTop, int iLeft, WORD wWidth, WORD wHeight )
{

    pVar->wType   = NUM_FLOAT;
    SetRect( &pVar->rct, iTop, iLeft, wWidth, wHeight );
}

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

static PCLIPRECT near GetRect()
{
   PCLIPVAR Rect = _lbase + 2;

   if( ! Rect->wType & NUM_FLOAT )
   {
       if( Rect->wType & BY_REF ) // Local/Static Ref
           Rect = (PCLIPVAR) Rect->pPointer1;
       else
           Rect = 0;
   }

   return (PCLIPRECT) Rect;
}

//---------------------------------------------------------------------------//

static void near NewRect( PCLIPRECT pVar )
{
    pVar->wType   = NUM_FLOAT;
}

//---------------------------------------------------------------------------//

static void near GetSet( WORD wIndex, WORD wPrmIdx )
{
    PCLIPRECT Rect = GetRect();
    PCLIPVAR  pVal;

    wPrmIdx++;

    if( Rect )
    {
        pVal = _param( wPrmIdx, NUMERIC );
        if( pVal )
        {
            ( (WORD near *) Rect )[ 2 + wIndex ] = (int) pVal->pPointer1;
            _bcopy( (LPBYTE) _eval, (LPBYTE) Rect, sizeof( CLIPVAR ) );
        }
        else
            _retni( ( (WORD near *) Rect )[ 2 + wIndex ] );
    }

    // si no es NUM_FLOAT ¢ es una ref a MemVar -> devuelve nil
}

//---------------------------------------------------------------------------//

CLIPPER NEWRECT( void ) // ( nTop, nLeft, nWidth, nHeight ) -> NewRect
{
    NewRect( (PCLIPRECT) _eval );
    SetRect( &( (PCLIPRECT) _eval )->rct, _parni( 1 ), _parni( 2 ),
                                          _parni( 3 ), _parni( 4 ) );
}

//---------------------------------------------------------------------------//

CLIPPER SCREENRECT( void ) // () -> WholeScreenRect
{
    NewRect( (PCLIPRECT) _eval );
    ScreenRect( &( (PCLIPRECT) _eval )->rct );
}

//---------------------------------------------------------------------------//

CLIPPER RectTop( void )    // ( Rect [, NewSet ] ) -> Rect->iTop ¢ NewRect
{
    GetSet( 1, 2 );
}

//---------------------------------------------------------------------------//

CLIPPER RectLeft( void )   // ( Rect [, NewSet ] ) -> Rect->iLeft ¢ NewRect
{
    GetSet( 2, 2 );
}

//---------------------------------------------------------------------------//

CLIPPER RectWidth( void ) // ( Rect [, NewSet ] ) -> Rect->wWidth ¢ NewRect
{
    GetSet( 3, 2 );
}

//---------------------------------------------------------------------------//

CLIPPER RectHeight( void )  // ( Rect [, NewSet ] ) -> Rect->wHeight ¢ NewRect
{
    GetSet( 4, 2 );
}

//---------------------------------------------------------------------------//

CLIPPER RectChange( void )  // ( Rect , [nTop], [nLeft], [nWidth], [nHeight] ) -> NewRect
{
    PCLIPRECT Rect = GetRect();

    if( _pcount > 1 )
        Rect->rct.iTop = _parni( 2 );

    if( _pcount > 2 )
        Rect->rct.iLeft = _parni( 3 );

    if( _pcount > 3 )
        Rect->rct.wWidth = _parni( 4 );

    if( _pcount > 4 )
        Rect->rct.wHeight = _parni( 5 );

    _bcopy( (LPBYTE) _eval, (LPBYTE) Rect, sizeof( CLIPRECT ) );

}

//---------------------------------------------------------------------------//

CLIPPER RECTBOTTOM( void )  // ( Rect ) -> nRectBottom
{
    PCLIPRECT Rect = GetRect();

    if( Rect )
        _retni( RectBottom( &Rect->rct ) );
    else
        _retni( 0 );
}

//---------------------------------------------------------------------------//

CLIPPER RECTRIGHT( void )  // ( Rect ) -> nRectHeight
{
    PCLIPRECT Rect = GetRect();

    if( Rect )
        _retni( RectRight( &Rect->rct ) );
    else
        _retni( 0 );
}

//---------------------------------------------------------------------------//

CLIPPER lOverRect( void ) // ( Rect, nRow, nCol )
{
    PCLIPRECT Rect = GetRect();

    if( Rect )
    {
        _retl( bOverRect( &Rect->rct, _parni( 2 ), _parni( 3 ) ) );
    }
    else
        _retl( FALSE );
}

//---------------------------------------------------------------------------//

CLIPPER lIntoRect( void ) // ( Rect, nRow, nCol )
{
    PCLIPRECT Rect = GetRect();

    if( Rect )
    {
        _retl( bIntoRect( &Rect->rct, _parni( 2 ), _parni( 3 ) ) );
    }
    else
        _retl( FALSE );
}

//---------------------------------------------------------------------------//

CLIPPER lBorderRec( void ) // ( Rect, nRow, nCol )
{
    PCLIPRECT Rect = GetRect();

    if( Rect )
    {
        _retl( bBorderRect( &Rect->rct, _parni( 2 ), _parni( 3 ) ) );
    }
    else
        _retl( FALSE );
}

//---------------------------------------------------------------------------//
