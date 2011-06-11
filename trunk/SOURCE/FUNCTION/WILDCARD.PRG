/*
   Funcion que devuelve .t. si cFileName encaja en la plantilla DOS de
   cWildCard.
*/


FUNCTION lWildCard ( cWildCard, cFileName )
RETURN ( lMatchWild( cFName( cWildCard ), cFName( cFileName ), 8 ) .and. ;
         lMatchWild( cFExt( cWildCard ),  cFExt( cFileName ) , 3 ) )

// lMatchWild es funci¢n C en lMatchwc.c
