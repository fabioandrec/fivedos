// GetFile DialogBox for FiveDos

#include "FiveDos.ch"
#include "Directry.ch"
#include "SysStr.ch"

static oWndFile

// -------------------------------------------------------------------------- //

function cGetFile( cFileSpec, cTitle )

    // The SysStr System
    local aSysStr := aSysStr()

    // for the Get of File
    local cFileName
    local oFileName

    // for the ListBox of Files
    local nFiles := 1
    local oFiles

    // for the ListBox of Directories
    local nDirec := 1
    local oDirec

    // for the Listbox of Types
    local oTypes
    local nTypes    := 1
    local aTypes
    local aTypesExt

    // SubDirectorio Actual
    local cCurDir

    // Para Tratamiento de los tipos
    local nPos

    // Ponemos el cursor a espera
    SetMCursor( IDC_CLOCK )

    // Tratamiento de tipos
    if ( nPos := At( "|", cFileSpec ) ) > 0

        aTypes    = {}
        aTypesExt = {}

        do while nPos > 0
            aAdd( aTypes, Alltrim( SubStr( cFileSpec, 1, nPos - 1 ) ) )
            cFileSpec = SubStr( cFileSpec, nPos + 1 )

            if ( nPos := At( "|", cFileSpec ) ) > 0
                aAdd( aTypesExt, AllTrim( SubStr( cFileSpec, 1, nPos - 1 ) ) )
                cFileSpec = SubStr( cFileSpec, nPos + 1 )
            else
                aAdd( aTypesExt, Alltrim( cFileSpec ) )
                exit
            endif
            nPos = At( "|", cFileSpec )
        enddo

        cFileSpec = aTypesExt[ 1 ]

    endif

    DEFAULT cFileSpec := "*.*"

    cCurDir := cFAcceso( cFileSpec )

    if cCurDir == "\"
        cCurDir   = cDrive() + ":\" + if( !empty( CurDir() ), CurDir() + "\", "" )
        // Alert( cCurDir + PadR( cFileName( cFileSpec ), 64 ) )
    elseif empty( cFDisco( cFileSpec ) )
        cCurDir   = cDrive() + ":" + cCurDir
    endif

    // cFileName = cCurDir + PadR( cFileSpec, 64 )
    cFileName = cCurDir + PadR( cFileName( cFileSpec ), 64 )

    // Ponemos los Valores Por Defecto.
    DEFAULT cTitle    := aSysStr[ SST_SELFILE ]
    DEFAULT aTypes    := { "Todos los ficheros | *.*" }
    DEFAULT aTypesExt := { "*.*" }

    // Definimos la Ventana
    DEFINE DIALOG oWndFile ;
        FROM 0, 0 TO 20, 52 ;
        TITLE cTitle

    // Ponemos el mensaje por defecto
    SET MESSAGE OF oWndFile TO "Caja de di logo de seleccion de ficheros"

    // A¤adimos los controles a la ventana
    @  2,  2 GET oFileName VAR cFileName OF oWndFile ;
        PROMPT "&Nombre Fichero:" ;
        PICTURE "@!KS30" ;
        MESSAGE "M scara para selecionar qu‚ ficheros ser n visualizados" ;
        VALID ( GetFileName( @cCurDir, cFileName, @cFileSpec ), ;
                oWndFile:BeginPaint(),;
                oFiles:acItems := GetFiles( cCurDir, cFileSpec ), ;
                oFiles:Reset(), ;
                oDirec:acItems := GetDirec( cCurDir ), ;
                oDirec:Reset(), ;
                oWndFile:EndPaint(),;
                .T. )

    @  4,  2 LISTBOX oFiles VAR nFiles OF oWndFile ;
        SIZE  16, 9 ;
        ARRAY GetFiles( cCurDir, cFileSpec ) ;
        MESSAGE "Selecione Fichero" ;
        PROMPT "&Ficheros:" ;
        ON CHANGE     oFileName:cText := cFichero( cCurDir, oFiles:acItems[ nFiles ], cFileSpec ) ;
        ON DBLCLICK ( oFileName:cText := cFichero( cCurDir, oFiles:acItems[ nFiles ], cFileSpec  ),;
                      oWndFile:Close() )

    @  4, 20 LISTBOX oDirec VAR nDirec OF oWndFile ;
        SIZE  16, 9 ;
        ARRAY GetDirec( cCurDir ) ;
        MESSAGE "Selecione SubDirectorio" ;
        PROMPT "&Directorios:" ;
        ON DBLCLICK ( SetMCursor( IDC_CLOCK ), ;
                      GetFileName( @cCurDir, ;
                      ( if( At( ":", oDirec:acItems[ nDirec ] ) == 0, ;
                        cCurDir, "" ) + oDirec:acItems[ nDirec ] + ;
                        "\" + cFileSpec ), @cFileSpec ), ;
                      oWndFile:BeginPaint(),;
                      oFileName:cText := PadR( cCurDir + cFileSpec, 64 ), ;
                      oDirec:acItems := GetDirec( cCurDir ), ;
                      oDirec:Reset(), ;
                      oFiles:acItems := GetFiles( cCurDir, cFileSpec ), ;
                      oFiles:Reset(),;
                      oWndFile:EndPaint(),;
                      SetMCursor( IDC_ARROW ) )

    @ 14,  2 LISTBOX oTypes VAR nTypes OF oWndFile ;
        ARRAY aTypes ;
        PROMPT "&Tipos de Ficheros:" ;
        MESSAGE "Seleccione tipo de fichero" ;
        SIZE 32, 4 ;
        ON DBLCLICK ( GetFileName( @cCurDir, cCurDir + aTypesExt[ nTypes ], @cFileSpec ), ;
                      oWndFile:BeginPaint(),;
                      oFileName:cText := PadR( cCurDir + cFileSpec, 64 ), ;
                      oFiles:acItems := GetFiles( cCurDir, cFileSpec ), ;
                      oFiles:Reset(),;
                      oWndFile:EndPaint() )

    @  7, 38 BUTTON " &Aceptar " OF oWndFile ;
        MESSAGE "Seleccionar el fichero" ;
        ACTION oWndFile:Close()

    @ 10, 38 BUTTON " &Cancelar " OF oWndFile ;
        MESSAGE "Cancelar la selecci¢n de fichero" ;
        ACTION ( cFileName := "", ;
                 oWndFile:bValid := bTrue(), ;
                 oWndFile:Close() )

    // Activamos la ventana
    ACTIVATE WINDOW oWndFile ;
        CENTERED ;
        VALID File( cFileName ) .And. !( "*" $ cFileName .Or. "?" $ cFileName )

return AllTrim( cFileName )

//---------------------------------------------------------------------------//

static function cFichero( cPath, cName, cFileSpec )
return PadR( cPath + ;
             if( empty( cName ), cFileSpec, RTrim( left( cName, 8 ) ) + "." + RTrim( right( cName, 3 ) ) ), ;
             64 )

// -------------------------------------------------------------------------- //

static function GetFileName( cCurDir, cFileName, cFileSpec )

    local cUnit, cDir, cFile
    local nPos

    cFileName = Alltrim( cFileName )

    if !Empty( cFileName )

        cUnit = cFDisco( cFileName )

        if Empty( cUnit )
            cUnit = SubStr( cCurDir, 1, 2 )
        endif

        if At( "\", cFileName ) > 0
            cDir = SubStr( cFileName, ;
                           ( nPos := At( ":", cFileName ) ) + 1, ;
                           Rat( "\", cFileName ) - nPos )
        else
            cDir = SubStr( cCurDir, 3 )
        endif

        cFile = cFMascara( cFileName )

        if Empty( cFile )
            cFile = cFileSpec
        endif

        if ( nPos := At( "\..", cDir ) ) > 0
            cDir = SubStr( cDir, 1, nPos - 1 )
            cDir = SubStr( cDir, 1, Rat( "\", cDir ) )
        endif
        cCurDir   = cUnit + cDir
        cFileSpec = cFile

    endif

return nil

// -------------------------------------------------------------------------- //

static function GetFiles( cCurDir, cFileSpec )

    local aDirectory, aFiles

    aDirectory := Directory( cCurDir + cFileName( cFileSpec ) )

    aFiles = Array( len( aDirectory ) )

    aEval( aDirectory, { | aFile, i, cName | cName := aFile[ F_NAME ],;
                         aFiles[ i ] := PropName( cFName( cName ) ) + " " + lower( cFExt( cName ) ) } )

    if Empty( aFiles )
        aAdd( aFiles, Space( 12 ) )
    endif

    aSort( aFiles )

return aFiles

// -------------------------------------------------------------------------- //

static function GetDirec( cCurDir )

    local aDirs := {}, aDirectory
    local i, nDrives, cDrive

    aDirectory  := Directory( cCurDir + "*.*", "D" )

    if Len( aDirectory ) > 0

        for i := 1 To Len( aDirectory )

            if "D" $ aDirectory[ i ][ F_ATTR ]
                aAdd( aDirs, aDirectory[ i ][ F_NAME ] )
            endif

        next

    endif

    i = aScan( aDirs, "." )

    if i != 0
        aDel( aDirs, i )
        aSize( aDirs, Len( aDirs ) - 1 )
    endif

    aSort( aDirs )

    if ( nDrives := nFloppys() ) > 0
        aAdd( aDirs, "A:" )

        if nDrives > 1
            aAdd( aDirs, "B:" )
        endif
    endif

    nDrives := nLogDrives()

    for i := 3 To nDrives
        cDrive := CHR( 64 + i ) + ":"
        // if file( ( cDrive := CHR( 64 + i ) + ":" ) + "\NUL" )
        if ValidDrive( i - 1 )
            aAdd( aDirs, cDrive )
        endif
    next

    if Len( aDirs ) == 0
        aAdd( aDirs, Space( 14 ) )
    endif

return aDirs

// -------------------------------------------------------------------------- //
