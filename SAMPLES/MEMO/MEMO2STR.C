// -------------------------------------------------------------------------- //
// Funciones a bajo nivel para la clase TMemo by Juan Rios Olivares
// -------------------------------------------------------------------------- //
#include <ClipApi.h>

#define CR              13
#define LF              10
#define MAX_LINE_WIDTH  512

extern LPSTR pascal _VSTRX( PCLIPVAR );

// -------------------------------------------------------------------------- //
CLIPPER Memo2aStr() // ( cMemo, nMaxWidth ) -> acItems
{
    PCLIPVAR pMemo;
    BOOL     bMemo;
    LPBYTE   lpMemo;
    WORD     wLines;
    WORD     wWidth;
    LONG     lMaxWidth;
    LPBYTE   lpTmp;
    char     cLine[ MAX_LINE_WIDTH ];
    WORD     wLastSpace;

    // Obtenemos el puntero al primer par metro
    pMemo = _param( 1, CHARACTER );
    if( pMemo )
    {
        // Obtenemos la cadena del buffer
        bMemo  = _VSTRLOCK( pMemo );
        lpMemo = _VSTR( pMemo );

        // Obtenemos el valor m ximo de la cadena
        lMaxWidth = _parni( 2 );

        // por si no se pasa el segundo parametro
        if( !lMaxWidth )
        {
            lMaxWidth = MAX_LINE_WIDTH;
        }

        // Contamos cuantas l¡neas hay para crear el array
        wLines     = 0;
        wWidth     = 0;
        lpTmp      = lpMemo;
        wLastSpace = 0;
        while( * lpTmp )
        {
            if( * lpTmp == ' ' )
            {
                wLastSpace = wWidth;
            }
            if( ( * lpTmp++ == CR && * lpTmp == LF ) ||
                ( ++wWidth >= lMaxWidth ) )
            {
                if( * lpTmp == LF )
                {
                    // Para que no lea el LF en la siguiente linea
                    lpTmp++;
                }
                else if( wLastSpace > 0 )
                {
                    lpTmp -= ( wWidth - wLastSpace );
                }
                wWidth = 0;
                wLastSpace = 0;
                wLines++;
            }
        }
        // Si ha quedado algo en la £ltima l¡nea
        if( wWidth )
        {
            wLines++;
        }

        // Creamos el array
        _ARRAYNEW( wLines );
        _bcopy( ( LPBYTE ) ++_tos, ( LPBYTE ) _eval, sizeof( CLIPVAR ) );

        // A¤adimos cada l¡nea en el array
        wLines     = 0;
        wWidth     = 0;
        lpTmp      = lpMemo;
        wLastSpace = 0;
        while( * lpTmp )
        {
            if( ( cLine[ wWidth ] = * lpTmp ) == ' ' )
            {
                wLastSpace = wWidth;
            }
            if( ( * lpTmp++ == CR && * lpTmp == LF ) ||
                ( ++wWidth >= lMaxWidth ) )
            {
                if( * lpTmp == LF )
                {
                    // Para que no lea el LF en la siguiente linea
                    lpTmp++;
                }
                else if( wLastSpace > 0 ) // Por si no tiene espacios
                {
                    // Partimos la l¡nea pero en el £ltimo espacio
                    lpTmp -= ( wWidth - wLastSpace );
                    wWidth = wLastSpace;
                }
                _cAtPutStr( _tos, wLines + 1, cLine, wWidth );
                wWidth = 0;
                wLastSpace = 0;
                wLines++;
            }
        }

        // Si ha quedado algo en la £ltima l¡nea
        if( wWidth )
        {
            _cAtPutStr( _tos, wLines + 1, cLine, wWidth );
        }

        // Ponemos el array en eval
        _bcopy( ( LPBYTE ) _eval, ( LPBYTE ) _tos--, sizeof( CLIPVAR ) );

        // Miramos si tenemos que desbloquear la cadena.
        if( bMemo )
        {
            _VSTRUNLOCK( pMemo );
        }
    }
}

// -------------------------------------------------------------------------- //
CLIPPER aStr2Memo() // ( acItems ) ->cBuffer
{
    PCLIPVAR pArray;
    WORD     wArrayLen;
    LONG     lSize;
    PCLIPVAR pLine;
    LPBYTE   lpLine;
    WORD     wItem;
    LPBYTE   lpBuffer;
    BOOL     bBuffer;

    pArray = _param( 1, ARRAY );
    if( pArray )
    {
        wArrayLen = _VARRAYLEN( pArray );
        if( wArrayLen )
        {
            lSize = 0;
            for( wItem = 1; wItem <= wArrayLen; wItem++ )
            {
                _cAt( pArray, wItem, CHARACTER, _eval );
                if( _eval )
                {
                    lpLine = _VSTRX( _eval );
                    lSize += strlen( lpLine ) + 2; // CR + LF
                }
            }

            _BYTESNEW( lSize );
            _bcopy( ( LPBYTE ) ++_tos, ( LPBYTE ) _eval, sizeof( CLIPVAR ) );
            bBuffer  = _VSTRLOCK( _eval );
            lpBuffer = _VSTRX( _eval );

            for( wItem = 1; wItem <= wArrayLen; wItem++ )
            {
                _cAt( pArray, wItem, CHARACTER, _eval );
                if( _eval )
                {
                    lpLine = _VSTRX( _eval );
                    lSize = strlen( lpLine );
                    _bcopy( lpBuffer, lpLine, lSize );
                    lpBuffer += lSize;
                    * lpBuffer++ = CR;
                    * lpBuffer++ = LF;
                }
            }
            if( bBuffer )
            {
                _VSTRUNLOCK( _tos );
            }
            _bcopy( ( LPBYTE ) _eval, ( LPBYTE ) _tos--, sizeof( CLIPVAR ) );
        }
    }
}

// -------------------------------------------------------------------------- //
