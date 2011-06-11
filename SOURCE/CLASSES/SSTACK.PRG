#include "Fivedos.ch"

//---------------------------------------------------------------------------//

CLASS TSStack FROM TStack

    METHOD Push( uVal ),;
           Pop( n ),;
           nFound( uVal, lExact )

    METHOD Top( p )  INLINE if( Empty( p:= len( Self ) ),, Self[ p ]:Top() )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD Push( uVal )

   local p:= len( Self )

   if Empty( p ) .or. Self[ p ]:lFull()
      aAdd( Self, TStack() )
      p++
   end

Return Self[ p ]:Push( uVal )

//---------------------------------------------------------------------------//

METHOD Pop( n )

  local p:= len( Self ),;
        uVal

  if !Empty( p )
     uVal := Self[ p ]:Pop( n )
     if Self[ p ]:lEmpty()
        aSize( Self, --p )
     end
  end

Return uVal

//---------------------------------------------------------------------------//

METHOD nFound( uVal, lExact )

  local i, nRet := 0

  for i = 1 to len( Self )
      if !Empty( nRet := Self[ i ]:nFound( uVal, lExact ) )
         exit
      end
  next

Return nRet

//---------------------------------------------------------------------------//
