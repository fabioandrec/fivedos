#include "FiveDos.ch"

#define ID_EMPTY      Chr( 32 )
#define ID_VERTLINE   Chr( 179 )
#define ID_VERTHORZ   Chr( 195 )
#define ID_CORNLINE   Chr( 192 )
#define ID_VERTHORZP  Chr( 198 )
#define ID_VERTHORZM  Chr( 195 )
#define ID_CORNLINEP  Chr( 192 )
#define ID_CORNLINEM  Chr( 192 )

static aLines

//----------------------------------------------------------------------------//

CLASS TTreeItem

   DATA   cDraw, cPrompt
   DATA   oPrev, oNext
   DATA   oTree
   DATA   lOpened
   DATA   nLevel
   DATA   cBmpOpen, cBmpClose
   DATA   cBmp1, cBmp2

   METHOD New( cPrompt, nLevel, cBmpOpen, cBmpClose ) CONSTRUCTOR

   METHOD Open() INLINE ;
                  If( ! ::lOpened .and. ::oTree != nil, ::lOpened := .t.,)

   METHOD Close() INLINE  If( ::lOpened, ::lOpened := .f.,)

   METHOD Skip( @n )

   METHOD GetNext() INLINE If( ::lOpened, ::oTree:oFirst, ::oNext )
   METHOD GetPrev()

   METHOD GetText() INLINE If( ::oTree != nil .and. ::lOpened, " - ", ;
                           If( ::oTree != nil, " + ", "   " ) ) + ::cDraw + ::cPrompt

   METHOD GetLabel()

   METHOD Draw( cPrevDraw )

   METHOD SetNext( oItem ) INLINE ::oNext := oItem,;
          If( ::oTree != nil, ::oTree:oLast:SetNext( oItem ),)

   METHOD Toggle() INLINE If( ::lOpened, ::Close(), ::Open() )

   METHOD ColSizes()

   METHOD Add( cPrompt )

   METHOD Delete() INLINE ::oPrev:oNext := ::oNext, ::Destroy()

   METHOD Destroy() INLINE if( !Empty( ::cBmp ), ;
                                ReleaseChars( ::cBmp ), ),;
                           if( !Empty( ::cBmp2 ), ;
                                ReleaseChars( ::cBmp2 ), )

   METHOD SetText( cPrompt ) INLINE ::cPrompt := cPrompt

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cPrompt, nLevel, cBmp1, cBmp2 ) CLASS TTreeItem


   ::cDraw     = ""
   ::cPrompt   = cPrompt
   ::lOpened   = .f.
   ::nLevel    = nLevel
    DEFAULT cBmp2 := ::cBmp1

    ::cBmp2 := cBmp2

    ::cBmpOpen  := If( !Empty( cBmp1 ) .and. File( cBmp1 ),;
                                ReadBitmap( cBmp1 ),' ' )

    ::cBmpClose := If( !Empty( cBmp2 ) .and. File( cBmp2 ),;
                                ReadBitmap( cBmp2 ) ,' ' )

return nil

//----------------------------------------------------------------------------//

METHOD Skip( n ) CLASS TTreeItem

   local nCount := 0
   local oItem  := Self

   if n > 0
      while nCount < n .and. oItem:GetNext() != nil
          oItem = oItem:GetNext()
          nCount++
      end
      n = nCount
   endif

   if n < 0
      while nCount < -n .and. oItem:GetPrev() != nil
         oItem = oItem:GetPrev()
         nCount++
      end
      n = -nCount
   endif

return oItem

//----------------------------------------------------------------------------//

METHOD GetPrev() CLASS TTreeItem

   if ::oPrev != nil
      if ::oPrev:nLevel < ::nLevel
         return ::oPrev
      else
         if ::oPrev:lOpened
            return ::oPrev:oTree:GetLast()
         else
            return ::oPrev
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Draw( cPrevDraw ) CLASS TTreeItem

   DEFAULT cPrevDraw := ""

   ::cDraw = cPrevDraw + ;
             If( ::oPrev != nil,;
             If( ::oNext != nil .and. ::oNext:nLevel == ::nLevel,;
             If( ::oTree != nil,;
             If( ::lOpened, ID_VERTHORZM, ID_VERTHORZP ), ID_VERTHORZ ),;
             If( ::oTree != nil,;
             If( ::lOpened, ID_CORNLINEM, ID_CORNLINEP ), ID_CORNLINE ) ),;
             ID_VERTHORZ )

   If ::oTree != nil
      ::oTree:Draw( cPrevDraw + If( ::oNext != nil,;
                    If( ::oNext:nLevel < ::nLevel,;
                        ID_VERTHORZ, ID_VERTLINE ),;
                        ID_EMPTY ) )
   endif
//   ::cDraw := ::cDraw + ::cPrompt
return ::cDraw

//----------------------------------------------------------------------------//

METHOD GetLabel() CLASS TTreeItem
    Local cText := ''

    if empty( ::cDraw )
        ::Draw()
    end
    cText := ::cDraw+if( ::lOpened, ::cBmpClose, ::cBmpOpen) + ::cPrompt
return cText

//----------------------------------------------------------------------------//

METHOD ColSizes() CLASS TTreeItem

   local aCols := Array( ::nLevel + 1 )

   AFill( aCols, 16 )
   AAdd( aCols, 300 )

return aCols

//----------------------------------------------------------------------------//

METHOD Add( cPrompt ) CLASS TTreeItem

   local oItem := TTreeItem():New( cPrompt, ::nLevel )
   local oPrev

   oItem:oPrev   = Self
   oItem:oNext   = ::oNext
   if ::oTree != nil
      ::oTree:oLast:oNext = oItem
   endif
   ::oNext = oItem

   while ( oPrev := ::GetPrev() ):nLevel >= ::nLevel
   end

   oPrev:oTree:oLast = oItem

return oItem

//----------------------------------------------------------------------------//
