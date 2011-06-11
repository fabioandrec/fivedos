// Implementaci¢n de un Browse gen‚rico creado desde c¢digo

#include "FiveDos.ch"
#include "SysStr.ch"

//----------------------------------------------------------------------------//

function Brw( cTitle, cListName, bNew, bModify, bDelete, bSearch, bList, cAlias )

   local oDlg, oLbx, btnNew, btnModify, btnDelete, btnSearch, btnList, btnEnd

   local aMsg := aSysStr()

   DEFAULT cTitle    := "Browse",;
           cListName := "Fields",;
           cAlias    := Alias()

   DEFINE DIALOG oDlg FROM 0, 0 TO 24, 79 TITLE cTitle

   BROWSE oBrw ALIAS cAlias ;
      AUTOCOLUMS
   ENDBROWSE

   @ 3, 3 LISTBOX oLbx BROWSE oBrw ;
       SIZE 20, 76 ;
       ALIAS cAlias ;
       LOGICLEN ( cAlias )->( RecCount() ) OF oDlg

   @ 13,  1 BUTTON btnNew    PROMPT aMsg[ SST_NEW    ] OF oDlg
   @ 13,  8 BUTTON btnModify PROMPT aMsg[ SST_MODIFY ] OF oDlg
   @ 13, 15 BUTTON btnDelete PROMPT aMsg[ SST_DELETE ] OF oDlg
   @ 13, 22 BUTTON btnSearch PROMPT aMsg[ SST_SEARCH ] OF oDlg
   @ 13, 29 BUTTON btnList   PROMPT aMsg[ SST_PRINT  ] OF oDlg
   @ 13, 36 BUTTON btnEnd    PROMPT aMsg[ SST_EXIT   ] OF oDlg ACTION oDlg:End()

   btnNew:bAction    = If( bNew    != nil, { || Eval( bNew ), oLbx:Refresh() },)
   btnModify:bAction = If( bModify != nil, { || Eval( bModify ), oLbx:Refresh() },)
   btnDelete:bAction = If( bDelete != nil, { || Eval( bDelete ), oLbx:Refresh() },)
   btnSearch:bAction = If( bSearch != nil, { || Eval( bSearch ), oLbx:Refresh() },)
   btnList:bAction   = If( bList   != nil, { || Eval( bList ), oLbx:Refresh() },)

   ACTIVATE DIALOG oDlg

return nil

//----------------------------------------------------------------------------//
