/*
旼 Programa 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
�   Aplication: Constructor file for class TReport, TColumn and TGroup     �
�         File: PDREPORT.PRG                                               �
�       Author: Ignacio Ortiz de Z＄iga Echeverr죂                         �
�          CIS: Ignacio Ortiz (100042,3051)                                �
�         Date: 07/28/94                                                   �
�         Time: 20:20:07                                                   �
�    Copyright: 1994 by Ortiz de Zu쨒ga, S.L.                              �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*/
#include "FiveDos.ch"

#define REPORT  1
#define COLUMNS 2
#define GROUPS  3

STATIC aReports := {}

//----------------------------------------------------------------------------//

FUNCTION RptBegin(aTitle   ,;
                  aHead    ,;
                  aFoot    ,;
                  aFont    ,;
                  aPen     ,;
                  lSummary ,;
                  cRptfile ,;
                  cResName ,;
                  lPrint   ,;
                  lScreen  ,;
                  cFile    ,;
                  oDevice  ,;
                  cName    ,;
                  cTFmt    ,;
                  cHFmt    ,;
                  cFFmt)

   AAdd( aReports ,;
        { TReport():New(aTitle   ,;
                        aHead    ,;
                        aFoot    ,;
                        aFont    ,;
                        aPen     ,;
                        lSummary ,;
                        cRptfile ,;
                        cResName ,;
                        lPrint   ,;
                        lScreen  ,;
                        cFile    ,;
                        oDevice  ,;
                        cName    ,;
                        cTFmt    ,;
                        cHFmt    ,;
                        cFFmt ), {}, {} } )

RETURN ATail( aReports )[ REPORT ]

//----------------------------------------------------------------------------//

FUNCTION RptAddGroup(bGroup, bHeader, bFooter, bFont, lEject )

     LOCAL oGroup

     oGroup := TRGroup():New( bGroup     ,;
                              bHeader    ,;
                              bFooter    ,;
                              bFont      ,;
                              lEject     ,;
                              Atail(aReports)[ REPORT ] )

     AAdd( ATail( aReports )[ GROUPS ], oGroup )

RETURN (NIL)

//----------------------------------------------------------------------------//

FUNCTION RptAddColumn(aTitle     ,;
                      nCol       ,;
                      aData      ,;
                      nSize      ,;
                      aPicture   ,;
                      uFont      ,;
                      lTotal     ,;
                      bTotalExpr ,;
                      cColFmt    ,;
                      lShadow    ,;
                      lGrid      ,;
                      nPen)

     LOCAL oColumn

     oColumn := TRColumn():New(aTitle     ,;
                               nCol       ,;
                               aData      ,;
                               nSize      ,;
                               aPicture   ,;
                               uFont      ,;
                               lTotal     ,;
                               bTotalExpr ,;
                               cColFmt    ,;
                               lShadow    ,;
                               lGrid      ,;
                               nPen       ,;
                               Atail(aReports)[ REPORT ] )

     AAdd( ATail( aReports )[ COLUMNS ], oColumn )

RETURN oColumn

//----------------------------------------------------------------------------//

FUNCTION RptEnd()

   LOCAL oReport  := ATail( aReports )[ REPORT ]
   LOCAL aColumns := ATail( aReports )[ COLUMNS ]
   LOCAL aGroups  := ATail( aReports )[ GROUPS ]

   AEval( aColumns, { | oColumn | oReport:AddColumn( oColumn ) } )
   AEval( aGroups, { | oGroup | oReport:AddGroup( oGroup ) } )

   ASize( aReports, Len( aReports ) - 1 )

RETURN oReport
