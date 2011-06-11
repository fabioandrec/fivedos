#include <ClipApi.h>

//---------------------------------------------------------------------------//
#pragma option -pr

static BYTE near ucClr2Att( BYTE Color )
{
   BYTE ucRet = 0;

   switch( Color )
   {
      case 'B':
           ucRet = 1; break;

      case 'G':
           ucRet = 2; break;

      case 'R':
           ucRet = 4; break;

      case 'W':
           ucRet = 7; break;

      case 'b':
           ucRet = 1; break;

      case 'g':
           ucRet = 2; break;

      case 'r':
           ucRet = 4; break;

      case 'w':
           ucRet = 7; break;

   }
   return( ucRet );
}

//---------------------------------------------------------------------------//

static WORD near wScanSep( LPSTR szColor, WORD wIndex )
{
    WORD wOffSet = 0;

    if( wIndex > 1 )
    {
        --wIndex;
        while( szColor[ wOffSet ] && wIndex )
        {
            if( szColor[ wOffSet ] == ',' )
                wIndex--;

            wOffSet++;
        }
        if( ! szColor[ wOffSet ] )
            wOffSet = 0;
    }

    return wOffSet;

}

//---------------------------------------------------------------------------//

#pragma option -p-

//---------------------------------------------------------------------------//

BYTE ucColor2N( LPSTR szColor )
{
    BYTE i    = 0;     // apuntador;
    BYTE bClr = 0;
    BYTE IsPP = TRUE;  // si es PrimerPlano ¢ segundo plano.

    while( szColor[ i ] )
    {
        switch( szColor[ i ] )
        {
            case '+':
                bClr |= 8;
                break;

            case '*':
                bClr |= 128;
                break;

            case '/':
                IsPP = FALSE;
                break;

            default:
                bClr |=   IsPP  ? ucClr2Att( szColor[ i ] )
                                : ucClr2Att( szColor[ i ] ) * 16;

        }
        i++;
    }

    return bClr;
}

//---------------------------------------------------------------------------//

CLIPPER nColorToN()
{
   _retnl( ucColor2N( _parc( 1 ) ) );
}

//----------------------------------------------------------------------------//

CLIPPER nStrColor( void ) // ( szColor, nClrIndex )
{
    PCLIPVAR pClr    = _param( 1, CHARACTER );
    BOOL bNeedUnLock;
    char * szColor;
    WORD wStart      = 0;
    WORD wEnd        = 0;
    BYTE bEnd;
    WORD wAtt;

    if( ! pClr || _parclen( 1 ) == 0 )
    {
        _retni( 0 ); // Default Color.
        return;
    }

    bNeedUnLock = _VSTRLOCK( pClr );
    szColor   = _VSTR( pClr );

    wEnd = wStart = wScanSep( szColor, _parni( 2 ) );

    while( szColor[ wEnd ] && szColor[ wEnd ] != ',' )
        wEnd++;

    bEnd = szColor[ wEnd ];
    szColor[ wEnd ] = 0;

    _retni( ucColor2N( szColor + wStart ) );

    szColor[ wEnd ] = bEnd;

    if( bNeedUnLock )
       _VSTRUNLOCK( pClr );

}

//----------------------------------------------------------------------------//
