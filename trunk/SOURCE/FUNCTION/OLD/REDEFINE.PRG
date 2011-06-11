#include "fivedos.ch"

//----------------------------------------------------------------------------//
// Para INLINE.
#xtranslate _BYNAME <v> [, <vN> ]   => ::<v> := <v> [, ::<vN> := <vN> ]
#xtranslate _BYNAME_IF_FULL <v> [,<vN>] ;
          => ;
             if( !IS_NIL( <v> ), ::<v> := <v>, ) ;
             [, if( !IS_NIL( <vN> ), ::<vN> := <vN>, ) ]
//----------------------------------------------------------------------------//
// METODO GUAY
/*
   #xCommand METHOD <Name>( <vars,...> ) PUSH ;
          => ;
             METHOD <Name>( <vars> ) INLINE _BYNAME_IF_FULL <vars>
   Ej:
   
      METHOD ReDefine( cMsg, cColors, nHelpId, bAction ) PUSH
/*     
//----------------------------------------------------------------------------//

// BUTTON
   METHOD ReDefine( cMsg, cColors, nHelpId, bAction ) INLINE ;
                   _BYNAME_IF_FULL cMsg, cColors, nHelpId, bAction


// CHECKBOX
   METHOD ReDefine( cMsg, cColors, nHelpId, bVar, bValid, bClick ) INLINE ;
                   _BYNAME_IF_FULL  cMsg, cColors, nHelpId, bVar, bValid, bClick 

// COMBOBOX 
   METHOD ReDefine( cMsg, cColors, nHelpId, bVar, aList, bValid, bChange ) INLINE ;
          _BYNAME_IF_FULL cMsg, cColors, nHelpId, bVar, aList, bValid, bChange









//----------------------------------------------------------------------------//
// LISTBOX

#xcommand REDEFINE LISTBOX [ <oLbx> VAR ] <cVar> [ ID <nId> ] ;
             [ ITEMS <cItems,...> ] [ LIST <uList,...> ] [ ARRAY <aList> ] ;
             [ FILES <cFileSpec> ] ;
             [ ON CHANGE <uChange> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ ON RIGHT CLICK <uRClick> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ <bitmaps: BITMAPS > [ SIZE <nSize> ] ] ;
             [ VALID <uValid> ]       ;
             [ COLOR <cColors> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
       => ;
          [ <oLbx> := ] <oWnd>:GetControl( <nId> ):ReDefine( <cMsg>, <cColors>,;
             <nHelpId>, bSETGET(<cVar>), [{<(cItems)>}] [{<uList>}] [<aList>],;
             <{uValid}>, <{uChange}>, <{uLDblClick}>, <{uRClick}> )
             
#xcommand REDEFINE LISTBOX [ <oLbx> ] [ ID <nId> ] ;
             [ <flds: FIELDS, COLUMNS> <Flds,...> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ ALIAS <cAlias> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ <sizes: FIELDSIZES, SIZES, COLSIZES> <aColSizes,...> ] ;
             [ <head: HEAD, HEADER, HEADERS> <aHeaders,...> ] ;
             [ SELECT <nInd> ] ;
             [ FOR <uValTop> [ TO <uValBottom> ] ] ;
             [ <change: ON CHANGE, ON CLICK> <uChange> ] ;
             [ ON [ LEFT ] DBLCLICK <uLDblClick> ] ;
             [ ON RIGHT CLICK <uRClick> ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ COLOR <cColors> ] ;
             [ <etiq: LABEL, PROMPT> <cLabel> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
             [ LOGICLEN <uLen> ] ;
             [ FREEZE <nColFreeze> ] ;
       => ;
          [ <oLbx> := ] <oWnd>:GetControl( <nId> ):ReDefine( <cMsg>, <cColors>,;
                              \{ [ <{Flds}> ] \}, ;
                              [ \{ <aHeaders> \} ], [ \{ <aColSizes> \} ],;
                              <nInd>, <uValTop>, <uValBottom>, <cAlias>,;
                              <nColFreeze>, <cLabel>, <{uLen}>,;
                              <{uChange}>, <{uLDblClick}>, <{uRClick}> )

#xcommand REDEFINE RADIO [ <oRadMenu> VAR ] <nVar> ;
             [ ID <nId,...> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ <change: ON CLICK, ON CHANGE> <uChange> ] ;
             [ COLOR <cColors> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
       => ;
          [ <oRadMenu> := ] TRadMenu():Redefine( <nId>, <oWnd>, <cMsg>, <cColors>,;
             <nHelpId>, bSETGET(<nVar>), \{ <nId> \}, <{uChange}> )

//----------------------------------------------------------------------------//
// SAY

#xcommand REDEFINE SAY [ <oSay> ] [ ID <nId> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <etiq: PROMPT, LABEL, VAR> <bText> ] ;
             [ PICTURE <cPicture> ] ;
             [ COLOR <cColors> ] ;
             [ <lCenter: CENTERED > ]  ;
             [ <lBorder: BORDER> ]  ;
             [ <update: UPDATE> ] ;
             [ FONT <oFont> ] ;
       => ;
          [ <oSay> := ] <oWnd>:GetControl( <nId> ):ReDefine( <cColors>, <{bText}>,;
                                                             <cPicture> )

#xcommand REDEFINE GET [ <oGet> VAR ] <uVar> [ ID <nId> ] ;
             [ <memo: MULTILINE, MEMO, TEXT> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ COLOR <cColors> ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
       => ;
          [ <oGet> := ] <oWnd>:GetControl( <nId> ):ReDefine( <cMsg>, <cColors>,;
                        <nHelpId>, bSETGET( <uVar> ) )

#xcommand REDEFINE GET [ <oGet> VAR ] <uVar> [ ID <nId> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <help: HELPID, HELP ID> <nHelpId> ] ;
             [ VALID <uValid> ]       ;
             [ PICTURE <cPict> ] ;
             [ COLOR <cColors> ] ;
             [ FONT <oFont> ] ;
             [ CURSOR <oCursor> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
       => ;
          [ <oGet> := ] <oWnd>:GetControl( <nId> ):ReDefine( <cMsg>, <cColors>,;
             <nHelpId>, bSETGET( <uVar> ), <{uValid}> )

#xcommand REDEFINE SCROLLBAR [ <oSbr> ] [ ID <nID>  ] ;
             [ RANGE <nMin>, <nMax> ] ;
             [ PAGESTEP <nPgStep> ] ;
             [ <up:UP, ON UP> <uUpAction> ] ;
             [ <dn:DOWN, ON DOWN> <uDownAction> ] ;
             [ <pgup:PAGEUP, ON PAGEUP> <uPgUpAction> ] ;
             [ <pgdn:PAGEDOWN, ON PAGEDOWN> <uPgDownAction> ] ;
             [ <pos: ON THUMBPOS> <uPos> ] ;
             [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ MESSAGE <cMsg> ] ;
             [ <update: UPDATE> ] ;
       => ;
             [ <oSbr> := ] <oWnd>:GetControl( <nId> )ReDefine( <cColors>,;
                                                  <nMin>, <nMax>, <nPgStep>,;
                        [<{uUpAction}>], [<{uDownAction}>], [<{uPgUpAction}>], ;
                        [<{uPgDownAction}>], [\{|nPos| <uPos> \}] )

#xcommand REDEFINE GROUP [ <oGroup> ] ;
             [ ID <nId> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ <label: LABEL, PROMPT> <cLabel> ] ;
             [ COLOR <cColors> ] ;
       => ;
          [ <oGroup> := ] <oWnd>:GetControl( <nId> ):ReDefine( <cColors>,;
                                                               <cLabel> )

#xcommand REDEFINE METER [ <oMeter> VAR ] <nActual> ;
             [ ID <nId> ];
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
             [ TOTAL <nTotal> ] ;
             [ <update: UPDATE> ] ;
       => ;
         [ <oMeter> := ] <oWnd>:GetControl( <nId> ):ReDefine( bSETGET(<nActual>),;
                                                                      <nTotal> )

#xcommand REDEFINE VBX [<oControl>] [ ID <nId> ] ;
             [ <wnd: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          [ <oControl> := ] <oWnd>:GetControl( <nId> ):ReDefine()

*/
