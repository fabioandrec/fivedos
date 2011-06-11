#include "ObjectsP.ch"
#include "rool2.ch"
#include "director.ch"
/* Director.ch -> Pseudo objeto item de directorio
#xtranslate    .filename     =>    \[1\]
#xtranslate    .filesize     =>    \[2\]
#xtranslate    .filedate     =>    \[3\]
#xtranslate    .filetime     =>    \[4\]
#xtranslate    .fileattrib   =>    \[5\]
*/
/*
ÚÄÄÄÄÄÄ:::::::::::::::::::::::::::ÄÄÄÄÄ¿
³                                      ³
³  M scara:                            ³
³  TxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxT  ³
³                                      ³
³  Ficheros:                           ³
³  xxxxxxxx.xxx      Informaci¢n       ³
³  xxxxxxxx.xxx                        ³
³  xxxxxxxx.xxx                        ³
³  xxxxxxxx.xxx      Cancelar          ³
³  xxxxxxxx.xxx                        ³
³  xxxxxxxx.xxx                        ³
³  xxxxxxxx.xxx      Aceptar           ³
³  xxxxxxxx.xxx                        ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
/* ID's ordenados -> Accesso directo a la Lista de controles de la Ventana. */
#define    ID_nFILESPEC     1
#define    ID_nFICHEROS     2
#define    ID_nFILEINFO     3
#define    ID_nCANCEL       4
#define    ID_nACEPTAR      5

static aDir
STATIC anStarts   := {}   // Pila de pocisiones donde empiezan los ficheros
static cFilePicked    // PKFEnd lo pone antes de terminar la ventana.
                      // si es empty no hay selecci¢n,

function cPickFile( cPathMask, cTitle )
 USES WINDOW
 local aFileList := {}
 
 
 if empty( cFMascara( cPathMask ) )   // ¨ nos han dado el nombre completo de un fichero ?

    if empty( cFFileName( cPathMask ) )  // tampoco es un fichero. ponemos
                                       // mascara por defecto: "*.*"
       cPathMask = cFAcceso( cPathMask ) + "*.*"

    else // terminamos  --------   OJO   -------------
         // Devolvemos el fullPathName recibido.

       RETURN ( cPathMask )
    
    endif
 endif



 DEFAULT cTitle = " Selecci¢n de Fichero "

 DEFINE WINDOW FROM 4, 16 TO 19, 55 ;
               CLOSEMODE RST_SC_FAD ;
               EXPLODE

 @ 2, 3 SAY "^Mascara" GET padr( cPathMask, 60 ) ON WINDOW ;
                       MESSAGE "M scara para selecionar qu‚ ficheros ser n visualizados" ;
                       WIDTH      32             ;
                       END   PKFMaskChanged      ;
                       DOWN

 @ 5, 3 LISTBOX "^Ficheros"  HEIGHT 8    WIDTH 12 ;
                MESSAGE   "Selecione Fichero ¢ subdirectorio con ENTER ¢ DobleClick ¢ pulse Aceptar" ;
                EXECUTE   PKFlbxChoosed  ;
                IDNUM     ID_nFICHEROS

 @ 6, 20 BUTTON " ^Informaci¢n "     ;
                MESSAGE "Ver los Caracteristicas del fichero actual" ;
                EXECUTE   PKFFileInfo

 @ 9, 20 BUTTON " ^Cancelar " ;
                MESSAGE   "Terminar sin selecionar" ;
                EXECUTE   _WINDOW_:EndExec

 @ 12, 20 BUTTON " ^Aceptar "    ;
                 MESSAGE  "Terminar y selecionar fichero ¢ cambiar de de directorio" ;
                 EXECUTE  PKFEnd

 _WINDOW_:nControl = ID_nFICHEROS

 // inicio de la ventana
 _WINDOW_:Display()
 cFilePicked = ""
 aadd( anStarts, nLeeDir( alltrim( cPathMask ), aFileList ) )
 _WINDOW_:GetControl( ID_nFICHEROS ):SetAcItems( aFileList )
 
 EXECUTE WINDOW
 HIDE WINDOW



 // nos cepillamos el ultimo item de anStarts.
 asize( anStarts, len( anStarts ) - 1 )

Return cFilePicked

/******
*/
static function PKFMaskChanged( oEdt )
 local aControls := oEdt:oParent:aControls
 local acItems   := aControls[ ID_nFICHEROS ]:acItems
 local cPathMask := rtrim( oEdt:GetDato() )

 if file( cFAcceso( cPathMask ) +"NUL" )

    if empty( cFMascara( cPathMask ) ) .and. file( cPathMask )
       // es un fichero. acabamos.

       cFilePicked = cPathMask
       oEdt:oParent:EndExec()

    elseif oEdt:lChanged

       anStarts[ len( anStarts ) ] = nLeeDir( cPathMask, acItems )
       aControls[ ID_nFICHEROS ]:SetAcItems( acItems )

    endif
 
 else // el directorio no exite.
    nAlert( { "Ese directorio no existe" } )

 endif
Return nil

/******
*/
static function PKFlbxChoosed( oLbx )
 local aControls := oLbx:oParent:aControls
 local cPathMask := aControls[ ID_nFILESPEC ]:GetDato()
 local cPath, cFile, nStart := aTail( anStarts ), acItems

  cFile = if( empty( cFMascara( cPathMask ) ),;
                     cFFileName( cPathMask ),;
                     cFMascara( cPathMask ) )
  // es un fichero
  if oLbx:nItem >= nStart .and. nStart > 0

     // Valor de retorno
     cFilePicked = cFAcceso( cPathMask ) + oLbx:acItems[ oLbx:nItem ]
     oLbx:oParent:EndExec()
     
  else // Cambio de directorio.
     
     acItems = oLbx:acItems
        // Bajamos un subdir.
     if acItems[ oLbx:nItem ] == ".."

        cPath = cFSubDir( cFAcceso( cPathMask ) ) + cFile

     else

        cPath = cFAcceso( cPathMask ) + ;
                upper( rtrim( acItems[ oLbx:nItem ] ) ) + "\" + cFile
                  
     endif
     aControls[ ID_nFILESPEC ]:SetDato( cPath )
     anStarts[ len( anStarts ) ] = nLeeDir( cPath, acItems )
     oLbx:SetAcItems( acItems )

  endif

Return nil

/******
*/
static function PKFEnd( oControl )

  PKFlbxChoosed( oControl:oParent:aControls[ ID_nFICHEROS ] )
  oControl:oParent:ChangeFocus( ID_nFICHEROS )

Return nil


/*******
*  Lee el Directorio con "cPathMask". Ordena el directorio poniendo
*  los Dir al principio de la lista y nPos donde empiezan los ficheros.
*  Carga el Array recibido( aFileList )
*/
Static FUNCTION nLeeDir( cPathMask, aFileList, nLin, nCol )    
 static aCual := { "/", "Ä", "\", "Ä" }
 // 1§ los directorios
 local nLen
 local d, i 
 local cMask     := cFMascara( cPathMask )
 local lMsOldCrs := lMsCursor( .f. )
 local cSave 
 local nAttrib   := nClr2Att( "N/GR*" )
 local nStartAt

 DEFAULT nLin = 19, nCol = 28
 cSave := savescreen( nLin, nCol, nLin, nCol + 16 )
 SayAt( nLin, nCol, " Trabajando...   ", nAttrib )

 aDir  = DIRECTORY( cFAcceso( cPathMask ) + "*.*" , "HSD")
 nLen  = len( aDir )

 // Excluye el directorio actual de la lista.
 if ( i := ascan( aDir, { |x| x.filename == "." } ) ) > 0
    aDel( aDir, i )
    --nLen
 endif

 // reDimensionamos el array recibido.
 aSize( aFileList, nLen )
 nCol += 15
 i = 1
 for d = 1 to Len( aFileList ) // es que aDir puede tener uno ya borrado.
     
     SayAt( nLin, nCol, aCual[ 1 + d % 4 ], nAttrib )
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
 
 nCol -= 15
 RestScreen( nLin, nCol, nLin, nCol + 16, cSave )
 lMsCursor( lMsOldCrs )

RETURN nStartAt


/*******
*/
static function PKFFileInfo( oPbt ) // Info del fichero en cuesti¢n
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
               
RETURN NIL
