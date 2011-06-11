#include <ClipApi.h>

CLIPPER nValType( void ) { _retnl( _param( 1, ALLTYPES )->wType ); }

CLIPPER lCharacter( void ) { _retl( _param( 1, CHARACTER )->wType ); }
CLIPPER lNumber( void )    { _retl( _param( 1, ANYNUMBER )->wType ); }
CLIPPER lLogical( void )   { _retl( _param( 1, LOGICAL )->wType ); }
CLIPPER lDate( void )      { _retl( _param( 1, DATE )->wType ); }
CLIPPER lBlock( void )     { _retl( _param( 1, BLOCK )->wType ); }

CLIPPER lObject( void )
{ 
   PCLIPVAR pvar = _param( 1, OBJECT );
   _retl( pvar->wType && _VDict( pvar ) );
}

CLIPPER lArray( void )
{ 
   PCLIPVAR pvar = _param( 1, ARRAY );
   _retl( pvar->wType && !_VDict( pvar ) );
}

//----------------------------------------------------------------------------//
