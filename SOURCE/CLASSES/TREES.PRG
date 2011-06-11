// Trees management for Clipper !!!

#include "FiveDos.ch"

static aTrees := {}
static nLevel := 0

static cBmpOpen, cBmpClose

//----------------------------------------------------------------------------//

function TreeBegin( cBmp1, cBmp2 )

   local oTree := TLinkList()

   AAdd( aTrees, oTree )
   nLevel++

   if !empty( cBmp1 )
    cBmpOpen := cBmp1
   end
   if !empty( cBmp2 )
    cBmpClose := cBmp2
   end

return oTree

//----------------------------------------------------------------------------//

function _TreeItem( cPrompt, cBmpOpen, cBmpClose, lOpened )


return ATail( aTrees ):Add( cPrompt, nLevel, cBmpOpen, cBmpClose, lOpened )

//----------------------------------------------------------------------------//

function TreeEnd()

   local oTree := ATail( aTrees )
   local oItem

   if Len( aTrees ) > 1
      ASize( aTrees, Len( aTrees ) - 1 )
      oItem = ATail( aTrees ):oLast
      oItem:oTree = oTree
      if empty(oItem:cBmpOpen)
         oItem:cBmp1:=cBmpOpen
         oItem:cBmpOpen  := If( !Empty( cBmpOpen ) .and. File( cBmpOpen ),;
                                ReadBitmap( cBmpOpen ) , ' ' )
      endif
      if empty(oItem:cBmpClose)
         oItem:cBmp2 = cBmpClose
         oItem:cBmpClose := If( !Empty( cBmpClose ) .and. File( cBmpClose ),;
                                ReadBitmap( cBmpClose ) , ' ' )
      endif
      oTree:oFirst:oPrev = ATail( aTrees ):oLast
   else
      aTrees = {}
   endif

   nLevel--

return nil

//----------------------------------------------------------------------------//
