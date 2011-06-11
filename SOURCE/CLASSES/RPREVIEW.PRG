#include "FiveDOS.ch"
#include "FontDef.h"

#define SAY_ROW    1
#define SAY_COL    2
#define SAY_TXT    3
#define SAY_TYP    4
#define SAY_WTH    5
#define SAY_CLR    6

static oWnd, nPage, oDevice

//---------------------------------------------------------------------------//

function RPreView( oDev )

    local oBar

    oDevice = oDev

    oDevice:End( .f. ) // End print task but not add Doc to print que.

    nPage := 1

    DEFINE WINDOW oWnd ;
            FROM  0, 0 TO ScrMaxRow(), ScrMaxCol() ;
            VSCROLL HSCROLL SIZE oDevice:nHorzSize(), oDevice:nVertSize() ;
            TITLE "FiveDOS Report PreView" ;
            NORESIZE ;
            NODRAG ;
            MENU PreViewMenu()

    SET MESSAGE OF oWnd TO "FiveDOS Report PreView"

    DEFINE BUTTONBAR oBar OF oWnd

    DEFINE BUTTON OF oBar ;
           LABEL chr( BORDERRIGHT ) + " " ;
           MESSAGE "Ir a la primera p gina" ;
           ACTION TopPage()

    DEFINE BUTTON OF oBar ;
           LABEL "  " ;
           MESSAGE "Ir a la p gina anterior" ;
           ACTION PrevPage()

    DEFINE BUTTON OF oBar ;
           LABEL "  " ;
           MESSAGE "Ir a la p gina siguiente" ;
           ACTION NextPage()

    DEFINE BUTTON OF oBar ;
            LABEL " " + chr( BORDERLEFT ) ;
            MESSAGE "Ir a la £ltima p gina" ;
            ACTION BottomPage()

    ACTIVATE WINDOW oWnd ;
        ON PAINT ShowPage() ;


return nil

//---------------------------------------------------------------------------//

static function PreViewMenu()

    local oMenu

    MENU oMenu
          MENUITEM "Archivo"
          MENU
               MENUITEM "&Imprimir" ACTION PrintDoc() ;
                    MESSAGE "Imprime el documento"

               SEPARATOR

               MENUITEM "&Salir" ACTION oWnd:End() ;
                    MESSAGE "Salir de la previsualizaci¢n"
          ENDMENU

          MENUITEM "&P gina"
          MENU
               MENUITEM "&Primera" ACTION TopPage() ;
                    MESSAGE "Ir a la primera p gina"

               MENUITEM "Pre&via" ACTION PrevPage() ;
                    MESSAGE "Ir a la p gina anterior"

               MENUITEM "&Siguiente" ACTION NextPage() ;
                    MESSAGE "Ir a la p gina siguiente"

               MENUITEM "&Ultima" ACTION BottomPage() ;
                    MESSAGE "Ir a la £ltima p gina"

          ENDMENU
   ENDMENU

return oMenu

//---------------------------------------------------------------------------//

static proc ShowPage()

    local aPage := oDevice:aMetaFile[ nPage ]
    local n, aSay
    oWnd:oBar:Say( 0, 30, "P gina: " + str( nPage, 4 ), oWnd:oBar:nColor )
    oWnd:oClient:BeginPaint()
    for n := 1 to len( aPage )
        aSay := aPage[ n ]
        oWnd:Say( aSay[ SAY_ROW ], aSay[ SAY_COL ], aSay[ SAY_TXT ] )
    next
    oWnd:oClient:EndPaint()

return

//---------------------------------------------------------------------------//

static proc TopPage()
    if nPage > 1
        nPage = 1
        oWnd:oClient:Clear()
        ShowPage()
    else
        Tone( 349, 1 )
    endif
return
static proc PrevPage()
    if nPage > 1
        --nPage
        oWnd:oClient:Clear()
        ShowPage()
    else
        Tone( 349, 1 )
    endif
return
static proc NextPage()
    if nPage < Len( oDevice:aMetaFile )
        ++nPage
        oWnd:oClient:Clear()
        ShowPage()
    else
        Tone( 349, 1 )
    endif
return
static proc BottomPage()
    if nPage < Len( oDevice:aMetaFile )
        nPage = Len( oDevice:aMetaFile )
        oWnd:oClient:Clear()
        ShowPage()
    else
        Tone( 349, 1 )
    endif
return
static proc PrintDoc()
    oDevice:AddDocToSpool( oDevice:cDir + "\" + oDevice:cFile )
return
//---------------------------------------------------------------------------//
