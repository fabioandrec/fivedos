// FiveDos LIB files management
// FiveDos LIB tools

#include "FiveDos.ch"
#include "FileIO.ch"
#include "FontDef.h"

//----------------------------------------------------------------------------//

function LibOpen( cLibName )

   local oWndLib, oLbx, oBrw, oBar
   local cNtxName, cAlias
   local nType
   local aModules := {}
   local aSizes   := {}
   local aOffsets := {}

   DEFAULT cLibName := cGetFile( "Library file ( *.lib ) | *.lib",;
                                 "Select a Library" )

   if ! File( cLibName )
      MsgStop( "I can't find " + cLibName )
      return nil
   endif

   CursorWait()

   if lLibOpen( cLibName )
      aModules = aLibModules()
      aOffsets = aLibOffset()
      aSizes   = aLibSizes()
      lLibClose()
      CursorHand()

   else
      CursorHand()
      Alert( "No se pudo abrir el archivo" )
      return nil
   endif


   DEFINE WINDOW oWndLib FROM 4, 4 TO 16, 59 ;
        TITLE "Library: " + cFName( cLibName ) ;
        NORESIZE

   BEGIN BROWSE oBrw ALIAS aModules
        COLUMN TITLE "Modulo" SHOW aModules[ oBrw:Cargo ] WIDTH 40
        COLUMN TITLE "Size" SHOW str( aSizes[ oBrw:Cargo ], 9 ) WIDTH 9
   ENDBROWSE


   @  0, 0 LISTBOX oLbx BROWSE oBrw ;
      LABEL "Module List"           ;
      LOGICLEN  Len( aModules )     ;
      ON DBLCLICK ObjExtrae( cLibName, ;
                             aModules[ oBrw:Cargo ], ;
                             aSizes[ oBrw:Cargo ],  ;
                             aOffsets[ oBrw:Cargo ] ) ;
      SIZE 54, 10                   ;
      OF oWndLib

   DEFINE BUTTONBAR oBar OF oWndLib

   DEFINE BUTTON PROMPT Chr( ARROWUPLEFT ) + CHR( ARROWUPRIGHT ) GROUP OF oBar ;
            WHILE PRESSED oLbx:GoUp(), MiliDelay( 100 )

   DEFINE BUTTON PROMPT Chr( ARROWDNLEFT ) + CHR( ARROWDNRIGHT )  OF oBar ;
            WHILE PRESSED oLbx:GoDown(), MiliDelay( 100 )


   ACTIVATE WINDOW oWndLib NOWAIT

return nil

//----------------------------------------------------------------------------//

static procedure ObjExtrae( cLibName, cModuleName, nSize, nOffset )

    local cBuffer, nHandle, cFileName

    nHandle = FOpen( cLibName, FO_READ )

    if nHandle != -1
        cBuffer = Space( nSize )
        FSeek( nHandle, nOffset, FS_SET )
        FRead( nhandle, @cBuffer, nSize )

        FClose( nHandle )

        cFileName = alltrim( cFName( cModuleName ) ) + ".obj"

        nHandle   = FCreate( cFileName, FC_NORMAL )
        FWrite( nHandle, cBuffer, nSize )
        FClose( nHandle )

    endif

return

//---------------------------------------------------------------------------//
