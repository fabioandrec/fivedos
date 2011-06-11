#include <ClipApi.h>
/*
#define DO_CASE       if(0){}
#define CASE(x)  else if(x)
#define ENDCASE       //
*/
static unsigned char ucRow0[] = "1234567890";
static unsigned char ucRow1[] = "QWERTYUIOP";
static unsigned char ucRow2[] = "ASDFGHJKL¥";
static unsigned char ucRow3[] = "ZXCVBNM";

//---------------------------------------------------------------------------//

int iAltToChr( int iKey )
{
   int iChar = 0;

   DO_CASE

      CASE( iKey >= 376 && iKey <= 385 )
         iChar = ucRow0[ iKey - 376 ];

      CASE( iKey >= 272 && iKey <= 281 )
         iChar = ucRow1[ iKey - 272 ];

      CASE( iKey >= 286 && iKey <= 294 )
         iChar = ucRow2[ iKey - 286 ];

      CASE( iKey >= 300 && iKey <= 306 )
         iChar = ucRow3[ iKey - 300 ];

   ENDCASE

   return iChar;
}


//----------------------------------------------------------------------------//

CLIPPER lAltChr() // ( nKey [ , @nKeyUpperSinAlt ] )
{
   int iKey = iAltToChr( _parni( 1 ) );

   if( _pcount > 1 )
        _storni( iKey, 2 );

   _retl( iKey > 0 );
}

//----------------------------------------------------------------------------//

CLIPPER cAlt2Chr() // ( nKey ) -> cKeyUpperSinAlt
{
    BYTE bChar = (BYTE) iAltToChr( _parni( 1 ) );
    _retclen( &bChar, 1 );
}

//---------------------------------------------------------------------------//

CLIPPER nAlt2Chr() // ( nKey ) -> nKeyUpperSinAlt
{
    _retni( iAltToChr( _parni( 1 ) ) );
}

//----------------------------------------------------------------------------//
