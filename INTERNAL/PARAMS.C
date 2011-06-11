#include <ClipApi.h>


//---------------------------------------------------------------------------//

static int _ParamCount( PCLIPVAR pBase )
{
    return (int) ( (BYTE) ( pBase->w3 ) );
}

//---------------------------------------------------------------------------//

CLIPPER ParamCount( void ) // nProcDeep
{
    _retni( _ParamCount( _ActInfo( 1 + _parni( 1 ) ) ) );
}

//---------------------------------------------------------------------------//

static void _GetParam( WORD wProcDeep, WORD wParmIndex )
{
    PCLIPVAR pBase     = _ActInfo( wProcDeep );

    if( pBase )
    {
        WORD wPCount       = _ParamCount( pBase );
        PCLIPVAR pParam    = IF( wParmIndex <= wPCount, pBase + 1 + wParmIndex, 0 );

        if( pParam )
            _bcopy( (LPBYTE) _eval, (LPBYTE) pParam, sizeof( CLIPVAR ) );
        else
            _eval->wType = 0;
    }
}

//---------------------------------------------------------------------------//

CLIPPER Param( void )  // nParamIndex
{
   _GetParam( 1, _parni( 1 ) );
}

//---------------------------------------------------------------------------//

CLIPPER GetParam( void ) // nProcDeep, nParamIndex
{
    _GetParam( 1 + _parni( 1 ), _parni( 2 ) );
}

//---------------------------------------------------------------------------//

static int _LocalCount( WORD wProcDeep )
{
    PCLIPVAR pBase     = _ActInfo( wProcDeep );
    WORD wLocals       = 0;

    if( pBase )
    {
        WORD wPCount       = _ParamCount( pBase );
        PCLIPVAR pStack    = IF( wProcDeep, _ActInfo( wProcDeep - 1 ), _tos ) - 1;

        wLocals = ( pStack - pBase ) - wPCount - 1;
    }

    return wLocals;
}

//---------------------------------------------------------------------------//

CLIPPER LocalCount( void ) // nProcDeep
{
    _retni( _LocalCount( 1 + _parni( 1 ) ) );
}

//---------------------------------------------------------------------------//

static void _GetLocal( WORD wProcDeep, WORD wLocalIndex )
{
    PCLIPVAR pBase     = _ActInfo( wProcDeep );

    if( pBase )
    {
        WORD wPCount       = _ParamCount( pBase );
        PCLIPVAR pStack    = IF( wProcDeep, _ActInfo( wProcDeep - 1 ), _tos ) - 1;
        WORD wLocals       = ( pStack - pBase ) - wPCount - 1;
        PCLIPVAR pLocal    = IF( wLocalIndex <= wLocals, pBase + 1 + wPCount + wLocalIndex, 0 );

        if( pLocal )
            _bcopy( (LPBYTE) _eval, (LPBYTE) pLocal, sizeof( CLIPVAR ) );
        else
            _eval->wType = 0;
    }

}

//---------------------------------------------------------------------------//

CLIPPER GetLocal( void ) // nProcDeep, nLocalIndex
{
    _GetLocal( 1 + _parni( 1 ), _parni( 2 ) );
}

//---------------------------------------------------------------------------//
