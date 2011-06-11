#include "FiveDos.ch"
#include "FileIO.ch"
#include "Styles.ch"

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
                      "CONTROL" }

function GetResources()
return "Temporal.RC"
                      
//---------------------------------------------------------------------------//
// Lee un recurso de un fichero, lo crea, y si procede, le a¤ade los controles.
// oCtrl, por si queremos a¤adirle los controles a un Recurso externo.

Function Read_RC( cResource, cNameRC, cFileRC, oCtrl )

   local nID, nCol, nRow, nWidth, nHeight, nCtrl, nLine, nLen, nLenLine, nLenCtrl,;
         cText, cStyle, cClass, cMenu, cFont, cCtrl, cLine,;
         oFile, xVar,;
         n := 2

   DEFAULT cFileRC := GetResources()

   cNameRC = Lower( AllTrim( cNameRC ) )
   oFile   = TFile():New( cFileRC )

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
           nCol    = val( cStrBtw( cLine, ',', n++ ) ) / 16
           nRow    = val( cStrBtw( cLine, ',', n++ ) ) / 8
           nWidth  = val( cStrBtw( cLine, ',', n++ ) ) / 16
           nHeight = val( cStrBtw( cLine, ',', n++ ) ) / 8
           
           oFile:Skip( 1 )
           
           while ( cCtrl := cStrBtw( ( cLine := oFile:ReadLn() ), ' ', 1 ) );
                 != "BEGIN"
           
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
              oCtrl:nPaintCount--
           endif

           oFile:Skip( 1 )
           
           while ( cStrBtw( LTrim( oFile:ReadLn() ), ' ', 1 ) ) != "END"
                 oGetDlgCtrl( oFile, oCtrl )
                 oFile:Skip( 1 )
           end

      case cResource == "MENU"
      
           xVar = 1

           MENU oCtrl

           while !Empty( xVar )               // Procedimiento no recursivo.
           
              oFile:Skip( 1 )
              while ( cCtrl := cStrBtw( ( cLine := oFile:ReadLn() ), ' ', 1 ) );
                    != "BEGIN"
                    oFile:Skip( 1 )
              end
   
              oFile:Skip( 1 )
              while ( cCtrl := cStrBtw( cLine := LTrim( oFile:ReadLn() ), ' ', 1 ) );
                    != "END"
   
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
                     
Function oGetDlgCtrl( oFile, oDlg )

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

      nID = val( SubStr( xVar := cStrBtw( cLine, ',', n++ ), At( ' ', xVar ) ) )
      
      if nCtrl == CLS_CONTROL
         cClass = cStrBtw( cStrBtw( cLine, ',', n++ ), '"', 2 )
         cStyle = cStrBtw( cLine, ',', n++ )
      endif

      nCol    = val( cStrBtw( cLine, ',', n++ ) ) / 16
      nRow    = val( cStrBtw( cLine, ',', n++ ) ) / 8
      nWidth  = val( cStrBtw( cLine, ',', n++ ) ) / 16
      nHeight = val( cStrBtw( cLine, ',', n++ ) ) / 8

      if nCtrl == CLS_CONTROL
         // Pasa los controles stardard por su sitio.
         if !Empty( nCtrl := aScan( acCtrlDlg, cClass ) )
            if nCtrl < CLS_SCROLLBAR
               cLabel = cText
            endif
         else
            nCtrl  = CLS_CONTROL
         endif
      else
         cStyle = cStrBtw( cLine, ',', n++ )
      endif

   else
   
      Alert( "ERROR, Control no definido... " + cCtrl )   
      return .f.
      
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
           @ nRow, nCol CHECKBOX oCtrl VAR xVar LABEL cText OF oDlg

      case nCtrl < CLS_RADIOBUTTON  // PushButton .or. DefPushButton .or. GroupBox
           @ nRow, nCol BUTTON oCtrl LABEL cText SIZE nWidth, nHeight OF oDlg
*           oCtrl:ReDefine( "boton", "es un boton", , , {|| Beep() }, , {|| Tone( 1000,1) } )

      case nCtrl == CLS_RADIOBUTTON
           if lGroup
              oCtrl = { cText, nID }
           else
              oCtrl = TRadio():New( nRow, nCol, cText,,, oDlg )
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
                      == acCtrlDlg[ CLS_RADIOBUTTON ]
                      oCtrl = oGetDlgCtrl( oFile, oCtrl )
                      aAdd( aList, oCtrl[ 1 ] )
                      aAdd( anID, oCtrl[ 2 ] )
                      oFile:Skip( 1 )
                end
                lGroup = .f.
                xVar   = 1
                @ nRow, nCol RADIO oCtrl VAR xVar ARRAY aList OF oDlg
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
         
   local cNameRC   := Lower( AllTrim( oCtrl:cVarName ) ),; // Nombre del recurso
         cResource := if( oCtrl:ClassName() == "TWINDOW", "DIALOG", "" )

   DEFAULT cFileRC := GetResources()
   
   oFile   = TFile():New( cFileRC )

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
           cStyle = cArr2Str( acCtrlStyles()[ CLS_DIALOG, CLS_DEFAULT ], " | " )
           cClass = ''
           cFont  = ''
           cMenu  = ''
           cLine = Lower( cNameRC ) + " " + cResource + ", " + ;
                   Str( oCtrl:nLeft   * 16, 4 ) + ", " + ;
                   Str( oCtrl:nTop    *  8, 4 ) + ", " + ;
                   Str( oCtrl:nWidth  * 16, 4 ) + ", " + ;
                   Str( oCtrl:nHeight *  8, 4 )        + ;
                   CRLF                                + ;
                   'STYLE ' + cStyle + CRLF            + ;
                   if( Empty( cText ), "", 'CAPTION "' + cText + '"' + CRLF ) + ;
                   "BEGIN" + CRLF

            aEval( oCtrl:oClient:aChilds,;
                   {| oCtrl | cLine += cGetDlgCtrl( oCtrl ) } )

            cLine += "END" + CRLF + CRLF
            
   endcase

   oFile:WriteLn( cLine )
   oFile:Close()
   
return .t.

//---------------------------------------------------------------------------//

Function cGetDlgCtrl( oCtrl )

   local nWidth, nHeight, n, cText,;
         cPrevLine  := '',;
         cLineCtrls := CRLF,;
         cCtrl      := oCtrl:ClassName(),;
         cStyle     := if( lGroup, "BS_GROUPBOX | ", '' )

   local c_Style, c_Class  // vars == nil, excepto para objetos Control.
   local acCtrlStyles := acCtrlStyles()

   lGroup  = .f.
   nWidth  = oCtrl:nWidth()
   nHeight = oCtrl:nHeight()

   do case

      case cCtrl == 'T' + acCtrlDlg[ CLS_COMBOBOX ]
           oCtrl:oLabel:nId = -1
           cPrevLine = cGetDlgCtrl( oCtrl:oLabel )
           cCtrl   = acCtrlDlg[ CLS_COMBOBOX ]
           cStyle += cArr2Str( acCtrlStyles[ CLS_COMBOBOX, CLS_DEFAULT ], " | " )

      case cCtrl == 'TGET'
           oCtrl:oLabel:nId = -1
           cPrevLine = cGetDlgCtrl( oCtrl:oLabel )
           cCtrl = acCtrlDlg[ CLS_EDITTEXT ]
           cStyle += cArr2Str( acCtrlStyles[ CLS_EDITTEXT, CLS_DEFAULT ], " | " )

      case cCtrl == 'T' + acCtrlDlg[ CLS_LISTBOX ]
           oCtrl:oLabel:nId = -1
           cPrevLine = cGetDlgCtrl( oCtrl:oLabel )
           cCtrl   = acCtrlDlg[ CLS_LISTBOX ]
           cStyle += cArr2Str( acCtrlStyles[ CLS_LISTBOX, CLS_DEFAULT ], " | " )

      case cCtrl == 'T' + acCtrlDlg[ CLS_SCROLLBAR ]
           cCtrl   = acCtrlDlg[ CLS_SCROLLBAR ]
           cStyle += "SBS_" + if( oCtrl:lHorizontal, "HORZ", "VERT" )

      case cCtrl == 'T' + acCtrlDlg[ CLS_CHECKBOX ]
           cCtrl   = acCtrlDlg[ CLS_CHECKBOX ]
           cText = ' "' + oCtrl:cText + '"'
           cStyle += cArr2Str( acCtrlStyles[ CLS_CHECKBOX, CLS_DEFAULT ], " | " )

      case cCtrl == 'TBUTTON'
           cCtrl   = acCtrlDlg[ CLS_PUSHBUTTON ]
           cText   = ' "' + oCtrl:oLabel:cText + '"'
           cStyle += cArr2Str( acCtrlStyles[ CLS_PUSHBUTTON, CLS_DEFAULT ], " | " )
           // Como la sombra esta incluida en en tama¤o del bot¢n.
           nWidth--
           nHeight--

      case cCtrl == 'TRADIO'
           cCtrl   = acCtrlDlg[ CLS_RADIOBUTTON ]
           cText   = ' "' + oCtrl:cText + '"'
           cStyle += cArr2Str( acCtrlStyles[ CLS_RADIOBUTTON, CLS_DEFAULT ], " | " )

      case cCtrl == 'TLABEL'              // LText, CText, RText
           cCtrl   = acCtrlDlg[ CLS_CTEXT + oCtrl:nJustify ]
           cText   = ' "' + oCtrl:cText + '"'
           cStyle += cArr2Str( acCtrlStyles[ CLS_CTEXT + oCtrl:nJustify, CLS_DEFAULT ], " | " )

      // Control...

      case cCtrl == 'TSAY'
           cText   = ' "' + oCtrl:cText + '"'
           c_Class = '"' + cCtrl + '"'
           c_Style = ''
           cCtrl   = 'CONTROL'

      case cCtrl == 'TRADMENU'
           lGroup  = .t.
           cText   = ' "' + oCtrl:oLabel:cText + '"'
           c_Class = '"' + cCtrl + '"'
           c_Style = ''
           cCtrl   = 'CONTROL'
           aEval( oCtrl:aChilds, {| oCtrl | cLineCtrls += cGetDlgCtrl( oCtrl ) } )

      otherwise

           Alert( 'Control no Salvado: ' + cCtrl )

   endcase

   lGroup = .f.

return cPrevLine                                   + ;
       space( 3 ) + cCtrl                 + " "    + ;
       if( IS_NIL( cText ),   '', cText   + ", " ) + ;
       Str( oCtrl:nGetId(), 4 )           + ", "   + ;
       if( IS_NIL( c_Class ), '', c_Class + ", " ) + ;
       if( IS_NIL( c_Style ), '', c_Style + ", " ) + ;
       Str( oCtrl:nLeft() * 16, 4 )       + ", "   + ;
       Str( oCtrl:nTop()  *  8, 4 )       + ", "   + ;
       Str(       nWidth  * 16, 4 )       + ", "   + ;
       Str(       nHeight *  8, 4 )                + ;
       if( Empty( cStyle ), '', ", " + cStyle    ) + ;
       cLineCtrls

//---------------------------------------------------------------------------//
