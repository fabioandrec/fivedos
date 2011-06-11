
//---------------------------------------------------------------------------//
//                                                                           //
//      Definici¢n de listado de columnas para FiveDOS                       //
//                                                                           //
//---------------------------------------------------------------------------//

#ifndef _REPORT_CH
    #define _REPORT_CH

    #define R_CENTER  0
    #define R_RIGHT   1
    #define R_LEFT    2

    #ifndef CRLF
        #define CRLF Chr( 13 ) + Chr( 10 )
    #endif

//----------------- Definicion de listado ------------------------------------//

#xcommand REPORT <oReport>                              ;
                 [ <Canal: CANAL, TO FILE> <cCanal> ]   ;
                 [ HEADER <aHead> ]                     ;
                 [ <mu: MARGIN UP, UP> <nMrgUp> ]       ;
                 [ <ml: MARGIN LEFT, LEFT> <nMrgLeft> ] ;
                 [ SEP HOR <cHeadSepH> ]                ;
                 [ SEP HEAD <cHeadSep> ]                ;
                 [ SEP COL <cColSep> ]                  ;
                 [ IN ALIAS <cAlias> ]                  ;
                 [ <lPage: PAGE> ]                      ;
                 [ <pos: POSITION, POS> <nPosPg> ]      ;
                 [ <lTPg: TOTAL PG> ]                   ;
                 [ <lTEnd: TOTAL END> ]                 ;
        => ;
         <oReport> := TRptCol():New( <cCanal>, <cAlias>, <aHead>,    ;
                       <nMrgUp>, <nMrgLeft>, <cHeadSepH>, <cHeadSep>, ;
                       <cColSep>, <.lTPg.>, <.lTEnd.>, <.lPage.>, <nPosPg> )

//---------------- Listados basados en Browse --------------------------------//

#xcommand REPORT <oReport> BROWSE < oBrw > ;
                 [ <Canal: CANAL, TO FILE> <cCanal> ] ;
                 [ HEADER <aHead> ]         ;
                 [ <mu: MARGIN UP, UP> <nMrgUp> ]       ;
                 [ <ml: MARGIN LEFT, LEFT> <nMrgLeft> ] ;
                 [ SEP HOR <cHeadSepH> ]    ;
                 [ SEP HEAD <cHeadSep> ]    ;
                 [ SEP COL <cColSep> ]      ;
                 [ <lPage: PAGE> ]          ;
                 [ <pos: POSITION, POS> <nPosPg> ]      ;
                 [ <lTPg: TOTAL PG> ]       ;
                 [ <lTEnd: TOTAL END> ]     ;
        => ;
         <oReport> := TRBrw():New( <oBrw>, <cCanal>, <aHead>, <nMrgUp>, ;
                                   <nMrgLeft>, <cHeadSepH>, <cHeadSep>, ;
                                   <cColSep>, <.lTPg.>, <.lTEnd.>, <.lPage.>, ;
                                   <nPosPg> )

//---------------- Listados basados en Mailing -------------------------------//

#xcommand REPORT MERGE <oReport> ;
                 [ <Canal: CANAL, TO FILE> <cCanal> ] ;
                 [ MODEL <cText> ] ;
                 [ <lEject: EJECT> ] ;
                 [ WIDTH <nWidth> ] ;
                 [ HEADER <aHead> ]         ;
                 [ <mu: MARGIN UP, UP> <nMrgUp> ]       ;
                 [ <ml: MARGIN LEFT, LEFT> <nMrgLeft> ] ;
                 [ IN ALIAS <cAlias> ] ;
                 [ <lPage: PAGE> ] ;
                 [ <pos: POSITION, POS> <nPosPg> ]      ;
        => ;
         <oReport> := TMerge():New( <cText>, <cCanal>, <.lEject.>, ;
                                   <nWidth>, <cAlias>, <aHead>, <nMrgUp>, ;
                                   <nMrgLeft>, <.lPage.>, <nPosPg> )

//---------------- Listados basados en Formatos-------------------------------//

#xcommand REPORT FORM <oReport> ;
                 [ <Canal: CANAL, TO FILE> <cCanal> ] ;
                 [ LINES <nLines> ] ;
                 [ WIDTH <nWidth> ] ;
                 [ <lEject: EJECT> ] ;
                 [ IN ALIAS <cAlias> ] ;
                 [ HEADER <aHead> ]         ;
                 [ <mu: MARGIN UP, UP> <nMrgUp> ]       ;
                 [ <ml: MARGIN LEFT, LEFT> <nMrgLeft> ] ;
                 [ <lPage: PAGE> ] ;
                 [ <pos: POSITION, POS> <nPosPg> ]      ;
        => ;
         <oReport> := TForm():New( <cCanal>, <nLines>, <nWidth>, <.lEject.>, ;
                                   <cAlias>, <aHead>, <nMrgUp>, <nMrgLeft>, ;
                                   <.lPage.>, <nPosPg> )

#xcommand DEFINE REPORT <*def*> => REPORT <def>

//---------------- Definici¢n del Grupo --------------------------------------//

#xcommand GROUP [ <oRptGrp> ] ;
                [ VAL <bGroup> ] ;
                [ HEADER <cGroup> ] ;
                [ FOOTER <cTxtEndGrp> ] ;
                [ <lEjectGrp: EJECT> ] ;
                [ <lSummary: TOTAL> ] ;
                [ ON START <bOnGroup> ] ;
                [ OF <oRpt> ] ;
        => ;
      [ <oRptGrp> := ] RptGroup( <bGroup>, <cGroup>, <cTxtEndGrp>, ;
                              <.lSummary.>, <bOnGroup>, <.lEjectGrp.>, <oRpt> )

//---------------- Definici¢n de Columnas ------------------------------------//

#xcommand RCOLUMN [ <oRptCol> ] ;
                [ TITLE <cHeader> ] ;
                [ <Evalua: DATA, BLOCK, EVAL> <bBlock> ] ;
                [ SIZE <nWidth> ] ;
                [ <lSummary: TOTAL> ] ;
                [ PICTURE <cPicture> ] ;
                [ OF <oRpt> ] ;
        => ;
         [ <oRptCol> := ] RptAddColumn( <bBlock>, <cHeader>, <nWidth>, ;
                                         <.lSummary.>, <cPicture>, <oRpt> )

#xcommand ADD RCOLUMN <*def*> => RCOLUMN <def>

#xcommand ADDRCOLUMN <*def*>  => RCOLUMN <def>

//---------------- Definici¢n de Datos para TFORM ----------------------------//

#xcommand FDATA [ <oData> ] ;
               [ <Linea: LINE, ROW, X> <nRow> ] ;
               [ <Columna: POSITION, COL, Y> <nCol> ] ;
               [ @ <nRow>, <nCol> ] ;
               [ <Evalua: DATA, BLOCK, EVAL> <bBlock> ] ;
               [ SIZE <nWidth> ] ;
               [ PICTURE <cPicture> ] ;
               [ OF <oRpt> ] ;
        => ;
         [ <oData> := ] RptAddData( <nRow>, <nCol>, <bBlock>, <nWidth>, ;
                                    <cPicture>, <oRpt> )

#xcommand ADD FDATA <*def*> => FDATA <def>

#xcommand ADDFDATA <*def*>  => FDATA <def>

//---------------- Fuerza un AutoColumn --------------------------------------//

#xcommand AUTOCOLUMN <oReport> => <oReport>:AutoColumn()

//---------------- Indicador de lineas por pagina ----------------------------//

#xcommand LINES [ PAGE ] <nLines> OF <oReport> => <oReport>:nPgLines := <nLines>

//---------------- Fin de definicion de listado ------------------------------//

#xcommand END REPORT =>   //------------ FIN DEFINICION LISTADO --------------//

#xcommand ENDREPORT ;
       => ;
          END REPORT

//---------------- Activaci¢n del listado ------------------------------------//

#xcommand ACTIVATE REPORT  <oReport>  ;
                [ FOR <bfor> ] ;
                [ WHILE <bwhile> ] ;
                [ ON INIT <bInit> ] ;
                [ ON END <bEnd> ] ;
                [ ON STARTPAGE <bStartPage> ] ;
                [ ON ENDPAGE <bEndPage> ] ;
                [ ON LINE <bLine> ] ;
        => ;
          <oReport>:Activate( <bfor>, <bwhile>, <bInit>, <bEnd>, ;
                <bStartPage>, <bEndPage>, <bLine> )

//---------- Eof Report.ch ---------------------------------------------------//

#endif
