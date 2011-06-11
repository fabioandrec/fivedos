#include <ClipApi.h>
extern LPSTR pascal _VSTRX( PCLIPVAR vString );

//---------------------------------------------------------------------------//

CLIPPER PasswordSt( void ) // r( cString, nPasswordChar ) -> cPasswordString
{
    LPBYTE pString = _parc( 1 );
    WORD wLen      = _parclen( 1 );
    WORD wChar     = _parni( 2 );

    if( ! wChar )
        wChar = '*';

    if( wLen )
    {
        LPBYTE pTarget;
        WORD wIndex;
        BOOL bUnLock;

        _BYTESNEW( wLen );

        bUnLock  = _VSTRLOCK( _eval );
        pTarget  = _VSTRX( _eval );

        for( wIndex = 0 ; wIndex < wLen; wIndex++ )
            pTarget[ wIndex ] = IF( pString[ wIndex ] == ' ', ' ', wChar );

        if( bUnLock )
            _VSTRUNLOCK( _eval );

    }
    else
        _retc( "" );
}

//---------------------------------------------------------------------------//
