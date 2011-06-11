#include "Fivedos.ch"

static bTrue  := {|| .t. } ,;
       bFalse := {|| .f. } ,;
       bNil   := {|| nil } ,;
       bNull  := {|| ""  }

function bTrue()
return bTrue

function bFalse()
return bFalse

function bNil()
return bNil

function bNull()
return bNull

// la variable debe pasarse por referencia.
function blSetGet( lVar )
  DEFAULT lVar = .f.
return { | lVal | if( Empty( PCount() ), lVar, lVar := lVal ) }

function Compila( cExp )
return &("{||" + cExp + "}")

function NextVal( uVal )
return if( ValType( uVal ) == "C", NEXTVALASCII( uVal ), uVal++ )
