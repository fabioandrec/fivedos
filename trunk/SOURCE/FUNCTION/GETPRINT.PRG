// funciones de captura de la impresora
#include 'fivedos.ch'
#include 'common.ch'


// Default .ini file
// section Printer
// Item Default .. default printer
// Item xxxxxxxx.drv = Device mode,hSize,vSize,Port

// Mode
// 0 = Screen :-)))
// 1 = Printer
// 2..255 for other use

// default ini file
static cINI
static oIni
static oPrintDefault
static cDrv
static cMode

//---------------------------------------------------------------------------//

// default printer

function GetPrintDefault()

    if !ISNIL( oPrintDefault )
        return oPrintDefault
    endif

    if ISNIL( cIni )
       cIni := 'Fivedos.ini'
    end

    if ISNIL( oIni )
        oIni := TIniFile():Use( cIni )
    else
        alert( 'Fichero '+ cIni + ' no existe' )
        // quit ??
    end

    cDrv  := oIni:cGet( 'Printer', 'Default' )
    cMode := oIni:cGet( 'Printer', cDrv )

    if left( cMode, 1 ) == '1'
        oPrintDefault := DCPrinter():New( cDrv, cMode )

    else
        oPrintDefault := DCPrinter():New( "" )
    end

return oPrintDefault

//---------------------------------------------------------------------------//

function GetPrintDrv()
return cDrv

//---------------------------------------------------------------------------//

function GetPrintMode()
return cMode

//---------------------------------------------------------------------------//
