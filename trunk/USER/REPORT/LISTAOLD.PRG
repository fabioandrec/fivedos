//---------------------------------------------------------------------------//

#include "FiveDOS.ch"

//---------------------------------------------------------------------------//

function main()

    local oRpt, oColu
//    local bWhile := { || club->Codigo <= 17  .and. club->( !eof() ) }
//    local bFor   := { || ("pp" $ Club->otros) }
//    local bFor   := { || ( Club->Codigo % 2 == 0 ) }
    local bLine  := { || FuncLine( oRpt ) }
    local bInit   := { || Alert( "Inicio del Listado" ) }
    local bEnd   := { || Alert( "Fin del listado" ) }
    local bStartPage := { || Alert( "Inicio de pagina" ) }
    local bEndPage := { || Alert( "Fin de Pagina" ) }

    USE Club2 INDEX i1club2 NEW
    USE Club  INDEX i1club  NEW

//    dbseek( 5 )   // Para poner el puntero en situacion inicial

    oRpt := TReport():New( "Club" )  // Cuando hay mas de una Dbf es conveniente
                                     // pasas el ALIAS o controlar que es la que
                                     // esta activa
//    oRpt:nPgLines := 30

    oRpt:aHead := { "Prueba con un literal", space( 15 ) + "Con composicion de funcion y literal",;
                    { || space( 20 ) + "Listado de la DBF CLUB de Prueba con CodeBlok" }, ;
                    { || space( 68 ) + "P gina: " + AllTrim( str( oRpt:nPage ) ) } }

    oRpt:cHeadIng := "Í"
    oRpt:cHeadSep := "Ø"
    oRpt:cColSep :=  "³"
//                                    bColumn,            cHeader, nWidth, lSumary, cPicture, cColSep
    oRpt:AddColumn( TRColumn():New( { || Club->Codigo }, "C¢digo", 05, .f., "99999" ) )
    oRpt:AddColumn( TRColumn():New( { || Club->Nombre }, "Nombre", 27, .f., "@!" ) )
    oRpt:AddColumn( TRColumn():New( { || Club->Otros  }, "Otros",  42, .f., "@!" ) )
    oRpt:AddColumn( TRColumn():New( { || MiFunc( Club->Codigo ) }, "Num.", 5,, "@!" ) )
    oRpt:AddColumn( TRColumn():New( { || oRpt:nLines }, "Linea", 5,, "99999" ) )


    oRpt:nMrgUp   := 2
    oRpt:nMrgLeft := 2

    oRpt:Activate( , , bInit, bEnd, bStartPage, bEndPage, bLine )

return nil

//----------------------------------------------------------
//  Ejemplo de valor de columna externa
//----------------------------------------------------------
func MiFunc( nCod )

    local cVal := ""

    if Club2->( DbSeek( nCod ) )
        cVal := Club2->Nombre
    else
        while !Club2->( DbSeek( nCod ) )
            nCod -= 10
        end
        cVal := Club2->Nombre
    endif

return cVal

function FuncLine( oRpt )

    SET PRINT OFF
    SET CONSOLE ON

    @ 12, 35 SAY oRpt:nLines

    SET CONSOLE OFF
    SET PRINT ON

return nil
