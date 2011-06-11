#include <ClipApi.h>

extern BYTE _locase( BYTE bChar );
extern BYTE _upcase( BYTE bChar );

extern LPSTR far pascal _VSTRX( PCLIPVAR );

//----------------------------------------------------------------------------//

void PropName( LPSTR szName )
{
   if( szName && *szName )
   {
      szName[ 0 ] = _upcase( szName[ 0 ] );

      while( * ( ++szName ) )
         * szName = _locase( * szName );
   }
}

//----------------------------------------------------------------------------//

CLIPPER PROPNAME( void ) // ( cName ) -> cName convierte contendo de la var en Proper Name
{
    PCLIPVAR pName = _param( 1, CHARACTER );

    if( pName )
    {
        PropName( _VSTRX( pName ) );
        * _eval = * pName;
    }
}

//---------------------------------------------------------------------------//
