#ifndef _FIVEDOS_CH
#define _FIVEDOS_CH

#define F2VERSION   "FiveDos 1.3"
#define FDCOPYRIGHT "(c) FiveTech Corp.- 1994/95/96"
#define FDAUTHORING "A.Linares, F.Pulp¢n, C.G¢mez, J.M.Rodr¡guez"

#define CRLF Chr( 13 ) + Chr( 10 )
#define LINESEP ";"

#define TABSIZE 4

#xcommand LINCADO( <nombre> ) =>  !(type( <(nombre)> ) == "U")
#xcommand LINKED( <nombre> ) =>  !(type( <(nombre)> ) == "U")

#define NEXTVALASCII( cExp ) ( SubStr( cExp, 1, Len( cExp ) - 1 ) + ;
                               Chr( Asc( SubStr( cExp, Len( cExp ) ) ) + 1 ) )
external nMRow, nMCol

//----------------------------------------------------------------------------//
// CURSORES RATON

#define IDC_ARROW    1    //
#define IDC_SIZEWE   2    // Una flechita de Oeste a Este.
#define IDC_SIZENS   3    // Una flechita de Norte a Sur
#define IDC_CROSS    4    // La Rosa de los Vientos.
#define IDC_HAND     5    // Una manita apuntando.
#define IDC_SIZENWSE 6    // Una flechita de NorOeste a SurEste
#define IDC_CLOCK    7    // Un reloj de arena.

//----------------------------------------------------------------------------//

#include "Window.ch"
#include "Dialog.ch"
#include "MenuBld.ch"
#include "Redefine.ch"
#include "eval.ch"
#include "ClrToN.ch"
#include "Objects.ch"
#include "InKey.ch"
#include "Browse.ch"
#include "inits.ch"
#include "database.ch"
#include "dbdict.ch"

//----------------------------------------------------------------------------//

#xtranslate bSETGET(<uVar>) => ;
            { | uVal | If( Empty( PCount() ), <uVar>, <uVar> := uVal ) }

//----------------------------------------------------------------------------//

#xtranslate IS_NIL( <v> )           =>   ( ( <v> ) == NIL )
#xtranslate IS_MEMO( <v> )          =>   ( valtype( <v> ) == "M" )
#xtranslate IS_PAR( <v> )           =>   ( ( <v> % 2 ) == 0 )
#xtranslate IS_ZERO( <v> )          =>   ( ( <v> ) == 0 )
#xtranslate IS_ARRAY( <v> )         =>   lArray( <v> )
#xtranslate IS_BLOCK( <v> )         =>   lBlock( <v> )
#xtranslate IS_CHARACTER( <v> )     =>   lCharacter( <v> )
#xtranslate IS_DATE( <v> )          =>   lDate( <v> )
#xtranslate IS_LOGICAL( <v> )       =>   lLogical( <v> )
#xtranslate IS_NUMBER( <v> )        =>   lNumber( <v> )
#xtranslate IS_NUMERIC( <v> )       =>   lNumber( <v> )
#xtranslate lNumeric( <v> )         =>   lNumber( <v> )
#xtranslate IS_OBJECT( <v> )        =>   lObject( <v> )

//----------------------------------------------------------------------------//

#xTranslate aAddFirst( <arr>, <val> ) => ;
            aAdd( <arr>, ); aIns( <arr>, 1 ); <arr>\[1\]:= <val>

//----------------------------------------------------------------------------//

#xcommand DO            => while .t.
#xcommand UNTIL <uExpr> => if <uExpr>; exit; end; end

//----------------------------------------------------------------------------//

#endif
