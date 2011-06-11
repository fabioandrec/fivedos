#include "FiveDos.ch"
#include "FileIO.ch"
#include "Styles.ch"

#define CHARPIX_X               4
#define CHARPIX_Y               8

/*
  "CHECKBOX, <cText>, <nID>, <nCol>, <nRow>, <nWidth>, <nHeight>, [cStyle]"
  "COMBOBOX,          <nID>, <nCol>, <nRow>, <nWidth>, <nHeight>, [cStyle]"
  "CONTROL,  <cText>, <nID>, [cClass], [cStyle], <nCol>, <nRow>, <nWidth>, <nHeight>"
  "CTEXT,    <cText>, <nID>, <nCol>, <nRow>, <nWidth>, <nHeight>, [cStyle]"
  "DEFPUSHBUTTON, <cText>, <nID>, <nCol>, <nRow>, <nWidth>, <nHeight>, [cStyle]"
  "EDITTEXT,          <nID>, <nCol>, <nRow>, <nWidth>, <nHeight>, [cStyle]"
  "GROUPBOX, <cText>, <nID>, <nCol>, <nRow>, <nWidth>, <nHeight>, [cStyle]"
  "LISTBOX,           <nID>, <nCol>, <nRow>, <nWidth>, <nHeight>, [cStyle]"
  "LTEXT,    <cText>, <nID>, <nCol>, <nRow>, <nWidth>, <nHeight>, [cStyle]"
  "PUSHBUTTON, <cText>, <nID>, <nCol>, <nRow>, <nWidth>, <nHeight>, [cStyle]"
  "RADIOBUTON, <cText>, <nID>, <nCol>, <nRow>, <nWidth>, <nHeight>, [cStyle]"
  "RTEXT,     <cText>, <nID>, <nCol>, <nRow>, <nWidth>, <nHeight>, [cStyle]" 
  "SCROLLBAR, <cText>, <nID>, <nCol>, <nRow>, <nWidth>, <nHeight>, [cStyle]" 
*/

//---------------------------------------------------------------------------//

static lGroup    := .f.
static acCtrlDlg := { "COMBOBOX", "EDITTEXT", "LISTBOX", "SCROLLBAR",;
                      "CHECKBOX", "PUSHBUTTON", "DEFPUSHBUTTON", "GROUPBOX",;
                      "RADIOBUTTON", "LTEXT", "CTEXT", "RTEXT", "DIALOG",;
                      "CONTROL", "SAY", "RADIOMENU", "CHECKMENU" }

//---------------------------------------------------------------------------//
// Lee un recurso de un fichero, lo crea, y si procede, le a¤ade los controles.
// oCtrl, por si queremos a¤adirle los controles a un Recurso externo.

Function Read_RC( cResource, cNameRC, cFileRC, oCtrl, cColor, oWnd )

   local nID, nCol, nRow, nWidth, nHeight, nCtrl, nLine, nLen, nLenLine, nLenCtrl,;
         cText, cStyle, cClass, cMenu, cFont, cCtrl, cLine,;
         oFile, xVar, n := 1

   DEFAULT cFileRC := GetResource()

   cNameRC = AllTrim( cNameRC )
   oFile   = TTxtFile():New( cFileRC )

   if oFile:Open( FO_READ + FO_DENYWRITE ) == F_ERROR
      Alert( "­ El fichero:;" + cFileRC + ";no se puede abrir !" + ;
             ";Error DOS N§: " + str( FERROR(), 3 ) )
      return nil
   endif

   if Empty( oFile:Seek( cNameRC + ' ' + cResource ) )
      Alert( "­ El Recurso:;" + ;
             "'" + cNameRC + ' ' + cResource + ;
             "';no existe !" )
      return nil
   endif

   cLine = oFile:ReadLn()
   
   do case
      case cResource == "DIALOG"
           nCol    = val( SubStr( xVar := cStrBtw( cLine, ',', n++ ),;
                          RAt( ' ', xVar ) ) )         / CHARPIX_X
           nRow    = val( cStrBtw( cLine, ',', n++ ) ) / CHARPIX_Y
           nWidth  = val( cStrBtw( cLine, ',', n++ ) ) / CHARPIX_X
           nHeight = val( cStrBtw( cLine, ',', n++ ) ) / CHARPIX_Y
           
           oFile:Skip( 1 )
           
           while ( cCtrl := cStrBtw( ( cLine := oFile:ReadLn() ), ' ', 1 ) );
                 != "BEGIN" .and. !oFile:Eof()
           
                 nLenLine = len( cLine )
                 nLenCtrl = len( cCtrl )

                 do case
                    case cCtrl == "CAPTION"
                         cText  = SubStr( cLine, nLenCtrl + 3, nLenLine - nLenCtrl - 2 )
                    case cCtrl == "STYLE"
                         cStyle = SubStr( cLine, 7 )
                    case cCtrl == "CLASS"
                         cClass = SubStr( cLine, 7 )
                    case cCtrl == "MENU"
                         cMenu  = SubStr( cLine, 6 )
                    case cCtrl == "FONT"
                         cFont  = SubStr( cLine, 6 )
                 endcase

                 oFile:Skip( 1 )
                 
           end

           if IS_NIL( oCtrl )
              DEFINE DIALOG oCtrl AT nRow, nCol SIZE nWidth, nHeight TITLE cText
           else
              oCtrl:nPaintCount++
              oCtrl:SetPos( nRow, nCol )
              oCtrl:ChangeSize( nWidth, nHeight )
              if !IS_NIL( cColor )
                 oCtrl:SetColor( cColor )
              endif
              oCtrl:nPaintCount--
           endif

           if !IS_NIL( cColor )
              oCtrl:SetColor( cColor )
           endif

           oFile:Skip( 1 )
           
           while ( cStrBtw( cLine := LTrim( oFile:ReadLn() ), ' ', 1 ) ) ;
                   != "END" .and. !oFile:Eof()
                 if !Empty( cLine )
                    oDlgReadCtrl( oFile, oCtrl )  // ( oFile, oDlg )
                 endif
                 oFile:Skip( 1 )
           end

      case cResource == "MENU"
      
           xVar = 1

           MENU oCtrl

           while !Empty( xVar )               // Procedimiento no recursivo.
           
              oFile:Skip( 1 )
              while ( cCtrl := cStrBtw( ( cLine := oFile:ReadLn() ), ' ', 1 ) );
                    != "BEGIN" .and. !oFile:Eof()
                    oFile:Skip( 1 )
              end
   
              oFile:Skip( 1 )
              while ( cCtrl := cStrBtw( cLine := LTrim( oFile:ReadLn() ), ' ', 1 ) );
                    != "END" .and. !oFile:Eof()
   
                    nLenLine = len( cLine )
                    nLenCtrl = len( cCtrl )
                    
                    do case
                       case cCtrl == "MENUITEM"
                            cText  = SubStr( cLine, nLenCtrl + 1 )
                            cText  = cStrBtw( cText, ' ', n:= 1 )
                            nID    = val( cStrBtw( cText, ' ', ++n ) )
                            cStyle = cStrBtw( cText, ' ', ++n )
                            
                            MENUITEM oCtrl PROMPT cText
                            oCtrl:nID = nID
                            
                       case cCtrl == "SEPARATOR"
                            SEPARATOR
   
                       case cCtrl == "POPUP"
                            cText  = SubStr( cLine, nLenCtrl + 1 )
                            cText  = cStrBtw( cText, ' ', n:= 1 )
                            cStyle = cStrBtw( cText, ' ', ++n )
   
                            MENU
                            MENUITEM cText
                            xVar++
                            exit
                            
                    endcase
                    oFile:Skip( 1 )
              end
              xVar--
           end

      case cResource == "ACELERATORS"
      case cResource == "STRINGTABLE"

      case cResource == "BITMAP" .or. ;
           cResource == "ICON"   .or. ;
           cResource == "CURSOR" .or. ;
           cResource == "FONT"

   endcase

   oCtrl:nID = cNameRC

   oFile:Close()
   
return oCtrl

//---------------------------------------------------------------------------//
                     
Function oDlgReadCtrl( oFile, oDlg )

   static cLabel

   local nID, nCol, nRow, nWidth, nHeight, nCtrl,;
         cText, cStyle, cClass, cCtrl, cLine,;
         oCtrl, xVar,;
         aList:= {}, anID:= {}, aDefList := { "&One", "&Two", "T&hree" },;
         n := 1

   cLine = LTrim( oFile:ReadLn() )
   cCtrl = cStrBtw( cLine, ' ', n )

   if !Empty( nCtrl := aScan( acCtrlDlg, cCtrl ) )

      if nCtrl > CLS_SCROLLBAR
         cText = cStrBtw( cLine, '"', ++n )
      endif

      nID = val( SubStr( xVar := cStrBtw( cLine, ',', n++ ), RAt( ' ', xVar ) ) )
      
      if nCtrl == CLS_CONTROL
         cClass = cStrBtw( cStrBtw( cLine, ',', n++ ), '"', 2 )
         cStyle = cStrBtw( cLine, ',', n++ )
      endif

      nCol    = val( cStrBtw( cLine, ',', n++ ) ) / CHARPIX_X
      nRow    = val( cStrBtw( cLine, ',', n++ ) ) / CHARPIX_Y
      nWidth  = val( cStrBtw( cLine, ',', n++ ) ) / CHARPIX_X
      nHeight = val( cStrBtw( cLine, ',', n++ ) ) / CHARPIX_Y

      // Pasa los controles stardard por su sitio.
      if nCtrl == CLS_CONTROL
         if ( nCtrl := aScan( acCtrlDlg, cClass ) ) < CLS_CONTROL
            if nCtrl < CLS_SCROLLBAR
               cLabel = cText
            endif
         else
            nCtrl = CLS_CONTROL
         endif
      else
         cStyle = cStrBtw( cLine, ',', n++ )
      endif

   else
   
      Alert( "ERROR, Control no definido... " + cCtrl )   
      return nil
      
   endif

   do case
      case nCtrl == CLS_COMBOBOX
           cText  = if( !IS_NIL( cLabel ), cLabel, "&ComboBox" )
           cLabel = nil
           xVar   = Space( nWidth - len( cText ) - 2 )
           @ nRow, nCol COMBOBOX oCtrl VAR xVar LABEL cText OF oDlg ;
                        ARRAY aDefList SIZE nWidth, nHeight - 1 

      case nCtrl == CLS_EDITTEXT
           cText  = if( !IS_NIL( cLabel ), cLabel, "&Get" )
           cLabel = nil
           xVar   = Space( nWidth - len( cText ) )
           @ nRow, nCol GET oCtrl VAR xVar LABEL cText OF oDlg
           
      case nCtrl == CLS_LISTBOX
           cText  = if( !IS_NIL( cLabel ), cLabel, "&ListBox" )
           cLabel = nil
           xVar   = 1
           @ nRow, nCol LISTBOX oCtrl VAR xVar LABEL cText OF oDlg ;
                        ARRAY aDefList SIZE nWidth, nHeight 

      case nCtrl == CLS_SCROLLBAR
           if max( nWidth, nHeight ) == nWidth
              @ nRow, nCol SCROLLBAR oCtrl SIZE nWidth HORIZONTAL OF oDlg
           else
              @ nRow, nCol SCROLLBAR oCtrl SIZE nHeight OF oDlg
           endif

      case nCtrl == CLS_CHECKBOX
           xVar = .f.
           if lGroup
              oCtrl = { cText, nID }
           else
              @ nRow, nCol CHECKBOX oCtrl VAR xVar LABEL cText OF oDlg
           endif

      case nCtrl == CLS_PUSHBUTTON .or. ;
           nCtrl == CLS_DEFPUSHBUTTON
           @ nRow, nCol BUTTON oCtrl LABEL cText SIZE nWidth, nHeight OF oDlg

      case nCtrl == CLS_GROUPBOX
           lGroup = .t.
           oFile:Skip( 1 )
           cCtrl  = cStrBtw( LTrim( oFile:ReadLn() ), ' ', 1 )

           while ( cCtrl == cStrBtw( LTrim( oFile:ReadLn() ), ' ', 1 ) );
                 .and. !oFile:Eof()
                 oCtrl = oDlgReadCtrl( oFile, oCtrl )
                 aAdd( aList, oCtrl[ 1 ] )
                 aAdd( anID, oCtrl[ 2 ] )
                 oFile:Skip( 1 )
           end

           lGroup = .f.

		   do case
              case cCtrl == acCtrlDlg[ CLS_RADIOBUTTON ]
                   xVar  = 1
                   @ nRow, nCol RADIOMENU oCtrl VAR xVar ;
                                ARRAY aList OF oDlg ;
                                LABEL cText

              case cCtrl == acCtrlDlg[ CLS_CHECKBOX ] 
                   xVar  = .f.
                   @ nRow, nCol CHECKMENU oCtrl VARS xVar ; // lVar1, lVar2, ...
                                ARRAY aList OF oDlg ;
                                LABEL cText
		   endcase

           aEval( oCtrl:aChilds, { | oItem, n | oItem:nID := anID[ n ] } )
   
      case nCtrl == CLS_RADIOBUTTON
           if lGroup
              oCtrl = { cText, nID }
           else
              @ nRow, nCol RADIOBUTTON oCtrl LABEL cText OF oDlg
           endif
           
      case nCtrl < CLS_DIALOG  // LTEXT, CTEXT, RTEXT
           // Si el nId == -1 no a¤adir a oDlg.
           oCtrl = TLabel():New( nRow, nCol, cText,, nWidth, nHeight,;
                                 if( nId == -1,, oDlg ), , nCtrl - CLS_CTEXT )
           if ( nId == -1 )
              cLabel = cText
           endif

      case nCtrl == CLS_DIALOG   // !! Childs !!

      case nCtrl == CLS_CONTROL

      do case
         case cClass == "TSAY"
              @ nRow, nCol SAY oCtrl LABEL cText SIZE nWidth, nHeight OF oDlg

         case cClass == "TRADMENU"

              lGroup = .t.

              oFile:Skip( 1 )
              while ( cCtrl := cStrBtw( ( cLine := LTrim( oFile:ReadLn() ) ), ' ', 1 ) );
                    == acCtrlDlg[ CLS_RADIOBUTTON ] .and. !oFile:Eof()
                    oCtrl = oDlgReadCtrl( oFile, oCtrl )
                    aAdd( aList, oCtrl[ 1 ] )
                    aAdd( anID, oCtrl[ 2 ] )
                    oFile:Skip( 1 )
              end

              lGroup = .f.
              xVar   = 1
              @ nRow, nCol RADIOMENU oCtrl VAR xVar ;
                           ARRAY aList OF oDlg ;
                           LABEL cText

              aEval( oCtrl:aChilds, { | oItem, n | oItem:nID := anID[ n ] } )

         case cClass == "TCHKMENU"

              lGroup = .t.

              oFile:Skip( 1 )
              while ( cCtrl := cStrBtw( ( cLine := LTrim( oFile:ReadLn() ) ), ' ', 1 ) );
                    == acCtrlDlg[ CLS_CHECKBOX ] .and. !oFile:Eof()
                    oCtrl = oDlgReadCtrl( oFile, oCtrl )
                    aAdd( aList, oCtrl[ 1 ] )
                    aAdd( anID, oCtrl[ 2 ] )
                    oFile:Skip( 1 )
              end

              lGroup = .f.
              xVar   = .f.
              @ nRow, nCol CHECKMENU oCtrl VARS xVar ; // lVar1, lVar2, ...
                           ARRAY aList OF oDlg ;
                           LABEL cText

              aEval( oCtrl:aChilds, { | oItem, n | oItem:nID := anID[ n ] } )

          otherwise
             alert( 'Clase CONTROL ' + cClass + ' no Definida' )
             return nil

      endcase

            otherwise
               alert( 'Control ' + cCtrl + ' no Definido' )
               return nil

   endcase

   if !lGroup
      oCtrl:nID = nID
   endif

return oCtrl

//---------------------------------------------------------------------------//

Function Write_RC( oCtrl, cFileRC )  // oResource, cFileResource.

   local cText, cStyle, cClass, cFont, cMenu, cLine,;
         oFile, nReg, n := 0
         
   local cNameRC   := AllTrim( oCtrl:cVarName ),; // Nombre del recurso
         cResource := if( oCtrl:ClassName() == "TWINDOW", "DIALOG", "" )

   DEFAULT cFileRC := GetResource()
   
   oFile = TTxtFile():New( cFileRC )

   if File( cFileRc )

      if oFile:Open( FO_READWRITE + FO_DENYWRITE ) == F_ERROR
         Alert( "­ El fichero:;" + cFileRC + ";no se puede abrir !" + ;
                ";Error DOS N§: " + str( FERROR(), 3 ) )
         return nil
      endif

      // Borrar Recurso antes de Volver a escribir
      if !Empty( oFile:Seek( cNameRC + ' ' + cResource ) )
         while !( Left( oFile:ReadLn(), 3 ) == 'END' ) .and. !oFile:Eof()
               oFile:Delete( 1 )
         end
         oFile:Delete( 2 )     // END + CRLF
      endif
      
      oFile:GoBottom()

   else

      if oFile:Create() == F_ERROR
         Alert( "­ El fichero:;" + cFileRC + ";no se puede crear !" + ;
                ";Error DOS N§: " + str( FERROR(), 3 ) )
         return nil
      endif

   endif 

   do case
      case cResource == "DIALOG"

           cText  = oCtrl:cTitle
           cStyle = cArr2Str( acCtrlStyles()[ CLS_DIALOG, _CLS_DEFAULT ], " | " )
           cClass = ''
           cFont  = ''
           cMenu  = ''
           cLine = cNameRC + " " + cResource + " "        + ;
                   Str( oCtrl:nLeft() * CHARPIX_X, 4 ) + ", "  + ;
                   Str( oCtrl:nTop()  * CHARPIX_Y, 4 ) + ", "  + ;
                   Str( oCtrl:nWidth  * CHARPIX_X, 4 ) + ", "  + ;
                   Str( oCtrl:nHeight * CHARPIX_Y, 4 )         + ;
                   CRLF                                            + ;
                   'STYLE ' + cStyle + CRLF                        + ;
                   if( Empty( cText ), "", 'CAPTION "' + cText + '"' + CRLF ) + ;
                   "BEGIN" + CRLF

            aEval( oCtrl:oClient:aChilds,;
                   {| oCtrl | cLine += cDlgWriteCtrl( oFile, oCtrl ) } )

            cLine += "END" + CRLF + CRLF
            
   endcase

   oFile:WriteLn( cLine )
   oFile:Close()
   
return .t.

//---------------------------------------------------------------------------//

Function cDlgWriteCtrl( oFile, oCtrl )

   local n, cText, nTmp1, nTmp2,;
         cPrevLine  := '',;
         cLineCtrls := CRLF,;
         cCtrl      := oCtrl:ClassName(),;
         cStyle     := if( lGroup, "BS_GROUPBOX | ", '' )

   local nWidth  := oCtrl:nWidth() ,;
         nHeight := oCtrl:nHeight()

   local c_Style, c_Class  // vars == nil, excepto para objetos Control.
   local acCtrlStyles := acCtrlStyles()

   lGroup  = .f.

   do case

      case cCtrl == 'T' + acCtrlDlg[ CLS_COMBOBOX ]
           if !Empty( oCtrl:oLabel )
              oCtrl:oLabel:nId = -1
              nTmp1 = oCtrl:oLabel:nTop
              nTmp2 = oCtrl:oLabel:nLeft
              oCtrl:oLabel:SetPos( oCtrl:nTop(), oCtrl:nLeft() )
              cPrevLine = cDlgWriteCtrl( oFile, oCtrl:oLabel )
              oCtrl:oLabel:SetPos( nTmp1, nTmp2 )
           endif
           cCtrl   = acCtrlDlg[ CLS_COMBOBOX ]
           cStyle += cArr2Str( acCtrlStyles[ CLS_COMBOBOX, _CLS_DEFAULT ], " | " )

      case cCtrl == 'TGET'
           if !Empty( oCtrl:oLabel )
              oCtrl:oLabel:nId = -1
              nTmp1 = oCtrl:oLabel:nTop
              nTmp2 = oCtrl:oLabel:nLeft
              oCtrl:oLabel:SetPos( oCtrl:nTop(), oCtrl:nLeft() )
              cPrevLine = cDlgWriteCtrl( oFile, oCtrl:oLabel )
              oCtrl:oLabel:SetPos( nTmp1, nTmp2 )
           endif
           cCtrl = acCtrlDlg[ CLS_EDITTEXT ]
           cStyle += cArr2Str( acCtrlStyles[ CLS_EDITTEXT, _CLS_DEFAULT ], " | " )

      case cCtrl == 'T' + acCtrlDlg[ CLS_LISTBOX ]
           if !Empty( oCtrl:oLabel )
              oCtrl:oLabel:nId = -1
              nTmp1 = oCtrl:oLabel:nTop
              nTmp2 = oCtrl:oLabel:nLeft
              oCtrl:oLabel:SetPos( oCtrl:nTop(), oCtrl:nLeft() )
              cPrevLine = cDlgWriteCtrl( oFile, oCtrl:oLabel )
              oCtrl:oLabel:SetPos( nTmp1, nTmp2 )
           endif
           cCtrl   = acCtrlDlg[ CLS_LISTBOX ]
           cStyle += cArr2Str( acCtrlStyles[ CLS_LISTBOX, _CLS_DEFAULT ], " | " )

      case cCtrl == 'T' + acCtrlDlg[ CLS_SCROLLBAR ]
           cCtrl   = acCtrlDlg[ CLS_SCROLLBAR ]
           cStyle += "SBS_" + if( oCtrl:lHorizontal, "HORZ", "VERT" )

      case cCtrl == 'T' + acCtrlDlg[ CLS_CHECKBOX ]
           cCtrl   = acCtrlDlg[ CLS_CHECKBOX ]
           cText = ' "' + oCtrl:cText + '"'
           cStyle += cArr2Str( acCtrlStyles[ CLS_CHECKBOX, _CLS_DEFAULT ], " | " )

      case cCtrl == 'TBUTTON'
           cCtrl   = acCtrlDlg[ CLS_PUSHBUTTON ]
           cText   = ' "' + oCtrl:oLabel:cText + '"'
           cStyle += cArr2Str( acCtrlStyles[ CLS_PUSHBUTTON, _CLS_DEFAULT ], " | " )
           // Como la sombra esta incluida en en tama¤o del bot¢n.
           nWidth--
           nHeight--

      case cCtrl == 'TRADMENU' .or. ;  // GROUPBOX
           cCtrl == 'TCHKMENU'
           lGroup  = .t.
           cCtrl   = acCtrlDlg[ CLS_GROUPBOX ]
           cText   = ' "' + oCtrl:oLabel:cText + '"'
           c_Class = '"'  + '"' + acCtrlDlg[ CLS_PUSHBUTTON ] + '"'
           cStyle += cArr2Str( acCtrlStyles[ CLS_GROUPBOX, _CLS_DEFAULT ], " | " )
           aEval( oCtrl:aChilds, {| oCtrl | cLineCtrls += ;
                                            cDlgWriteCtrl( oFile, oCtrl ) } )

      case cCtrl == 'TRADIO'
           cCtrl   = acCtrlDlg[ CLS_RADIOBUTTON ]
           cText   = ' "' + oCtrl:cText + '"'
           cStyle += cArr2Str( acCtrlStyles[ CLS_RADIOBUTTON, _CLS_DEFAULT ], " | " )

      case cCtrl == 'TLABEL'              // LText, CText, RText
           cCtrl   = acCtrlDlg[ CLS_CTEXT + oCtrl:nJustify ]
           cText   = ' "' + oCtrl:cText + '"'
           cStyle += cArr2Str( acCtrlStyles[ CLS_CTEXT + oCtrl:nJustify, _CLS_DEFAULT ], " | " )

      // Control...

      case cCtrl == 'TSAY'
           cText   = ' "' + oCtrl:cText + '"'
           c_Class = '"' + cCtrl + '"'
           c_Style = ''
           cCtrl   = 'CONTROL'
/*
      case cCtrl == 'TRADMENU' .or. ;
           cCtrl == 'TCHKMENU'
           lGroup  = .t.
           cText   = ' "' + oCtrl:oLabel:cText + '"'
           c_Class = '"'  + acCtrlDlg[ CLS_PUSHBUTTON ] + '"'
           c_Style = 'BS_GROUPBOX'
           cCtrl   = 'CONTROL'
           aEval( oCtrl:aChilds, {| oCtrl | cLineCtrls += ;
                                            cDlgWriteCtrl( oFile, oCtrl ) } )
*/
      otherwise

           Alert( 'Control no Salvado: ' + cCtrl )

   endcase

   lGroup = .f.

return cPrevLine                                    + ;
       space( 3 ) + cCtrl                  + " "    + ;
       if( IS_NIL( cText ),   '', cText    + ", " ) + ;
       Str( oCtrl:nGetId(), 4 )            + ", "   + ;
       if( IS_NIL( c_Class ), '', c_Class  + ", " ) + ;
       if( IS_NIL( c_Style ), '', c_Style  + ", " ) + ;
       Str( oCtrl:nLeft   * CHARPIX_X, 4 ) + ", "   + ;
       Str( oCtrl:nTop    * CHARPIX_Y, 4 ) + ", "   + ;
       Str(       nWidth  * CHARPIX_X, 4 ) + ", "   + ;
       Str(       nHeight * CHARPIX_Y, 4 )          + ;
       if( Empty( cStyle ), '', ", " + cStyle    )  + ;
       cLineCtrls

//---------------------------------------------------------------------------//
