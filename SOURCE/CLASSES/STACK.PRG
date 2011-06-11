#include "Fivedos.ch"

#define MAXLENARRAY   4096

//---------------------------------------------------------------------------//

CLASS TStack

    METHOD Push( uVal )  INLINE if( ::lFull(),, aAdd( Self, uVal ) )
    METHOD Top()         INLINE aTail( Self )
    METHOD lEmpty()      INLINE Empty( Self )
    METHOD lFull()       INLINE ( len( Self ) == MAXLENARRAY )
    METHOD lFound( uVal, lExact ) INLINE !Empty( nFound( uVal, lExact ) )
    METHOD nFound( uVal, lExact ),;
           Pop( n )

ENDCLASS

//---------------------------------------------------------------------------//
// NOT INLINE FOR SPEED
// Para un array con distintos tipos de valores, hay que utilizar el sig. codeblock
// local bBlock := {|e| valtype( e ) == valtype( uVal ) .And. e == uVal }

METHOD nFound( uVal, lExact )

  local nRet

    DEFAULT lExact := .t.

    lExact := Set( _SET_EXACT, lExact )
    nRet   := aScan( Self, uVal )
    Set( _SET_EXACT, lExact )

Return nRet

//---------------------------------------------------------------------------//

METHOD Pop( n )

  local uRet

    if !Empty( Self )
       if IS_NUMBER( n )
          if !Empty( n ) .and. n <= len( Self )
             uRet := Self[ n ]
             aDel( Self, n )
             aSize( Self, len( Self ) - 1 )
          end
       else
          uRet := aTail( Self )
          aSize( Self, len( Self ) - 1 )
       end
    end

Return uRet

//---------------------------------------------------------------------------//
