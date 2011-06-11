#include "fivedos.ch"
#include "NoteBook.ch"

#define BOXSINGLE "ÚÄ¿³ÙÄÀ³"

#define PAGECOLOR "N+/B, W+/B, BG+/B, BG+/B"
#define TABSCOLOR "N/N*, W+/B, GR+/N*, GR+/B, N+/BG, B/BG"


function main()
    local oWnd, oBook
    local oDbf, oBrw, oLbx
    local aList  := { ' &Primero ', ' &Segundo ',' &Tercero ' }
    local nIndex := 2
    local oDlg1, oDlg2, oDlg3
    local cText  := 'Dialogo 2'
    local cText2 := 'Dialogo 1'

    if !File( "Dialog01.ntx" )
        USE Dialog NEW
        INDEX ON Upper( Dialog->Name ) TO Dialog01.ntx FOR !Deleted()
        CLOSE
    endif

    SetKey( K_F10, {|| Alert( oWnd:cTitle + " " + cText ) } )

    DEFINE DIALOG oWnd FROM 2,2 TO 23, 75 ;
        TITLE "Testing FiveDos 'Tabs'" ;
        NOSYSMENU


    DEFINE MESSAGE BAR OF oWnd PROMPT "Prueba con Tabs"

    @ 3,    2   BUTTON '   P&rueba   ' OF oWnd

    @ 5,    2   BUTTON ' &Otro Boton ' OF oWnd

/* Un control cualquiera puede controlar los pages... por ejemplo los tabs...
*/

    @ 1,    18  TABMENU nIndex ARRAY aList OF oWnd ;
                ON CHANGE oBook:SetPage( nIndex, .t. )  ;
                COLOR TABSCOLOR


   /**** ejemplo de pesta¤as debajo del libro....

    @ 18,    18  TABMENU nIndex ARRAY aList OF oWnd ;
                 ON CHANGE oBook:SetPage( nIndex, .t. )  ;
                 COLOR TABSCOLOR ;
                 AT BOTTOM
   ****/

/**   el soporte de los folders
*/
    @ 2, 18 TO 17, 70 NOTEBOOK oBook OF oWnd ;
        COLOR PAGECOLOR

    BEGIN PAGE oDlg1 OF oBook

        @  2, 4 BUTTON ' Dialogo 1.&1 ' OF oBook MESSAGE 'Boton 1,1' SIZE 13, 3
        @  6,19 BUTTON ' Dialogo 1.&2 ' OF oBook MESSAGE 'Boton 2,1' SIZE 13, 3
        @ 11,35 BUTTON ' Dialogo 1.&3 ' OF oBook MESSAGE 'Boton 3,1' SIZE 13, 3
        @ 14, 20 GET cText2 PROMPT "&BoxName:" OF oBook

    BEGIN PAGE oDlg2 OF oBook

        @  2, 35 BUTTON ' Dialogo 2.&1 ' OF oBook MESSAGE 'Boton 1,2' SIZE 13, 3
        @  6, 19 BUTTON ' Dialogo 2.&2 ' OF oBook MESSAGE 'Boton 2,2' SIZE 13, 3
        @ 11,  4 BUTTON ' Dialogo 2.&3 ' OF oBook MESSAGE 'Boton 3,2' SIZE 13, 3
        @ 14, 20 GET cText PROMPT "&BoxName:" OF oBook


    USE DATABASE oDbf FILE "Dialog"  ;
        INDEX "Dialog01.ntx"

    BEGIN BROWSE oBrw ALIAS oDbf COLOR "W+/W, W+/N"
        COLUMN TITLE "Nombre"  SHOW oDbf:Name
    ENDBROWSE

    BEGIN PAGE oDlg3 OF oBook

       @  1,  2 LISTBOX oLbx BROWSE oBrw ;
          SIZE 49, 12                    ;
          LOGICLEN oDbf:KeyCount()       ;
          ON DBLCLICK DbfEdit( oLbx, oDbf ) ;
          PROMPT "&Clientes"             ;
          OF oBook

       @ 14,  5 BUTTON "  &New  "  OF oBook ACTION DbfEdit( oLbx, oDbf, .t. )
       @ 14, 18 BUTTON "  &Edit  " OF oBook ACTION DbfEdit( oLbx, oDbf )
       @ 14, 32 BUTTON "  &Del  "  OF oBook ACTION DbfDel( oLbx, oDbf )

    @ 15,   2   BUTTON '    &Exit    ' ACTION oWnd:End() OF oWnd

    ACTIVATE DIALOG oWnd VALID lMsgend() ON INIT oBook:SetPage( nIndex )

    CLOSE DATABASE oDbf

return nil

//---------------------------------------------------------------------------//

#include "dbfedit.prg" // static function DbfEdit( oLbx, oDbf, lNew )

//---------------------------------------------------------------------------//

#include "dbfdel.prg"

//---------------------------------------------------------------------------//
