#include "fivedos.ch"
#include "NoteBook.ch"
#include "FontDef.h"

#define BOXSINGLE "ÚÄ¿³ÙÄÀ³"
#define BOX3DS    chr( POINT_SE ) + chr( BORDERBOTTOM ) + chr( POINT_SW )  + chr( BORDERLEFT ) + chr( POINT_NW )  + chr( BORDERTOP ) + chr( POINT_NE )  + chr( BORDERRIGHT )


function PreMain()

    local oWnd

    DEFINE WINDOW oWnd FROM 2,2 TO 22, 75 TITLE "Cosaco"

    DEFINE MESSAGE BAR OF oWnd PROMPT "Test de Casque"

    @ 1,    2   BUTTON ' &Prueba ' ACTION MaIN() of oWnd

    @ 3,    2   BUTTON ' &Otro Boton ' action OwND:eND() of oWnd

    ACTIVATE WINDOW oWnd VALID lMsgend()

RETURN NIL

function main()
    local oWnd, n := 'pppppp', oBook
    local cText := 'Dialogo 2'
    local oDbf, oBrw, oLbx
    local aList := { '&Primero ', '&Segundo ','&Tercero ' }
    local nIndex := 1
    local oDlg1, oDlg2, oDlg3

   if !File( "Dialog01.ntx" )
        USE Dialog NEW
        INDEX ON Upper( Dialog->Name ) TO Dialog01.ntx FOR !Deleted()
        CLOSE
    endif

    DEFINE WINDOW oWnd FROM 2,2 TO 22, 75

    DEFINE MESSAGE BAR OF oWnd PROMPT "Prueba con folders"

    @ 1,    2   BUTTON ' &Prueba ' of oWnd

    @ 3,    2   BUTTON ' &Otro Boton ' of oWnd

/* Un control cualquiera puede controlar los pages
*/
    @ 5,    2   RADIOMENU nIndex ARRAY aList OF oWnd ;
                PROMPT "Selec&t Dialog" ;
                ON CHANGE oBook:SetPage( nIndex )

/**   el soporte de los Pages... la clase NoteBook
*/

    @ 1, 18 TO 17, 70 NOTEBOOK oBook OF oWnd  ;
            COLOR "N/GR,W+/GR,BG+/GR, BG+/GR"


    BEGIN PAGE oDlg1 OF oBook // ON PAINT oDlg1:Box( 0, 0, 16, 52, BOXSINGLE, oDlg1:nColor )

        @  3, 4 BUTTON ' Dialogo 1.&1 ' OF oBook MESSAGE 'Boton 1,1'
        @  7,19 BUTTON ' Dialogo 1.&2 ' OF oBook MESSAGE 'Boton 2,1'
        @ 12,35 BUTTON ' Dialogo 1.&3 ' OF oBook MESSAGE 'Boton 3,1'

    BEGIN PAGE oDlg2 OF oBook


        @  3, 35 BUTTON ' Dialogo 2.&1 ' OF oBook MESSAGE 'Boton 1,2'
        @  7, 19 BUTTON ' Dialogo 2.&2 ' OF oBook MESSAGE 'Boton 2,2'
        @ 12,  4 BUTTON ' Dialogo 2.&3 ' OF oBook MESSAGE 'Boton 3,2'
        @ 14, 20 GET cText PROMPT "&BoxName:" OF oBook PASSWORD


    USE DATABASE oDbf FILE "Dialog"  ;
        INDEX "Dialog01.ntx"

    BEGIN BROWSE oBrw ALIAS oDbf COLOR "W+/W, W+/N"
        COLUMN TITLE "Nombre"  SHOW oDbf:Name
    ENDBROWSE

    BEGIN PAGE oDlg3 OF oBook // ON PAINT oDlg3:Box( 0, 0, 16, 52,, oDlg3:nColor )

       @  1,  2 LISTBOX oLbx BROWSE oBrw ;
          SIZE 49, 12                    ;
          LOGICLEN oDbf:KeyCount()       ;
          ON DBLCLICK DbfEdit( oLbx, oDbf ) ;
          PROMPT "&Clientes"             ;
          OF oBook

       @ 14,  5 BUTTON "  &New  "  OF oBook ACTION DbfEdit( oLbx, oDbf, .t. )
       @ 14, 18 BUTTON "  &Edit  " OF oBook ACTION DbfEdit( oLbx, oDbf )
       @ 14, 32 BUTTON "  &Del  "  OF oBook ACTION DbfDel( oLbx, oDbf )

    @ 15,   2   BUTTON ' &Exit ' ACTION oWnd:End() OF oWnd

    ACTIVATE WINDOW oWnd VALID lMsgend() ;
             ON PAINT oWnd:Box3D( 0, 17, 18, 71, nStrColor("gr+/bg" ), ) // nStrColor( "n+/bg" ) )
             // ON INIT oBook:SetPage( nIndex )

    CLOSE DATABASE oDbf

return nil

//---------------------------------------------------------------------------//

#include "dbfedit.prg"

//---------------------------------------------------------------------------//

#include "dbfdel.prg"

//---------------------------------------------------------------------------//
