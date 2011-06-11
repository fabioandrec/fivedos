#include "FiveDos.ch"

static cTable
static aRecurses := {} // recursos de caracteres, cbmp y similares

#define RESOURCE_ID    1
#define RESOURCE_CHARS 2
#define RESOURCE_COUNT 3


//---------------------------------------------------------------------------//

function CarRoom( nCars )

    local cCar   := ""
	local n      := 0

    if cTable == nil
		cTable := space( 255 )
        // Cua
        reservecar( 1, 19 )
        reservecar( 224, 255 )
        reservecar( 196 ) // separador del menu

        // Latin Languages
        reservecar( 32, 122 )
        reservecar( 123, 125 )  // { | }
        reservecar( 128, 130 )  // €,,‚
        reservecar( 133 )  // …
        reservecar( 135 )  // ‡
        reservecar( 138 )  //
        reservecar( 141 )  //
        reservecar( 149 )  //
        reservecar( 151 )  //
        reservecar( 155, 159 )  // Coins.
        reservecar( 160, 168 )  //  ¡¢£¤¥¦§¨

        // bloques, muy usados en bitmaps y sombras de botones //
        reservecar( 219, 223 )

    endif

    while ( n := At( " ", cTable ) ) > 0 .and. len( cCar ) < nCars
        cCar  += chr( n )                   // 1 - 255
        cTable = stuff( cTable, n, 1, '1' )
    end

  /******************* OJO RECUPERAR luego.............

    if nCars != len(cCar)
        eval( ErrorBlock(), _FDgenerror( 1 ) )
    endif

  *******************************/

return cCar

//---------------------------------------------------------------------------//

static function ReserveCar( cnCarBeg, cnCarEnd )

	local nCar1, nCar2, nLen

    nCar1 = if( Valtype( cnCarBeg ) == "C", asc( cnCarBeg ), cnCarBeg )
    nCar2 = if( cnCarEnd == nil, nCar1, if( valtype( cnCarEnd ) =='C',;
                                            asc( cnCarEnd ), cnCarEnd ) )
    nLen   = nCar2 - nCar1 + 1
    cTable = stuff( cTable, nCar1, nlen, replicate( '1', nLen ) )

return nil

//---------------------------------------------------------------------------//

static function FreeCar( cCars )

    local nLen := len( cCars )
	local n

    for n = 1 TO nLen
        cTable = stuff( cTable, asc( substr( cCars, n, 1 ) ) ,;
                        1, " " )
    next

return nil

//---------------------------------------------------------------------------//

function ReadBitmap( cBmpFile )         // TextMode simulation

    if File( cBmpFile )
        return LoadBitmap( cBmpFile, MemoRead( cBmpFile ) )
    elseif type( cBmpFile ) == "C" // MemVar that contain the data: a resource....
        return LoadBitmap( cBmpFile, &( cBmpFile ) )
    endif

return ""

//---------------------------------------------------------------------------//

function LoadBitmap( cBmpName, cBmp )

    local cDefBytes
    local nChars := Int( At( Chr( 13 ), cBmp ) / 8 )
    local cChars := ""
    local aBytes := Array( nChars )
    local n, n2

    cChars := AllocChars( cBmpName, nChars ) // CarRoom( nChars )

    afill( aBytes, "" )

    for n = 1 to 16
        cDefBytes = MemoLine( cBmp,, n )
        for n2 = 0 to nChars - 1
            aBytes[ n2 + 1 ] += Chr( nBin2Dec( SubStr( cDefBytes, 1 + n2 * 8, 8 ) ) )
        next
    next

    for n = 1 to Len( cChars )
        SetChar( asc( substr( cChars, n, 1 ) ) , aBytes[ n ] )
    next

return cChars

//---------------------------------------------------------------------------//

function AllocChars( cRecurseID, nCars )

    local n, cCars

    cRecurseID := Upper( alltrim( cRecurseID ) )

    if ( n := ascan ( aRecurses , { |x| x[ RESOURCE_ID ] == cRecurseID } ) ) > 0
        cCars := aRecurses[ n, RESOURCE_CHARS ]
        aRecurses[ n, RESOURCE_COUNT ]++
	else
		cCars := CarRoom( nCars )
        aadd( aRecurses, { cRecurseID, cCars, 1 } )
    endif

return cCars

//---------------------------------------------------------------------------//

function ReleaseChars( cRecurseID )

    local n

    cRecurseID = Upper( alltrim( cRecurseID ) )

    n := ascan ( aRecurses , { |x| x[ RESOURCE_ID ] == cRecurseID } )

    if n > 0 .and.  --aRecurses[ n, RESOURCE_COUNT ] <= 0

        FreeCar( aRecurses[ n, RESOURCE_CHARS ] )

        // deber¡a resetear la definici¢n de estos caracteres.

        adel( aRecurses, n )
        asize( aRecurses, len( aRecurses ) -1 )
    endif

return nil

//---------------------------------------------------------------------------//
