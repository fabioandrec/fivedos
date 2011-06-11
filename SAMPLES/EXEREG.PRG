//----------------------------------------------------------------------------//
//  FiveDos 1.0 - Tutorial ExeReg - Demo
//  (c) A.Linares, F.Pulp¢n 1994
//
//  Contruir con BUILD ExeReg
//  To Build:    BUILD ExeReg
//----------------------------------------------------------------------------//

#include "FiveDos.ch"

static oWnd

//----------------------------------------------------------------------------//

function Main()

   DEFINE WINDOW oWnd FROM 1, 1 TO 22, 75 ;
      TITLE OemToAnsi( "FiveDos Exe Registration Program" ) ;
      MENU  BuildMenu()

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( "FiveDos 1.0, (c) A.Linares & F.Pulp¢n, 1994" )

   ACTIVATE WINDOW oWnd

return

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM "&Acerca de..." ;
                ACTION MsgInfo( "(C) A.Linares, F.Pulp¢n 1994", "FiveDos 1.0" ) ;

      MENUITEM "&Salir" ACTION If( MsgYesNo( OemToAnsi( "¨ Desea terminar la Ejecuci¢n ?" ), ;
                                             "Seleccione, por favor" ), ;
                                   oWnd:End(),)

      MENUITEM "&Registrar Exe" ACTION RegisterExe()

   ENDMENU

return oMenu

//----------------------------------------------------------------------------//
