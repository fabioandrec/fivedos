#include "FiveDos.ch"

//----------------------------------------------------------------------------//

function aStr2Arr( cList, cSep )

   local nPos, aList := {}

   DEFAULT cSep := ","

   while ( nPos := At( cSep, cList ) ) != 0
         aAdd( aList, SubStr( cList, 1, nPos - 1 ) )
         cList = SubStr( cList, nPos + 1 )
   end

   aAdd( aList, cList )

return aList

//----------------------------------------------------------------------------//

function cArr2Str( aList, cSep )

   local i, cList := ''

   DEFAULT cSep  := ","

   for i = 1 to Len( aList )
       cList += aList[ i ] + cSep
   next

return SubStr( cList, 1, Len( cList ) - Len( cSep ) )

//----------------------------------------------------------------------------//

