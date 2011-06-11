#include "Objects.ch"

CLASS TIniFile

    DATA aLines
    DATA cFileName
    DATA nFoundAt
    DATA cValue
    DATA cSection
    DATA cEntry

    METHOD  Use(), cGet(), Set(), Save()
    METHOD nSections SETGET

ENDCLASS


//----------------------------------------------------------------------------//

METHOD Use( cIniFile )

   local nHandle
   local cLine   := ""

   ::aLines    = {}
   ::cEntry    = ""
   ::cSection  = ""
   ::cValue    = ""
   ::nFoundAt  = 0

   if cIniFile != nil
      cIniFile += If( At( ".", cIniFile ) == 0, ".ini", "" )
   endif

   ::cFileName = cIniFile

   if cIniFile != nil
      if ( nHandle := If( File( cIniFile ), FOpen( cIniFile ), nil ) ) != nil
         while lFReadStr( nHandle, @cLine )
            AAdd( ::aLines, AllTrim( cLine ) )
         end
         FClose( nHandle )
      endif
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Set( cSection, cEntry, cValue )

   local n      := 1  ,;
         lFound := .f.,;
         aLines := ::aLines

   cSection = AllTrim( cSection )
   cEntry   = AllTrim( cEntry )
   cValue   = AllTrim( cValue )

   BYNAME cSection, cEntry, cValue

   if ! Empty( cSection ) .and. ! Empty( cEntry )
      while n <= Len( aLines ) .and. ;
            ! ( lFound := "[" + Upper( cSection ) + "]" $ ;
                          Upper( AllTrim( aLines[ n++ ] ) ) )
      end
      if ! lFound
         if n > 2
            AAdd( aLines, "" )
         endif
         AAdd( aLines, "[" + cSection + "]" )
         AAdd( aLines, cEntry + "=" + cValue )
         ::nFoundAt = Len( aLines )
      else
         while n <= Len( aLines ) .and. ;
               ! ( lFound := Upper( cEntry ) $ ;
                   Upper( AllTrim( SubStr( aLines[ n ],;
                          1, At( "=", aLines[ n ] ) - 1 ) ) ) ) .and. ;
               SubStr( AllTrim( aLines[ n++ ] ), 1, 1 ) != "["
         end
         if lFound
            aLines[ n ] = cEntry + "=" + cValue
            ::nFoundAt  = n
         else
            if n >= Len( aLines )
               AAdd( aLines, cEntry + "=" + cValue )
               ::nFoundAt = Len( aLines )
            else
               n--
               while Empty( aLines[ n-- ] ); end
               AAdd( aLines, nil )
               AIns( aLines, n )
               aLines[ n ] = cEntry + "=" + cValue
               ::nFoundAt = n
            endif
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD cGet( cSection, cEntry, cDefault )

   local n      := 1
   local lFound := .f.
   local aLines := ::aLines

   cSection = AllTrim( cSection )
   cEntry   = AllTrim( cEntry )

   if cDefault != nil
      do case
         case ValType( cDefault ) == "C"
              cDefault = AllTrim( cDefault )

         case ValType( cDefault ) == "N"
              cDefault = AllTrim( Str( cDefault ) )

         case ValType( cDefault ) == "D"
              cDefault = DToC( cDefault )

         case ValType( cDefault ) == "L"
              cDefault = If( cDefault, ".t.", ".f." )
      endcase
   endif

   BYNAME cSection, cEntry
   ::cValue   = ""

   if ! Empty( cSection ) .and. ! Empty( cEntry )
      while n <= Len( aLines ) .and. ;
            ! ( lFound := "[" + Upper( cSection ) + "]" $ ;
                          Upper( AllTrim( aLines[ n++ ] ) ) )
      end
      if ! lFound
         if cDefault != nil
            ::cValue = cDefault
            if n > 2
               AAdd( aLines, "" )
            endif
            AAdd( aLines, "[" + cSection + "]" )
            AAdd( aLines, cEntry + "=" + cDefault )
            ::nFoundAt = Len( aLines )
         else
            ::nFoundAt = 0
         endif
      else
         while n <= Len( aLines ) .and. ;
               ! ( lFound := Upper( cEntry ) $ ;
                   Upper( AllTrim( SubStr( aLines[ n ],;
                          1, At( "=", aLines[ n ] ) - 1 ) ) ) ) .and. ;
               SubStr( AllTrim( aLines[ n++ ] ), 1, 1 ) != "["
         end
         if lFound
            ::nFoundAt = n
            ::cValue = AllTrim( SubStr( aLines[ n ],;
                                At( "=", aLines[ n ] ) + 1 ) )
            if Empty( ::cValue ) .and. cDefault != nil
               aLines[ n ] = cEntry + "=" + cDefault
               ::cValue = cDefault
            endif
         else
            if cDefault != nil
               ::cValue = cDefault
               if n >= Len( aLines )
                  AAdd( aLines, cEntry + "=" + cDefault )
                  ::nFoundAt = Len( aLines )
               else
                  n--
                  while Empty( aLines[ n-- ] ); end
                  AAdd( aLines, nil )
                  AIns( aLines, n )
                  aLines[ n ] = cEntry + "=" + cDefault
                  ::nFoundAt = n
               endif
            else
               ::nFoundAt = 0
            endif
         endif
      endif
   endif

return ::cValue

//----------------------------------------------------------------------------//

METHOD Save()

   local aLines     := ::aLines
   local n, nHandle := If( File( ::cFileName ), FOpen( ::cFileName, 1 ),;
                                                FCreate( ::cFileName, 0 ) )
   if nHandle != -1
      for n = 1 to Len( aLines )
         FWrite( nHandle, aLines[ n ] + Chr( 13 ) + Chr( 10 ),;
                 Len( aLines[ n ] ) + 2 )
      next
      FClose( nHandle )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD nSections()

   local n, aLines := ::aLines
   local nSections := 0

   for n = 1 to Len( aLines )
       if SubStr( aLines[ n ], 1, 1 ) == "["
          nSections++
       endif
   next

return nSections

//----------------------------------------------------------------------------//
