#include "FiveDos.ch"
#include "SysColor.ch"
#include "fontdef.h"

#define MAXLENARRAY   4096

static oBrw

//----------------------------------------------------------------------------//
// Funciones para LISTBOX BROWSE
//----------------------------------------------------------------------------//

function oBrwBegin( nTop, nLeft, nBottom, nRight, cColors, cHeadSep, cSeparator,;
                    nColFreeze, nInd, uValTop, uValBottom, cAlias, lAutoFields,;
                    lGroup )

   DEFAULT  cAlias  := Alias(),;
            nTop    := 0,;
            nLeft   := 0,;
            nBottom := 5,;
            nRight  := 24

   oBrw = TBrowseNew( nTop, nLeft, nBottom, nRight )
   
   if( IS_ARRAY( cAlias ),;
       SetBrwArrFlt( oBrw, uValTop, uValBottom, cAlias ),;
       SetBrwDbFlt( oBrw, uValTop, uValBottom, nInd, cAlias ) )

   if lAutoFields
      if IS_ARRAY( cAlias )
         AutoAFields( oBrw, cAlias )
      else
         if IS_OBJECT( cAlias )
            if cAlias:FamilyName() == "TFILE"
               COLUMN TITLE cAlias:cName ;
                      SHOW cAlias:ReadLn( TABSIZE ) ;
                      WIDTH 74
            else
               ( cAlias:nArea )->( AutoFields( oBrw, lGroup ) )
            endif
         else
            ( cAlias )->( AutoFields( oBrw, lGroup ) )
         endif

      endif
   endif

   oBrw:ColorSpec = if( !IS_NIL( cColors ), cColors, aSysColor( CLR_cBROWSE ) )

   if !IS_NIL( cSeparator )
      oBrw:colSep = cSeparator
   endif   
   if !IS_NIL( nColFreeze )
      oBrw:freeze = nColFreeze
   endif   
   
   if !( IS_ARRAY( cAlias ) .and. lAutoFields )
      oBrw:HeadSep = if( !IS_NIL( cHeadSep ), cHeadSep, " Ä" )
   endif
   
return oBrw

//----------------------------------------------------------------------------//

function oBrwColumn( bData, cTitle, nWidth, cFooter, anColors, bColor, cFootSep,;
                     cPicture )

   local oCol := TbColumnNew( cTitle, bData )
   
   if !IS_NIL( nWidth )
      oCol:Width = nWidth
   endif
      
   if !IS_NIL( cFooter )
      oCol:Footing = cFooter
   endif
      
   if !IS_NIL( anColors )
      oCol:defColor = anColors
   endif
      
   if !IS_NIL( bColor )
      oCol:colorBlock = bColor
   endif   
      
   if !IS_NIL( cFootSep )
      oCol:FootSep = cFootSep
   endif   

   if !IS_NIL( cPicture )
      oCol:picture = cPicture
   endif   

   oBrw:AddColumn( oCol )

return oCol

//---------------------------------------------------------------------------//

function BrowseEnd()
return oBrw := nil

//----------------------------------------------------------------------------//
// Funciones para LISTBOX FIELDS
//----------------------------------------------------------------------------//

function oWBrowse( nTop, nLeft, nWidth, nHeight, abFld, aHeaders, aColSizes,;
                   oDlg, cColors, cMsg, nInd, uValTop, uValBottom,;
                   cAlias, nColFreeze, cLabel, bLogicLen, bChange, bDblClick,;
                   bWhen, bValid, bRClick, lMSelect, acColorLabel )

   local lAutoFields := empty( abFld ),;
         lGroup      := .f.

   local oBrw, oCol, nCol, aList, i,;
         nColWidth := 0,;
         lEmptyCol := Empty( aColSizes )

   DEFAULT nHeight   := oDlg:nHeight - nTop  - 5 ,;
           nWidth    := oDlg:nWidth  - nLeft - 4 ,;
           cAlias    := Alias(),;
           aColSizes := {}

   oBrw = TBrowseNew( nTop, nLeft, nTop + nHeight + 1, nLeft + nWidth + 1 )

   // Comprueba si FIELDS, tiene el/los arrays.
   if !lAutoFields .and. IS_ARRAY( eval( abFld[1] ) )
      cAlias = eval( abFld[1] )                 // Mono o Multi Array en Fields.
      if ( nCol := len( abFld ) ) > 1
         cAlias = Array( nCol )
         for i = 1 to nCol
             cAlias[i] = eval( abFld[ i ] )     // MultiArrays en Fields.
         next
         
      endif

   endif
      
   i = if( IS_ARRAY( cAlias ),;
           SetBrwArrFlt( oBrw, uValTop, uValBottom, cAlias ),;
           SetBrwDbFlt( oBrw, uValTop, uValBottom, nInd, cAlias ) )

   DEFAULT bLogicLen := i         // Asigna bLogicLen si no lo envian.

   if lAutoFields
      if IS_ARRAY( cAlias )
         AutoAFields( oBrw, cAlias, aHeaders, aColSizes )
      else
         if IS_OBJECT( cAlias )
            if cAlias:FamilyName() == "TFILE"
               oBrw:AddColumn( oCol := TbColumnNew( cAlias:cName,;
                                       { || cAlias:ReadLn( TABSIZE ) } ) )
               oCol:Width = oDlg:nWidth - 6
            else // se supone que es workarea
               ( cAlias:nArea )->( AutoFields( oBrw, lGroup ) )
            endif
         else
            ( cAlias )->( AutoFields( oBrw, lGroup ) )
         endif

      endif
   else
      nCol = len( abFld )
      if !Empty( aHeaders )
         aSize( aHeaders, nCol )
      endif   
      
      for i = 1 to nCol
          oBrw:AddColumn( ;
          oCol:= TbColumnNew( if( Empty( aHeaders ),,aHeaders[ i ] ), abFld[ i ] ) )
          if !Empty( aColSizes ) .and. !Empty( aColSizes[ i ] )
             oCol:width = aColSizes[ i ]
          endif
      next
   endif
   
   oBrw:ColorSpec = if( !IS_NIL( cColors ), cColors, aSysColor( CLR_cBROWSE ) )
   oBrw:HeadSep   = " Ä"
    
return TCtlBrowse():New( nTop, nLeft, nWidth, nHeight, oBrw, cLabel, cMsg,;
                         cColors, oDlg, bLogicLen, bChange, bDblClick,;
                         bWhen, bValid, bRClick, acColorLabel )

//----------------------------------------------------------------------------//
// Funciones para BROWSE TREE
//----------------------------------------------------------------------------//

function oTreeBrowse( nTop, nLeft, nWidth, nHeight, oTree, oDlg, ;
                      cLabel, cMsg, cColors, bChange, bDblClick,;
                      bWhen, bValid, bRClick, acColorLabel )

  local Self := TCtlBrowse()
  local oBrw,;
        oItem     := oTree:oFirst,;
        bLogicLen := { || oTree:nCount() }
        bDblClick := { || If( oItem:oTree != nil, ( oItem:Toggle(),;
                              ::oVScroll:SetRange( oTree:nCount() ),;
                              ::Clear() ),) }

    DEFAULT nHeight   := oDlg:nHeight - nTop  - 5 ,;
            nWidth    := oDlg:nWidth  - nLeft - 4

    oBrw = TBrowseNew( nTop, nLeft, nTop + nHeight + 1, nLeft + nWidth + 1 )

    while .t.
          oItem:Draw()
          if IS_NIL( (oItem := oItem:GetNext()) )
             exit
          elseif IS_NIL( oItem:oNext )
             oItem:Draw()
             exit
          endif
    enddo

    oBrw:Cargo         := oTree:oFirst
    oBrw:GoTopBlock    := { || oBrw:Cargo := oTree:oFirst }
    oBrw:GoBottomBlock := { || oBrw:Cargo := oTree:GetLast() }
    oBrw:SkipBlock     := { | n | oBrw:Cargo := oBrw:Cargo:Skip( @n ), n }

    oBrw:AddColumn( TbColumn():New( Chr( LEFTRADIO ) + ;
                                    Chr( CENTERRADIO2 ) + chr( RIGHTRADIO ),;
                                    {|| pad( oItem:GetLabel(), nWidth-2 ) } ) )

    oBrw:ColorSpec = if( !IS_NIL( cColors ), cColors, aSysColor( CLR_cBROWSE ) )
    oBrw:HeadSep   = "Ä"
    
return Self:New( nTop, nLeft, nWidth, nHeight, oBrw, cLabel, cMsg,;
                 cColors, oDlg, bLogicLen, bChange, bDblClick,;
                 bWhen, bValid, bRClick, acColorLabel )

//----------------------------------------------------------------------------//
// Funciones para BROWSE MULTISELECT
//----------------------------------------------------------------------------//

function oMSelBrowse( nTop, nLeft, nWidth, nHeight, oBrowse, oDlg, cLabel,;
                      cMsg, cColors, bLogicLen, bChange, bWhen, bValid, bRClick, ;
                      acColorLabel )

   local n,;
         oCtlBrw:= TCtlBrowse(),;
         bDblClick,;
         bClrBlock,;
         nLen   := oBrowse:colCount,;
         oStack := {}
//          oStack := if( eval( bLogicLen ) > MAXLENARRAY, TSStack(), TStack() )

   // bClrBlock = {|x| if( oStack:lFound( oCtlBrw:oVScroll:nOption, .t. ), ( Tock(), Tock(), {4,5} ), {1,2} ) }
   bClrBlock = {|x| if( ascan( oStack, oCtlBrw:oVScroll:nOption ) > 0, (tock(),{4,5}), {1,2} ) }

   for n = 1 to nLen
       oBrowse:getColumn( n ):ColorBlock := bClrBlock
   next

   oBrowse:AutoLite = .t.
   oBrowse:Cargo    = oStack

                    // if( Empty( n:= oStack:nFound( oCtlBrw:oVScroll:nOption, .t. ) ),;
                    //    oStack:Push( oCtlBrw:oVScroll:nOption ),;
                    //    oStack:Pop( n ) ),;
   bDblClick := {|Self, n| ;
                    if( ( n := ascan( oStack, oCtlBrw:oVScroll:nOption ) ) == 0,;
                        aadd( oStack, oCtlBrw:oVScroll:nOption ),;
                        ( adel( oStack, n ), asize( oStack, len( oStack ) - 1 ) ) ),;
                    oCtlBrw:BrwHide(),;
                    oCtlBrw:RefreshCurrent(),;
                    oCtlBrw:BrwDisplay() }

return oCtlBrw:New( nTop, nLeft, nWidth, nHeight, oBrowse, cLabel, cMsg,;
                         cColors, oDlg, bLogicLen, bChange, bDblClick,;
                         bWhen, bValid, bRClick, acColorLabel )

//----------------------------------------------------------------------------//
// Funciones VARIAS
//----------------------------------------------------------------------------//

function SetBrwDb( oBrw, cAlias )

   local bLogicLen
   
   DEFAULT cAlias := Alias()
   
   if IS_OBJECT( cAlias )
      oBrw:GoTopBlock    = {|| cAlias:GoTop() }
      oBrw:GoBottomBlock = {|| cAlias:GoBottom() }
      oBrw:SkipBlock     = { | nSkip | cAlias:Skipper( nSkip ) }
      bLogicLen          = {|| cAlias:RecCount() }
   else   
      oBrw:GoTopBlock    = {|| ( cAlias )->( DbGoTop() ) }
      oBrw:GoBottomBlock = {|| ( cAlias )->( DbGoBottom() ) }
      oBrw:SkipBlock     = { | nSkip | ( cAlias )->( _DbSkipper( nSkip ) ) }
      bLogicLen          = {|| ( cAlias )->( RecCount() ) }
   endif

return bLogicLen

//----------------------------------------------------------------------------//

function SetBrwDbFlt( oBrw, uValTop, uValBottom, nInd, cAlias )

   local bSkip, bLogicLen
   
   DEFAULT uValBottom := uValTop,;
           cAlias     := Alias(),;
           nInd       := ( cAlias )->( IndexOrd() )

   // Posibility of using FILTERs based on INDEXES!!!

   if IS_NIL( uValTop ) .or. IS_OBJECT( cAlias )
      bLogiclen = SetBrwDb( oBrw, cAlias )
      if !IS_NIL( uValTop ) .and. IS_OBJECT( cAlias )
         cAlias:SetScope( uValTop, uValBottom, nInd )
      endif
   else   
      bSkip              = bSkipKey( uValTop, uValBottom, nInd, cAlias )
      oBrw:GoTopBlock    = {|| ( cAlias )->( DbSeek( uValTop, .t. ) ) }
      oBrw:GoBottomBlock = {|| ( cAlias )->( DbSeek( NextVal( uValBottom ), .t. ),;
                                             DbSkip( -1 ) ) }
      oBrw:SkipBlock     = { | nSkip | ( cAlias )->( DbSkipKey( nSkip, bSkip ) ) }
      bLogicLen          = {|| ( cAlias )->( DbCountKey( oBrw ) ) }
   endif
   
return bLogicLen

//----------------------------------------------------------------------------//

function SetArray( oBrw, aList )

   local nAt := 1
   
   oBrw:GoTopBlock    = {|| nAt := 1 }
   oBrw:GoBottomBlock = {|| nAt := len( aList ) }
   oBrw:SkipBlock     = { | nSkip, nDo | if( IS_NIL( nSkip ), nAt,;
        ( nAt:= Min( Max( ( nDo:= nAt ) + nSkip, 1 ), len( aList ) ) ) - nDo ) }
          
return bSetGet( nAt )         // The Goto() .and. the RecNo()

//----------------------------------------------------------------------------//

function SetBrwArray( oBrw, aList )

   local bLogicLen
   
   if !IS_ARRAY( aList[1] )
      bLogicLen          = {|| len( aList ) }
      oBrw:Cargo         = 1
      oBrw:GoTopBlock    = {|| oBrw:Cargo := 1 }
      oBrw:GoBottomBlock = {|| oBrw:Cargo := len( aList ) }
      oBrw:SkipBlock     = { | nSkip, nDo | ;
                                ( oBrw:Cargo:= Min( Max( ( nDo:= oBrw:Cargo ) +;
                                  nSkip, 1 ), len( aList ) ) ) - nDo }
   else
      bLogicLen          = {|| len( aList[1] ) }
      oBrw:Cargo         = 1
      oBrw:GoTopBlock    = {|| oBrw:Cargo := 1 }
      oBrw:GoBottomBlock = {|| oBrw:Cargo := len( aList[1] ) }
      oBrw:SkipBlock     = { | nSkip, nDo | ;
                                ( oBrw:Cargo:= Min( Max( ( nDo:= oBrw:Cargo ) +;
                                  nSkip, 1 ), len( aList[1] ) ) ) - nDo }
   endif

return bLogicLen

//----------------------------------------------------------------------------//
// Nota: el array debe de estar ordenado. Warning, will not avaliable.

function SetBrwArrFlt( oBrw, uValTop, uValBottom, aList )

   local bSkip, bLogicLen

   DEFAULT uValBottom := uValTop

   if IS_NIL( uValTop )
      bLogicLen = SetBrwArray( oBrw, aList )
   else   
      bSkip              = bSkipKey( uValTop, uValBottom, oBrw, aList )
      bLogicLen          = {|| ArrCountKey( oBrw ) }
      oBrw:GoTopBlock    = {|| aScan( aList, { |e| e >= uValTop } ) }
      oBrw:GoBottomBlock = {|| RaScan( aList, { |e| e <= uValTop } ) }
      oBrw:SkipBlock     = { | nSkip | ArrSkipKey( nSkip, bSkip, oBrw, aList ) }
   endif

return bLogicLen

//----------------------------------------------------------------------------//
//  Manejo de ficheros con clave.
//----------------------------------------------------------------------------//
// Al utilizar esta funcion, tener en cuenta que si el indice no esta creado
// incluyendo el alias, debeis seleccionarlo en el programa antes de evaluar
// el codeblock.       ej: ( Clientes )->( eval( bWhen ) )

function bSkipKey( uValTop, uValBottom, nInd, cAlias )

   local cClave, cType := valtype( uValTop )

   DEFAULT uValBottom := uValTop,;
           cAlias     := Alias(),;
           nInd       := ( cAlias )->( IndexOrd() )

   if IS_OBJECT( nInd )                     // Array.
      cClave = "cAlias[ nInd:cargo ]"
   else
      // Esta cClave no introduce "cAlias->"
      cClave = if( IS_CHARACTER( nInd ), nInd, ( cAlias )->( IndexKey( nInd ) ) )
   endif
   
   do case
      case IS_CHARACTER( cType )
           return Compila( if( uValTop == uValBottom,; 
                            cClave + "='"  + uValTop + "'",;
                            cClave + ">='" + uValTop + "'.and." +;
                            cClave + "<='" + uValBottom + "'" ) )
                   
      case IS_DATE( cType )
           return Compila( if( uValTop == uValBottom,; 
                            cClave + " = CToD( '" + DToC( uValTop ) + "')",;
                            cClave + ">= CToD( '" + DToC( uValTop ) + "') .and." +;
                            cClave + "<= CToD( '" + DToC( uValBottom ) + "')" ) )
                            
      case IS_NUMBER( cType ) .or. IS_LOGICAL( cType )
           return Compila( if( uValTop == uValBottom,; 
                            cClave + "="  + cValToChar( uValTop ),;
                            cClave + ">=" + cValToChar( uValTop ) + ".and." +;
                            cClave + "<=" + cValToChar( uValBottom ) ) )
   endcase
   
return bTrue()

//----------------------------------------------------------------------------//
// No hace falta seleccionar el cAlias pues ya esta puesto en el codeblock.

static function DbSkipKey( nSkip, bWhile )

   local nSkipped, i, i2, n, nPos:= 0
   
   // Necesario para comprobar si el registro a¤adido cumple la clave.
   if Empty( nSkip )
      return if( IS_NIL( nSkip ), eval( bWhile ), DbSkip( nSkip ) )
   endif
   
   nSkipped = _DbSkipper( nSkip )   // Ojo. _DbSkipper() no hace skip + 1
   
   if !Empty( nSkipped ) .and. !Eval( bWhile )
   
      _DbSkipper( -nSkipped )
      
      if abs( nSkip ) == 1                             // Poner Eof o Bof.
      
         i        = nSkip
         nSkipped = nPos
         
      else
      
         If nSkip > nPos
            i  = 1
            i2 = .5
            // Pre-Optimizaci¢n  ( correci¢n de anchura ) Positivos.
            nSkip = Min( nSkipped, nSkip - i )   // Corrige Eof() y el Max.
         else
            i  = - 1
            i2 = -.5
            // Pre-Optimizaci¢n  ( correci¢n de anchura ) Negativos.
            nSkip = Max( nSkipped, nSkip - i )   // Corrige Bof() y el Min.
         endif
            
         nSkipped = nPos
         
         // Busqueda binaria.
         while nSkip != nSkipped
               n = int( ( nSkip + nSkipped ) / 2 + i2 ) //  + i/2
               _DbSkipper( n - nPos )
               nPos = n
               if eval( bWhile )
                  nSkipped = n
               else   
                  nSkip    = n - i
               endif   
         end
            
         DbSkip( nSkip - n )
         
      endif
      
//      MsgInfo( if( i > 0, "End", "Beginning" ) + " of file" )
      
   else
   
      if nSkip > nSkipped
         DbGoBottom()
//         MsgInfo( "End of file" )
      elseif nSkip < nSkipped
         DbGoTop()
//         MsgInfo( "Beginning of file" )
      endif
      
   endif   

return nSkipped

//----------------------------------------------------------------------------//

static function ArrSkipKey( n, bWhile, oBrw, aList )

   local nSkipped := 0, nDirection ,;
         nRecNo   := oBrw:Cargo    ,;
         nLen     := len( aList )

   oBrw:Cargo += n
   
   if Eval( bWhile ) .and. oBrw:Cargo <= nLen .and. oBrw:Cargo > 0
      nSkipped = n
   else   
      oBrw:Cargo = nRecNo
      nDirection = If( n > 0, 1, -1 )
      while nSkipped != n .and. Eval( bWhile ) .and. oBrw:Cargo < nLen .and.;
            oBrw:Cargo > 1
            oBrw:Cargo += nDirection
            nSkipped   += nDirection
      end
      if ! Eval( bWhile )
         oBrw:cargo -= nDirection
         nSkipped   -= nDirection
      endif
   endif
   
return nSkipped

//----------------------------------------------------------------------------//
// Llamar a la funcion con ( cAlias )->( DbCountKey( oBrw ) )

function DbCountKey( oBrw )

   local nRegs, nRecNo := RecNo()
   
   DbGoTop()
   nRegs = eval( oBrw:SkipBlock, LastRec() )
   DbGoTo( nRecNo )

return nRegs

//----------------------------------------------------------------------------//

function ArrCountKey( oBrw )

   local nRecNo := oBrw:Cargo, nRecFirst
   local nReg   := 0

   if eval( oBrw:GoTopBlock )             // Busca el Primer Registro.
      nRecFirst = oBrw:Cargo              // Guarda el N§ del Primer Registro.
      eval( oBrw:GoBottomBlock )          // Busca el Ultimo Registro.
      nReg = oBrw:Cargo - nRecFirst + 1   // N§ de Registros = Last - First + 1.
   endif
   
   oBrw:Cargo = nRecNo                    // Posiciona Registro Actual.

return nReg

//----------------------------------------------------------------------------//
// Llamar a la funcion con ( cAlias )->( AutoFields( oBrw ) )

function AutoFields( oBrw, lGroup, lSetGet )

   local i, nFields:= FCount(), nArea := Select()
   local cHeader, cSep, nLen, nWidth, nLenTotal:= 0, nCol:= 0
   
   memvar cCad
   
   DEFAULT lSetGet := .f.,;
           oBrw    := TBrowseDb()

   if lGroup
   
      nLen    = 0
      nWidth  = oBrw:nRight - oBrw:nLeft + 1
      cSep    = oBrw:ColSep
      cCad    = "'" + cSep + "'"
      cHeader = cSep
      
      for i = 1 to nFields
          nCol++
          nLen       = nValLen( FieldGet( i ),;
                                if( IS_NUMBER( FieldGet(i) ), .f., .t. ) )
          nLenTotal += nLen + len( cSep )
          
          if nLenTotal > nWidth
             oBrw:AddColumn( TbColumnNew( cHeader, Compila( cCad ) ) )
             cCad      = "'" + cSep + "'"
             cHeader   = cSep
             nLenTotal = len( cSep )
             if nCol > 1
                nCol     = 1
                cHeader += Pad( Field( i ), nLen ) + cSep
                cCad    += "+ cValToChar(" + Field( i ) + ")+'" + cSep + "'"
             endif
          else
             cHeader += Pad( Field( i ), nLen ) + cSep
             cCad    += "+ cValToChar(" + Field( i ) + ")+'" + cSep + "'"
          endif
          
      next
      
      if !Empty( nCol )
         oBrw:AddColumn( TbColumnNew( cHeader, Compila( cCad ) ) )
      endif
      
   else
   
      for i = 1 to nFields
          oBrw:AddColumn( TbColumnNew( Field( i ),;
               if( lSetGet, FieldWBlock( Field( i ), nArea ),;
                            FieldBlock( Field( i ) ) ) ) )
      next
      
   endif
   
return nFields

//----------------------------------------------------------------------------//

function AutoAFields( oBrw, aList, aHeaders, aColSizes )

  local i, oCol, nCol, nColWidth := 0
  
  DEFAULT oBrw := TBrowseNew()

  if IS_ARRAY( aList[ 1 ] )
     nCol = len( aList )
     for i = 1 to nCol
         oBrw:AddColumn( oCol:= TbColumnNew( if( Empty( aHeaders ),, aHeaders[i] ),;
                                bFieldArr( oBrw, aList, i ) ) )
         if Empty( aColSizes )                        
            nColWidth = 0
            AEval( aList[i], { | e | nColWidth := Max( nColWidth, nValLen( e, .t. ) ) } )
         else
            nColWidth = aColSizes[ i ]
         endif      
         oCol:Width = nColWidth
     next
  else
     nCol = 1
     oBrw:AddColumn( oCol:= TbColumnNew( if( Empty( aHeaders ),, aHeaders[1] ),;
                            bFieldArr( oBrw, aList ) ) )
     if Empty( aColSizes )                        
        AEval( aList, { | e | nColWidth := Max( nColWidth, nValLen( e, .t. ) ) } )
     else
        nColWidth = aColSizes[ 1 ]
     endif   
     oCol:Width = nColWidth
  endif
  
return nCol

//----------------------------------------------------------------------------//
// Para usar cuando se a¤ade una columna a un browse.

function bFieldArr( oBrw, aList, i )
return if( IS_NIL( i ), {|| aList[ oBrw:Cargo ] }, {|| aList[i] [ oBrw:Cargo ] } )

//----------------------------------------------------------------------------//

