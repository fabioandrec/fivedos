#include <ClipApi.h>

extern CLIPPER __str1( void );
extern CLIPPER __ltrim( void );
extern CLIPPER __dtoc( void );

//----------------------------------------------------------------------------//

CLIPPER cValToChar() // ( uVal [ , lNoTrimNumbers ] )
{
   if( ( _lbase + 2 )->wType & ( CHARACTER | ANYNUMBER | DATE ) )
        _bcopy( ( LPBYTE ) ( ++_tos ), ( LPBYTE ) ( _lbase + 2 ), 14 );
   
   switch( ( _lbase + 2 )->wType )
   {
      case CHARACTER:
           break;
           
      case NUMERIC:
      case NUM_FLOAT:
           __str1();

           if( !_parl( 2 ) )
                __ltrim();
           break;

       case DATE:
           __dtoc();
           break;

       case LOGICAL:
            _PutC( _parl( 1 ) ? ".T.": ".F." );
            break;

       default:
           _PutC( "" );
   }

   _bcopy( ( LPBYTE ) ( _eval ), ( LPBYTE ) ( _tos-- ), 14 ); }

//----------------------------------------------------------------------------//
