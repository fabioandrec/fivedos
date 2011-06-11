//----------------------------------------------------------------------------//
//  FiveDos - Test Non Modal windows
//  (c) FiveDos Team 1995
//
//----------------------------------------------------------------------------//

#include "FiveDos.ch"
#include "SysStr.ch"  // Usa SysLanguage()
#include "ctlalign.ch"

#define GETMEM()   Memory( 0 ) // BliMemAvl()

static oWnd

//----------------------------------------------------------------------------//

function Main()

   SysLanguage( SLG_SPANISH ) // Lenguaje de sistema de FiveDos.

   DEFINE WINDOW oWnd FROM 1, 1 TO 22, 75 ;
      TITLE "Construyendo cajas no modales" + str( GETMEM() ) ;
      MENU  BuildMenu()

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT )

   ACTIVATE WINDOW oWnd MAXIMIZED ON CLICK msginfo( STR( winversion() ) + str( winmode() ) ) // oWnd:Cascade()

return nil

//----------------------------------------------------------------------------//

function BuildMenu()

   local oMenu

   MENU oMenu
      MENUITEM OemToAnsi( "&Informaci¢n" )
      MENU
         MENUITEM "&Acerca de..." ;
            ACTION MsgInfo( OemToAnsi( "Tutorial de FiveWin" + CRLF + CRLF + ;
                            FDCOPYRIGHT ) ) ;
            MESSAGE OemToAnsi( "Informaci¢n acerca de este programa" )
         SEPARATOR
         MENUITEM "&Terminar..."  ;
            ACTION If( MsgYesNo( OemToAnsi( "¨ Desea terminar ?" ) ),;
                       oWnd:End(),) ;
            MESSAGE OemToAnsi( "Terminar la ejecuci¢n de este programa" )
      ENDMENU

      MENUITEM "&No Modal" ;
          MESSAGE "Construye una nueva caja no modal" ;
          ACTION NoModal()

      MENUITEM "&Cascade" ;
          MESSAGE "Pone las ventanas en cascada" ;
          ACTION oWnd:Cascade()
   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

function NoModal()

   static n := 0

   local oWNM, oLbx, oBrw

   USE Dialog.dbf READONLY SHARED NEW ALIAS ( "DLOG" + padl( alltrim( str( n++ ) ), 6, "0" ) )

   DEFINE WINDOW oWNM FROM 3, 6 TO 20, 70 ;
          TITLE "FiveDOS Control aligment test" ;
          NOSHADOW

   oWNM:Cargo := Select()

   SET MESSAGE OF oWNM ;
      TO OemToAnsi( FDCOPYRIGHT ) ;
      CENTERED
      
   @ 0, 0 SAY str( oWNM:Cargo, 4 ) ;
        CENTERED ;
        OF oWNM
   aTail( oWNM:oClient:aChilds ):nAlign := ALIGN_TOP

   @ 0, 0 SAY " I'm ; Left " ;
        CENTERED ;
        COLOR "W+/B" ;
        OF oWNM
   aTail( oWNM:oClient:aChilds ):nAlign := ALIGN_LEFT

   @ 0, 0 SAY " I'm ; Right " ;
        CENTERED ;
        COLOR "W+/G" ;
        OF oWNM
   aTail( oWNM:oClient:aChilds ):nAlign := ALIGN_RIGHT

   @ 0, 0 SAY "I'm Bottom" ;
        CENTERED ;
        OF oWNM
   aTail( oWNM:oClient:aChilds ):nAlign := ALIGN_BOTTOM

   BEGIN BROWSE oBrw COLOR "W+/W, W+/N, W/N"                  // Browse Colors
        COLUMN TITLE "Nombre"  SHOW ( oWNM:Cargo )->Name
        COLUMN TITLE "Level"   SHOW ( oWNM:Cargo )->Level
   ENDBROWSE

   oBrw:SkipBlock := { | n | ( oWNM:Cargo )->( _DbSkipper( n ) ) }

   @  10,  10 LISTBOX oLbx BROWSE oBrw           ;
            LOGICLEN ( oWNM:Cargo )->( RecCount() )     ;
            OF oWNM
   oLbx:nAlign := ALIGN_CLIENT

   oWnd:cTitle := "Construyendo cajas no modales" + str( GETMEM() )

   ACTIVATE WINDOW oWNM NOWAIT



return nil

//----------------------------------------------------------------------------//
