#include <ClipApi.h>
#include <MaxMin.h>

#include <Rects.h>
#include <MakeLong.h>
#include <Dos.h>
#include <Fontdef.h>

#define CR 13
#define LF 10

typedef struct _SCRPORT_
{
    RCT rct;
    WORD wSize;
    BYTE bScreen[];
} SCRPORT;


typedef SCRPORT far * LPSCRPORT;

extern LPBYTE TextVideo( void );
extern WORD wLabelLen( LPSTR );

extern void SetMouseData( LPBYTE ); // Deja el flag bWorking TRUE
extern void SetDbgActive( BOOL );   // Prepara el modulo de raton para
                                    // entrar/salir del debugger;
extern void MouseRelease( BOOL );   // Pone bWorking = FALSE
extern void MouseOff( void );
extern void MouseOn( WORD );


extern LPBYTE _vmPtr( LONG );
extern LPBYTE _vmDirtyPtr( LONG );
extern LPBYTE _vmLock( LONG );
extern void   _vmUnLock( LONG );
extern LONG   _vmAlloc( WORD wKBytes );
extern WORD   _vmReAlloc( LONG, WORD wKBytes );
extern void   _vmFree( LONG );
extern WORD   _vmSize( LONG );

LONG ScreenPort( void );

extern LPBYTE pascal _VSTRX( PCLIPVAR );


CLIPPER WAppCurren( void );

static BOOL _NeedUnLock = FALSE;

static gtHWND hCurrent = 0;
static gtHWND hWndApp  = 0;

static char FiveBox[ 9] = { BORDERUPLEFT,
                            BORDERTOP,
                            BORDERUPRIGHT,
                            BORDERRIGHT,
                            CORNERDRIGHT,
                            BORDERBOTTOM,
                            CORNERDLEFT,
                            BORDERLEFT,
                            0 };



#define RETPARM( v ) if( _NeedUnLock ) _VSTRUNLOCK( _param( v, -1 ) ); _bcopy( (LPBYTE) _eval, (LPBYTE) _param( v, -1 ), sizeof( CLIPVAR ) )


//---------------------------------------------------------------------------//

// Debug Link
typedef void ( far * PLINEPROC )( WORD, PCLIPNAME );
typedef void ( far * PWORDPROC )( WORD );
typedef void ( far * PVOIDPROC )( void );

typedef struct
{
    int       iEntryFlag;
    WORD      wGotKey;
    PVOIDPROC pInputProc;     // Por cada entrada de tecla
    PLINEPROC pLineProc;      // Por cada linea
    PVOIDPROC pEntryProc;     // Por cada entrada/salida de un proc
    PWORDPROC pAltDProc;      // Las llamadas a AltD()
    PWORDPROC pTermProc;      // Al terminar la ejecuci¢n del prog
    PVOIDPROC pInitProc;      // Al comenzar la ejecuci¢n  "   "
} DBGCOMMAREA;

extern DBGCOMMAREA far _dbgcomm;
extern WORD        far _sysflags;

// CallBacks de plankton al debugger.
static PLINEPROC pOldLineProc  = 0;
static PWORDPROC pOldAltDProc  = 0;
static PWORDPROC pOldTermProc  = 0;
/*
static PVOIDPROC pOldInputProc = 0;
static PVOIDPROC pOldEntryProc = 0;
static PVOIDPROC pOldInitProc  = 0;
*/

//---------------------------------------------------------------------------//
// Enable FastCall
#pragma option -pr

static LPSCRPORT near GetPortParam( WORD wParam )
{
    PCLIPVAR  vPort = _param( wParam, CHARACTER );
    _NeedUnLock     = _VSTRLOCK( vPort );
    return (LPSCRPORT ) _VSTRX( vPort );
}

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

//--------------

static void near Shadow( LPBYTE pScreen )
{
    BYTE Att = * pScreen;

    if( Att <= 0x08 )
    {
        * pScreen = 0x08;
        return;
    }

    if( Att & 0x80 )
        Att &= 0x7F;
    else
        Att &= 0x0F;

    if( Att & 0x08 )
        Att &= 0x77;

    if( Att == 0x00 )
        Att = 0x08;

    * pScreen = Att;
}

//--------------

static WORD near wPortOffset( LPSCRPORT pPort, int iRow, int  iCol )
{
    if( iRow >= 0 && iCol >= 0 && iCol < pPort->rct.wWidth && iRow < pPort->rct.wHeight )
        return( ( ( iRow * pPort->rct.wWidth ) + iCol ) * 2 );
    else
        return -1;
}


//---------------------------------------------------------------------------//

static void near _retPort( LPSCRPORT pPort )
{
    _retclen( (LPBYTE) pPort,
               sizeof( SCRPORT ) + pPort->wSize );
}

//---------------------------------------------------------------------------//

/*
    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    ³    Source          ³
    ³                    ³
    ³   iTop, iLeft      ³
    ³       ÚÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    ³       ³||||||||||||³  Target       ³
    ³       ³||||||||||||³               ³
    ÀÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÙ               ³
            ³                            ³
            ³                            ³
            ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

static void near CopyVPort( LPSCRPORT pSrc, int iTop, int iLeft, LPSCRPORT pTgt,
                BOOL bSetScreen )
{
   if( pSrc && pTgt )
   {

       /* Paso del Buffer de entrada */
       WORD  wSrcStep  = pSrc->rct.wWidth * 2;

       /* Paso del Buffer de salida */
       WORD  wTgtStep  = pTgt->rct.wWidth * 2;

       /* tama¤o del Buffer de entrada */
       WORD  wLenSrc   = pSrc->wSize;

       /* tama¤o del Buffer de salida */
       WORD  wLenTgt   = pTgt->wSize;

       WORD  wBytes    = 2 * ( iLeft >= 0
                             ? MIN( pSrc->rct.wWidth - MIN( iLeft, pSrc->rct.wWidth ), pTgt->rct.wWidth )
                             : MIN( pSrc->rct.wWidth, pTgt->rct.wWidth - MIN( Abs( iLeft ), pTgt->rct.wWidth ) ) );

       /* El Desplazamiento inicial de los buffers */
       WORD  wDespSrc   = MAX( MIN( iTop, wSrcStep ),  0 ) * wSrcStep +
                          MAX( iLeft, 0 ) * 2;

       WORD  wDespTgt   = MIN( Abs( MIN( iTop,  0 ) ), wTgtStep ) * wTgtStep +
                          Abs( MIN( iLeft, 0 ) ) * 2;

       /* Bucle de copia */
       while( wDespSrc < wLenSrc &&  wDespTgt < wLenTgt )
       {
            if( bSetScreen )
                _bcopy( pSrc->bScreen + wDespSrc,
                        pTgt->bScreen + wDespTgt,
                        wBytes );
            else
                _bcopy( pTgt->bScreen + wDespTgt,
                        pSrc->bScreen + wDespSrc,
                        wBytes );

            wDespTgt += wTgtStep;
            wDespSrc += wSrcStep;
       }
   }
}

//---------------------------------------------------------------------------//

static LONG near NewPort( int iTop, int iLeft, WORD wWidth, WORD wHeight )
{
    WORD wSize      = MAX( 1, wWidth ) * MAX( 1, wHeight ) * 2;
    static LONG oMem = 0;
    LPSCRPORT pPort;

    if( oMem == 0 )
    {
        oMem =  _vmAlloc( 1 + ( sizeof( SCRPORT ) + wSize ) / 1024 );
    }
    else if( _vmSize( oMem ) < 1 + ( sizeof( SCRPORT ) + wSize ) / 1024 )
    {
        _vmReAlloc( oMem, 1 + ( sizeof( SCRPORT ) + wSize ) / 1024 );
    }

    pPort = (LPSCRPORT ) _vmLock( oMem );

    SetRect( &pPort->rct, iTop, iLeft, wWidth, wHeight );

    pPort->wSize    = wSize;
    _bset( pPort->bScreen, 0, wSize );

    return oMem;
}

//---------------------------------------------------------------------------//

// Disable FastCall
#pragma option -p-

//---------------------------------------------------------------------------//

// Devuelve recorte con coord rel al mismo origen de las de pSrc
// el Rect es relativo al mismo origen que pSrc.
LONG GetScreen( LPSCRPORT pSrcPort, LPRCT pRect )
{
   LONG oMem = NewPort( pRect->iTop,
                        pRect->iLeft,
                        pRect->wWidth, pRect->wHeight );
   LPSCRPORT TgtPort = (LPSCRPORT) _vmDirtyPtr( oMem );

   CopyVPort( pSrcPort,
              pRect->iTop - pSrcPort->rct.iTop,
              pRect->iLeft - pSrcPort->rct.iLeft,
              TgtPort, FALSE );

   return oMem;

}

//---------------------------------------------------------------------------//
/* devuelve copia con coor rel a src del rect definido por cTgtPort
*/

CLIPPER GETSCREEN( void ) // cSrcPort, cTgtPort -> cNewPort
{
    LPRCT pRect       = &( ( (LPSCRPORT) _parc( 2 ) )->rct );
    LONG oMem         = NewPort( pRect->iTop,
                                 pRect->iLeft,
                                 pRect->wWidth, pRect->wHeight );
    LPSCRPORT TgtPort = (LPSCRPORT) _vmDirtyPtr( oMem );

    CopyVPort( (LPSCRPORT) _parc( 1 ),
               pRect->iTop,
               pRect->iLeft,
               TgtPort, FALSE );

    _retPort( TgtPort );
    _vmUnLock( oMem );
}

//---------------------------------------------------------------------------//
                            // coordenadas relativas a target
/* SetScreen( cTargetVPort, cSourceVPort ) -> cNewTargetScreen
*/
CLIPPER SETSCREEN( void )
{
   LPSCRPORT TgtPort = GetPortParam( 1 );
   LPSCRPORT SrcPort = (LPSCRPORT ) _parc( 2 ); // _VSTR( _param( 2, CHARACTER ) );

   CopyVPort( TgtPort, SrcPort->rct.iTop, SrcPort->rct.iLeft, SrcPort, TRUE );

   RETPARM( 1 );

}

//---------------------------------------------------------------------------//
                                    // coord rel a Tgt
void SetScrRect( LPSCRPORT TgtPort, LPSCRPORT SrcPort,
                 LPRCT pSrcRect )   // Coord rel a Tgt
{

    LONG oMem          = GetScreen( SrcPort, pSrcRect );
    LPSCRPORT pSrcClip = (LPSCRPORT) _vmDirtyPtr( oMem );

    CopyVPort( TgtPort, pSrcClip->rct.iTop, pSrcClip->rct.iLeft, pSrcClip, TRUE );

    _vmUnLock( oMem );
}

//---------------------------------------------------------------------------//
/*  SetScrRect( cVPTgt, cVPSrc, nTgtRelASource ) -> cNewTgt
*/

CLIPPER SETSCRRECT( void )
{
    LPSCRPORT pTgtPort = GetPortParam( 1 );
    LPRCT     pRect    = GetRectParam( 3 );

    if( pRect )
        SetScrRect( pTgtPort, (LPSCRPORT) _parc( 2 ), pRect );
        // SetScrRect( pTgtPort, (LPSCRPORT) _VSTR( _param( 2, CHARACTER ) ), pRect );

    RETPARM( 1 );
}

//---------------------------------------------------------------------------//

void VPClear( LPSCRPORT pPort, char cChar, char cClr )
{
    LPBYTE pScreen = pPort->bScreen;
    WORD w = 0;

    while( w < pPort->wSize )
    {
        pScreen[ w++ ] = cChar;
        pScreen[ w++ ] = cClr;
    }
}

//---------------------------------------------------------------------------//

CLIPPER VClear( void ) // cVPort, cChar, nClr ) -> cVPOrt
{
    LPSCRPORT pPort = GetPortParam( 1 );
    VPClear( pPort, _parc( 2 )[ 0 ], _parni( 3 ) );
    RETPARM( 1 );
}

//---------------------------------------------------------------------------//

CLIPPER VIEWPORTNE( void ) // ( nRow, nCol, nWidth, nHeight, cChar, nBackColor )
{
    LONG oMem = NewPort( _parni( 1 ), _parni( 2 ),
                         _parni( 3 ), _parni( 4 ) );
    LPSCRPORT pPort =  (LPSCRPORT) _vmLock( oMem );

    VPClear( pPort, _parc( 5 )[ 0 ], _parni( 6 ) );

    _retPort( pPort );
    _vmUnLock( oMem );

}

//---------------------------------------------------------------------------//

CLIPPER VSetImage( void ) // ( cVPort, cImage )
{
    LPSCRPORT pPort = GetPortParam( 1 );

    _bcopy( pPort->bScreen, _parc( 2 ), MIN( pPort->wSize, _parclen( 2 ) ) );

    RETPARM( 1 );
}

//---------------------------------------------------------------------------//

CLIPPER VGetImage( void ) // ( cVPort ) -> cImage
{
    LPSCRPORT pPort = (LPSCRPORT) _parc( 1 );

    _retclen( pPort->bScreen, pPort->wSize );
}


//---------------------------------------------------------------------------//

CLIPPER VClonePort( void ) // ( cVPort ) -> cVClonedPort
{
    _retPort( (LPSCRPORT) _VSTR( _param( 1, -1 ) ) );
}

//---------------------------------------------------------------------------//

void VPShadow( LPSCRPORT pPort, int iTop, int iLeft,
                                int iBottom, int iRight )
{
    int iCol;
    WORD wDesp;

    while( iTop <= iBottom )
    {
        for( iCol = iLeft; iCol <= iRight; iCol++ )
        {
             wDesp = wPortOffset( pPort, iTop, iCol );

             if( wDesp != 0xFFFF )
                 Shadow( pPort->bScreen + wDesp + 1 );
        }

        iTop++;
    }

}

//---------------------------------------------------------------------------//

void VPSayRep( LPSCRPORT pPort, int iRow, int iCol, BYTE bChar, WORD wAtt,
               WORD wCount )
{
       WORD i      = 0;
       WORD wDesp;

       while( i < wCount )
       {
           wDesp = wPortOffset( pPort, iRow, iCol++ );

           if( wDesp != 0xFFFF )
           {
               pPort->bScreen[ wDesp ]     = bChar;
               pPort->bScreen[ wDesp + 1 ] = wAtt;
           }

           i++;
       }

}

//---------------------------------------------------------------------------//

void VPWriteAt( LPSCRPORT pPort, int iRow, int iCol, LPSTR sText,
                WORD wAtt, WORD wCount )
{
   /*
   if( iRow >= 0 && iRow < pPort->rct.wHeight &&
       ( iCol >= 0 ? iCol < pPort->rct.wWidth : TRUE ) )
   {
   */
       WORD i      = 0;
       WORD wDesp;

       while( i < wCount )
       {
           wDesp = wPortOffset( pPort, iRow, iCol++ );

           if( wDesp != 0xFFFF )
           {
               pPort->bScreen[ wDesp ]     = sText[ i ];
               pPort->bScreen[ wDesp + 1 ] = wAtt;
           }

           i++;
       }

   // }
}

//---------------------------------------------------------------------------//

void VPSay( LPSCRPORT pPort, int iRow, int iCol, LPSTR szText, WORD wAtt )
{
   VPWriteAt( pPort, iRow, iCol, szText, wAtt, strlen( szText ) );
}

//---------------------------------------------------------------------------//

/* VSay( cViewPort, nRow, nCol, cText, nClr ) -> cNewScreenPort
*/
CLIPPER VSay( void )
{
   LPSCRPORT TgtPort = GetPortParam( 1 );

   VPWriteAt( TgtPort, _parni( 2 ), _parni( 3 ), _parc( 4 ), _parni( 5 ),
              _parclen( 4 ) );

   RETPARM( 1 );
}

//---------------------------------------------------------------------------//

void VPSayHot( LPSCRPORT pPort, int iRow, int iCol,
               LPSTR szText, WORD wAttNormal, WORD wAttHot )
{

   if( iRow >= 0 && iRow < pPort->rct.wHeight &&
       ( iCol >= 0 ? iCol < pPort->rct.wWidth : TRUE ) )
   {
       WORD wDesp;
       BYTE bChar = szText[ 0 ];

       while( bChar )
       {
           wDesp = wPortOffset( pPort, iRow, iCol++ );

           if( wDesp != 0xFFFF )
           {
               if( bChar == '&' )
               {
                   pPort->bScreen[ wDesp ]     = * ++szText;
                   pPort->bScreen[ wDesp + 1 ] = wAttHot;
               }
               else
               {
                   pPort->bScreen[ wDesp ]     = bChar;
                   pPort->bScreen[ wDesp + 1 ] = wAttNormal;
               }
           }

           bChar = ( ++szText )[ 0 ];

       }

   }
}

//---------------------------------------------------------------------------//

CLIPPER VSayHot( void ) // ( cVPort, nRow, nCol, cHotText, nClrNormal, nClrHot )
{
    LPSCRPORT pPort = GetPortParam( 1 );
    VPSayHot( pPort, _parni( 2 ), _parni( 3 ),
               _parc( 4 ), _parni( 5 ), _parni( 6 ) );
    RETPARM( 1 );
}

//---------------------------------------------------------------------------//

void VPBox( LPSCRPORT pPort,
            int iTop, int iLeft,
            WORD wWidth, WORD wHeight,
            LPSTR szBox, WORD wAtt )
{
   LPSCRPORT BoxPort;
   BYTE register bAtt = wAtt;
   WORD register i;
   WORD wStep         = wWidth * 2;
   WORD wOffset;
   LONG oMem = NewPort( iTop, iLeft, wWidth, wHeight );
   BoxPort = (LPSCRPORT) _vmDirtyPtr( oMem );

   // Desplazamiento del comienzo de la £ltima linea.
   wOffset = wStep * ( wHeight - 1 );

   if( !szBox )
        szBox = FiveBox;

   // ¨ Rellenamos ?
   // El interior si 9§ caracter existe
   if( szBox[ 8 ] )
   {
       VPClear( BoxPort, szBox[ 8 ], bAtt );
   }
   else
   {
       // Copiamos la imagen en el puerto de la caja,
       // porque debe ser transparente...
       CopyVPort( pPort, iTop, iLeft,
                  BoxPort, FALSE );
   }

   // Dibujamos la caja ....

   /* Esquina SupIzq */
   BoxPort->bScreen[ 0 ] = szBox[ 0 ];
   BoxPort->bScreen[ 1 ] = bAtt;
   // wOffset apunta a la £tima linea.
   /* Linea Superior e inferior */
   for( i = 2; i < wStep - 2; i += 2 )
   {
        // Superior.
        BoxPort->bScreen[ i ]     = szBox[ 1 ];
        BoxPort->bScreen[ i + 1 ] = bAtt;
        // inferior.
        BoxPort->bScreen[ i + wOffset ]     = szBox[ 5 ];
        BoxPort->bScreen[ i + wOffset + 1 ] = bAtt;

   }

   /* Esquina SupDer */
   BoxPort->bScreen[ wStep - 2 ] = szBox[ 2 ];
   BoxPort->bScreen[ wStep - 1 ] = bAtt;

   /* Linea Derecha e izquierda */
   // wOffset ya apunta al principio de la £ltima linea
   for( i = wStep; i < wOffset ; i += wStep )
   {
        // Derecha.
        BoxPort->bScreen[ i + wStep - 2 ] = szBox[ 3 ];
        BoxPort->bScreen[ i + wStep - 1 ] = bAtt;
        // Izquierda.
        BoxPort->bScreen[ i ]     = szBox[ 7 ];
        BoxPort->bScreen[ i + 1 ] = bAtt;
   }
        
   /* Esquina Inferior Izquierda y Derecha */
   // wOffset sigue apuntando al principio de la £ltima linea
   BoxPort->bScreen[ wOffset ]             = szBox[ 6 ];
   BoxPort->bScreen[ wOffset + 1 ]         = bAtt;
   BoxPort->bScreen[ wOffset + wStep - 2 ] = szBox[ 4 ];
   BoxPort->bScreen[ wOffset + wStep - 1 ] = bAtt;


   // ... copiamos el BoxPort en el puerto de la caja.
   CopyVPort( pPort, iTop, iLeft, BoxPort, TRUE );

   // y liberamos el puerto temporal: BoxPort.
   _vmUnLock( oMem );

}

//---------------------------------------------------------------------------//

/* VBox( cViewPort,
         nTop, nLeft, nBottom, nRight,
         cBox, nBoxColor ) -> cViewPort
*/
CLIPPER VBox( void )
{
   LPSCRPORT TgtPort = GetPortParam( 1 );
   int iTop  = _parni( 2 );
   int iLeft = _parni( 3 );

   VPBox( TgtPort, iTop, iLeft,
          _parni( 5 ) - iLeft + 1,
          _parni( 4 ) - iTop + 1,
          IF( _param( 6, CHARACTER ), _parc( 6 ), 0 ),
          _parni( 7 ) );

   RETPARM( 1 );
}


//---------------------------------------------------------------------------//

void VPFlash( LPSCRPORT pPort )
{
   LONG oMem = ScreenPort();
   LPSCRPORT AppPort = (LPSCRPORT) _vmDirtyPtr( oMem );

   // ... copiamos el Port en el puerto de la App.
   CopyVPort( AppPort, pPort->rct.iTop, pPort->rct.iLeft, pPort, TRUE );

   _gtRest( 0, 0, AppPort->rct.wHeight - 1, AppPort->rct.wWidth - 1,
            AppPort->bScreen );
   // y liberamos el puerto temporal: AppPort.
   _vmUnLock( oMem );

}

//---------------------------------------------------------------------------//

/* VFlash( cViewPort )
*/
CLIPPER VFlash( void )
{
   LPSCRPORT pPort = GetPortParam( 1 );
   VPFlash( pPort );
   RETPARM( 1 );
}

//---------------------------------------------------------------------------//

CLIPPER VWidth( void ) // ( cViewPort ) -> nViewPortWidth
{
    _retni( ( (LPSCRPORT ) _parc( 1 ) )->rct.wWidth );
}

//---------------------------------------------------------------------------//

CLIPPER VHeight( void ) // ( cViewPort ) -> nViewPortHeight
{
    _retni( ( (LPSCRPORT ) _parc( 1 ) )->rct.wHeight );
}

//---------------------------------------------------------------------------//

CLIPPER VTop( void )  // ( cViewPort ) -> nViewPortTop
{
    _retni( ( (LPSCRPORT ) _parc( 1 ) )->rct.iTop );
}

//---------------------------------------------------------------------------//

CLIPPER VLeft( void )  // ( cViewPort ) -> nViewPortLeft
{
    _retni( ( (LPSCRPORT ) _parc( 1 ) )->rct.iLeft );
}

//---------------------------------------------------------------------------//

CLIPPER VRight( void ) // cViewPort -> nViewPortRight
{
    LPSCRPORT pPort = (LPSCRPORT) _parc( 1 );
    _retni( pPort->rct.iLeft + pPort->rct.wWidth - 1 );
}

//---------------------------------------------------------------------------//

CLIPPER VBottom( void ) // cViewPort -> nViewPortBottom
{
    LPSCRPORT pPort = (LPSCRPORT) _parc( 1 );
    _retni( pPort->rct.iTop + pPort->rct.wHeight - 1 );
}

//---------------------------------------------------------------------------//

CLIPPER VSetPos( void )  // ( cViewPort, nTop, nLeft ) -> nViewPortTop
{
    LPSCRPORT pPort = GetPortParam( 1 );

    pPort->rct.iTop  = _parni( 2 );
    pPort->rct.iLeft = _parni( 3 );

    RETPARM( 1 );
}

//---------------------------------------------------------------------------//

CLIPPER VIsOver( void ) // ( cViewPort, nRow, nCol )
{
    LPSCRPORT pPort = (LPSCRPORT) _parc( 1 );
   _retl( bOverRect( &pPort->rct, _parni( 2 ), _parni( 3 ) ) );
}

//---------------------------------------------------------------------------//

CLIPPER VIsInto( void ) // ( cViewPort, nRow, nCol )
{
    LPSCRPORT pPort = (LPSCRPORT) _parc( 1 );
   _retl( bIntoRect( &pPort->rct, _parni( 2 ), _parni( 3 ) ) );
}

//---------------------------------------------------------------------------//

CLIPPER VIsBorder( void ) // ( cViewPort, nRow, nCol )
{
    LPSCRPORT pPort = (LPSCRPORT) _parc( 1 );
   _retl( bBorderRect( &pPort->rct, _parni( 2 ), _parni( 3 ) ) );
}

//---------------------------------------------------------------------------//

CLIPPER nVToRect( void ) // cVPort -> nRectDelAreaDelPort
{
    LPRCT pRect = &( (LPSCRPORT) _parc( 1 ) )->rct;

    RectNew( _eval, pRect->iTop,   pRect->iLeft,
                    pRect->wWidth, pRect->wHeight );
}

//---------------------------------------------------------------------------//

CLIPPER cSwapAtt( void ) // ( cScreen, nAtt1, nAtt2 )
{
    LPBYTE pScreen  = (LPBYTE) GetPortParam( 1 );
    BYTE bAtt1      = _parni( 2 );
    BYTE bAtt2      = _parni( 3 );
    WORD wOff;

    for( wOff = 1; wOff < _parclen( 1 ); wOff += 2 )
    {
        if( pScreen[ wOff ] == bAtt1 )
            pScreen[ wOff ] = bAtt2;
        else if( pScreen[ wOff ] == bAtt2 )
            pScreen[ wOff ] = bAtt1;
    }

    RETPARM( 1 );
}

//---------------------------------------------------------------------------//

CLIPPER cSetAtt( void ) // ( cScreen, nAtt )
{
    LPBYTE pScreen  = (LPBYTE) GetPortParam( 1 );
    BYTE bAtt       = _parni( 2 );
    WORD wOff;

    for( wOff = 1; wOff < _parclen( 1 ); wOff += 2 )
        pScreen[ wOff ] = bAtt;

    RETPARM( 1 );
}



//---------------------------------------------------------------------------//

/* Cambia atributos nAtt1 por Att2 y viceversa
   en el area descrita por nRect
*/
CLIPPER VSwapAtt( void ) // cVPort, nRect, nAtt1, nAtt2 -> cVport
{
    LPSCRPORT pPort = GetPortParam( 1 );
    LPRCT     pRect = GetRectParam( 2 );
    BYTE bAtt1      = _parni( 3 );
    BYTE bAtt2      = _parni( 4 );
    WORD wOff;
    int iRow, iCol;

    for( iRow = pRect->iTop; iRow < pRect->iTop + pRect->wHeight; iRow++ )
        for( iCol = pRect->iLeft; iCol < pRect->iLeft + pRect->wWidth; iCol++ )
        {
            if( ( wOff = wPortOffset( pPort, iRow, iCol ) ) != 0xFFFF )
            {
                if( pPort->bScreen[ wOff + 1 ] == bAtt1 )
                    pPort->bScreen[ wOff + 1 ] = bAtt2;
                else if( pPort->bScreen[ wOff + 1 ] == bAtt2 )
                    pPort->bScreen[ wOff + 1 ] = bAtt1;
            }

        }

    RETPARM( 1 );
}

//---------------------------------------------------------------------------//

CLIPPER nLabelRect( void ) // ( cTextToVLabel ) -> nLabelRect
{
    int i        = 0;
    int iLine    = 0;
    int iLen     = _parclen( 1 );
    int iHeight  = 1;
    int iWidth   = 0;
    LPSTR pLabel = _parc( 1 );

    while( i < iLen )
    {
        switch( pLabel[ i ] )
        {
            case ';' :
                if( pLabel[ i + 1 ] == ';' )
                {
                    iLine++;
                    i += 2;
                }
                else
                {
                    iWidth = MAX( iWidth, iLine + 1 );
                    iHeight++ ;
                    iLine = 0;
                    i++;
                }
                break;

            case CR:
                iWidth = MAX( iWidth, iLine + 1 );
                iHeight++ ;
                iLine = 0;
                i++;
                break;

            case LF:
                i++;
                break;

            default:
                i++;
                iLine++;
                break;
        }
    }

    RectNew( _eval, 0, 0, MAX( iWidth, iLine ), iHeight );

}

//---------------------------------------------------------------------------//

/* VLabel( pPort, cLabel, nClrNormal, nClrHotKey, xJustify ) -> cLabelPort

   si xJustify == 0 -> Centrado
                < 0 -> Left
                > 0 -> Right
*/
CLIPPER VLabel( void )
{
    LPSCRPORT pPort = GetPortParam( 1 );
    WORD wWidth   = pPort->rct.wWidth;
    WORD wHeight  = pPort->rct.wHeight;
    WORD wAttNorm = _parni( 3 );
    WORD wAttHot  = _parni( 4 );
    int  iJustify = _parni( 5 );
    int  iRow     = 0;
    int  iCol     = 0;
    int  iCount   = 1;
    WORD wLen     = _parclen( 2 );
    LONG oMem     = NewPort( 0, 0, 1, wLen + 1 );
    LPSTR szLabel = (LPSTR) ( (LPSCRPORT) _vmDirtyPtr( oMem ) )->bScreen;
    LPSTR pSrcLabel = _parc( 2 );

    // iRow indiza pSrcLabe
    // iCol indize szLabel

    while( iRow < wLen )
    {
        switch( pSrcLabel[ iRow ] )
        {
            case ';' :
                if( pSrcLabel[ iRow + 1 ] == ';' )
                {
                    szLabel[ iCol++ ] = ';';
                    iRow += 2;
                }
                else
                {
                    szLabel[ iCol++ ] = 0;
                    iCount++;
                    iRow++;
                }
                break;

            case CR:
                szLabel[ iCol++ ] = 0;
                iCount++;
                iRow++;
                break;

            case LF:
                iRow++;
                break;

            default:
                szLabel[ iCol++ ] = pSrcLabel[ iRow++ ];
        }
    }

    szLabel[ iCol ] = 0;

    // Borramos TODA el area del puerto.
    VPClear( pPort, ' ', wAttNorm );

    iRow   = MAX( (int) wHeight - iCount, 0 ) / 2;
    iCount = iCount + iRow;

    while( iRow < wHeight && iRow < iCount )
    {
        if( iJustify == 0 )
            iCol = ( (int) wWidth - (int) wLabelLen( szLabel ) ) / 2;
        else if( iJustify > 0 )
            iCol = ( (int) wWidth - (int) wLabelLen( szLabel ) + 1 );
        else
            iCol = 0;
        VPSayHot( pPort, iRow++, iCol,
                  szLabel, wAttNorm, wAttHot );

        szLabel += strlen( szLabel ) + 1;

    }

    _vmUnLock( oMem );

    RETPARM( 1 );
}

//---------------------------------------------------------------------------//

/*
   VBtnShadow( cPort ) -> cPort
*/

CLIPPER VBtnShadow( void )
{
   LPSCRPORT pPort = GetPortParam( 1 );


   WORD wStep        = pPort->rct.wWidth * 2;
   WORD wOffset;

   // Derecha arriba
   wOffset = wStep - 2;

   pPort->bScreen[ wOffset ] = 'Ü';
   pPort->bScreen[ wOffset + 1 ] &= 0xF0;

   // Lateral derecho
   wOffset += wStep;
   while( wOffset < pPort->wSize - wStep )
   {
       // pPort->bScreen[ wOffset ] = 219; // 'Û';
       // pPort->bScreen[ wOffset + 1 ] &= 0xF0;
       Shadow( pPort->bScreen + wOffset + 1 );
       wOffset += wStep;
   }

   // Abajo.
   wOffset = 2 + wStep * ( pPort->rct.wHeight - 1 );
   while( wOffset < pPort->wSize)
   {
       pPort->bScreen[ wOffset++ ] = 'ß';
       pPort->bScreen[ wOffset++ ] &= 0xF0;
   }

   RETPARM( 1 );

}

//---------------------------------------------------------------------------//

CLIPPER SCREENPORT( void )
{
    LONG oMem = ScreenPort();
    LPSCRPORT AppPort = (LPSCRPORT) _vmDirtyPtr( oMem );

    _retPort( AppPort );

    _vmUnLock( oMem );
}

//---------------------------------------------------------------------------//
// Los dos puertos deben tener el mismo tama¤o... !!!!
CLIPPER CopyPort( void ) // ( cTargetPort, cSrcPort ) -> cCopiedTargetPort
{

    LPSCRPORT TgtPort = GetPortParam( 1 );
    LPSCRPORT SrcPort = ( LPSCRPORT ) _parc( 2 );

    _bcopy( (LPBYTE) TgtPort,
            (LPBYTE) SrcPort,
            sizeof( SCRPORT ) + TgtPort->wSize );

    RETPARM( 1 );
}

//---------------------------------------------------------------------------//

/*********************************************

   The _gtW...() connection....

*********************************************/

//---------------------------------------------------------------------------//

static gtHWND near GetCurrent( void )
{
    _gtMaxRow();

    asm {
            mov dx, es
            mov ax, bx
        }

    return (gtHWND) MAKELONG( _AX, _DX );

}


//----------------------------------------------------------------------------//

CLIPPER WAppCurren( void )
{
   if( hWndApp == 0 )
       _gtWApp( &hWndApp );

   if( !( hWndApp == hCurrent ) )
   {
      /*
        BOOL bSetMouse = hCurrent > 0;
        if( bSetMouse )
            SetMouseData( (LPBYTE) _vmDirtyPtr( (LONG) hWndApp->pVmm ) );
      */
        hCurrent = hWndApp;
        _gtWCurrent( hWndApp );
      /*
        if( bSetMouse )
            MouseRelease();
      */
   }
}

//---------------------------------------------------------------------------//

CLIPPER IsAppCurre( void ) // ->.t. si la ventana activa es la aplicaci¢n.
{
    if( hWndApp == 0 )
       _gtWApp( &hWndApp );

    _retl( hWndApp == GetCurrent() );
}

//---------------------------------------------------------------------------//

CLIPPER SCREENFLAS( void )
{
   LPSCRPORT pSrcPort = GetPortParam( 1 );

   if( hWndApp == 0 )
       _gtWApp( &hWndApp );

   hCurrent = GetCurrent();
   SetMouseData( pSrcPort->bScreen );

   if( !( hWndApp == hCurrent ) )
   {

       hCurrent = hWndApp;

       _bcopy( (LPBYTE) _vmDirtyPtr( (LONG) hWndApp->pVmm ),
               pSrcPort->bScreen, pSrcPort->wSize - ( 4 * pSrcPort->rct.wWidth ) );

       // while( !( ( inport( 0x3DA ) & 8 ) == 8 ) );
       // while( !( ( inport( 0x3DA ) & 8 ) == 0 ) );

       _gtWCurrent( hWndApp );

   }
   else
   {
        // while( !( ( inport( 0x3DA ) & 8 ) == 8 ) );
        // while( !( ( inport( 0x3DA ) & 8 ) == 0 ) );
        _gtRest( 0, 0, pSrcPort->rct.wHeight - 1, pSrcPort->rct.wWidth - 1,
                 pSrcPort->bScreen );

        // _bcopy( TextVideo(), pSrcPort->bScreen,
        //         pSrcPort->wSize - ( 4 * pSrcPort->rct.wWidth ) );
   }

   MouseRelease( _pcount > 1 );

   RETPARM( 1 );
}

//---------------------------------------------------------------------------//

CLIPPER VWCreate() // ( nTop, nLeft, nWidth, nHeight )
{
   gtRECT rct;
   gtHWND hWnd;

   if( hWndApp == 0 )
       _gtWApp( &hWndApp );

   rct.wTop    = _parni( 1 );
   rct.wLeft   = _parni( 2 );
   rct.wWidth  = _parni( 3 );
   rct.wHeight = _parni( 4 );

   _gtWCreate( ( LPgtRECT ) &rct, &hWnd );

   _gtWVis( hWnd, 0 );

   _retnl( ( LONG ) hWnd );
}

//---------------------------------------------------------------------------//

/*  WToVP( cVPTarget, hWndSrc ) -> cVPTarget
*/

CLIPPER WToVP()
{
   LPSCRPORT pTgtPort = GetPortParam( 1 );
   gtHWND    hWSrc    = (gtHWND) _parnl( 2 );

   _bcopy( pTgtPort->bScreen,
           (LPBYTE) _vmPtr( (LONG) hWSrc->pVmm ),
           pTgtPort->wSize );

   RETPARM( 1 );
}


//----------------------------------------------------------------------------//

CLIPPER WCurrent()
{

   gtHWND hWnd = (gtHWND) _parnl( 1 );

   if( hWnd && !( hWnd == hCurrent ) )
   {
       _gtWCurrent( hWnd );
       hCurrent = hWnd;
   }

}

//----------------------------------------------------------------------------//

CLIPPER WDestroy( void )
{
    gtHWND hWnd = (gtHWND) _parnl( 1 );

    if( hWnd )
        _gtWDestroy( hWnd );
}

//---------------------------------------------------------------------------//

LONG ScreenPort( void )
{
   LONG oScrMem;
   LPSCRPORT AppPort;

   WORD wMaxRow;
   WORD wMaxCol;

   gtHWND hOldWnd = GetCurrent();

   if( !( hWndApp == hOldWnd ) )
   {
       if( hWndApp == 0 )
           _gtWApp( &hWndApp );
       _gtWCurrent( hWndApp );
   }

   wMaxRow = _gtMaxRow();
   wMaxCol = _gtMaxCol();

   oScrMem = NewPort( 0, 0, wMaxCol + 1, wMaxRow + 3 );
   AppPort = (LPSCRPORT ) _vmDirtyPtr( oScrMem );

   AppPort->rct.wHeight -= 2;
   // AppPort->wSize   -= 4 * ( wMaxCol + 1 );

   _gtSave( 0, 0, wMaxRow, wMaxCol, AppPort->bScreen );

   if( hOldWnd != hWndApp )
       _gtWCurrent( hOldWnd );

   return oScrMem;
}

//---------------------------------------------------------------------------//

WORD wScrMaxRow( void )
{
    if( hWndApp == 0 )
        _gtWApp( &hWndApp );

    return hWndApp->wHeight - 1;
}

//---------------------------------------------------------------------------//

CLIPPER ScrMaxRow( void )
{
   _retni( wScrMaxRow() );
}

//---------------------------------------------------------------------------//

WORD wScrMaxCol( void )
{
    if( hWndApp == 0 )
        _gtWApp( &hWndApp );

    return hWndApp->wWidth - 1;
}

//---------------------------------------------------------------------------//

CLIPPER ScrMaxCol( void )
{
    _retni( wScrMaxCol() );
}

//---------------------------------------------------------------------------//

static void DbgLineProc( WORD wLine, PCLIPNAME pProc )
{
    if( pOldLineProc )
    {
        _dbgcomm.pLineProc  = 0;

        SetDbgActive( TRUE );

        ( pOldLineProc )( wLine, pProc );

        if( hCurrent && !( hWndApp == hCurrent ) )
            _gtWCurrent( hCurrent );

        SetDbgActive( FALSE );

        _dbgcomm.pLineProc  = DbgLineProc;

    }
}

//---------------------------------------------------------------------------//

static void DbgAltDProc( WORD wWord )
{
    if( pOldAltDProc )
    {
        _dbgcomm.pAltDProc  = 0;

        SetDbgActive( TRUE );

        ( pOldAltDProc )( wWord );

        if( hCurrent && !( hWndApp == hCurrent ) )
            _gtWCurrent( hCurrent );

        SetDbgActive( FALSE );

        _dbgcomm.pAltDProc  = DbgAltDProc;

    }
}

//---------------------------------------------------------------------------//

static void DbgTermProc( WORD wWord )
{
    if( pOldTermProc )
    {
        _dbgcomm.pTermProc  = 0;

        SetDbgActive( TRUE );

        ( pOldTermProc )( wWord );

        if( hCurrent && !( hWndApp == hCurrent ) )
            _gtWCurrent( hCurrent );

        SetDbgActive( FALSE );

        _dbgcomm.pTermProc  = DbgTermProc;

    }
}

//---------------------------------------------------------------------------//
/*
static void DbgInputProc( void )
{
    if( _dbgcomm.pInputProc && pOldInputProc )
    {
        _dbgcomm.pInputProc  = 0;

        SetDbgActive( TRUE );

        ( pOldInputProc )();

        if( hCurrent && !( hWndApp == hCurrent ) )
            _gtWCurrent( hCurrent );

        SetDbgActive( FALSE );

        _dbgcomm.pInputProc  = DbgInputProc;

    }
}

//---------------------------------------------------------------------------//

static void DbgEntryProc( void )
{
    if( pOldEntryProc )
    {
        _dbgcomm.pEntryProc  = 0;

        SetDbgActive( TRUE );

        ( pOldEntryProc )();

        if( hCurrent && !( hWndApp == hCurrent ) )
            _gtWCurrent( hCurrent );

        SetDbgActive( FALSE );

        _dbgcomm.pEntryProc  = DbgEntryProc;

    }
}

//---------------------------------------------------------------------------//

static void DbgInitProc( void )
{
    if( pOldInitProc )
    {
        _dbgcomm.pInitProc  = 0;

        SetDbgActive( TRUE );

        ( pOldInitProc )();

        if( hCurrent && !( hWndApp == hCurrent ) )
            _gtWCurrent( hCurrent );

        SetDbgActive( FALSE );

        _dbgcomm.pInitProc  = DbgInitProc;

    }
}
*/
//---------------------------------------------------------------------------//

static void near LinkDbg( void )
{
    pOldLineProc = _dbgcomm.pLineProc;
    _dbgcomm.pLineProc = DbgLineProc;

    pOldAltDProc = _dbgcomm.pAltDProc;
    _dbgcomm.pAltDProc = DbgAltDProc;

    pOldTermProc = _dbgcomm.pTermProc;
    _dbgcomm.pTermProc = DbgTermProc;
/*
    pOldInputProc = _dbgcomm.pInputProc;
    _dbgcomm.pInputProc = DbgInputProc;

    pOldEntryProc = _dbgcomm.pEntryProc;
    _dbgcomm.pEntryProc = DbgEntryProc;

    pOldInitProc = _dbgcomm.pInitProc;
    _dbgcomm.pInitProc = DbgInitProc;
*/
}

//---------------------------------------------------------------------------//

static void near UnLinkDbg( void )
{
    if( _dbgcomm.pLineProc )
        _dbgcomm.pLineProc = pOldLineProc;
    pOldLineProc = 0;

    if( _dbgcomm.pAltDProc )
        _dbgcomm.pAltDProc = pOldAltDProc;
    pOldAltDProc = 0;

    if( _dbgcomm.pTermProc )
        _dbgcomm.pTermProc = pOldTermProc;
    pOldTermProc = 0;
 /*
    if( _dbgcomm.pInputProc )
        _dbgcomm.pInputProc = pOldInputProc;
    pOldInputProc = 0;

    if( _dbgcomm.pEntryProc )
        _dbgcomm.pEntryProc = pOldEntryProc;
    pOldEntryProc = 0;

    if( _dbgcomm.pInitProc )
        _dbgcomm.pInitProc = pOldInitProc;
    pOldInitProc = 0;
 */
}
//---------------------------------------------------------------------------//

BOOL FDosLinkDbg( void )
{
    if( pOldLineProc )
    {
        UnLinkDbg();
        return TRUE;
    }
    else if( _dbgcomm.pLineProc )   // Link
    {
        LinkDbg();
        return TRUE;
    }

    return FALSE;
}

//---------------------------------------------------------------------------//
