#include "FiveDos.ch"

static aMenus := {}

//----------------------------------------------------------------------------//

function MenuBegin( cColors )

   local oLastMenu, oMenu

   if ( oLastMenu := ATail( aMenus ) ) == nil
      oMenu := TMenuBar():New( ,,,,, cColors )
   else
      oMenu := TMenuBox():New()
      ATail( oLastMenu:aChilds ):SetMenu( oMenu )
   endif

   AAdd( aMenus, oMenu )

return oMenu

//----------------------------------------------------------------------------//

function MnuItem( cItem, cMsg, bAction, lDisable, lChecked, nShortCut )

   DEFAULT lDisable := .f.

   if ValType( nShortCut ) == "N" .and. ValType( bAction ) == "B"
      aadd( aMenus[ 1 ]:aShortCut, nShortCut )
      aadd( aMenus[ 1 ]:aShortCut, bAction   )
   endif

return ATail( aMenus ):Add( TMenuItem():New( 0, 0, cItem, cMsg, ;
                            bAction, ! lDisable, lChecked, nShortCut ) )

//----------------------------------------------------------------------------//

function MenuEnd()
   aMenus = ASize( aMenus, Len( aMenus ) - 1 )
return nil

//----------------------------------------------------------------------------//
