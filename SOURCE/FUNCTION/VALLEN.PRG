//----------------------------------------------------------------------------//

function nValLen( uValue, lPict )

   local cType := ValType( uValue ),;
         nLen  := 0

   do case
      case cType $ "CA"
           nLen = Len( uValue )

      case cType == "N"
           nLen = if( Empty( lPict ), Len( LTrim( Str( uValue ) ) ), 10 )

      case cType == "L"
           nLen = if( Empty( lPict ), 1, 3 )

      case cType == "D"
           nLen = len( DtoC( Date() ) )

      case cType == "M"
           nLen = if( Empty( lPict ), len( uValue ), 10 )
   endcase

return nLen

//----------------------------------------------------------------------------//
