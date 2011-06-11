#include "FiveDos.ch"

// array definition for printer drivers
#include "PRNDef.ch"


//----------------------------------------------------------------------

CLASS TDevice

    DATA nHeight, nWidth    AS Numeric      INIT 1
    DATA cRight             AS Character    INIT "Fivetech (c) 1995 "
    DATA cTech              AS Character    INIT "PRINTER"


    METHOD New( cDevice ) INLINE Self

    METHOD  nVertSize():VIRTUAL,;
            nHorzSize():VIRTUAL,;
            nHorzRes():VIRTUAL,;
            nVertRes():VIRTUAL,;
            nNumBrushes():VIRTUAL,;
            nPixelx():VIRTUAL,;
            nPixelY():VIRTUAL,;
            SetVPExt( nWidth, nHeight ):VIRTUAL,;
            Refresh():VIRTUAL

    METHOD SetExt( nUnitsWidth, nUnitsHeight ) INLINE ;
                                    ::nWidth    := nUnitsWidth,;
                                    ::nHeight   := nUnitsHeight,;
                                    ::Refresh()

ENDCLASS

//---------------------------------------------------------------------------//
