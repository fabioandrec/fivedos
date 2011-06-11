#include "FiveWin.ch"

#define HORZSIZE            4
#define VERTSIZE            6
#define HORZRES             8
#define VERTRES            10
#define LOGPIXELSX         88
#define LOGPIXELSY         90

#define MM_TEXT             1
#define MM_LOMETRIC         2
#define MM_HIMETRIC         3
#define MM_LOENGLISH        4
#define MM_HIENGLISH        5
#define MM_TWIPS            6
#define MM_ISOTROPIC        7
#define MM_ANISOTROPIC      8

static oPrinter

//----------------------------------------------------------------------------//

CLASS TPrinter

   DATA   hDC
   DATA   cDevice, cDriver, cPort
   DATA   nPage
   DATA   lPreview

   METHOD New( cDocument, lUser ) CONSTRUCTOR
   METHOD NewMeta() CONSTRUCTOR

   METHOD StartPage() INLINE  StartPage( ::hDC )

   METHOD EndPage()   INLINE  EndPage( ::hDC )

   METHOD End()       INLINE  If( ::hDC != 0, ( EndDoc( ::hDC ),;
                              DeleteDC( ::hDC ), ::hDC := 0 ),)

   METHOD Say( nRow, nCol, cText, oFont )

   METHOD SetPos( nRow, nCol )  VIRTUAL
   METHOD Line( nRow, nCol )    VIRTUAL

   METHOD Box( nRow, nCol, nBottom, nRight ) INLINE ;
                      Rectangle( ::hDC, nRow, nCol, nBottom, nRight )

   METHOD nVertRes()  INLINE  GetDeviceCaps( ::hDC, VERTRES  )
   METHOD nHorzRes()  INLINE  GetDeviceCaps( ::hDC, HORZRES  )

   METHOD nVertSize() INLINE  GetDeviceCaps( ::hDC, VERTSIZE )
   METHOD nHorzSize() INLINE  GetDeviceCaps( ::hDC, HORZSIZE )

   METHOD nLogPixelsX() INLINE GetDeviceCaps( ::hDC, LOGPIXELSX )
   METHOD nLogPixelsY() INLINE GetDeviceCaps( ::hDC, LOGPIXELSY )

   METHOD SetPixelMode()  INLINE SetMapMode( ::hDC, MM_TEXT )
   METHOD SetTwipsMode()  INLINE SetMapMode( ::hDC, MM_TWIPS )

   METHOD SetLoInchMode() INLINE SetMapMode( ::hDC, MM_LOENGLISH )
   METHOD SetHiInchMode() INLINE SetMapMode( ::hDC, MM_HIENGLISH )

   METHOD SetLoMetricMode() INLINE SetMapMode( ::hDC, MM_LOMETRIC )
   METHOD SetHiMetricMode() INLINE SetMapMode( ::hDC, MM_HIMETRIC )

   METHOD SetIsotropicMode()   INLINE SetMapMode( ::hDC, MM_ISOTROPIC )
   METHOD SetAnisotropicMode() INLINE SetMapMode( ::hDC, MM_ANISOTROPIC )

   METHOD SetWindowExt( nUnitsWidth, nUnitsHeight ) INLINE ;
                        SetWindowExt( ::hDC, nUnitsWidth, nUnitsHeight )

   METHOD SetViewPortExt( nWidth, nHeight ) INLINE ;
                          SetViewPortExt( ::hDC, nWidth, nHeight )

   METHOD GetTextWidth(cText,oFont) INLINE GetTextWidht(::hDC, cText, oFont:hFont)

   METHOD GetTextHeight(cText,oFont) INLINE oFont:nHeight


ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cDocument, lUser ) CLASS TPrinter

   local cPrinter

   DEFAULT lUser := .f.

   if lUser
      ::hDC = GetPrintDC( GetActiveWindow() )
   else
      cPrinter  = GetProfString( "windows", "device", ",,," )
      ::cDevice = StrToken( cPrinter, 1, "," )
      ::cDriver = StrToken( cPrinter, 2, "," )
      ::cPort   = StrToken( cPrinter, 3, "," )
      ::hDC     = CreateDC( ::cDriver, ::cDevice, ::cPort )
   endif

   if ::hDC != 0
      StartDoc( ::hDC, cDocument )
   else
      MsgAlert( "Printer not ready!" )
   endif

   ::nPage    := 1
   ::lPreview := .F.

return nil

//----------------------------------------------------------------------------//
METHOD NewMeta() CLASS TPrinter

     ::nPage    := 0
     ::lPreview := .T.

return nil


METHOD StartPage() CLASS TPrinter

     IF ::lPreview
          ::hDC := CreateMetaFile("tmp"+StrZero(++::nPage,4) ".mtf")
     ELSE
          StartPage(::hDc)

     ENDIF

Return NIL

METHOD EndPage() CLASS TPrinter

     IF ::lPreview
          ::hDC := CloseMetaFile(::hDC)
     ELSE
          EndPage(::hDc)

     ENDIF

Return NIL

//----------------------------------------------------------------------------//

METHOD Say( nRow, nCol, cText, oFont ) CLASS TPrinter

   if oFont != nil
      oFont:Activate( ::hDC )
   endif

   TextOut( ::hDC, nRow, nCol, cText )

   if oFont != nil
      oFont:DeActivate( ::hDC )
   endif

return nil

//----------------------------------------------------------------------------//

function PrintBegin( cDoc, lUser )
return oPrinter := TPrinter():New( cDoc, lUser )

function PageBegin() ; oPrinter:StartPage() ; return nil

function PageEnd() ; oPrinter:EndPage(); return nil

function PrintEnd() ; oPrinter:End() ; oPrinter := nil; return nil

//----------------------------------------------------------------------------//
