// LinkLists in Clipper !!!

#include "FiveDos.ch"

//----------------------------------------------------------------------------//

CLASS TLinkList

   DATA   oFirst, oLast

   METHOD Add( cPrompt, nLevel, hBmpOpen, hBmpClose, lOpened )
   METHOD OpenAll()
   METHOD GetLast()
   METHOD nCount()
   METHOD Draw( cPrevDraw )

   MESSAGE Eval METHOD _Eval( bAction )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Add( cPrompt, nLevel, hBmpOpen, hBmpClose, lOpened ) CLASS TLinkList

   local oItem

   DEFAULT lOpened := .f., nLevel := If( ::oFirst != nil, ::oFirst:nLevel,)

   oItem := TTreeItem():New( cPrompt, nLevel, hBmpOpen, hBmpClose )

   if ::oFirst == nil
      ::oFirst = oItem
      ::oLast  = oItem
   else
      ::oLast:SetNext( oItem )
      oItem:oPrev   = ::oLast
      ::oLast       = oItem
   endif

   oItem:lOpened = lOpened

return oItem

//----------------------------------------------------------------------------//

METHOD OpenAll() CLASS TLinkList

   local oItem := ::oFirst

   while oItem != nil
      oItem:Open()
      oItem = oItem:GetNext()
   end

return nil

//----------------------------------------------------------------------------//

METHOD GetLast() CLASS TLinkList

   if ::oLast:lOpened
      return ::oLast:oTree:GetLast()
   else
      return ::oLast
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Draw( cPrevDraw ) CLASS TLinkList

   local oItem := ::oFirst

   while oItem != nil
      oItem:Draw( cPrevDraw )
      oItem = If( oItem:oNext != nil .and. ;    // Don't use GetNext()
                  oItem:oNext:nLevel == oItem:nLevel,;
                  oItem:oNext, nil )
   end

return nil

//----------------------------------------------------------------------------//

METHOD nCount() CLASS TLinkList

   local oItem  := ::oFirst
   local nItems := 0

   while oItem != nil
      nItems++
      oItem = oItem:GetNext()
   end

return nItems

//----------------------------------------------------------------------------//

METHOD _Eval( bAction ) CLASS TLinkList

   local oItem := ::oFirst

   while oItem != nil
      Eval( bAction, oItem )
      oItem = If( oItem:oTree != nil, oItem:oTree:oFirst, oItem:oNext )
   end

return nil

//----------------------------------------------------------------------------//
