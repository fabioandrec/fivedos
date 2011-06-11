#include "FiveDos.ch"

// clase general de device
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

#ifndef NOGDICAPMASKS

#define MM_TEXT             1
#define MM_LOMETRIC         2
#define MM_HIMETRIC         3
#define MM_LOENGLISH        4
#define MM_HIENGLISH        5
#define MM_TWIPS            6
#define MM_ISOTROPIC        7
#define MM_ANISOTROPIC      8

// array definition for printer drivers
#include "PRNDef.ch"


//----------------------------------------------------------------------

Function GetDeviceCaps( oDevice, nMode )
    local xRet := 0
    do case
        case nMode = DRIVERVERSION
            xRet := oDevice:cRIGHT
        case nMode = TECHNOLOGY
            xRet := oDevice:cTech
        case nMode = HORZSIZE
            xRet := oDevice:nHSize()
        case nMode =  VERTSIZE
            xRet := oDevice:nVSize()
        case nMode =  HORZRES
            xRet := oDevice:nhRes()
        case nMode =  VERTRES
            xRet := oDevice:nvRes()
        case nMode =  NUMBRUSHES
            xRet := oDevice:NumBrushes()
        case nMode =  NUMPENS
            xRet := oDevice:NumPens()
        case nMode =  LOGPIXELSX
            xRet := oDevice:nPixelx()
        case nMode =  LOGPIXELSY
            xRet := oDevice:nPixely()
    endcase
return xRet


//--------------------------------------------------------------------//
// De momento ...
Function SetMapMode( hDC, nMode )
    // :-))
Return NIL


//-------------------------------------------------------------------//
Function SetWindowExt( hDC, nUnitsWidth, nUnitsHeight )
return  hDc:SetExt( nUnitsWidth, nUnitsHeight )


//------------------------------------------------------------------//
Function SetViewPortExt( hDC, nWidth, nHeight )
return  hDc:SetVPExt( nWidth, nHeight )

