#include <ClipApi.h>
#include <Rects.h>
#include <cView.h>


typedef struct _SCRPORT_
{
    RCT rct;
    WORD wSize;
    BYTE bScreen[];
} SCRPORT;


typedef SCRPORT far * LPSCRPORT;

extern void VPWriteAt( LPSCRPORT pPort, int iRow, int iCol,
                       LPBYTE sText, WORD wAtt, WORD wLen );

extern void VPSayHot( LPSCRPORT pPort, int iRow, int iCol,
                      LPSTR szText, WORD wAttNormal, WORD wAttHot );

void VPBox( LPSCRPORT pPort,
            int iTop, int iLeft,
            WORD wWidth, WORD wHeight,
            LPSTR szBox, WORD wAtt );

extern LPBYTE pascal _VSTRX( PCLIPVAR );

extern BYTE bMouseRow( void );
extern BYTE bMouseCol( void );

static BOOL _NeedUnLock = FALSE;

//---------------------------------------------------------------------------//
// Friend PseudoMethods

//---------------------------------------------------------------------------//

static void near UpdateOwner( void )
{
    static PCLIPSYMBOL pUpdate = 0;

    if( pUpdate == 0 )
        pUpdate = _Get_Sym( "UPDATEOWNE" );

    _PutSym( pUpdate );
    _xPushM( _lbase + 1 );
    _xSend( 0 );
}

//---------------------------------------------------------------------------//

static void near pascal GetInstVar( WORD wInstVar, PCLIPVAR pTarget )
{
    _cAt( _lbase + 1, wInstVar, -1, pTarget );
}

//---------------------------------------------------------------------------//

static LPSCRPORT near GetPortX( void )
{
    _cAt( _lbase + 1, INS_cVPORT, -1, ++_tos );

    _NeedUnLock = _VSTRLOCK( _tos );

    return (LPSCRPORT ) _VSTRX( _tos );
}

//---------------------------------------------------------------------------//

static void near pascal SetPortX( BOOL bUpdate )
{
// No es necesario asignar otra vez el puerto.
//    _cAtPut( _lbase + 1, INS_cVPORT, _tos );

    if( _NeedUnLock )
        _VSTRUNLOCK( _tos );
    _tos--;

    if( bUpdate )
        UpdateOwner();
}

//---------------------------------------------------------------------------//

static LPSCRPORT near GetPort( void )
{
    _cAt( _lbase + 1, INS_cVPORT, -1, ++_tos );
    return (LPSCRPORT ) _VSTR( _tos-- );
}

//---------------------------------------------------------------------------//
/*
static void near pascal SetPort( LPSCRPORT pPort )
{
    _storclen( (LPBYTE) pPort, pPort->wSize, 0, INS_cVPORT );
}
*/

//---------------------------------------------------------------------------//

static void near GetRect( LPRCT pRect )
{
    _cAt( _lbase + 1, INS_nCLIPRECT, -1, ++_tos );

    if( _tos->wType & NUM_FLOAT )
        _bcopy( (LPBYTE) pRect, (LPBYTE) &( ( (PCLIPRECT) _tos )->rct ), sizeof( RCT ) );
    else
        _bcopy( (LPBYTE) pRect, (LPBYTE) &( GetPort()->rct ), sizeof( RCT ) );

    _tos--;

}

/***
static LPRCT near GetRect( void )
{
    _cAt( _lbase + 1, INS_nCLIPRECT, -1, _eva );

    if( _eva->wType & NUM_FLOAT )
    {
        // return (LPRCT) &( (PCLIPRECT) _eval )->rct;
        return &( ( (PCLIPRECT) _eval )->rct );
    }
    else
        return &( GetPort()->rct );
}
*****/
//---------------------------------------------------------------------------//

CLIPPER TVIsOver( void ) // ( nRow, nCol )
{
    RCT Rect;
    GetRect( &Rect );
    _retl( bOverRect( &Rect, _parni( 1 ), _parni( 2 ) ) );
    // _retl( bOverRect( GetRect(), _parni( 1 ), _parni( 2 ) ) );
}

//---------------------------------------------------------------------------//

CLIPPER TVIsOverRe( void ) // ::IsOverResize( nMRow, nMCol )
{
    if( _parl( 0, INS_lDESIGN ) )
    {
        RCT Rct;
        int iRow   = _parni( 1 );
        int iCol   = _parni( 2 );
        int iRight;

        GetRect( &Rct );
        iRight = RectRight( &Rct );

        _retl( iRow == RectBottom( &Rct )  &&
               ( iCol == iRight - 1  || iCol == iRight ) );
    }
    else
        _retl( FALSE );
}

/*****
CLIPPER TVIsOverRe( void ) // ::IsOverResize( nMRow, nMCol )
{
    if( _parl( 0, INS_lDESIGN ) )
    {
        LPRCT pRct = GetRect();
        int iRow   = _parni( 1 );
        int iCol   = _parni( 2 );
        int iRight = RectRight( pRct );

        _retl( iRow == RectBottom( pRct )  &&
               ( iCol == iRight - 1  || iCol == iRight ) );
    }
    else
        _retl( FALSE );
}
******/

//---------------------------------------------------------------------------//

CLIPPER TVWidth( void ) // () -> nViewPortWidth
{
    _retni( GetPort()->rct.wWidth );
}

//---------------------------------------------------------------------------//

CLIPPER TVHeight( void ) // () -> nViewPortHeight
{
    _retni( GetPort()->rct.wHeight );
}

//---------------------------------------------------------------------------//

CLIPPER TVTop( void )  // () -> nViewPortTop
{
    _retni( GetPort()->rct.iTop );
}

//---------------------------------------------------------------------------//

CLIPPER TVLeft( void )  // () -> nViewPortLeft
{
    _retni( GetPort()->rct.iLeft );
}

//---------------------------------------------------------------------------//

CLIPPER TVRight( void ) // () -> nViewPortRight
{
    LPSCRPORT pPort = GetPort();
    _retni( pPort->rct.iLeft + pPort->rct.wWidth - 1 );
}

//---------------------------------------------------------------------------//

CLIPPER TVBottom( void ) // () -> nViewPortBottom
{
    LPSCRPORT pPort = GetPort();
    _retni( pPort->rct.iTop + pPort->rct.wHeight - 1 );
}

//---------------------------------------------------------------------------//

CLIPPER TVSetPos( void )  // ( nTop, nLeft )
{
    LPSCRPORT pPort = GetPortX();

    pPort->rct.iTop  = _parni( 1 );
    pPort->rct.iLeft = _parni( 2 );

    _cAt( _lbase + 1, INS_nCLIPRECT, -1, _eval );

    if( _eval->wType & NUM_FLOAT )
    {
        ( (PCLIPRECT) _eval )->rct.iTop  = pPort->rct.iTop;
        ( (PCLIPRECT) _eval )->rct.iLeft = pPort->rct.iLeft;
        _cAtPut( _lbase + 1, INS_nCLIPRECT, _eval );
    }

    SetPortX( FALSE );
}

//---------------------------------------------------------------------------//

CLIPPER TVSay( void ) // ( nRow, nCol, cText, nClr )
{
   LPSCRPORT pPort = GetPortX();

   VPWriteAt( pPort, _parni( 1 ), _parni( 2 ), _parc( 3 ), _parni( 4 ),
              _parclen( 3 ) );

   SetPortX( TRUE );
}

//---------------------------------------------------------------------------//

CLIPPER TVSayHot( void ) // ( nRow, nCol, cHotText, nClrNormal, nClrHot )
{
    LPSCRPORT pPort = GetPortX();
    VPSayHot( pPort, _parni( 1 ), _parni( 2 ),
               _parc( 3 ), _parni( 4 ), _parni( 5 ) );
    SetPortX( TRUE );
}

//---------------------------------------------------------------------------//

CLIPPER TVBox( void ) // ( nTop, nLeft, nBottom, nRight, cBox, nBoxColor )
{
   LPSCRPORT pPort = GetPortX();
   int iTop  = _parni( 1 );
   int iLeft = _parni( 2 );

   VPBox( pPort, iTop, iLeft,
          _parni( 4 ) - iLeft + 1,
          _parni( 3 ) - iTop + 1,
          IF( _param( 5, CHARACTER ), _parc( 5 ), 0 ),
          _parni( 6 ) );

   SetPortX( TRUE );
}

//---------------------------------------------------------------------------//
// Para cuando TWindow herede de de TView se puede codificar esto: sin mensajes
// Para entonces solo los objetos TView que no tengan oWnd tendr n coordenadas
// de Screen. O sea que ser n ventanas.
// Las Ventanas se relacionaran entre si a trav‚s de TWindow:oParent

static int near OrgTop( PCLIPVAR pObj )
{
    int iTop = 0;
    PCLIPVAR pWnd  = ++_tos;
    PCLIPVAR pData = ++_tos;

    * pWnd = * pObj;

    while( pWnd->wType & OBJECT && _VDict( pWnd ) != 0 )
    {
        _cAt( pWnd, INS_cVPORT, -1, pData );
        iTop += ( (LPSCRPORT ) _VSTR( pData ) )->rct.iTop;
        _cAt( pWnd, INS_oWND, -1, pWnd );
    }

    _tos -= 2;

    return iTop;
}

//---------------------------------------------------------------------------//

static int near OrgLeft( PCLIPVAR pObj )
{
    int iLeft = 0;
    PCLIPVAR pWnd  = ++_tos;
    PCLIPVAR pData = ++_tos;

    * pWnd = * pObj;

    while( pWnd->wType & OBJECT && _VDict( pWnd ) != 0 )
    {
        _cAt( pWnd, INS_cVPORT, -1, pData );
        iLeft += ( (LPSCRPORT ) _VSTR( pData ) )->rct.iLeft;
        _cAt( pWnd, INS_oWND, -1, pWnd );
    }

    _tos -= 2;

    return iLeft;
}

//---------------------------------------------------------------------------//

CLIPPER TVOrgTop( void )
{
    _retni( OrgTop( _lbase + 1 ) );
}

//---------------------------------------------------------------------------//

CLIPPER TVOrgLeft( void )
{
    _retni( OrgLeft( _lbase + 1 ) );
}

//---------------------------------------------------------------------------//


CLIPPER TVnMRow( void )
{
    _retni( ( (int) bMouseRow() ) - OrgTop( _lbase + 1 ) );
}

//---------------------------------------------------------------------------//

CLIPPER TVnMCol( void )
{
    _retni( ( (int) bMouseCol() ) - OrgLeft( _lbase + 1 ) );
}

//---------------------------------------------------------------------------//

CLIPPER TVBeginPai( void )
{
    _storni( _parni( 0, INS_nPAINTCOUNT ) + 1, 0, INS_nPAINTCOUNT );
}

//---------------------------------------------------------------------------//

CLIPPER TVEndPaint( void )
{
    int iPaintCount = _parni( 0, INS_nPAINTCOUNT ) - 1;

    if( iPaintCount <= 0 )
    {
        _storni( 0, 0, INS_nPAINTCOUNT );
        UpdateOwner();
    }
    else
        _storni( iPaintCount, 0, INS_nPAINTCOUNT );
}

//---------------------------------------------------------------------------//

CLIPPER TVUpdate( void )
{
    // oChild:Flash( ::cVPort )
    static PCLIPSYMBOL pFlash = 0;

    if( pFlash == 0 )
        pFlash = _Get_Sym( "FLASH" );

    _PutSym( pFlash );
    _xPushM( _param( 1, -1 ) );
    _cAt( _lbase + 1, INS_cVPORT, -1, ++_tos );
    _xSend( 1 );

    // ::UpdateOwner()
    UpdateOwner();

}

//---------------------------------------------------------------------------//

CLIPPER TVUpdateOw( void )
{
    static PCLIPSYMBOL pUpdate = 0;

    /*
    if ::nPaintCount <= 0 .and. ::oWnd != nil
        ::oWnd:Update( Self )
    endif
    */

    int nPaintCount = _parni( 0, INS_nPAINTCOUNT );

    _cAt( _lbase + 1, INS_oWND, -1, _eval );

    if( nPaintCount <= 0 && _eval->wType & OBJECT )
    {
        if( pUpdate == 0 )
            // pUpdate = _Get_Sym( "UPDATE" );
            pUpdate = _Get_Sym( "CH_UPDATE" );

        _PutSym( pUpdate );
        _xPushM( _eval );
        _xPushM( _lbase + 1 );
        _xSend( 1 );
    }

}

//---------------------------------------------------------------------------//
