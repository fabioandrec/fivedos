#include "Fivedos.ch"
#include "sysstr.ch"

//----------------------------------------------------------------------------//

CLASS TDataBase FROM TWorkArea, TDb

   DATA lScope, lBof, lEof AS LOGIC
   DATA bBof, bEof, bNew   AS BLOCK INIT bNil()
   DATA bWhile             AS BLOCK INIT bTrue()
   DATA uValTop, uValBottom

   METHOD Append()         INLINE ::Super:Append(), eval( ::bNew, Self )
   METHOD BoF()            INLINE ::lBof .or. ::Super:Bof()
   METHOD Create( aField ) INLINE if( lArray( aField ), ::aField:= aField, ),;
                                  ::Super:Create( ::cFile, ::aField, ::cDriver )
   METHOD EoF()            INLINE ::lEof .or. ::Super:Eof()
   METHOD GoTo( nReg )     INLINE ::lEof:= .f., ::lBof:= .f., ::Super:GoTo( nReg )

   METHOD GoTop()          INLINE if( !::lScope, ::Super:GoTop(),;
                                                ::Super:Seek( ::uValTop, .t. ) ),;
                                  ::lEof:= .f., ::lBof:= .t., eval( ::bBof, Self )

   METHOD GoBottom()       INLINE if( !::lScope, ::Super:GoBottom(),;
                                    ( ::Super:Seek( NextVal( ::uValBottom ), .t. ),;
                                      ::Super:Skip( -1 ) ) ),;
                                  ::lBof:= .f., ::lEof:= .t., eval( ::bEof, Self )
                                 
   METHOD KeyCount()       BLOCK {| Self, nRecNo, nKey | ;
                                    nRecNo := ::RecNo(),;
                                    ::GoTop() ,;
                                    nKey   := ::Skipper( ::LastRec() ),;
                                    ::GoTo( nRecNo ), ++nKey }

   METHOD KeyGoto( nKey )  INLINE ::GoTop(), ::Skipper( --nKey )

   METHOD KeyNum()         BLOCK {| Self, nRecNo, nKey | ;
                                    nRecNo := ::RecNo(),;
                                    nKey   := abs( ::Skipper( -( ::LastRec() ) ) ),;
                                    ::GoTo( nRecNo ), ++nKey }

   METHOD bSkipKey( uValTop, uValBottom, nIndex ),;
          CreateIndex( cName ),;
          New( nArea, cDriver, cFile, cAlias, lShared, lReadOnly, aField, aIndex ),;
          Redefine( cName, cAlias, cScope, oDict ),;
          SetIndex( xIndex, lName ),;
          SetOrder( nOrder ),;
          SetScope( uValTop, uValBottom, nIndex, cIndex ),;
          Seek( uExp, lSoft ),;
          SelectDb(),;
          Skip( nSkip ),;
          Skipper( nSkip ),;  // Nota: ::Skipper() sin param. no mueve el puntero.
          Use( nArea, cDriver, cFile, cAlias, lShared, lReadOnly )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nArea, cDriver, cFile, cAlias, lShared, lReadOnly, aField, aIndex )

    cAlias := Upper( if( Empty( cAlias ), cFile, cAlias ) )

    BYNAME nArea     INIT NUMBER
    ::nInitArea := ::nArea
    BYNAME cAlias
    BYNAME cFile     DEFAULT cAlias
    BYNAME cDriver   DEFAULT DbSetDriver()
    BYNAME lShared   INIT LOGICAL
    BYNAME lReadOnly INIT LOGICAL
    BYNAME aField    INIT ARRAY   // array de objetos dbField.
    BYNAME aIndex    INIT ARRAY   // array de objetos dbIndex.

RETURN Self

//----------------------------------------------------------------------------//

METHOD Use( nArea, cDriver, cFile, cAlias, lShared, lReadOnly )

   BYNAME cAlias    INIT DEFAULT if( !Empty( cFile ), Upper( cFile ), )
   BYNAME cDriver   INIT DEFAULT DbSetDriver()
   BYNAME lShared   INIT LOGICAL
   BYNAME lReadOnly INIT LOGICAL
   BYNAME cFile     INIT DEFAULT if( !Empty( cAlias ), cAlias, Alias() )
   BYNAME nArea     INIT NUMBER
   if IS_NIL( ::nInitArea )
      ::nInitArea := ::nArea
   end

return ::Super:Use( ::nArea, ::cDriver, ::cFile, ::cAlias, ::lShared, ::lReadOnly )

//----------------------------------------------------------------------------//
// cName  = Alias de dbf en oDict.
// cAlias = Alias que se asigna a oDb redefinida.
// cScope = Scope para todos los indices.

METHOD Redefine( cName, cAlias, cScope, oDict )

   ::TDb:Redefine( cName, cAlias, oDict )
   if !Empty( cScope )
      ::SetScope( cScope,, .t.,, .t. )
   end

return Self

//----------------------------------------------------------------------------//

METHOD SelectDb()
return if( Empty( Select( ::cAlias ) ), ::Use(), DbSelectArea( ::cAlias ) ), Self

//----------------------------------------------------------------------------//

METHOD SetOrder( nOrder )

  local aIndex := ::aIndex

  if !Empty( aIndex )
     if IS_CHARACTER( nOrder )
        nOrder := aScan( ::aIndex, {|e| e:cName == Upper( nOrder ) } )
     end
     ::uValTop    := ::aIndex[ nOrder ]:uValTop
     ::uValBottom := ::aIndex[ nOrder ]:uValBottom
     ::bWhile     := ::bSkipKey( ::uValTop, ::uValBottom, nOrder )
  end
  ::Super:SetOrder( nOrder )

return nil

//----------------------------------------------------------------------------//

METHOD SetIndex( acIndex, acName )

   local i, n, p

   if Empty( acIndex )                           // Indice en ::aIndex.
      if IS_LOGICAL( acName ) 
         aEval( ::aIndex, {|e| ::Super:SetIndex( e:cFile ) } )
         ::SetOrder( 1 )
       else
         if IS_CHARACTER( acName )
            acName := { acName }
         end
         for n = 1 to len( acName )
             if !Empty( p:= aScan( ::aIndex, {|e| e:cName == Upper( acName[i] ) } ) )
                ::Super:SetIndex( ::aIndex[p]:cFile )
                if n == 1               // Activa el orden al primer indice.
                   ::SetOrder( p )
                end
    end
         next
      end
    else
      if IS_ARRAY( acIndex )
         aEval( acIndex, {|e| ::Super:SetIndex( e ) } )
         ::SetOrder( 1 )
      elseif IS_CHARACTER( acIndex )
             ::Super:SetIndex( acIndex )
             if Empty( ::IndexOrd() )
                ::SetOrder( 1 )
             end
      end
   end

return nil

//----------------------------------------------------------------------------//

METHOD CreateIndex( cName )

  aEval( if( Empty( cName ), ::aIndex,;
            ::aIndex[ aScan( ::aIndex, {|e| e:cName == Upper( cName ) } ) ] ),;
    {|e| (::nArea)->(ordCondSet( e:cFor, Compila( e:cFor ),,,,,,,,,e:lDescend ) ),;
          ::Super:CreateIndex( e:cFile, e:cKey, Compila( e:cKey ), e:lUnique ) } )

return nil

//----------------------------------------------------------------------------//

METHOD Seek( uExp, lSoft )
return if( ::Super:Seek( uExp, lSoft ) .and. ;
           !( ::lScope .and. !eval( ::bWhile ) ),;
           ( ::lBof:= .f., ::lEof:= .f., .t. ),;
           ( ::GoBottom(), .f. ) )

//----------------------------------------------------------------------------//
// Nota: ::Skip() si mueve el puntero.

METHOD Skip( nSkip )

   DEFAULT nSkip := 1                    // Activate ::Skip() == ::Skip(1)

   // Desactiva eof() y bof()
   ::lEoF = .f.
   ::lBof = .f.

   ::Super:Skip( nSkip )
   
   if ::lScope
      if !Eval( ::bWhile )
         if( nSkip > 0, ::GoBottom(), ::GoTop() )
      endif
   else
      if ::Eof()
         ::GoBottom()
      elseIf ::Bof()   
         ::GoTop()
      endif   
   endif

return nil

//----------------------------------------------------------------------------//
// by J.M.R. & F.Pulp¢n.                Nota: ::Skipper() no mueve el puntero.

METHOD Skipper( nSkip )

   local nSkipped, bWhile, i, i2, n, nPos:= 0
   local lBuffer
*   local nOldArea   
/*
   // Incrementa velocidad en Browse. ( SOLO EN CASOS ATIPICOS )
   if Empty( nSkip ) .or. ( nSkip > nPos .and. ::Eof() ) ;
                     .or. ( nSkip < nPos .and. ::Bof() )

      if ::lEof
         ::lBof = .f.
      endif
      if ::lBof
         ::lEof = .f.
      endif

      return nPos                        // Return 0
   endif
*/
   ::lEoF = .f.                          // Desactiva eof() y bof()
   ::lBof = .f.
   
   // No quitar, sino no funciona el SetScope()
*  nOldArea = Select()
*  DbSelectArea( ::nArea )
   
   nSkipped = ::Super:Skipper( nSkip )
   
   if !Empty( nSkipped ) .and. ::lScope .and. !Eval( bWhile:= ::bWhile )
   
      ::Super:Skipper( -nSkipped )
      
      if abs( nSkip ) == 1                             // Poner Eof o Bof.
      
         i        = nSkip
         nSkipped = nPos                               // nSkipped = 0
         
      else
      
         If nSkip > nPos                               // nSkip > 0
            i  = 1
            i2 = .5
            // Pre-Optimizaci¢n  ( correci¢n de anchura ) Positivos.
            nSkip = Min( nSkipped, nSkip - i )   // Corrige Eof() y el Max.
         else                                          // nSkip < 0
            i  = - 1
            i2 = -.5
            // Pre-Optimizaci¢n  ( correci¢n de anchura ) Negativos.
            nSkip = Max( nSkipped, nSkip - i )   // Corrige Bof() y el Min.
         endif
            
         nSkipped = nPos                               // nSkipped = 0

         // Save the buffer and itself = .f.
         lBuffer := ::lBuffer = .f.

         // Busqueda binaria.
         while nSkip != nSkipped
               n = int( ( nSkip + nSkipped ) / 2 + i2 ) //  + i/2
               ::Super:Skipper( n - nPos )
               nPos = n
               if eval( bWhile )
                  nSkipped = n
               else   
                  nSkip    = n - i
               endif   
         end

         // Restore the buffer.
         ::lBuffer = lBuffer

         // Load buffer and skip if necesit.
         ::Super:Skip( nSkip - n )
         
      endif
      
      if i > 0
         ::lEof = .t.
         eval( ::bEof, Self )
      else   
         ::lBof = .t.
         eval( ::bBof, Self )
      endif   
      
   else
   
     if nSkip > nSkipped
        ::GoBottom()
     elseif nSkip < nSkipped
        ::GoTop()
     end

   endif   
   
*   DbSelectArea( nOldArea )

return nSkipped

//----------------------------------------------------------------------------//

METHOD SetScope( uValTop, uValBottom, nIndex, cIndex, lScope )

   local aIndex := ::aIndex

   DEFAULT uValBottom := uValTop

   if IS_LOGICAL( nIndex ) .and. !Empty( aIndex )
      for nIndex = 1 to Len( aIndex )
          aIndex[ nIndex ]:uValTop    := uValTop
          aIndex[ nIndex ]:uValBottom := uValBottom
          aIndex[ nIndex ]:lScope     := lScope
      next
      nIndex       := Max( ::IndexOrder(), 1 )  // Dbf no abierta.
      lScope       := aIndex[ nIndex ]:lScope
      ::uValTop    := aIndex[ nIndex ]:uValTop
      ::uValBottom := aIndex[ nIndex ]:uValBottom

   elseif !Empty( lScope ) .and. !IS_NIL( uValTop )

      BYNAME uValTop, uValBottom
      if !Empty( aIndex )
         DEFAULT nIndex := Max( ::IndexOrder(), 1 )  // Dbf no abierta.
         aIndex[ nIndex ]:lScope     := lScope
         aIndex[ nIndex ]:uValTop    := uValTop
         aIndex[ nIndex ]:uValBottom := uValBottom
      end
   end

   BYNAME lScope INIT LOGICAL

return lScope

//----------------------------------------------------------------------------//

METHOD bSkipKey( uValTop, uValBottom, nIndex )

   local bWhile, cClave, cType

   DEFAULT nIndex := ::IndexOrder()

   if !Empty( ::aIndex )
      DEFAULT uValTop    := ::aIndex[ nIndex ]:uValTop,;
              uValBottom := ::aIndex[ nIndex ]:uValBottom
      cClave:= ::aIndex[ nIndex ]:cKey
   else
      cClave := IndexKey( nIndex )
   end                 

   if !( '->' $ cClave )
      cClave = ::cAlias + "->" + cClave
   end

   cType := valtype( uValTop )

   do case
      case IS_CHARACTER( cType )
           bWhile := Compila( if( uValTop == uValBottom,; 
                                  cClave + "='"  + uValTop + "'",;
                                  cClave + ">='" + uValTop + "'.and." +;
                                  cClave + "<='" + uValBottom + "'" ) )
                   
      case IS_DATE( cType )
           bWhile := Compila( if( uValTop == uValBottom,; 
                              cClave + " = CToD( '" + DToC( uValTop ) + "')",;
                              cClave + ">= CToD( '" + DToC( uValTop ) + "') .and." +;
                              cClave + "<= CToD( '" + DToC( uValBottom ) + "')" ) )
                            
      case IS_NUMBER( cType ) .or. IS_LOGICAL( cType )
           bWhile := Compila( if( uValTop == uValBottom,; 
                              cClave + "="  + cValToChar( uValTop ),;
                              cClave + ">=" + cValToChar( uValTop ) + ".and." +;
                              cClave + "<=" + cValToChar( uValBottom ) ) )
      otherwise
           bWhile := bTrue()
   endcase
   
return bWhile

//----------------------------------------------------------------------------//
// Nota: Aunque sean m‚todos de TWorkArea, hay que seleccionar el nArea antes
//       de hacer alguna operaci¢n con la Dbf.
