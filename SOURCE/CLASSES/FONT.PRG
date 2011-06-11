#include "FiveDos.ch"



#define ITALIC      16
#define BOLD        32
#define UNDERLINE   64
#define STREAKEOUT 128

//----------------------------------------------------------------------------//

CLASS TFont

   DATA   cFaceName
   DATA   hFont, hFontOld
   DATA   lBold, lItalic, lUnderline, lStrikeOut
   DATA   nHeight, nWidth, nEscapement, nOrientation, nWeight
   DATA   nCharSet, nOutPrecision, nClipPrecision, nQuality, nPitchFamily
   DATA   nCount
   DATA   lDestroy

   // s¢lo este valor descrive el caracter para el sistema de impresi¢n
   DATA   nDesc                         AS NUMERIC

   METHOD New( cFaceName, nWidth, nHeight, lFromUser,;
               lBold, nEscapement, nOrientation, nWeight, lItalic,;
               lUnderline, lStrikeOut, nCharSet, nOutPrecision,;
               nClipPrecision, nQuality, oDevice ) CONSTRUCTOR

   METHOD Choose( nRGBColor )   virtual

   METHOD End() Virtual

   METHOD Release() Virtual

   METHOD Activate( hDC ) Virtual

   METHOD DeActivate( hDC ) Virtual

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cFaceName, nWidth, nHeight, lFromUser, lBold,;
            nEscapement, nOrientation, nWeight, lItalic, lUnderline,;
            lStrikeOut, nCharSet, nOutPrecision, nClipPrecision,;
            nQuality, oDevice ) CLASS TFont


   // para asegurarnos que no pase ....
   lFromUser := .f.
   if lFromUser
    // montar un dialogo de eleccion de fuentes
    // podr¡a ser un arbolito ...
   endif

   if lBold
      nWeight = nOr( nWeight, BOLD )
   endif

   cFaceName := Upper(AllTrim(cFaceName))

   // ya veremos si se puede usar posteriormente
   /*
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
   ::nCount         = 0
   */
    BYNAME   cFaceName    DEFAULT "NORMAL"
    BYNAME   lBold        DEFAULT  .F.
    BYNAME   lItalic      DEFAULT  .F.
    BYNAME   lUnderLine   DEFAULT  .F.
    BYNAME   lStrikeOut   DEFAULT  .F.

    ::nHeight := 1
    do case
        case cFaceName ='NORMAL'
             ::nWidth := 1
             ::nDesc  := 0
        case cFaceName ='EXPANDED'
             ::nWidth := 2
             ::nDesc  := 1
        case cFaceName ='CONDENSED'
             ::nWidth := 0.5 // una aproximaci¢n, claro
             ::nDesc  := 3
        otherwise
             ::nWidth := 1 // por si no era eso :-))
             ::nDesc  := 0
    endcase
    if ::lItalic
        ::nDesc := nOR ( ::nDesc, ITALIC )
    endif
    if ::lBold
        ::nDesc := nOR ( ::nDesc, BOLD )
    endif
    if ::lUnderline
        ::nDesc := nOR ( ::nDesc, UNDERLINE )
    endif
    if ::lStrikeOut
        ::nDesc := nOR ( ::nDesc, STREAKEOUT )
    endif

return nil

