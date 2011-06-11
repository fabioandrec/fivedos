#include "FiveDos.ch"
#include "PRNDef.ch"


/* Testing FiveDos TPrinter class
*/

//---------------------------------------------------------------------------//

function main()

  local oPrn, cText := "texto de pruebassssssssssssssssssssssss" + chr(13), hPrn
  local n, nn := 0
  local cBuffer := cText
/*
  SET PRINTER TO ("PRNTEST.txt")

  ? nLPTInit( 1 ), nLPTStat( 1 )

  n = 1

  while .t.

        if len( cBuffer ) < 1
            cBuffer = cText
        endif

        n = nLPTWrite( 1, cBuffer )

        if n < len( cBuffer )
            cBuffer = right( cBuffer, len( cBuffer ) - n )
        else
            cBuffer = cText
        endif

        ? n
  end
*/

  oPrn := PrintBegin( "Testing Printer" )

  PageBegin()
    for n := 1 to 100
        oPrn:Say( 20, 3, "Esto esta en la linea 20" )
        oPrn:Say( 10, 3, "Esto esta en la linea 10 SIN SALTO DE PAGINA" )
    next
  PageEnd()
/*
  PageBegin()
    oPrn:Say( 20, 3, "Esto esta en la linea 20 de la 2¦ pagina" )
    oPrn:Say( 10, 3, "Esto esta en la linea 10 SIN SALTO DE PAGINA" )
  PageEnd()
*/

  PrintEnd()

  MsgInfo( "FiveDos;Clipper for MS-Dos Library;Testing print spool",;
            F2VERSION + " information." )


return nil

//---------------------------------------------------------------------------//

