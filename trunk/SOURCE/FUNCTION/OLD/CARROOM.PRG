#include "FiveDOs.ch"

Static cTable
Static aRecurses := {} // recursos de caracteres, cbmp y similares

//-----------------------------------------------------------------------//

Function CarRoom( nCars )

	local cCar   := ''
	local n      := 0
	IF cTable=nil
		cTable := space( 255 )
		reservecar( ' ', "š" )
		reservecar( 160, 163 )
	ENDIF
	FOR n := 1 TO 255
		IF substr( cTable, n, 1 ) == ' '
		  //	cCar+=chr(n-1) // 0-254 asi se incluye el chr(0)
									// pero sayHot y ::say se hacen un lio ..
			cCar += chr( n ) // 0-254
			cTable := stuff( cTable, n, 1, '1' )
		ENDIF
		IF len( cCar ) = nCars
			exit
		ENDIF
	NEXT
  /******************* OJO RECUPERAR luego.............

	IF nCars != len(cCar)
		EVAL ( ErrorBlock(), _FDgenerror(1))
	ENDIF

  *******************************/

return ( cCar )


//------------------------------------------------------------------------//


function reservecar( cnCarBeg, cnCarEnd )
	local nCar1, nCar2, nLen

	IF Valtype( cnCarBeg ) == "C"
		nCar1 := asc( cnCarBeg )

	else
		nCar1 := cnCarBeg

	ENDIF

	IF cnCarEnd = nil
		nCar2 := nCar1

	elseif valtype( cnCarEnd ) =='C'
		nCar2 := asc( cnCarEnd )

	else
		nCar2 := cnCarEnd

	ENDIF

	nLen := nCar2 - nCar1 + 1
	cTable := stuff( cTable, nCar1, nlen, replicate( '1', nLen ) )
return (nil)


//-----------------------------------------------------------------------//

Function freecar( cCars )
	local nLen := len( cCars )
	local n
	FOR n := 1 TO nLen
	    cTable := stuff( cTable, asc( substr( cCars, n, 1 ) ) ,;
		 	nlen, replicate( ' ', nLen ) )
	NEXT
return (nil)


//-----------------------------------------------------------------------//

function ReadBitmap( cBmpFile )         // MsDos simulation

    local cBmp     := MemoRead( cBmpFile )
    local cDefBytes
    local nLineLen := At( Chr( 13 ), cBmp ) - 1
    local nChars   := nLineLen / 8
    local cChars   := ""
    local aBytes   := Array( nChars )
    local n, n2

    cChars := GetCarRecurse( cBmpFile , nChars ) // Carroom( nChars )

    for n = 1 to nChars
        aBytes[ n ] = ""
    next

    for n = 1 to 16
        cDefBytes = MemoLine( cBmp,, n )
        for n2 = 1 to nChars
            aBytes[ n2 ] += Chr( nBin2Dec( SubStr( cDefBytes, 1 + ( n2 - 1 ) * 8, 8 ) ) )
        next
    next

    for n = 1 to Len( cChars )
        SetChar( asc( substr( cChars, n, 1 ) ) , aBytes[ n ] )
    next

return cChars

//----------------------------------------------------------------------------//


function GetCarRecurse( cBmpFile, nCars )
	Local n := 0
	Local cCars
	cBmpFile := Upper( alltrim( cBmpFile ) )

	IF !empty( aRecurses ) .AND. (n := ascan ( aRecurses ,;
			 {|x| x[2] == cBmpFile } ) ) >0
		cCars := aRecurses[n,2]
	else
		cCars := CarRoom( nCars )
		aadd(aRecurses,{ cBmpFile, cCars } )
	ENDIF
return cCars

//----------------------------------------------------------------------//

Function ReleaseCarRecurse( cBmpFile )
	local n := 0

	IF (n := ascan ( aRecurses , {|x| x[2] == cBmpFile } ) ) >0
		 FreeCar( aRecurses[ n, 2 ] )
		 adel( aRecurses , n )
		 asize( aRecurses, len( aRecurses ) -1 )
	ENDIF
return nil
