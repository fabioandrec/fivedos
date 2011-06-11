#include "FiveDos.ch"

//--------------------------------------------------------------------//
class TBmp // control de redefiniciones y bitmap.

        CLASSDATA  cTable       AS CHARACTER
        CLASSDATA  aRecurses    AS ARRAY
        DATA cId                AS CHARACTER
        DATA cChar              AS CHARACTER

        METHOD New( cFile, cDef ) CONSTRUCTOR
        METHOD AllocChars( cRecurseID, nCars )
        METHOD CarRoom( nCar )
        METHOD Destroy() INLINE ReleaseChars( ::cId )
        METHOD FreeCar( cCars )
        METHOD Get()
        METHOD ReadBitmap( cBmpFile )         // TextMode simulation
        METHOD ReleaseChars( cRecurseID )
        METHOD ReserveCar( cnCarBeg, cnCarEnd )
        METHOD SetDef( aDef )

endclass
//------------------------------------------------------------------//

/*
        Puede recibir uno de estos dos par metros, cFile o aDef, siempre
        tiene preferencia cFile sobre aDef, en caso de recibir los dos

        cFile = nombre de fichero . bmp
        aDef = array de definici¢n de caractares, con un subarray por cacarter

*/

METHOD New( cFile, aDef )
   local n,m


   if valtype( cFile ) == 'C'
      cFile := alltrim( cFile )
      if !'.' $ cFile
           cFile += ".BMP"
      end
      if file( cFile )
         ::cChar := ::ReadBitmap( cFile )
         ::cId := cFile
      else
         alert( 'No se encuentra el BitMap;'+cFile)
         ::cId :='.NO_DEF.' // .NO_DEF. es imposible como nombre de fichero
         ::cChar := ''
      end
   elseif valtype( aDef ) == 'A'
           ::cId := '.DEF.'+strzero( len( ::aRecurses ) + 1 , 3 )
           // .def.001 es imposible como nombre de fichero
           ::cChar := ::AllocChars( ::nId, int( len( aDef ) ) )
           for n:=1 to len( ::cChar )
                   setchar( asc( substr( ::cChar, n, 1 ) ) , aDef[ n ] )
           next
            // a¤adir las definiciones al array
            aadd( atail( ::aResurces ) , aDef )

    else
           alert( 'Parametros erroneos en clase tBmp')
    end



return Self

//------------------------------------------------------------------//

METHOD CarRoom( nCars )

	local cCar   := ''
	local n      := 0

    if ::cTable == nil
                ::cTable := space( 255 )
        // Cua
        reservecar( 1, 17 )
        reservecar( 224, 255 )

        // Spain languages
        reservecar( 32, 122 )
        reservecar( 123, 125 )  // { | }
        reservecar( 128, 130 )  // €,,‚
        reservecar( 133 )  // …
        reservecar( 135 )  // ‡
        reservecar( 138 )  //
        reservecar( 141 )  //
        reservecar( 149 )  //
        reservecar( 151 )  //
        reservecar( 155, 159 )  // Monedas.
        reservecar( 160, 168 )  //


    endif

    while ( n := At( " ", ::cTable ) ) > 0 .and. len( cCar ) < nCars
        cCar  += chr( n )                   // 1 - 255
        ::cTable = stuff( ::cTable, n, 1, '1' )
    end

  /******************* OJO RECUPERAR luego.............

    if nCars != len(cCar)
        eval( ErrorBlock(), _FDgenerror( 1 ) )
    endif

  *******************************/

return cCar

//---------------------------------------------------------------------------//
METHOD Get()
    return ::cChars


//---------------------------------------------------------------------------//
/*
    Modifica la definicion de un recurso de caracteres ....
    recibe un array de definici¢n ( ver encabezado )
    */

METHOD SetDef( aDef )
    local nLen := max( len( aDef ), len( ::cChars ) ) , n
    for n:= 1 to nLen
        setchar( asc( substr( ::cChar, n, 1 ) ) , aDef[ n ] )
    next
    n := ascan( ::aRecurses, {|x| x[1] = ::cId } )
    ::aRecourses[ n , 4 ]:= aDef
return nil


//---------------------------------------------------------------------------//

METHOD ReserveCar( cnCarBeg, cnCarEnd )

	local nCar1, nCar2, nLen

    nCar1 = if( Valtype( cnCarBeg ) == "C", asc( cnCarBeg ), cnCarBeg )
    nCar2 = if( cnCarEnd == nil, nCar1, if( valtype( cnCarEnd ) =='C',;
                                            asc( cnCarEnd ), cnCarEnd ) )
    nLen   = nCar2 - nCar1 + 1
    ::cTable = stuff( ::cTable, nCar1, nlen, replicate( '1', nLen ) )

return nil

//---------------------------------------------------------------------------//

METHOD FreeCar( cCars )

    local nLen := len( cCars )
	local n

    for n = 1 TO nLen
        ::cTable = stuff( ::cTable, asc( substr( cCars, n, 1 ) ) ,;
                        nlen, replicate( ' ', nLen ) )
    next

return nil

//---------------------------------------------------------------------------//

METHOD ReadBitmap( cBmpFile )         // TextMode simulation

    local cBmp   := MemoRead( cBmpFile )
    local cDefBytes
    local nChars := Int( At( Chr( 13 ), cBmp ) / 8 )
    local cChars := ""
    local aBytes := Array( nChars )
    local n, n2

    cChars := AllocChars( cBmpFile , nChars ) // CarRoom( nChars )

    for n = 1 to nChars
        aBytes[ n ] = ""
    next

    for n = 1 to 16
        cDefBytes = MemoLine( cBmp,, n )
        for n2 = 0 to nChars - 1
            aBytes[ n2 + 1 ] += Chr( nBin2Dec( SubStr( cDefBytes, 1 + n2 * 8, 8 ) ) )
        next
    next

    for n = 1 to Len( cChars )
        SetChar( asc( substr( cChars, n, 1 ) ) , aBytes[ n ] )
    next

    // a¤adir las definiciones al array
    aadd( atail( ::aResurces ) , aBytes )

return cChars

//---------------------------------------------------------------------------//

METHOD AllocChars( cRecurseID, nCars )

    local n, cCars

    cRecurseID := Upper( alltrim( cRecurseID ) )

    if ( n := ascan ( ::aRecurses , { |x| x[ 2 ] == cRecurseID } ) ) > 0
        cCars := ::aRecurses[ n, 2 ]
        ::aRecurses[ n, 3 ]++
	else
		cCars := CarRoom( nCars )
        aadd( ::aRecurses, { cRecurseID, cCars, 1 } )
    endif

return cCars

//---------------------------------------------------------------------------//

METHOD ReleaseChars( cRecurseID )

    local n := ascan ( ::aRecurses , { |x| x[2] == cRecurseID } )

    if n > 0 .and.  --::aRecurses[ n, 3 ] <= 0
        FreeCar( ::aRecurses[ n, 2 ] )

        // deber¡a resetear la definici¢n de estos caracteres.

        adel( ::aRecurses , n )
        asize( ::aRecurses, len( ::aRecurses ) -1 )
    endif

return nil

//---------------------------------------------------------------------------//
