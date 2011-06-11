#include <extend.h>

CLIPPER lMatchWild() // ( cPatron, cCadena, nMaxLen )
{
   byte * sPatron = _parc( 1 );
   byte * sCadena = _parc( 2 );
   quant  qLen    = _parni( 3 );
   quant  i       = 0;
   byte lRet      = FALSE;
   byte lSeguir   = TRUE;
   byte bPat;

   while( lSeguir && i < qLen )
   {
      bPat = sPatron[ i ];

      if( bPat == 42 )  // == "*"
      {
         lSeguir = FALSE;
         lRet    = TRUE;
      }
      else if( bPat != 63 ) // != "?"
      {
         lSeguir = ( bPat == sCadena[ i ] ? TRUE : FALSE );
         lRet    = lSeguir;
      }
      else 
        lRet = TRUE;

      ++i;
   }
   _retl( lRet );
}
