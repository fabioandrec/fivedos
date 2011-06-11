#include "FiveWin.ch"
#include "set.ch"
#include "FileIO.ch"


#define BEGINDOC  17
#define PAGEREC   18
#define PAGEITEM  19
#define ENDDOC    20


#define SAY_ROW    1
#define SAY_COL    2
#define SAY_TXT    3
#define SAY_TYP    4
#define SAY_WTH    5
#define SAY_CLR    6


static oPrinter

//----------------------------------------------------------------------------//

static procedure WriteRec( hFile, nRecord, cRecord )

    local cBuffer := chr( nRecord ) + I2Bin( Len( cRecord ) ) + cRecord

    FWrite( hFile, @cBuffer, len( cBuffer ) )

return

//---------------------------------------------------------------------------//

CLASS TPrinter

    DATA   hDC, hDCOut, hFile
    DATA   cFile, cDir, cDocument               AS Character
    DATA   nPage, nCopies, nXOffset, nYOffset   AS Numeric
    DATA   lMeta                                AS Logical
    DATA   aPage

    CLASSDATA nFileCount    INIT    110
    CLASSDATA aDocs         INIT {}
    CLASSDATA hTimer        AS Numeric
    CLASSDATA lPrinting     AS Logical

    METHOD New( cDocument, lUser, lMeta ) CONSTRUCTOR

    METHOD Begin()      INLINE  ::End(),;
                                if( !empty( ::hDC ),;
                                    ::hFile := FCreate( ::cDir + "\" + ;
                                                        ::cFile, FC_NORMAL ),),;
                                WriteRec( ::hFile, BEGINDOC, "" )

    METHOD StartPage()
    METHOD EndPage()

    METHOD End()


    METHOD Say( nRow, nCol, cText, oFont, nWidth, nClrText )

    METHOD Box( nRow, nCol, nBottom, nRight, oPen )     VIRTUAL
    METHOD SayBitmap( nRow, nCol, cBitmap, nWidth, nHeight, nRaster ) VIRTUAL
    METHOD Line( nTop, nLeft, nBottom, nRight, oPen )   VIRTUAL
    METHOD FillRect(aCols, oBrush)                     VIRTUAL
    METHOD Setup() VIRTUAL

    METHOD SetCopies( nCopies )      INLINE ::nCopies := max( 1, nCopies )


    METHOD  Preview():VIRTUAL,;
            ResetDC():VIRTUAL,;
            SetLandscape():VIRTUAL,;
            SetPortrait():VIRTUAL,;
            SetPos( nRow, nCol ):VIRTUAL

/*
   METHOD Cmtr2Pix(nRow, nCol) INLINE ;
          {Max( 0, (nRow*10*::nVertRes()/::nVertSize())-::nXoffset ) ,;
           Max( 0, (nCol*10*::nHorzRes()/::nHorzSize())-::nYoffset ) }

   METHOD Inch2Pix(nRow, nCol) INLINE ;
          {Max( 0, (nRow*::nVertRes()/(::nVertSize()/25.4))-::nXoffset ) ,;
           Max( 0, (nCol*::nHorzRes()/(::nHorzSize()/25.4))-::nYoffset ) }

   METHOD nVertRes()  INLINE  GetDeviceCaps( ::hDC, VERTRES  )
   METHOD nHorzRes()  INLINE  GetDeviceCaps( ::hDC, HORZRES  )

   METHOD nVertSize() INLINE  GetDeviceCaps( ::hDC, VERTSIZE )
   METHOD nHorzSize() INLINE  GetDeviceCaps( ::hDC, HORZSIZE )

   METHOD nLogPixelX() INLINE GetDeviceCaps( ::hDC, LOGPIXELSX )
   METHOD nLogPixelY() INLINE GetDeviceCaps( ::hDC, LOGPIXELSY )

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

   METHOD GetTextWidth( cText,oFont) INLINE ;
                          GetTextWidht(::hDC, cText, oFont:hFont)

   METHOD GetTextHeight( cText,oFont)    INLINE oFont:nHeight
*/

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cDocument, lUser, lMeta ) CLASS TPrinter

    local cPrinter

    DEFAULT lUser := .f.,;
            cDocument := "_FDosDoc"

    BYNAME lMeta IFNONIL

    if lUser // hDC es un objeto PrintDevice que contiene los datos propios de cada dispositivo
        ::hDC := GetPrintDC( GetActiveWindow() )
    else
        ::hDC := GetPrintDefault( GetActiveWindow() )
    endif

    ::cDocument := cDocument
    ::nCopies   := 1

    ::cDir   = AllTrim( if( !empty( GetEnv( "TEMP" ) ), GetEnv( "TEMP" ), Curdir() ) )

    if Right( ::cDir, 1 ) == "\"
        ::cDir = SubStr( ::cDir, 1, Len( ::cDir ) - 1 )
    endif

    ::cFile = rtrim( left( ::cDocument, 8 ) ) + "." + str( ++::nFileCount, 3 )

    ::Begin()
    
return Self

//----------------------------------------------------------------------------//

METHOD End() CLASS TPrinter

    if !empty( ::hFile )

        if !empty( ::aPage )
            ::EndPage()
        endif

        WriteRec( ::hFile, ENDDOC, "" )

        FClose( ::hFile )
        ::hFile = nil

    endif

return nil

//----------------------------------------------------------------------------//

METHOD StartPage() CLASS TPrinter

     ::EndPage()

     ::nPage++
     ::aPage = {}

return NIL

//----------------------------------------------------------------------------//

METHOD EndPage() CLASS TPrinter

    local cBuffer := ""

    if !empty( ::aPage )

        ASort( ::aPage,,, { |x,y| x[ SAY_ROW ] < y[ SAY_ROW ] } )

        aeval( ::aPage, {|o| cBuffer += chr( PAGEITEM ) + ;
                                        I2BIN( 6 + len( o[ SAY_TXT ] ) ) + ;
                                        I2BIN( o[ SAY_ROW ] ) + ;
                                        I2BIN( o[ SAY_COL ] ) + ;
                                        I2BIN( o[ SAY_TYP ] ) + ;
                                        o[ SAY_TXT ] } )
    endif

    ::aPage = nil

    WriteRec( ::hFile, PAGEREC, cBuffer )

return NIL

//----------------------------------------------------------------------------//

METHOD Say( nRow, nCol, cText, oFont, nWidth, nClrText ) CLASS TPrinter

    if ::aPage != NIL
        aadd( ::aPage, { nRow, nCol, cText, oFont, nWidth, nClrText } )
    endif

return nil

//---------------------------------------------------------------------------//

function PrintBegin( cDoc, lUser, lPreview )
return oPrinter := TPrinter():New( cDoc, lUser, lPreview )

function PageBegin() ; oPrinter:StartPage() ; return nil

function PageEnd() ; oPrinter:EndPage(); return nil

function PrintEnd()
     oPrinter:End()
     oPrinter := nil
return nil

//----------------------------------------------------------------------------//
