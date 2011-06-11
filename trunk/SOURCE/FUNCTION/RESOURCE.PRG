static aResources := {},;
       nResource  := 0

//----------------------------------------------------------------------------//

function SetResource( cResource )

   if !Empty( cResource )
      if Empty( nResource := aScan( aResources, cResource := Upper( cResource ) ) )
         aAdd( aResources, cResource )
         nResource = len( aResources )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

function GetResource()
return if( !Empty( nResource ), aResources[ nResource ], "Temporal.rc" )

//----------------------------------------------------------------------------//

function DelResource( cResource )

   if !Empty( cResource )
      if !Empty( nResource := aScan( aResources, Upper( cResource ) ) )
         aDel( aResources, nResource )
         aSize( aResources, nResource := len( aResources ) - 1 )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

function FreeResource()
   aResources = {}
   nResource  = 0
return nil

//----------------------------------------------------------------------------//

