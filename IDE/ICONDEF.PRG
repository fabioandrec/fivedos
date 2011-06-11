#include 'FiveDos.ch'
#include "FontDef.h"

static Icon   := {}      // estructura de un icono
static aIcon  := { , }
static Cars
static cFile  := ""
static oBar

// Thaks to Juan Rios from Canarias (Spain) for his solutions

// -------------------------------------------------------------------------- //

function IconDef( oMain )

    static  oWnd

    local   n

    if oWnd == NIL

        Icon = {}
        for n := 1 To 16
            aAdd( Icon, '0000000000000000' )
        next

        aIcon[ 1 ] := Replicate( Chr( 0 ), 16 )
        aIcon[ 2 ] := Replicate( Chr( 0 ), 16 )

        Cars := AllocChars( '_IconDef_', 2 )

        SetChar( Asc(  Left( Cars, 1 ) ), aIcon[ 1 ] )
        SetChar( Asc( Right( Cars, 1 ) ), aIcon[ 2 ] )

        DEFINE WINDOW oWnd ;
            AT 3, 12 SIZE 36, 21 ;
            TITLE "Iconos" OF oMain ;
            NORESIZE

        DEFINE BUTTONBAR oBar OF oWnd

        DEFINE MESSAGE BAR OF oWnd ;
            PROMPT "ICONDEF " + FDCOPYRIGHT

        DEFINE BUTTON FILE '..\bitmaps\exit.bmp'  OF oBar ;
            MESSAGE "Cierra la ventana de iconos" ;
			ACTION oWnd:Close()

        DEFINE BUTTON FILE '..\bitmaps\trash.bmp'  OF oBar ;
            MESSAGE "Limpia el icono actual" ;
            ACTION ( IconClear( oWnd ), oWnd:oClient:CLear(), Tock() )

        DEFINE BUTTON FILE  "..\bitmaps\Save.BMP" ;
            ACTION IconSave() OF oBar ;
            MESSAGE "Salva el icono actual"

        DEFINE BUTTON FILE  "..\bitmaps\Load.BMP" ;
            ACTION IconLoad( oWnd ) OF oBar ;
            MESSAGE "Cargar un icono"

        DEFINE BUTTON PROMPT Cars OF oBar ;
            MESSAGE "Preview del icono actual" ;
            ACTION Tone( 800, 0.1 )

       ACTIVATE WINDOW oWnd             ;
           ON CLICK IconSet( oWnd )     ;
           ON PAINT IconPaint( oWnd )   ;
           VALID oWnd := NIL, cFile := "", ReleaseChars( "_IconDef_" ), .T. ;
           NOWAIT
    else
        oWnd:SetCurrent()
    endif

return NIL

// -------------------------------------------------------------------------- //

static function IconPaint( oWnd )

    local cTemp
    local n

    for N := 1 To 16
        cTemp := StrTran( Icon[ n ], '0', Chr( THUMBLEFT ) + Chr( THUMBRIGHT ) )
        cTemp := StrTran( cTemp, '1', '±±' )
        oWnd:Say( n, 1, cTemp )
    next

return NIL

// -------------------------------------------------------------------------- //

static function IconSet( oWnd )
    local cTemp, nRow, nCol, nRowAnt, nColAnt, bPintar

    nRow := oWnd:nMRow() - 2
    nCol := oWnd:nMCol() - 1

    if nRow <= 0 .or. nRow >= 17 .or. nCol <= 0 .or. nCol >= 33
       return nil
    endif

    bPintar := ( SubStr( Icon[ nRow ], Int( ( nCol + 1 ) / 2 ), 1 ) == '0' )

    while lMPressed()
        If nRow <> nRowAnt .Or. nCol <> nColAnt
            nRowAnt := nRow
            nColAnt := nCol
            nCol := Int( ( nCol + 1 ) / 2 )
            if nRow > 0 .And. nRow < 17 .And. nCol > 0 .And. nCol < 17
                If ( cTemp := If( bPintar, '1', '0' ) ) <> SubStr( Icon[ nRow ], nCol, 1 )
                    Icon[ nRow ] := Stuff( Icon[ nRow ], nCol, 1, cTemp )
                    cTemp := StrTran( Icon[ nRow ], '0', Chr( THUMBLEFT ) + ;
                        Chr( THUMBRIGHT ) )
                    cTemp := StrTran( cTemp, '1', '±±' )
                    oWnd:Say( nRow, 1, cTemp )
                    aIcon[ 1 ] := Stuff( aIcon[ 1 ], nRow, 1, ;
                        Chr( nBin2Dec( SubStr( Icon[ nRow ], 1, 8 ) ) ) )
                    aIcon[ 2 ] := Stuff( aIcon[ 2 ], nRow, 1, ;
                        Chr( nBin2Dec( SubStr( Icon[ nRow ], 9, 8 ) ) ) )
                    SetChar( Asc( Left( Cars, 1 ) ), aIcon[ 1 ] )
                    SetChar( Asc( Right( Cars, 1 ) ), aIcon[ 2 ] )
                    Tock()
                endif
            endif
        endif
        MUpdate()
        nRow := oWnd:nMRow() - 2
        nCol := oWnd:nMCol() - 1
    end

return NIL

// -------------------------------------------------------------------------- //

static function IconSave()
    local oWnd
    local cText:=""
	local n
    local lSave := .f.

	//cGetFile('*.prg') ... y mientras ...

    DEFINE DIALOG oWnd ;
        FROM 10, 10 TO 17, 40 ;
        TITLE "Salvar El icono como ..."
    if Empty( cFile )
        cFile := Pad( 'Test', 8 )
    end

    @  2,  2 GET cfile PROMPT 'Fichero : ' OF oWnd

    @  4,  2 BUTTON ' &Salvar ' ;
        ACTION ( lSave := .T., oWnd:Close() ) OF oWnd

    @  4, 15 BUTTON ' Sa&lir ' ;
        ACTION oWnd:End() OF oWnd

    ACTIVATE DIALOG oWnd

    if lSave .And. !Empty( cFile )
        if File( AllTrim( cFile ) + '.BMP' )
            if Alert( 'El Fichero ' + AllTrim( cFile ) + '.BMP ya existe',;
                { '&Sobreescribir', '&Cancelar' } ) <> 1
                Return NIL
            endif
        endif

        for n := 1 To 16
            cText += Icon[ n ] + CRLF
        next

        MemoWrit( Alltrim( cFile ) + '.bmp', cText )

    endif

return nil

// -------------------------------------------------------------------------- //

static function IconLoad( oMain )
    local oWnd
    local cText := ""
    local n
    local cBmp
    local cDefBytes
    local n2

    if !Empty( cFile ) .and. MsgYesNo( "Ya hay una imagen editandose;se perder  si continua;¨ Continuar ?", "Cargar imagen" )
       cFile = ""
    endif

    if Empty( cFile )
        cFile := cGetFile( ".\*.bmp" )
    endif

    if !Empty( cFile )
        if !File( cFile )
            Alert( "El Fichero " + cFile + " no puede abrirse." )
            return NIL
        else
            cBmp   := MemoRead( cFile )
            aIcon := { "", "" }
            for n := 1 To 16
                cDefBytes = Alltrim( MemoLine( cBmp, , n ) )
                for n2 := 0 To 1
                    aIcon[ n2 + 1 ] += Chr( nBin2Dec( SubStr( cDefBytes, 1 + n2 * 8, 8 ) ) )
                    icon[ n ] := cDefBytes
                next
            next
            SetChar( Asc( SubStr( Cars, 1, 1 ) ) , aIcon[ 1 ] )
            SetChar( Asc( SubStr( Cars, 2, 1 ) ) , aIcon[ 2 ] )
            oMain:oClient:Clear()
        endif
    endif

return NIL

// -------------------------------------------------------------------------- //

static function IconClear( oWnd )
    local m
    Icon := aFill( Icon, '0000000000000000' )
    aIcon[ 1 ] := Replicate( Chr( 0 ), 16 )
    aIcon[ 2 ] := Replicate( Chr( 0 ), 16 )
	oWnd:oClient:Clear()
    SetChar( Asc(  Left( Cars, 1 ) ), aIcon[ 1 ] )
    SetChar( Asc( Right( Cars, 1 ) ), aIcon[ 2 ] )
    cFile = ""

return NIL

// -------------------------------------------------------------------------- //
