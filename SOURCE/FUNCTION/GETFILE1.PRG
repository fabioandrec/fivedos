#include "FiveDos.ch"
#include "SysStr.ch"

/* Director.ch -> Pseudo objeto item de directorio */
#xtranslate    .filename     =>    \[1\]
#xtranslate    .filesize     =>    \[2\]
#xtranslate    .filedate     =>    \[3\]
#xtranslate    .filetime     =>    \[4\]
#xtranslate    .fileattrib   =>    \[5\]


/* ID's ordenados -> Accesso directo a la Lista de controles de la Ventana. */
#define    ID_nFILESPEC     1
#define    ID_nFICHEROS     2
#define    ID_nFILEINFO     3
#define    ID_nCANCEL       4
#define    ID_nACEPTAR      5

static aDir
static anStarts   := {} // Pila de pocisiones donde empiezan los ficheros
static cFilePicked      // PKFEnd lo pone antes de terminar la ventana.
                        // si es empty no hay selecci¢n,
static aFileList
static oDlg, oGet, oLbx

function cGetFile( cPathMask, cTitle )
 local nLbxSet
 local aSysStr := aSysStr()

 aFileList := {}
 
 if empty( cFMascara( cPathMask ) )   // ¨ nos han dado el nombre completo de un fichero ?

    if empty( cFFileName( cPathMask ) )  // tampoco es un fichero. ponemos
                                       // mascara por defecto: "*.*"
       cPathMask = cFAcceso( cPathMask ) + "*.*"

    else // terminamos  --------   OJO   -------------
         // Devolvemos el fullPathName recibido.

       RETURN ( cPathMask )
    
    endif
 endif

 DEFAULT cTitle := aSysStr[ SST_SELFILE ]

 DEFINE DIALOG oDlg AT  nil, nil SIZE 66, 17  TITLE cTitle

 DEFINE MESSAGE BAR OF oDlg PROMPT "..."

 cPathMask := padr( cPathMask, 52 )
 cFilePicked = ""
 aadd( anStarts, nLeeDir( alltrim( cPathMask ), aFileList ) )


 @ 2, 3 GET oGet VAR cPathMask ;
            MESSAGE "M scara para selecionar qu‚ ficheros ser n visualizados" ;
            LABEL aSysStr[ SST_MASK ]         ;
            VALID ( PKFMaskChanged( oGet ), .t. ) ;
            OF oDlg

 @ 4, 3 LISTBOX oLbx VAR nLbxSet   ;
                ARRAY aFileList    ;
                LABEL aSysStr[ SST_FILES ]  ;
                SIZE 24, 10         ;
                MESSAGE   "Selecione Fichero ¢ subdirectorio" ;
                ON DBLCLICK PKFlbxChoosed( oLbx )  ;
                OF oDlg

 @  5, 40 BUTTON aSysStr[ SST_INFOLABEL ] SIZE 17, 1 ;
                 MESSAGE "Ver los Caracteristicas del fichero actual" ;
                 ACTION   PKFFileInfo() ;
                 OF oDlg

 @  8, 40 BUTTON aSysStr[ SST_CANCEL ] SIZE 17, 1 ;
                 MESSAGE   "Terminar sin selecionar" ;
                 ACTION   oDlg:End()  ;
                 OF oDlg

 @ 11, 40 BUTTON aSysStr[ SST_ACCEPT ] SIZE 17, 3 ;
                 MESSAGE  "Terminar y selecionar fichero ¢ cambiar de de directorio" ;
                 ACTION  PKFEnd( oLbx ) ;
                 OF oDlg

 ACTIVATE DIALOG oDlg

 // nos cepillamos el ultimo item de anStarts.
 asize( anStarts, len( anStarts ) - 1 )

return cFilePicked

/******
*/
static function PKFMaskChanged( oEdt )

 local cPathMask := oEdt:cText()

 if file( cFAcceso( cPathMask ) +"NUL" )

    if empty( cFMascara( cPathMask ) ) .and. file( cPathMask )
       // es un fichero. acabamos.

       cFilePicked = cPathMask
       oDlg:End()

    elseif oEdt:oGet:Changed

       // Hay que resetear el ListBox
       aFileList := {}
       anStarts[ len( anStarts ) ] = nLeeDir( cPathMask, aFileList )
       oLbx:Reset()

    endif
 
 else // el directorio no exite.
    Alert( aSysStr( SST_BADPATH ) )

 endif

return nil

/******
*/
static function PKFlbxChoosed( oLbx )
 local cPathMask := eval( oGet:bSetGet )
 local cPath, cFile, nStart := aTail( anStarts ), acItems

  cFile = if( empty( cFMascara( cPathMask ) ),;
                     cFFileName( cPathMask ),;
                     cFMascara( cPathMask ) )
  // es un fichero
  if oLbx:nOption >= nStart .and. nStart > 0

     // Valor de retorno
     cFilePicked = cFAcceso( cPathMask ) + oLbx:acItems[ oLbx:nOption ]
     oDlg:End()
     
  else // Cambio de directorio.
     
     acItems = oLbx:acItems
        // Bajamos un subdir.
     if acItems[ oLbx:nOption ] == ".."

        cPath = cFSubDir( cFAcceso( cPathMask ) ) + cFile

     else

        cPath = cFAcceso( cPathMask ) + ;
                upper( rtrim( acItems[ oLbx:nOption ] ) ) + "\" + cFile
                  
     endif
     oGet:cText = cPath
     anStarts[ len( anStarts ) ] = nLeeDir( cPath, acItems )
     oLBx:Reset()

  endif

Return nil

/******
*/
static function PKFEnd( oListBox )

  oDlg:oClient:ChangeFocus( ID_nFICHEROS )

  PKFlbxChoosed( oListBox )

Return nil
/*********************************************************************/

/*******
*  Lee el Directorio con "cPathMask". Ordena el directorio poniendo
*  los Dir al principio de la lista y nPos donde empiezan los ficheros.
*  Carga el Array recibido( aFileList )
*/
static FUNCTION nLeeDir( cPathMask, aFileList )

 // 1§ los directorios
 local nLen
 local d, i 
 local cMask     := cFMascara( cPathMask )
 local nStartAt

 SetMCursor( IDC_CLOCK )

 aDir  = DIRECTORY( cFAcceso( cPathMask ) + "*.*" , "HSD")
 nLen  = len( aDir )

 // Excluye el directorio actual de la lista.
 if ( i := ascan( aDir, { |x| x.filename == "." } ) ) > 0
    aDel( aDir, i )
    --nLen
 endif

 // reDimensionamos el array recibido.
 aSize( aFileList, nLen )
 i = 1
 for d = 1 to Len( aFileList ) // es que aDir puede tener uno ya borrado.
     
     if ( "D" $ aDir[ d ].fileattrib ) // es un directorio.

         aFileList[ i++ ] = aDir[ d ].filename

     else  // es un fichero.
        // ¨ cumple la mascara ?
        if lWildCard( cMask, aDir[ d ].filename )

           // Solo Mayuscula la primera y las despues de puntuaci¢n.
           aFileList[ i++ ] = lower( aDir[ d ].filename )
          
        else // Lo machacamos.
        
           aDel( aFileList, i )
           nLen--
           
        endif

     endif

 next

 aSize( aFileList, nLen )
 
 // ponemos los subdir en lo alto de la lista
 aSort( aFileList )

 // ¨ donde co¤o estan los ficheros ?
 nStartAt = ascan( aFileList, { |x| x > "Z" } )

 oDlg:MouseMove( nMRow(), nMCol() )
 
RETURN nStartAt


/*******
*/
static function PKFFileInfo( oPbt ) // Info del fichero en cuesti¢n
/*
local aControls := oPbt:oParent:aControls
local cPathMask := aControls[ ID_nFILESPEC ]:GetDato()
local cPath     := cFAcceso( cPathMask )
local nLen      := max( 22, 9 + len( cPath ) )
local acItems   := aControls[ ID_nFICHEROS ]:acItems
local aFile := aDir[ ascan( aDir,;
                 {|x| x[1] == upper( acItems[ aControls[ ID_nFICHEROS ]:nItem ] )})]

  nAlert( { padr( "Acceso : " + cPath, nLen ),;
            padr( "Fichero: " + aFile[1], nLen ),;
            padr( "Bytes  : " + str(aFile[2]), nLen ),;
            padr( "Fecha  : " + dtoc(aFile[3]), nLen),;
            padr( "Hora   : " + aFile[4], nLen ),;
            padr( "Atribu.: " + aFile[5], nLen ) },,"w+/b" )
*/
RETURN NIL


