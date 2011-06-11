#include 'fivedos.ch'
#include "fontdef.h"

	Static Icon := {} // estructura de un icono
	Static aIcon:={,}
	Static Cars
    static cFile := ""

//---------------------------------------------------------------------//
Function  IconDEF( oMain )

    static oWnd
    local n
	 local oBar

    if oWnd == nil
        for n:=1 to 16
            aadd( icon, '0000000000000000' )
        next
        aIcon[1] := replicate( chr(0), 16 )
        aIcon[2] := replicate( chr(0), 16 )

        Cars:=AllocChars('_IconDef_',2)
        setchar(asc(left(Cars,1)),aIcon[1])
        setchar(asc(Right(Cars,1)),aIcon[2])

        DEFINE WINDOW oWnd AT 3, 12 SIZE 36, 21 ;
               TITLE "Iconos" OF OMain ;
               NORESIZE

        DEFINE BUTTONBAR oBar OF oWnd

        DEFINE MESSAGE BAR OF oWnd ;
            PROMPT "ICONDEF " + FDCOPYRIGHT

        DEFINE BUTTON FILE '..\bitmaps\exit.bmp'  OF oBar ;
			ACTION oWnd:Close()

        DEFINE BUTTON FILE '..\bitmaps\trash.bmp'  OF oBar ;
			ACTION (ICONClear(oWnd), oWnd:oClient:CLear(),tock())

        DEFINE BUTTON FILE  "..\bitmaps\Save.BMP" ACtion IconSave() OF oBar

        DEFINE BUTTON FILE  "..\bitmaps\Load.BMP" ACtion IconLoad( oWnd ) OF oBar

        DEFINE BUTTON prompt Cars of oBar

    else

        IconClear()

    endif

    ACTIVATE WINDOW oWnd ;
        ON CLICK IconSet( oWnd );
        ON PAINT IconPaint( oWnd ) ;
        VALID ( oWnd := nil, ReleaseChars("_IconDef_"), .t. ) ;
        NOWAIT

return nil

//--------------------------------------------------------------------//
static Function IconPaint(oWnd)
	local cTemp
	local n
	for n:=1 to 16
        cTemp:=strtran(icon[n],'0',chr( THUMBLEFT )+ chr( THUMBRIGHT ) )
        cTemp:=strtran(cTemp,'1','±±')
        oWnd:say( n , 1, cTemp)
    next

return nil

//--------------------------------------------------------------------//
static Function iconSet(oWnd)
   local cTemp
   local nRow:=oWnd:nMRow() - 2
   local nCol:=oWnd:nMCol() - 1
	nCol := Int( (nCol+1) / 2 )
	if (nRow>0 .and. nRow<=16) .and. ( nCol>0 .and. nCol<=16)
       Tock()
		cTemp := if( substr(Icon[nRow],nCol,1)='1', '0', '1' )
		Icon[nRow]:=stuff( Icon[nRow],nCol,1,cTemp)
        cTemp:=strtran(icon[nRow],'0',chr( THUMBLEFT )+ chr( THUMBRIGHT ) )
        cTemp:=strtran(cTemp,'1','±±')
		oWnd:say(nRow,1,cTemp)
        aIcon[1]=stuff(aIcon[1],nRow,1,chr(nBin2dec(substr(Icon[nRow],1,8))))
        aIcon[2]=stuff(aIcon[2],nRow,1,chr(nBin2dec(substr(Icon[nRow],9,8))))
		setchar(asc(left(Cars,1)),aIcon[1])
		setchar(asc(Right(Cars,1)),aIcon[2])
       Tock()
    else
        tone(50,0.2)
	end
	return nil
//-----------------------------------------------------------------------//
Static function IconSave()
    Local oWnd
	Local cText:=""
	local n
    Local lSave := .f.

	//cGetFile('*.prg') ... y mientras ...

    define dialog ownd from 10,10 to 17, 40 title "Salvar El icono como ..."
    if empty(cFile)
        cFile := pad('Test',8)
    end

    @ 2,2 get cfile prompt 'Fichero : ' of oWnd

    @ 4, 2 button ' &Salvar ' action (lSave := .t., oWnd:Close() ) of oWnd

    @ 4,15 button ' Sa&lir ' action oWnd:end() of oWnd

    Activate dialog oWnd

    if lSave .and. !empty(cFile)

        if file(alltrim(cFile)+'.bmp')
            if alert('El Fichero '+alltrim(cFile)+'.bmp ya existe',;
                {'&Sobreescribir','&Cancelar'}) = 2
                return nil
            endif
        endif


        FOR n := 1 TO 16
            cText += Icon[n] +CRLF
        NEXT
        Memowrit(alltrim(cFile)+'.bmp',cText)
    endif

Return nil

//---------------------------------------------------------------------------//

Static function IconLoad(oMain)
    Local oWnd
	Local cText:=""
	local n
    Local lLoad := .f.
    local cBmp
    local cDefBytes
    local n2

	//cGetFile('*.prg') ... y mientras ...

    define dialog ownd from 10,10 to 17, 40 title "Cargar el icono "
    if empty(cFile)
        cFile := pad('Test',8)
    end

    @ 2,2 get cfile prompt 'Fichero : ' of oWnd

    @ 4, 2 button ' &Cargar ' action (lLoad := .t., oWnd:Close() ) of oWnd

    @ 4,15 button ' Sa&lir ' action oWnd:end() of oWnd

    Activate dialog oWnd

    if lLoad .and. !empty(cFile)

        if !file(alltrim(cFile)+'.bmp')
            alert('El Fichero '+alltrim(cFile)+'.bmp no existe')
                   return nil
            else

            cBmp   := MemoRead( cFile+'.bmp' )
            
        aIcon := {"",""}

        for n = 1 to 16
            cDefBytes = MemoLine( cBmp,, n )
            for n2 = 0 to 1
                aIcon[ n2 + 1 ] += Chr( nBin2Dec( SubStr( cDefBytes, 1 + n2 * 8, 8 ) ) )
                icon[n] := cDefBytes
            next
        next
        SetChar( asc( substr( Cars, 1, 1 ) ) , aIcon[ 1 ] )
        SetChar( asc( substr( Cars, 2, 1 ) ) , aIcon[ 2 ] )
        oMain:oClient:CLear()
     endif
    endif

Return nil





Static Function IconClear(oWnd)
	local m

        icon:=afill( icon, '0000000000000000' )

        aIcon[1] := replicate( chr(0), 16 )
        aIcon[2] := replicate( chr(0), 16 )
	oWnd:oClient:Clear()

   setchar(asc(left(Cars,1)),aIcon[1])
   setchar(asc(Right(Cars,1)),aIcon[2])

return nil
