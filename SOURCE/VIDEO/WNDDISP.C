#include <dos.h>
#include <ClipApi.h>
#include <Rects.h>
#include <FontDef.h>
#include <maxmin.h>
#include <cWIndow.h>

//---------------------------------------------------------------------------//

typedef struct _SCRPORT_
{
    RCT rct;
    WORD wSize;
    BYTE bScreen[];
} SCRPORT;

typedef SCRPORT far * LPSCRPORT;

extern WORD wLabelLen( LPSTR );

extern LPBYTE pascal _VSTRX( PCLIPVAR );

extern void VPBox( LPSCRPORT pPort,
            int iTop, int iLeft,
            WORD wWidth, WORD wHeight,
            LPSTR szBox, WORD wAtt );

extern void VPSayRep( LPSCRPORT pPort, int iRow, int iCol, BYTE bChar, WORD wAtt,
               WORD wCount );

extern void VPSay( LPSCRPORT pPort, int iRow, int iCol, LPSTR szText, WORD wAtt );
extern void VPSayHot( LPSCRPORT pPort, int iRow, int iCol,
               LPSTR szText, WORD wAttNormal, WORD wAttHot );

extern void VPWriteAt( LPSCRPORT pPort, int iRow, int iCol, LPSTR szText, WORD wAtt, WORD wCount );

extern void VPShadow( LPSCRPORT pPort, int iTop, int iLeft,
                                int iBottom, int iRight );

extern LPBYTE pascal _VSTRX( PCLIPVAR );

extern BOOL bIsEga( void );

static WORD bEga = 0xFFFF;

//----------------------------------------------------------------------------//

/********

CLIPPER VWndDispla()
{
    PCLIPVAR  vPort  = _param( 1, CHARACTER );
    BOOL bNeedUnLock = _VSTRLOCK( vPort );
    LPSCRPORT pPort  = (LPSCRPORT ) _VSTRX( vPort );
    LPRCT pRect      = GetRectParam( 2 );

    WORD wStyle     = _parni( 3 );
    WORD wClrBox    = ( WORD ) _parni( 4 );
    WORD wClrTitle  = ( WORD ) _parni( 5 );
    int iRight      = pRect->iLeft + pRect->wWidth  - 1;
    int iBottom     = pRect->iTop  + pRect->wHeight - 1;
    LPSTR szTitle   = _parc( 6 );
    LPSTR szMessage = _parc( 7 );
    BOOL lMaximized = _parl( 8 );
    BYTE bFrame[ 10 ];
    BYTE bClose[ 3 ], bMinimize[ 3 ], bMaximize[ 3 ], bRestore[ 3 ];

    if( bEga == 0xFFFF )
        bEga = bIsEga();


    if( bEga )
    {
       bFrame[ 0 ] = ' ';
       bFrame[ 1 ] = ' ';
       bFrame[ 2 ] = ' ';
       bFrame[ 3 ] = BORDERRIGHT;
       bFrame[ 4 ] = CORNERDRIGHT;
       bFrame[ 5 ] = BORDERBOTTOM;
       bFrame[ 6 ] = CORNERDLEFT;
       bFrame[ 7 ] = BORDERLEFT;
       bFrame[ 8 ] = 0; // FILLCHAR;
    }
    else
    {

       bFrame[ 0 ] = ' ';
       bFrame[ 1 ] = ' ';
       bFrame[ 2 ] = ' ';
       bFrame[ 3 ] = '³';
       bFrame[ 4 ] = 'Ù';
       bFrame[ 5 ] = 'Ä';
       bFrame[ 6 ] = 'À';
       bFrame[ 7 ] = '³';
       bFrame[ 8 ] = 0; // FILLCHAR;

    }


    if( bEga )
    {
       bClose[ 0 ] = CLOSELEFT;
       bClose[ 1 ] = CLOSERIGHT;

       bMinimize[ 0 ] = MINIMIZELEFT;
       bMinimize[ 1 ] = MINIMIZERIGHT;

       bMaximize[ 0 ] = MAXIMIZELEFT;
       bMaximize[ 1 ] = MAXIMIZERIGHT;

       bRestore[ 0 ] = RESTORELEFT;
       bRestore[ 1 ] = RESTORERIGHT;
    }
    else
    {
       bClose[ 0 ] = 'þ';
       bClose[ 1 ] = 'þ';
    }

    bClose[ 2 ]    = 0;
    bMinimize[ 2 ] = 0;
    bMaximize[ 2 ] = 0;
    bRestore[ 2 ]  = 0;

    VPBox( pPort, pRect->iTop, pRect->iLeft, pRect->wWidth, pRect->wHeight,
            bFrame, wClrBox );

    // Title
    VPSayRep( pPort, pRect->iTop, pRect->iLeft,
              32, wClrTitle, pRect->wWidth );
    VPWriteAt( pPort, pRect->iTop, pRect->iLeft + MAX( 0, pRect->wWidth / 2 - _parclen( 6 ) / 2 ),
               szTitle, wClrTitle, MIN( pRect->wWidth, _parclen( 6 ) ) );

    // Message
    VPSayRep( pPort, iBottom, pRect->iLeft,
              32, wClrTitle, pRect->wWidth );

    VPWriteAt( pPort, iBottom, pRect->iLeft + MAX( 0, pRect->wWidth / 2 - _parclen( 7 ) / 2 ),
               szMessage, wClrTitle, MIN( pRect->wWidth, _parclen( 7 ) ) );

    VPSay( pPort, pRect->iTop, pRect->iLeft, bClose, wClrTitle );

    if( wStyle & WND_LICONIZE )
    {
       VPSay( pPort, pRect->iTop, iRight - 1 - IF( wStyle & WND_LGROW, 2, 0 ), bMinimize, wClrTitle );
    }

    if( wStyle & WND_LGROW )
    {
       VPSay( pPort, pRect->iTop, iRight - 1, IF( lMaximized, bRestore, bMaximize ), wClrTitle );
    }

    if( wStyle & WND_LSHADOW )
    {
       VPShadow( pPort, iBottom + 1, pRect->iLeft + 2, iBottom + 1, iRight + 2 );
       VPShadow( pPort, pRect->iTop + 1, iRight + 1, iBottom, iRight + 2 );
    }

    if( bNeedUnLock )
        _VSTRUNLOCK( vPort );

    _bcopy( (LPBYTE) _eval, (LPBYTE) vPort, sizeof( CLIPVAR ) );
}

**********************/

//---------------------------------------------------------------------------//

CLIPPER VMBoxDispl() //  cVPort, nBoxRect, nClrIzqArr, nClrDchaAbjo
{
   PCLIPVAR  vPort  = _param( 1, CHARACTER );
   BOOL bNeedUnLock = _VSTRLOCK( vPort );
   LPSCRPORT pPort  = (LPSCRPORT ) _VSTRX( vPort );
   LPRCT pRect      = GetRectParam( 2 );
   WORD wClrUpLeft  = _parni( 3 );
   WORD wClrDnRight = _parni( 4 );
   WORD w, wT;

   BYTE bBorderUpLeft  = BORDERUPLEFT;
   BYTE bBorderUpRight = BORDERUPRIGHT;
   BYTE bBorderLeft    = BORDERLEFT;
   BYTE bBorderRight   = BORDERRIGHT;
   BYTE bCornerDLeft   = CORNERDLEFT;
   BYTE bCornerDRight  = CORNERDRIGHT;

   wT = pRect->iLeft + pRect->wWidth - 1;

   VPWriteAt( pPort, pRect->iTop, pRect->iLeft, &bBorderUpLeft,
              wClrUpLeft, 1 );
   VPSayRep( pPort, pRect->iTop, pRect->iLeft + 1, BORDERTOP,
              wClrUpLeft, pRect->wWidth - 2 );
   VPWriteAt( pPort, pRect->iTop, wT, &bBorderUpRight,
              wClrDnRight, 1 );

   for( w = pRect->iTop + 1; w < pRect->iTop + pRect->wHeight - 1 ; w++ )
   {
      VPWriteAt( pPort, w, pRect->iLeft, &bBorderLeft, wClrUpLeft, 1 );
      VPSayRep( pPort, w, pRect->iLeft + 1, ' ', wClrDnRight,
                pRect->wWidth - 2 );
      VPWriteAt( pPort, w, wT, &bBorderRight, wClrDnRight, 1 );
   }

   wT = pRect->iTop + pRect->wHeight - 1;

   VPWriteAt( pPort, wT, pRect->iLeft, &bCornerDLeft,
              wClrUpLeft, 1 );
   VPSayRep( pPort, wT, pRect->iLeft + 1, BORDERBOTTOM,
              wClrDnRight, pRect->wWidth - 2 );
   VPWriteAt( pPort, wT, pRect->iLeft + pRect->wWidth - 1, &bCornerDRight,
              wClrDnRight, 1 );

   if( bNeedUnLock )
        _VSTRUNLOCK( vPort );

   _bcopy( (LPBYTE) _eval, (LPBYTE) vPort, sizeof( CLIPVAR ) );
}

//----------------------------------------------------------------------------//


CLIPPER VWndShadow( void ) // ( cScreenPort, nWndRect, cMessage, nClrMsg ) -> cScreenPort
{
    PCLIPVAR  vPort  = _param( 1, CHARACTER );
    BOOL bNeedUnLock = _VSTRLOCK( vPort );
    LPSCRPORT pPort  = (LPSCRPORT ) _VSTRX( vPort );
    LPRCT pRect      = GetRectParam( 2 );
    int iRight       = pRect->iLeft + pRect->wWidth  - 1;
    int iBottom      = pRect->iTop  + pRect->wHeight - 1;
    

    VPShadow( pPort, iBottom + 1, pRect->iLeft + 2, iBottom + 1, iRight + 2 );
    VPShadow( pPort, pRect->iTop + 1, iRight + 1, iBottom, iRight + 2 );

    if( _pcount > 2 )
    {
        PCLIPVAR vMsg    = _param( 3, CHARACTER );
        WORD wClrMsg     = (WORD)_parni( 4 );
        WORD wWidth      = pRect->wWidth;
        WORD wLen        = _parclen( 3 );
        if( vMsg && wLen )
        {
            VPSayRep( pPort, iBottom, pRect->iLeft, 32, wClrMsg, wWidth );
            VPWriteAt( pPort, iBottom, pRect->iLeft + MAX( 0, wWidth / 2 - wLen / 2 ),
                    _VSTR( vMsg ), wClrMsg, MIN( wWidth, wLen ) );
        }
    }

    if( bNeedUnLock )
        _VSTRUNLOCK( vPort );

    _bcopy( (LPBYTE) _eval, (LPBYTE) vPort, sizeof( CLIPVAR ) );
}

//----------------------------------------------------------------------------//

CLIPPER VWndDraw() // ( cVPort, nWndRect, nClrBox )
{
    BYTE bFrame[ 10 ];
    PCLIPVAR  vPort  = _param( 1, CHARACTER );
    BOOL bNeedUnLock = _VSTRLOCK( vPort );
    LPSCRPORT pPort  = (LPSCRPORT ) _VSTRX( vPort );
    LPRCT pRect      = GetRectParam( 2 );

    if( bEga == 0xFFFF )
    {
        bEga = bIsEga();
    }

    if( bEga )
    {
            bFrame[ 0 ] = ' ';
            bFrame[ 1 ] = ' ';
            bFrame[ 2 ] = ' ';
            bFrame[ 3 ] = BORDERRIGHT;
            bFrame[ 4 ] = CORNERDRIGHT;
            bFrame[ 5 ] = BORDERBOTTOM;
            bFrame[ 6 ] = CORNERDLEFT;
            bFrame[ 7 ] = BORDERLEFT;
            bFrame[ 8 ] = 0; // FILLCHAR;
    }
    else
    {
            bFrame[ 0 ] = ' ';
            bFrame[ 1 ] = ' ';
            bFrame[ 2 ] = ' ';
            bFrame[ 3 ] = '³';
            bFrame[ 4 ] = 'Ù';
            bFrame[ 5 ] = 'Ä';
            bFrame[ 6 ] = 'À';
            bFrame[ 7 ] = '³';
            bFrame[ 8 ] = 0; // FILLCHAR;

    }

    VPBox( pPort, 0, 0, pRect->wWidth, pRect->wHeight,
           bFrame, _parni( 3 ) );

    if( bNeedUnLock )
        _VSTRUNLOCK( vPort );

    _bcopy( (LPBYTE) _eval, (LPBYTE) vPort, sizeof( CLIPVAR ) );
}

//----------------------------------------------------------------------------//

CLIPPER VMnBarDraw() // ( cVPort, nWidth, nHeight, nStyle,
{                    //   nClrBox, nClrTitle, cTitle, lMaximized )

    PCLIPVAR  vPort  = _param( 1, CHARACTER );
    BOOL bNeedUnLock = _VSTRLOCK( vPort );
    LPSCRPORT pPort  = (LPSCRPORT ) _VSTRX( vPort );
    WORD wWidth      = _parni( 2 );
    WORD wHeight     = _parni( 3 );

    WORD wStyle      = _parni( 4 );
    WORD wClrBox     = ( WORD ) _parni( 5 );
    WORD wClrTitle   = ( WORD ) _parni( 6 );
    LPSTR szTitle    = _parc( 7 );
    BOOL lMaximized  = _parl( 8 );
    BYTE bFrame[ 2 ], bMinimize[ 3 ], bMaximize[ 3 ], bRestore[ 3 ];
    WORD wLeft       = IF( wStyle & WND_LCLOSE, 2, 0 );
    WORD wTitleWidth = wWidth -
                       wLeft -
                       IF( wStyle & WND_LICONIZE, 2, 0 ) -
                       IF( wStyle & WND_LGROW, 2, 0 );
    WORD i;


    if( bEga == 0xFFFF )
        bEga = bIsEga();

    if( bEga )
    {
       bFrame[ 0 ] = BORDERRIGHT;
       bFrame[ 1 ] = BORDERLEFT;

       bMinimize[ 0 ] = MINIMIZELEFT;
       bMinimize[ 1 ] = MINIMIZERIGHT;

       bMaximize[ 0 ] = MAXIMIZELEFT;
       bMaximize[ 1 ] = MAXIMIZERIGHT;

       bRestore[ 0 ] = RESTORELEFT;
       bRestore[ 1 ] = RESTORERIGHT;
    }
    else
    {
       bFrame[ 0 ] = '³';
       bFrame[ 1 ] = '³';
    }

    bMinimize[ 2 ] = 0;
    bMaximize[ 2 ] = 0;
    bRestore[ 2 ]  = 0;

    // Title
    VPSayRep( pPort, 0, wLeft, 32, wClrTitle, wTitleWidth );
    VPWriteAt( pPort, 0, wLeft + MAX( 0, wTitleWidth / 2 - _parclen( 7 ) / 2 ),
               szTitle, wClrTitle, MIN( wTitleWidth, _parclen( 7 ) ) );

    if( wStyle & WND_LICONIZE )
       VPSay( pPort, 0, wWidth - 2 - IF( wStyle & WND_LGROW, 2, 0 ), bMinimize, wClrTitle );

    if( wStyle & WND_LGROW )
       VPSay( pPort, 0, wWidth - 2, IF( lMaximized, bRestore, bMaximize ), wClrTitle );

    for( i = 1; i < wHeight; i++ )
    {
        VPSayRep( pPort, i, 0, bFrame[ 1 ], wClrBox, 1 );
        VPSayRep( pPort, i, wWidth - 1, bFrame[ 0 ], wClrBox, 1 );
    }
    
    if( bNeedUnLock )
        _VSTRUNLOCK( vPort );

    _bcopy( (LPBYTE) _eval, (LPBYTE) vPort, sizeof( CLIPVAR ) );
}

//---------------------------------------------------------------------------//
// Draws a MenuItem
CLIPPER VMnitDraw( void ) // ( cVPort, cHotText, lFocussed, nColor, nClrHot,
                          //   lChecked, lOpenChar
                          //   nClrFocRight, nClrFocLeft ) -> cVPort
{
    PCLIPVAR  vPort  = _param( 1, CHARACTER );
    BOOL bNeedUnLock = _VSTRLOCK( vPort );
    LPSCRPORT pPort  = (LPSCRPORT ) _VSTRX( vPort );
    int  iRight     = pPort->rct.wWidth - 1;
    WORD wLen       = _parclen( 2 );
    BOOL bFocussed  = _parl( 3 );
    WORD wColor     = _parni( 4 );
    WORD wChecked   = _parl( 6 );

    BYTE bBackClr;
    BYTE bTemp[ 2 ];
    bTemp[ 1 ] = 0;
    bTemp[ 0 ] = ' ';


    VPSayRep( pPort, 0, 0, ' ', wColor, pPort->rct.wWidth );

    if( bFocussed && wLen > 2 )
    {
        bBackClr = ( (BYTE) wColor ) & 0xF0;
        VPSayRep( pPort, 0, 0, BORDERLEFT,
                  ( ( (BYTE) _parni( 9 ) ) & 0x0F ) | bBackClr, 1 );
        VPSayRep( pPort, 0, iRight, BORDERRIGHT,
                  ( ( (BYTE) _parni( 8 ) ) & 0x0F ) | bBackClr, 1 );
    }

    if( wChecked )
    {
        bTemp[ 0 ] = 'û';
        VPSay( pPort, 0, 1, bTemp, wColor );
    }

    if( wLen > 2 )
    {
        bTemp[ 0 ] = IF( _parl( 7 ), 16, ' ' );
        VPSay( pPort, 0, iRight - 1, bTemp, wColor );
        wChecked++;
    }

    VPSayHot( pPort, 0, wChecked, _parc( 2 ), wColor, _parni( 5 ) );

    if( bNeedUnLock )
        _VSTRUNLOCK( vPort );

    _bcopy( (LPBYTE) _eval, (LPBYTE) vPort, sizeof( CLIPVAR ) );
}

//---------------------------------------------------------------------------//
