#include "FiveDos.ch"

#define nActual oSay:Cargo[ 1 ]
#define nTotal  oSay:Cargo[ 2 ]
#define nTemp   oSay:Cargo[ 3 ]

//----------------------------------------------------------------------------//

function Calc( oWnd )

   local oSay
   
   DEFINE DIALOG oWnd ;
     AT 2, 2 SIZE 21, 14 ;
     TITLE "Calculadora" ;
     OF oWnd

   SetKey( K_ENTER, { || __KeyBoard( "=" ) } )

   @  0, 1 SAY oSay ;
      PROMPT Transform( 0, "@E 9,999,999,999,999" ) COLOR "W+/B" ;
      OF oWnd

   oSay:bGetText = { || Transform( nTemp, "@E 9,999,999,999,999" ) }
   oSay:Cargo    = { 0, 0, 0 }

   @  2,  0 BUTTON " &/ " OF oWnd ACTION ( nTotal /= nActual, nActual := 0, nTemp := nTotal, oSay:Refresh() )
   @  2,  5 BUTTON " &* " OF oWnd ACTION ( nTotal *= nActual, nActual := 0, nTemp := nTotal, oSay:Refresh() )
   @  2, 10 BUTTON " &- " OF oWnd ACTION ( nTotal -= nActual, nActual := 0, nTemp := nTotal, oSay:Refresh() )
   @  2, 15 BUTTON " &+ " OF oWnd ACTION ( nTotal += nActual, nActual := 0, nTemp := nTotal, oSay:Refresh() )
   @  4,  0 BUTTON " &7 " OF oWnd ACTION Key( 7, oSay )
   @  4,  5 BUTTON " &8 " OF oWnd ACTION Key( 8, oSay )
   @  4, 10 BUTTON " &9 " OF oWnd ACTION Key( 9, oSay )
   @  4, 15 BUTTON " &C " OF oWnd ACTION ( nActual := 0, nTemp := nActual, oSay:Refresh() )
   @  6,  0 BUTTON " &4 " OF oWnd ACTION Key( 4, oSay )
   @  6,  5 BUTTON " &5 " OF oWnd ACTION Key( 5, oSay )
   @  6, 10 BUTTON " &6 " OF oWnd ACTION Key( 6, oSay )
   @  6, 15 BUTTON " &A " OF oWnd ACTION ( nActual := 0, nTotal := 0, nTemp := 0, oSay:Refresh() )
   @  8,  0 BUTTON " &1 " OF oWnd ACTION Key( 1, oSay )
   @  8,  5 BUTTON " &2 " OF oWnd ACTION Key( 2, oSay )
   @  8, 10 BUTTON " &3 " OF oWnd ACTION Key( 3, oSay )
   @  8, 15 BUTTON " &P " OF oWnd ACTION ( oWnd:End(), KeyPlus( AllTrim( Str( nTotal ) ) ) )
   @ 10,  0 BUTTON " &0      " OF oWnd ACTION Key( 0, oSay )
   @ 10, 10 BUTTON " &. " OF oWnd ACTION ( nActual *= 1.0, nTemp := nActual, oSay:Refresh() )
   @ 10, 15 BUTTON " &= " OF oWnd ACTION ( nActual := nTotal, nTotal := 0, nTemp := nActual, oSay:Refresh() )

   ACTIVATE WINDOW oWnd NOWAIT

return nil

//----------------------------------------------------------------------------//

static procedure Key( n, oSay )

   if nActual < 1000000000000
      nActual = ( nActual * 10 ) + n
      nTemp = nActual
      oSay:Refresh()
   endif

return

//----------------------------------------------------------------------------//
