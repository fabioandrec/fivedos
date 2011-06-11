#include "FiveDos.ch"
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

/* Device Parameters for GetDeviceCaps() */
#define DRIVERVERSION 0
#define TECHNOLOGY    2
#define HORZSIZE      4
#define VERTSIZE      6
#define HORZRES       8
#define VERTRES       10
#define BITSPIXEL     12
#define PLANES        14
#define NUMBRUSHES    16
#define NUMPENS       18
#define NUMMARKERS    20
#define NUMFONTS      22
#define NUMCOLORS     24
#define PDEVICESIZE   26
#define CURVECAPS     28
#define LINECAPS      30
#define POLYGONALCAPS 32
#define TEXTCAPS      34
#define CLIPCAPS      36
#define RASTERCAPS    38
#define ASPECTX       40
#define ASPECTY       42
#define ASPECTXY      44

#define LOGPIXELSX    88
#define LOGPIXELSY    90

#define SIZEPALETTE  104
#define NUMRESERVED  106
#define COLORRES     108

#define MM_TEXT             1
#define MM_LOMETRIC         2
#define MM_HIMETRIC         3
#define MM_LOENGLISH        4
#define MM_HIENGLISH        5
#define MM_TWIPS            6
#define MM_ISOTROPIC        7
#define MM_ANISOTROPIC      8


static oPrinter

//---------------------------------------------------------------------------//

CLASS TPrinter

    DATA   hDC, hDCOut, hFile
    DATA   cFile, cDir, cDocument               AS Character
    DATA   nPage, nCopies, nXOffset, nYOffset   AS Numeric
    DATA   lMeta                                AS Logical
    DATA   aPage, aMetaFile

    CLASSDATA nFileCount            INIT    110
    CLASSDATA aDocs                 INIT {}
    CLASSDATA hTimer, hFileSpool, nPageIndex, nPageLen    AS Numeric
    CLASSDATA lWorking             AS Logical


    METHOD New( cDocument, lUser, lMeta ) CONSTRUCTOR

    METHOD Begin()      INLINE  ::End(),;
                                if( !empty( ::hDC ),;
                                    ::hFile := FCreate( ::cDir + "\" + ;
                                                        ::cFile, FC_NORMAL ),),;
                                WriteRec( ::hFile, BEGINDOC, "" )

    METHOD StartPage(),;
           EndPage(),;
           AddDocToSpool( cDocFile ),;
           End( lPrintNow ),;
           Say( nRow, nCol, cText, oFont, nWidth, nClrText )

    METHOD Box( nRow, nCol, nBottom, nRight, oPen )
    METHOD SayBitmap( nRow, nCol, cBitmap, nWidth, nHeight, nRaster ) VIRTUAL
    METHOD Line( nTop, nLeft, nBottom, nRight, oPen )
    METHOD FillRect(aCols, oBrush)
    METHOD Setup()                                      VIRTUAL

    METHOD SetCopies( nCopies )     INLINE ::nCopies := max( 1, nCopies )


    METHOD  Preview():VIRTUAL,;
            ResetDC():VIRTUAL,;
            SetLandscape():VIRTUAL,;
            SetPortrait():VIRTUAL,;
            SetPos( nRow, nCol ):VIRTUAL


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

   METHOD GetTextWidth( cText, oFont ) INLINE ;
                        if( !empty( cText ), len( cText ), 0 )

   METHOD GetTextHeight( cText,oFont)    INLINE oFont:nHeight

   METHOD SpoolTic()

   METHOD lPrinting() INLINE !empty( ::aDocs )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cDocument, lUser, lMeta ) CLASS TPrinter

    local cPrinter

    DEFAULT lUser := .f.,;
            cDocument := "_FDosDoc"

    BYNAME lMeta IFNONIL

    if lUser // hDC es un objeto PrintDevice que contiene los
        // datos propios de cada dispositivo

        // ::hDC := GetPrintDC() // Dialog Box to select printer.
        ::hDC := GetPrintDefault( )
    else
        ::hDC := GetPrintDefault( )
    endif

    ::cDocument := cDocument
    ::nCopies   := 1

    ::cDir   = AllTrim( if( !empty( GetEnv( "TEMP" ) ), GetEnv( "TEMP" ), Curdir() ) )

    if Right( ::cDir, 1 ) == "\"
        ::cDir = SubStr( ::cDir, 1, Len( ::cDir ) - 1 )
    endif

    if ::lMeta
        ::aMetaFile = {}
    endif

    ::cFile = rtrim( left( ::cDocument, 8 ) ) +'.'+ str( ++::nFileCount, 3 )

    ::Begin()
    
return Self

//----------------------------------------------------------------------------//

METHOD AddDocToSpool( cDocFile )

    aadd( ::aDocs, cDocFile )

    if empty( ::hTimer )
        DEFINE  TIMER ::hTimer ;
                INTERVAL 250 ;
                ACTION ::SpoolTic()

        ACTIVATE TIMER ::hTimer
    endif

return nil

//----------------------------------------------------------------------------//

METHOD End( lPrintDocNow ) CLASS TPrinter

    DEFAULT lPrintDocNow := .t.

    if !empty( ::hFile )

        if !empty( ::aPage )

            ::EndPage()
        endif

        WriteRec( ::hFile, ENDDOC, "" )

        FClose( ::hFile )

        ::hFile = NIL

        if lPrintDocNow
            ::AddDocToSpool( ::cDir + "\" + ::cFile )
        endif

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

        if ::lMeta
            aadd( ::aMetaFile, ::aPage )
        endif

    endif


    ::aPage = nil

    WriteRec( ::hFile, PAGEREC, cBuffer )

return NIL

//----------------------------------------------------------------------------//

METHOD Say( nRow, nCol, cText, oFont, nWidth, nClrText ) CLASS TPrinter

    if ::aPage != NIL .and. !empty( cText )
        aadd( ::aPage, { nRow, nCol, cText, oFont, nWidth, nClrText } )
    endif

return nil


//---------------------------------------------------------------------------//

// only vertical u horizontal
METHOD Line( nTop, nLeft, nBottom, nRight, oPen )
    Local n

    if ! nTop = nBottom
           for n:= nTop to nBottom
                ::Say( n, nLeft, substr(oPen:cStyle,4,1) )
           next
        else
            ::Say( nTop, nLeft, replicate(substr(oPen:cStyle,2,1),nRight-nLeft+1 ) )
    end

return nil

//---------------------------------------------------------------------------//

METHOD Box( nRow, nCol, nBottom, nRight, oPen )
    local n
    // Top Line
    ::Say( nRow, nCol, left(oPen:cStyle,1)+;
        replicate(substr(oPen:cStyle,2,1),nRight-nCol-1 )+;
        substr(oPen:cStyle,3,1) )

    for n:= nRow +1 to nBottom -1
        ::say(n,nCol,substr(oPen:cStyle,4,1))
        ::say(n,nRight,substr(oPen:cStyle,8,1))
    next

    ::Say( nBottom, nCol, substr(oPen:cStyle,7,1)+;
        replicate(substr(oPen:cStyle,6,1),nRight-nCol-1 )+;
        substr(oPen:cStyle,5,1) )
return nil
// _______________________________________________________________________//


METHOD FillRect(aCols, oBrush)
    local n

    for n:= aCols[1] to aCols[3] step if(aCols[1]>aCols[3],1,-1)
        ::Say( n, aCols[2], replicate(oBrush:cStyle,aCols[4]-aCols[2]+1 ) )
    next

return nil



METHOD SpoolTic()

    local hFile, nRecId := 0, nRecLen, cText, nRow, nCol, nType

    if ::lWorking
        return nil
    endif

    ::lWorking = .t.

    if empty( ::hFileSpool )
        if empty( ::aDocs )
            RELEASE TIMER ::hTimer
            ::hTimer = 0
        else
            if ( hFile := FoPen( ::aDocs[ 1 ], FO_READ + FO_EXCLUSIVE ) ) != -1
                ::hFileSpool = hFile
            else // ERROR
                ::lWorking = .f.
                return nil
            endif
        endif

    else
        hFile = ::hFileSpool
    endif

    while FError() == 0 .and. ::hDC:Flush( 1, .f. ) .and. !empty( hFile )

        SysRefresh()

        nRecId  = nGetByte( hFile )
        nRecLen = nGetWord( hFile )

        do case
            case nRecId == BEGINDOC

            case nRecId == PAGEREC
                 ::nPageLen   = nRecLen
                 ::nPageIndex = 0

            case nRecId == PAGEITEM
                 ::nPageIndex += nRecLen + 1

                 cText := space( nRecLen - 6 )

                 nRow  := nGetWord( hFile )
                 nCol  := nGetWord( hFile )
                 nType := nGetWord( hFile )

                 if nRecLen - 6 > 0
                    FRead( hFile, @cText, nRecLen - 6 )
                 endif


                 ::hDC:Say( nRow, nCol, cText, nType )
                 if ::nPageIndex >= ::nPageLen
                    ::hDC:Eject()
                    hFile = 0
                 endif


            case nRecId == ENDDOC
                ::hDC:Eject()
                FClose( hFile )
                FErase( ::aDocs[ 1 ] )
                aDel( ::aDocs, 1 )
                aSize( ::aDocs, len( ::aDocs ) - 1 )
                ::hFileSpool := hFile := 0
        endcase
    end

    ::lWorking = .f.

return nil
//---------------------------------------------------------------------------//

function PrintBegin( cDoc, lUser, lPreview )
return oPrinter := TPrinter():New( cDoc, lUser, lPreview )

//----------------------------------------------------------------------------//

procedure PageBegin() ; oPrinter:StartPage() ; return

//----------------------------------------------------------------------------//

procedure PageEnd() ; oPrinter:EndPage(); return

//----------------------------------------------------------------------------//

procedure PrintEnd() ; oPrinter:End() ; oPrinter := nil ; return

//----------------------------------------------------------------------------//

static function nGetByte( hFile )
    local cByte := " "
return If( FRead( hFile, @cByte, 1 ) == 1, Asc( cByte ), -1 )

//---------------------------------------------------------------------------//

static function nGetWord( hFile )
    local cWord := " "
return If( FRead( hFile, @cWord, 2 ) == 2, Bin2I( cWord ), -1 )

//----------------------------------------------------------------------------//

static function WriteRec( hFile, nRecId, cRecord )

    local cBuffer := chr( nRecId ) + I2Bin( Len( cRecord ) ) + cRecord

return FWrite( hFile, @cBuffer, len( cBuffer ) ) == len( cBuffer )

//---------------------------------------------------------------------------//

function nLPTWrite( nPort, cBuffer )

    local nBytes := 0

    while lLPTReady( nPort ) .and. nBytes < len( cBuffer )
        nLPTSend( nPort, substr( cBuffer, ++nBytes, 1 ) )
        MiliDelay( 1 )
    end

return nBytes

//---------------------------------------------------------------------------//
