// Funciones para evaluaci¢n de codeblocks en bucles.

#include <ClipApi.h>

extern void _evStrobe( void ); // Trinca teclas ALt-c,...
                               // para poder salir de un bucle mal hecho...

static BOOL bExit = FALSE;

//---------------------------------------------------------------------------//

static void PushLocalByRef( PCLIPVAR pVar )
{
    ( ++_tos )->wType = BY_REF;
    _tos->pPointer1 = (void far *) pVar;
}

// -------------------------------------------------------------------------- //

static void _PushParam( int iParam )
{
    // Si se han recibido parametros para el codeblock.
    for( ; iParam <= _pcount; iParam++ )
    {
        * ( ++_tos ) = * ( _lbase + iParam + 1 );
        // _bcopy( ( LPBYTE ) ++_tos, ( LPBYTE ) _param( iParam, ALLTYPES ), sizeof( CLIPVAR ) );
    }
}

// -------------------------------------------------------------------------- //

CLIPPER EvalWhile() // bBlock, bWhile, uParam1, uParam2, ...
{
    PCLIPVAR bBlock  = _param( 1, BLOCK );
    PCLIPVAR bWhile  = _param( 2, BLOCK );
    int iParam, iEvent = 0;

    bExit = FALSE;

    if( !bWhile || !bBlock )
        return ; // <<------------  EXIT

    for( ; ; )
    {
        _cEval0( bWhile );
        if( !( ( CLV_WORD * ) _eval )->wWord || bExit )
            break;

        _PutSym( _SymEval );
        _xPushM( bBlock );
        _PushParam( 3 );
        _xEval( _pcount - 2 );

        if( ++iEvent > 10 )
        {
            _evStrobe();
            iEvent = 0;
        }
    }

    bExit = FALSE;
}

// -------------------------------------------------------------------------- //

CLIPPER EvalUntil() // bBlock, bUntil, uParam1, uParam2, ...
{
    PCLIPVAR bBlock  = _param( 1, BLOCK );
    PCLIPVAR bUntil  = _param( 2, BLOCK );
    int iParam, iEvent = 0;

    bExit = FALSE;

    if( !bBlock )
        return ;

    for( ; ; )
    {
        _PutSym( _SymEval );
        _xPushM( bBlock );
        _PushParam( 3 );
        _xEval( _pcount - 2 );

        _cEval0( bUntil );
        if( ( ( CLV_WORD * ) _eval )->wWord  || bExit )
            break;

        if( ++iEvent > 10 )
        {
            _evStrobe();
            iEvent = 0;
        }
    }

    bExit = FALSE;

}

// -------------------------------------------------------------------------- //

CLIPPER EvalFor() // bBlock, nInit, nEnd, nStep, uParam1, uParam2, ...
{
    PCLIPVAR bBlock  = _param( 1, BLOCK );
    LONG lEnd        = _parnl( 3 );
    LONG lStep       = _parnl( 4 );
    int  iEvent      = 0;
    PCLIPVAR pInit   = _param( 2, NUMERIC );
    LPLONG   plInit;

    bExit = FALSE;

    if( ! bBlock || !pInit )
        return ;   // <<------------- EXIT

    plInit = (LPLONG) &pInit->pPointer1;

    if( !lStep )    // Set default value to one.
        lStep = 1;

    for( ; !bExit && IF( lStep > 0, *plInit <= lEnd, *plInit >= lEnd ); *plInit += lStep )
    {
        _PutSym( _SymEval );
        _xPushM( bBlock );
        PushLocalByRef( pInit );
        _PushParam( 5 );
        _xEval( 1 + IF( _pcount < 4, 0, _pcount - 4 ) );

        if( ++iEvent > 10 )
        {
            _evStrobe();
            iEvent = 0;
        }
    }

    bExit = FALSE;
}

// -------------------------------------------------------------------------- //

CLIPPER EvalExit( void )
{
    bExit = TRUE;
}

//---------------------------------------------------------------------------//
