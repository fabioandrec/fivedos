#include <ClipApi.h>

#define LPT_TIMEOUT    1
#define LPT_IOERROR    8
#define LPT_SELECTED  16
#define LPT_PAPEROUT  32
#define LPT_ACK       64
#define LPT_READY    128


#define LPT_OK    ( LPT_READY | LPT_SELECTED )

#define wStatus() wLPTStatus( iGetPort() )

//---------------------------------------------------------------------------//

WORD wLPTStatus( int iPort )
{
    WORD wStat;

    asm {
            mov ah, 0x02
            mov dx, iPort
            int 0x17
            mov al, ah
            mov ah, 0
    }

    return _AX;
}

//---------------------------------------------------------------------------//

WORD wLPTInit( int iPort )
{
    WORD wStat;

    asm {
            mov ah, 0x01
            mov dx, iPort
            int 0x17
            mov al, ah
            mov ah, 0
    }

    return _AX;
}

//---------------------------------------------------------------------------//

WORD wLPTSend( int iPort, BYTE bChar )
{
    WORD wStat;

    asm {
            mov ah, 0x00
            mov al, bChar
            mov dx, iPort
            int 0x17
            mov al, ah
            mov ah, 0
    }

    return _AX;
}

//---------------------------------------------------------------------------//

static int iGetPort( void )
{
    int iPort = _parni( 1 );

    return IF( iPort > 0, iPort - 1, 0 );

}

//---------------------------------------------------------------------------//

CLIPPER lLPTPaper( void ) // .t. si NO hay papel
{
   _retl( wStatus() & LPT_PAPEROUT );
}

//---------------------------------------------------------------------------//

CLIPPER lLPTReady( void ) // .t. si la impresora esta lista y selecionada.
{
    _retl( ( wStatus() & LPT_OK ) == LPT_OK );
}

//---------------------------------------------------------------------------//

CLIPPER nLPTInit( void )
{
    _retni( wLPTInit( iGetPort() ) );
}

//---------------------------------------------------------------------------//

CLIPPER nLPTStat( void )
{
    _retni( wStatus() );
}

//---------------------------------------------------------------------------//

static void near moment( void )
{
    int i ;
    for( i = 0; i < 100; i++ );
}

//---------------------------------------------------------------------------//

CLIPPER nLPTSend( void ) // ( nPort, cChar ) // -> nStatus
{
    _retni( wLPTSend( iGetPort(), _parc( 2 )[ 0 ] ) );
}

//---------------------------------------------------------------------------//
