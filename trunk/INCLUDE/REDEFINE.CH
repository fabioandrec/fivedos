#ifndef _REDEFINE_CH
#define _REDEFINE_CH

//----------------------------------------------------------------------------//
// Resources

#xcommand SET RESOURCES TO <cName1> [,<cName2>] ;
       => ;
          [ SetResource( <cName2> ); ] SetResource( <cName1> )

#xcommand SET RESOURCES TO => FreeResource()

//----------------------------------------------------------------------------//

#xcommand DEFINE DIALOG [ <oDlg> ]                             ;
             [ <resource: RESOURCE, NAME, RESNAME> <cNameRC> ] ;
             [ <file: FILE, FILENAME, DISK> <cFileRC> ]        ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <wnd: WINDOW, OF> <oWnd> ] ;
       => ;
           [ <oDlg> ] = Read_RC( "DIALOG", <cNameRC>, <cFileRC>, <oDlg>,;
                                 <cColors>, <oWnd> )

//----------------------------------------------------------------------------//

#xcommand DEFINE MENU [ <oMnu> ]                               ;
             [ <resource: RESOURCE, NAME, RESNAME> <cNameRC> ] ;
             [ <file: FILE, FILENAME, DISK> <cFileRC> ]        ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <wnd: WINDOW, OF> <oWnd> ] ;
       => ;
           [ <oMnu> ] = Read_RC( "MENU", <cNameRC>, <cFileRC>, <oMnu>,;
                                 <cColors>, <oWnd> )

//----------------------------------------------------------------------------//

#xcommand DEFINE BITMAP [ <oBmp> ] ;
             [ ID <nId> ] ;
             [ <resource: RESOURCE, NAME, RESNAME> <cNameRC> ] ;
             [ <file: FILE, FILENAME, DISK> <cFileRC> ]        ;
             [ <wnd: WINDOW, OF> <oWnd> ] ;
       => ;      
           [ <oBmp> ] = Read_RC( "BITMAP", <cNameRC>, <cFileRC>, <oBmp>,;
                                 <oWnd> )

//----------------------------------------------------------------------------//
// Loading strings/or other Types from Resources

#xcommand DEFINE VAR <uVar> [ ID <nId> ] ;
             [ AS <type: CHARACTER, NUMERIC, LOGICAL, DATE> ]  ;
             [ <resource: RESOURCE, NAME, RESNAME> <cNameRC> ] ;
             [ <file: FILE, FILENAME, DISK> <cFileRC> ]        ;
       => ;
          <uVar> := Read_RC( <nId>, [Upper(<(type)>)], <uVar> )

//----------------------------------------------------------------------------//
// BUTTON

#xcommand REDEFINE BUTTON [ <oBtn> ] [ ID <nId> ]           ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ]           ;
             [ <etiq: PROMPT, LABEL> <cText>    ]           ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ MESSAGE <cMsg> ]                             ;
             [ ACTION <uAction> ]                           ;
             [ WHILE PRESSED <bWhilePressed> ]              ;
             [ WHEN    <uWhen> ]                            ;
             [ VALID   <uValid> ]                           ;
             [ FILE <cBmp> ]                                ;
             [ <help:HELP, HELPID, HELP ID> <nHelpId> ]     ;
             [ <update: UPDATE> ]                           ;
       => ;
          [ <oBtn> := ] <oWnd>:oGetId( <nId> ):ReDefine( <cText>, <cMsg>,;
                    <cColors>, <nHelpId>, <{uAction}>, <cBmp>,;
                    <{bWhilePressed}>, <{uWhen}>, <{uValid}> )
                        
//----------------------------------------------------------------------------//
// CHECKBOX
                        
#xcommand REDEFINE CHECKBOX [ <oCbx> VAR ] <lVar> [ ID <nId> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <etiq: PROMPT, LABEL> <cText> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ <click: ON CLICK, ON CHANGE> <uClick> ];
             [ <update: UPDATE> ] ;
       => ;
          [ <oCbx> := ] <oWnd>:oGetId( <nId> ):ReDefine( <cText>, <cMsg>,;
                  <cColors>, <nHelpId>, bSETGET(<lVar>), <uWhen>, <uValid> )
 
//----------------------------------------------------------------------------//
// RADIOBUTTON

#xcommand REDEFINE RADIOBUTTON [ <oRbt> ] [ ID <nId> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <etiq: LABEL, PROMPT> <cText> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
       => ;
          [ <oRbt> := ] <oWnd>:oGetId( <nId> ):Redefine( <cText>, <cMsg>,;
             <cColors>, <nHelpId>, <uWhen>, <uValid> )

//----------------------------------------------------------------------------//
// SAY

#xcommand REDEFINE SAY [ <oSay> ] [ <etiq: PROMPT, LABEL, VAR> <bText> ] [ ID <nId> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ PICTURE <cPicture> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <lCenter: CENTERED > ]  ;
             [ <lBorder: BORDER> ]  ;
             [ <update: UPDATE> ] ;
             [ FONT <oFont> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
       => ;
          [ <oSay> := ] <oWnd>:oGetId( <nId> ):ReDefine( <cColors>,;
                   <nHelpId>, <{bText}>, <cPicture>, if( <.lCenter.>, 0, -1 ) )

//---------------------------------------------------------------------------//
// LABEL

#xcommand REDEFINE LABEL [ <oLabel> ] [ PROMPT <cText> ] [ ID <nId> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <lCenter: CENTERED > ]  ;
             [ FONT <oFont> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ MESSAGE <cMsg> ] ;
       => ;
          [ <oLabel> := ] <oWnd>:oGetId( <nId> ):ReDefine( <cText>, <cMsg>,;
                                <cColors>, <nHelpId>, if( <.lCenter.>, 0, -1 ) )

//----------------------------------------------------------------------------//
// GET

#xcommand REDEFINE GET [ <oGet> VAR ] <uVar> [ ID <nId> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ PICTURE <cPicture> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
       => ;
          [ <oGet> := ] <oWnd>:oGetId( <nId> ):ReDefine( <cMsg>, <cColors>,;
             <nHelpId>, bSETGET( <uVar> ), <cPicture>, <cLabel>, ;
             <{uWhen}>, <{uValid}> )

//---------------------------------------------------------------------------//
// LISTBOX ARRAY

#xcommand REDEFINE LISTBOX [ <oLbx> VAR ] <nVar> [ ID <nId> ] ;
             [ ITEMS <cItems,...> ] [ LIST <uList,...> ] [ ARRAY <aList> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ <bitmaps: BITMAPS > [ SIZE <nSize> ] ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ FILES <cFileSpec> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ ON RIGHT CLICK <uRClick> ] ;
       => ;
          [ <oLbx> := ] <oWnd>:oGetId( <nId> ):ReDefine( <cMsg>, <cColors>,;
             <nHelpId>, bSETGET(<nVar>), [{<(cItems)>}] [{<uList>}] [<aList>],;
             <cLabel>, <{uWhen}>, <{uValid}>, <{uChange}>, <{uLDblClick}> )

//----------------------------------------------------------------------------//
// SCROLLBAR

#xcommand REDEFINE SCROLLBAR [ <oSbr> ] [ ID <nID> ] ;
             [ RANGE <nRANGE> ] ;
             [ PAGESTEP <nPgStep> ] ;
             [ SIZE <nLen> ] ;
             [ ON UP <uUp> ] ;
             [ ON DOWN <uDown> ] ;
             [ ON PAGEUP <uPgUp> ] ;
             [ ON PAGEDOWN <uPgDown> ] ;
             [ ON THUMBPOS <uThumbPos> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN    <uWhen> ] ;
             [ VALID   <uValid> ] ;
             [ <update: UPDATE> ] ;
       => ;
             [ <oSbr> := ] <oWnd>:oGetId( <nID> ):ReDefine( <cMsg>, <cColors>,;
                        <nLen>, <nRANGE>, <nPgStep>, [<{uUp}>], [<{uDown}>],;
                        [<{uPgUp}>], [<{uPgDown}>], <{uThumbPos}>,;
                        <{uWhen}>, <{uValid}> )

//----------------------------------------------------------------------------//
// COMBOBOX

#xcommand REDEFINE COMBOBOX [ <oCbx> VAR ] <cVar> [ ID <nId> ] ;
             [ ITEMS <cItems,...> ] [ LIST <uList,...> ] [ ARRAY <aList> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ PICTURE <cPicture> ];
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ <update: UPDATE> ] ;
       => ;
          [ <oCbx> := ] <oWnd>:oGetId( <nId> ):ReDefine( <cMsg>, <cColors>,;
             <nHelpId>, bSETGET(<cVar>),;
             [ \{ <(cItems)> \} ] [ \{ <uList> \} ] [ <aList> ],;
             <cLabel>, <cPicture>, <{uWhen}>, <{uValid}>, <{uChange}>,;
             <{uLDblClick}> )

//----------------------------------------------------------------------------//
// RADIOMENU

#xcommand REDEFINE RADIOMENU [ <oRadMenu> VAR ] <nVar> [ ID <nId> ] ;
             [ ITEMS <cItems,...> ] [ LIST <uList,...> ] [ ARRAY <aList> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <update: UPDATE> ] ;
       => ;
          [ <oRadMenu> := ] <oWnd>:oGetId( <nId> ):Redefine( <cMsg>, <cColors>,;
             <nHelpId>, bSETGET(<nVar>),;
             [ \{ <(cItems)> \} ] [ \{ <uList> \} ] [ <aList> ],;
             <cLabel>, <{uWhen}>, <{uValid}>, <{uChange}> )

//----------------------------------------------------------------------------//
// CHECKMENU

#xcommand REDEFINE CHECKMENU [ <oChkMenu> VARS ] <lVar1> [,<lVarN>] [ ID <nID> ] ;
             [ ITEMS <cItems,...> ] [ LIST <uList,...> ] [ ARRAY <aList> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
             [ <color: COLOR, COLORS> <cColors> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ VALID <uValid> ] ;
             [ <update: UPDATE> ] ;
       => ;
          [ <oChkMenu> := ] <oWnd>:oGetId( <nID> ):ReDefine( <cMsg>, <cColors>,;
             <nHelpId>, \{ bSETGET( <lVar1> ) [, bSETGET( <lVarN> ) ]\},;
             [ \{ <cItems> \} ] [ \{ <uList> \} ] [ <aList> ],;
             <cLabel>, <{uWhen}>, <{uValid}>, <{uChange}> )

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

/*
#xcommand REDEFINE MENUITEM [ <nId> ] ;
             [ SHORTCUT <nKey> ] ;
             [ MESSAGE <cMsg> ] ;
             [ ACTION <uAction> ] ;
             [ <check:CHECKED> ] ;
             [ <disable:DISABLED> ] ;
        => ;
           [ <oMenuItem> := ] MnuItem( <cItem>, <cMsg>,;
             <{uAction}>, <.disable.>, <.check.>, <nKey> )

//----------------------------------------------------------------------------//

#xcommand REDEFINE BITMAP [ <oBmp> ] [ ID <nId> ] ;
             [ <resource: RESOURCE, NAME, RESNAME> <cNameRC> ] ;
             [ <file: FILE, FILENAME, DISK> <cFileRC> ]        ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <lClick: ON ClICK, ON LEFT CLICK> <uLClick> ] ;
             [ <rClick: ON RIGHT CLICK> <uRClick> ] ;
             [ <scroll: SCROLL> ] ;
             [ <adjust: ADJUST> ] ;
             [ CURSOR <oCursor> ] ;
             [ <update: UPDATE> ] ;
           => ;  
           [ <oBmp> := ] <oWnd>:oGetId( <nId> ):ReDefine(;
                         <cResName>, <cBmpFile>,;
                         [\{ |nRow,nCol,nKeyFlags| <uLClick> \}],;
                         [\{ |nRow,nCol,nKeyFlags| <uRClick> \}] )

//----------------------------------------------------------------------------//
// LISTBOX FIELDS             ( no terminado )

#xcommand REDEFINE LISTBOX [ <oLbx> ] [ ID <nId> ] ;
             [ <flds: FIELDS, COLUMNS> <Flds,...> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ ALIAS <cAlias> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ <sizes: FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
             [ <head: HEAD, HEADER, HEADERS> <aHeaders,...> ] ;
             [ SELECT <nIndice> ] ;
             [ FOR <uValTop> [ TO <uValBottom> ] ] ;
             [ <change: ON CHANGE, ON CLICK> <uChange> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ ON RIGHT CLICK <uRClick> ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ COLOR <cColor> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ LOGICLEN <uLen> ] ;
             [ FREEZE <nColFreeze> ] ;
       => ;
          [ <oLbx> := ] <oWnd>:oGetId( <nId> ):ReDefine( <cMsg>, <cColor>,;
                              \{ [ <{Flds}> ] \}, ;
                              [ \{ <aHeaders> \} ], [ \{ <aColSizes> \} ],;
                              <nIndice>, <uValTop>, <uValBottom>, <cAlias>,;
                              <nColFreeze>, <cLabel>, <{uLen}>,;
                              <{uChange}>, <{uLDblClick}>, <{uRClick}> )

   METHOD ReDefine( cMsg, cColor, aFlds, aHeaders, aColSizes, nIndice,;
                    uValTop, uValBottom, cAlias, nColFreeze, cLabel, bLen,;
                    bChange, bLDblClick, bRClick ) INLINE ;
                    oWBrowse( <nTop>, <nLeft>, <nWidth>, <nHeight>, ;
                              \{ [ <{Flds}> ] \}, ;
                              [ \{ <aHeaders> \} ], [ \{ <aColSizes> \} ],;
                              <oWnd>, <cColor>, <cMsg>, <nInd>, <uValTop>, ;
                              <uValBottom>, <cAlias>, <nColFreeze>, ;
                              <cLabel>, <{uLen}>, <{uChange}>, <{uLDblClick}> )
//                            <{uRClick}> )

//----------------------------------------------------------------------------//
// MULTI GET
/*
#xcommand REDEFINE GET [ <oGet> VAR ] <uVar> [ ID <nId> ] ;
             [ <memo: MULTILINE, MEMO, TEXT> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ COLOR <cColor> ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
       => ;
          [ <oGet> := ] <oWnd>:oGetId( <nId> ):ReDefine( <cMsg>, <cColor>,;
                        <nHelpId>, bSETGET( <uVar> ) )

   METHOD ReDefine( cMsg, cColor, nHelpId, bText, cPicture ) INLINE ;
                    ::New( ::nTop, ::nLeft, bText, cColor )
*/
//----------------------------------------------------------------------------//
// GROUP

#xcommand REDEFINE GROUP [ <oGroup> ] ;
             [ ID <nId> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <label: LABEL, PROMPT> <cLabel> ] ;
             [ COLOR <cColor> ] ;
       => ;
//          [ <oGroup> := ] <oWnd>:oGetId( <nId> ):ReDefine( <cColor>,;
//                                                               <cLabel> )

//----------------------------------------------------------------------------//
// METER

#xcommand REDEFINE METER [ <oMeter> VAR ] <nActual> ;
             [ ID <nId> ];
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ TOTAL <nTotal> ] ;
             [ <update: UPDATE> ] ;
       => ;
//         [ <oMeter> := ] <oWnd>:oGetId( <nId> ):ReDefine( bSETGET(<nActual>),;
//                                                                      <nTotal> )

//----------------------------------------------------------------------------//
// VBX

#xcommand REDEFINE VBX [<oControl>] [ ID <nId> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
//          [ <oControl> := ] <oWnd>:oGetId( <nId> ):ReDefine()


//----------------------------------------------------------------------------//
*/
#endif

