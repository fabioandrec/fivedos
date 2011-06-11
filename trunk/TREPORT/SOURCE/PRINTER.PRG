#include "FiveDos.ch"

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

   DATA   hDC, hDCOut
   DATA   aMeta, aPalettes
   DATA   cDevice, cDriver, cPort, cDir, cDocument
   DATA   nPage
   DATA   lMeta,

   METHOD New( cDocument, lUser, lMeta ) CONSTRUCTOR

   MESSAGE StartPage() VIRTUAL // METHOD _StartPage()
   MESSAGE EndPage() INLINE DevOut( Chr( 18 ) ) // METHOD _EndPage()

   METHOD End()

   METHOD Say( nRow, nCol, cText, oFont, nWidth, nClrText )

   METHOD SayBitmap( nRow, nCol, cBitmap, nWidth, nHeight, nRaster )

   METHOD SetPos( nRow, nCol )  INLINE DevPos( nRow, nCol ) // MoveTo( ::hDCOut, nCol, nRow )

   METHOD Line( nTop, nLeft, nBottom, nRight, oPen ) INLINE ;
                      DevPos( nTop, nLeft )
                      // LineTo( ::hDCOut, nRight, nBottom,;
                      //        iif(oPen != NIL, oPen:hPen ,0 ) )

   /*
   METHOD Box( nRow, nCol, nBottom, nRight, oPen ) INLINE
                      // Rectangle( ::hDCOut, nRow, nCol, nBottom, nRight,;
                      //           iif(oPen != NIL, oPen:hPen ,0 ) )
   */

   METHOD Cmtr2Pix(nRow, nCol) INLINE ;
               ({nRow*10*::nVertRes()/::nVertSize(), ;
                 nCol*10*::nHorzRes()/::nHorzSize()})

   METHOD Inch2Pix(nRow, nCol) INLINE ;
               ({nRow*::nVertRes()/(::nVertSize()/25.4), ;
                 nCol*::nHorzRes()/(::nHorzSize()/25.4) })

   METHOD nVertRes()  INLINE  GetDeviceCaps( ::hDC, VERTRES  )
   METHOD nHorzRes()  INLINE  GetDeviceCaps( ::hDC, HORZRES  )

   METHOD nVertSize() INLINE  GetDeviceCaps( ::hDC, VERTSIZE )
   METHOD nHorzSize() INLINE  GetDeviceCaps( ::hDC, HORZSIZE )

   METHOD nLogPixelsX() INLINE GetDeviceCaps( ::hDC, LOGPIXELSX )
   METHOD nLogPixelsY() INLINE GetDeviceCaps( ::hDC, LOGPIXELSY )

   // METHOD SetPixelMode()  INLINE SetMapMode( ::hDC, MM_TEXT )
   // METHOD SetTwipsMode()  INLINE SetMapMode( ::hDC, MM_TWIPS )

   // METHOD SetLoInchMode() INLINE SetMapMode( ::hDC, MM_LOENGLISH )
   // METHOD SetHiInchMode() INLINE SetMapMode( ::hDC, MM_HIENGLISH )

   // METHOD SetLoMetricMode() INLINE SetMapMode( ::hDC, MM_LOMETRIC )
   // METHOD SetHiMetricMode() INLINE SetMapMode( ::hDC, MM_HIMETRIC )

   // METHOD SetIsotropicMode()   INLINE SetMapMode( ::hDC, MM_ISOTROPIC )
   // METHOD SetAnisotropicMode() INLINE SetMapMode( ::hDC, MM_ANISOTROPIC )

   METHOD SetWindowExt( nUnitsWidth, nUnitsHeight ) INLINE ;
                        SetWindowExt( ::hDC, nUnitsWidth, nUnitsHeight )

   METHOD SetViewPortExt( nWidth, nHeight ) INLINE ;
                          SetViewPortExt( ::hDC, nWidth, nHeight )

   METHOD GetTextWidth( cText, oFont ) INLINE Len( cText )
                          // GetTextWidht( ::hDC, cText, oFont:hFont )

   METHOD GetTextHeight(cText,oFont) INLINE oFont:nHeight

   METHOD Preview() INLINE iif(::lMeta, RPreview(Self), )

   MESSAGE FillRect(aCols, oBrush)  VIRTUAL // METHOD _FillRect(aCols, oBrush)

   METHOD SetLandscape() VIRTUAL // INLINE PrnLandscape( ::hDC )
   METHOD SetPortrait()  VIRTUAL // INLINE PrnPortrait( ::hDC )

   METHOD SetCopies( nCopies ) VIRTUAL // INLINE PrnSetCopies( ::hDC, nCopies )

   METHOD Setup() INLINE PrinterSetup()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cDocument, lUser, lMeta ) CLASS TPrinter

   local cPrinter

   DEFAULT lUser := .f. ,;
           lMeta := .f.

   if lUser
      // ::hDC = GetPrintDC( GetActiveWindow() )
   else
      /*
      cPrinter  = GetProfString( "windows", "device", ",,," )
      ::cDevice = StrToken( cPrinter, 1, "," )
      ::cDriver = StrToken( cPrinter, 2, "," )
      ::cPort   = StrToken( cPrinter, 3, "," )
      ::hDC   = CreateDC( ::cDriver, ::cDevice, ::cPort )
      */
   endif

   if ::hDC != 0
     if !lMeta
      SET DEVICE TO PRINTER
      // StartDoc( ::hDC, cDocument )
     endif
   else
      MsgAlert( "Printer not ready!" )
   endif

   ::cDocument := cDocument
   ::nPage     := 0
   ::lMeta     := lMeta

   if !lMeta
     ::hDcOut = ::hDC
   else
     ::aMeta  = {}
     ::cDir   = iif(!empty(GetEnv("TEMP")), GetEnv("TEMP"), Curdir())
     if Right( ::cDir, 1 ) == "\"
        ::cDir = SubStr( ::cDir, 1, Len( ::cDir ) - 1 )
     endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS TPrinter


     If ::hDC != 0
          if !::lMeta
             SET DEVICE TO SCREEN
               // EndDoc(::hDC)
          endif
          // DeleteDC(::hDC)
          ::hDC := 0
     endif

     If ::lMeta
        SET DEVICE TO SCREEN
          // EndDoc(::hDCOut)
          // DeleteDC(::hDCOut)
          ::hDCOut := 0
     endif

Return NIL

//----------------------------------------------------------------------------//

METHOD _StartPage() CLASS TPrinter

     ::nPage++

     if ::lMeta
          AAdd(::aMeta,::cDir+"\tmp"+Padl(::nPage,4,"0")+".wmf")
          ::hDCOut := CreateMetaFile(Atail(::aMeta))
     else
          StartPage(::hDC)
     endif

Return NIL

//----------------------------------------------------------------------------//

METHOD _EndPage() CLASS TPrinter

   if ::lMeta
      ::hDCOut := DeleteMetaFile( CloseMetaFile( ::hDCOut ) )
   else
      // EndPage( ::hDC )
   endif

Return NIL

//----------------------------------------------------------------------------//

METHOD Say( nRow, nCol, cText, oFont, nWidth, nClrText ) CLASS TPrinter

   if oFont != nil
      oFont:Activate( ::hDCOut )
   endif

   // SetbkMode( ::hDCOut, 1 )               // transparent

   if nClrText != nil
      SetTextColor( ::hDCOut, nClrText )
   endif

   DevPos( nRow, nCol )
   DevOut( cText )
   // TextOut( ::hDCOut, nRow, nCol, cText )

   if oFont != nil
      oFont:DeActivate( ::hDCOut )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SayBitmap( nRow, nCol, cBitmap, nWidth, nHeight, nRaster ) CLASS TPrinter

   local hDib, hPal

   if File( cBitmap )
      hDib = DibRead( cBitmap )
      if ! ::lMeta
         hPal = DibPalette( hDib )
      endif
      DibDraw( ::hDCOut, hDib, hPal, nRow, nCol, nWidth, nHeight, nRaster )
      GlobalFree( hDib )
      if ! ::lMeta
         DeleteObject( hPal )
      endif
   endif

RETURN NIL

//----------------------------------------------------------------------------//

METHOD _FillRect (aCols, oBrush) CLASS TPrinter

     FillRect(::hDCOut ,aCols, oBrush:hBrush)

RETURN NIL

//----------------------------------------------------------------------------//

function PrintBegin( cDoc, lUser, lPreview )
return oPrinter := TPrinter():New( cDoc, lUser, lPreview )

function PageBegin() ; oPrinter:StartPage() ; return nil

function PageEnd() ; oPrinter:EndPage(); return nil

function PrintEnd()

     IF oPrinter:lMeta
          oPrinter:Preview()
     ELSE
          oPrinter:End()
     ENDIF

     oPrinter := nil

return nil

//----------------------------------------------------------------------------//

function RPreview()

return nil

//----------------------------------------------------------------------------//
