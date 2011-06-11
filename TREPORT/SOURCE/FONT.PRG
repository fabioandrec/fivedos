#include "FiveDos.ch"

#define FW_NORMAL 400
#define FW_BOLD   700

//----------------------------------------------------------------------------//

CLASS TFont

   DATA   cFaceName
   DATA   hFont, hFontOld
   DATA   lBold, lItalic, lUnderline, lStrikeOut
   DATA   nHeight, nWidth, nEscapement, nOrientation, nWeight
   DATA   nCharSet, nOutPrecision, nClipPrecision, nQuality, nPitchFamily

   METHOD New( cFaceName, nWidth, nHeight, lFromUser,;
               lBold, nEscapement, nOrientation, nWeight, lItalic,;
               lUnderline, lStrikeOut, nCharSet, nOutPrecision,;
               nClipPrecision, nQuality, oDevice ) CONSTRUCTOR

   METHOD Choose( nRGBColor )     // passed by reference

   METHOD End() INLINE If( ::hFont != 0, DeleteObject( ::hFont ),),;
                           ::hFont := 0

   METHOD Release() INLINE If( ::hFont != 0, DeleteObject( ::hFont ),),;
                           ::hFont := 0

   METHOD Activate( hDC ) INLINE ::hFontOld := SelectObject( hDC, ::hFont )

   METHOD DeActivate( hDC ) INLINE  SelectObject( hDC, ::hFontOld )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cFaceName, nWidth, nHeight, lFromUser, lBold,;
            nEscapement, nOrientation, nWeight, lItalic, lUnderline,;
            lStrikeOut, nCharSet, nOutPrecision, nClipPrecision,;
            nQuality, oDevice ) CLASS TFont

   local aFont, nRGBColor

   DEFAULT nEscapement := 0, nOrientation := 0, nWeight := 0, nHeight := 14,;
           lItalic := .f., lFromUser := .f., lUnderLine := .f.,;
           lStrikeOut := .f., nCharSet := 0, nOutPrecision := 0,;
           nClipPrecision := 0, nQuality := 0, lBold := .f.

   if lFromUser
      aFont     = ChooseFont( , @nRGBColor )
      lFromUser = ! Empty( aFont[ LF_FACENAME ] )
      aFont[ LF_HEIGHT ] = Int( aFont[ LF_HEIGHT ] * 10 / 13 )
   endif

   if lBold
      nWeight = nOr( nWeight, FW_BOLD )
   endif

   ::cFaceName      = If( lFromUser, aFont[ LF_FACENAME ], cFaceName )
   ::nHeight        = If( lFromUser, aFont[ LF_HEIGHT ], nHeight )
   ::nWidth         = If( lFromUser, aFont[ LF_WIDTH ], nWidth )
   ::nEscapement    = If( lFromUser, aFont[ LF_ESCAPEMENT ], nEscapement )
   ::nOrientation   = If( lFromUser, aFont[ LF_ORIENTATION ], nOrientation )
   ::nWeight        = If( lFromUser, aFont[ LF_WEIGHT ], nWeight )
   ::lBold          = If( lFromUser, ! ( ::nWeight == FW_NORMAL ), lBold )
   ::lItalic        = If( lFromUser, aFont[ LF_ITALIC ], lItalic )
   ::lUnderLine     = If( lFromUser, aFont[ LF_UNDERLINE ], lUnderLine )
   ::lStrikeOut     = If( lFromUser, aFont[ LF_STRIKEOUT ], lStrikeOut )
   ::nCharSet       = If( lFromUser, aFont[ LF_CHARSET ], nCharSet )
   ::nOutPrecision  = If( lFromUser, aFont[ LF_OUTPRECISION ], nOutPrecision )
   ::nClipPrecision = If( lFromUser, aFont[ LF_CLIPPRECISION ], nClipPrecision )
   ::nQuality       = If( lFromUser, aFont[ LF_QUALITY ], nQuality )
   ::nPitchFamily   = If( lFromUser, aFont[ LF_PITCHANDFAMILY ], 0 )
   ::hFontOld       = 0

   if oDevice != nil
      ::nHeight = ( oDevice:nLogPixelsY() / 72 ) * ::nHeight
   endif

   if ::cFaceName != "System"
      ::hFont = CreateFont( { ::nHeight, ::nWidth, ::nEscapement,;
                              ::nOrientation, ::nWeight, ::lItalic,;
                              ::lUnderLine, ::lStrikeOut, ::nCharSet,;
                              ::nOutPrecision, ::nClipPrecision,;
                              ::nQuality, ::nPitchFamily, ::cFaceName } )
   endif

   if ::nHeight < 0
      ::nHeight = Abs( ::nHeight )
      ::nWidth  = ::nHeight * 0.44
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Choose( nRGBColor ) CLASS TFont

   local aFont := ChooseFont( { ::nHeight, ::nWidth, ::nEscapement,;
                                ::nOrientation, ::nWeight, ::lItalic,;
                                ::lUnderLine, ::lStrikeOut, ::nCharSet,;
                                ::nOutPrecision, ::nClipPrecision,;
                                ::nQuality, ::nPitchFamily, ::cFaceName },;
                               @nRGBColor )

   ::cFaceName      = aFont[ LF_FACENAME ]
   ::nHeight        = aFont[ LF_HEIGHT ]
   ::lBold          = ! ( ::nWeight == FW_NORMAL )
   ::nWidth         = aFont[ LF_WIDTH ]
   ::nEscapement    = aFont[ LF_ESCAPEMENT ]
   ::nOrientation   = aFont[ LF_ORIENTATION ]
   ::nWeight        = aFont[ LF_WEIGHT ]
   ::lItalic        = aFont[ LF_ITALIC ]
   ::lUnderLine     = aFont[ LF_UNDERLINE ]
   ::lStrikeOut     = aFont[ LF_STRIKEOUT ]
   ::nCharSet       = aFont[ LF_CHARSET ]
   ::nOutPrecision  = aFont[ LF_OUTPRECISION ]
   ::nClipPrecision = aFont[ LF_CLIPPRECISION ]
   ::nQuality       = aFont[ LF_QUALITY ]
   ::nPitchFamily   = aFont[ LF_PITCHANDFAMILY ]

   if ::cFaceName != "System"
      if ! Empty( ::hFont )
         DeleteObject( ::hFont )
      endif
      ::hFont = CreateFont( { ::nHeight, ::nWidth, ::nEscapement,;
                              ::nOrientation, ::nWeight, ::lItalic,;
                              ::lUnderLine, ::lStrikeOut, ::nCharSet,;
                              ::nOutPrecision, ::nClipPrecision,;
                              ::nQuality, ::nPitchFamily, ::cFaceName } )
   endif

return Self            //  returns a reference to the Object

//----------------------------------------------------------------------------//

function ChooseFont()

return nil

//----------------------------------------------------------------------------//
