//----------------------------------------------------------------------------//

function cKeyBuffer()

   local cKeys := ""
   local nKey

   while ( nKey := NextKey() ) != 0
      cKeys += Chr( nKey )
      InKey( 0 )
   end

return cKeys

//----------------------------------------------------------------------------//

function KeyPlus( cKeys )

   local cOldKeys := cKeyBuffer()

   __Keyboard( cOldKeys + cKeys )

return nil

//----------------------------------------------------------------------------//
