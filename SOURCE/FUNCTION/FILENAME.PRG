
/*******
*/
FUNCTION cFDisco( cPathMask )     // devuelve cUnidad l¢gica 
                                 // ej: de "c:\pepe\file.*"
                                 // devuelve "C:"
                                 // de : "\pepe\file.*"
                                 // devuelve ""
LOCAL cDisco := ""
if at( ":", cPathMask ) == 2
   cDisco = upper( left( cPathMask, 2 ) )
endif
RETURN ( cDisco )

/*******
*/
FUNCTION cFAcceso( cPathMask )  // DEVUELVE ACCESO
                               // ej.: de "c:\path\path\filename.ext"
                               // devuelve "c:\path\path\"
                               // ej:  de  "" -> "\"
                               // EJ: de "C:" -> "C:\"
LOCAL i                        // ej: de "C:filename.ext" -> "C:\"

i = rat( "\", cPathMask )
if i > 0
   cPathMask = upper( left( cPathMask, i ) )
else
   cPathMask = cFDisco( cPathMask ) + "\"
endif
RETURN cPathMask


/*********
*/
FUNCTION cFilename( cPathMask )
LOCAL i
i = rat( "\", cPathMask )

if i > 0 .and. i < len( cPathMask )
   cPathMask = right( cPathMask, len( cPathMask ) - i )
elseif ( i := at(":", cPathMask ) ) > 0
   cPathMask = right( cPathMask, len( cPathMask ) - i )
endif
RETURN ( upper( cPathMask ) )

/*******
*/
FUNCTION cFMascara( cPathMask ) // devuelve Mascara de un filename
                               // ej. de "c:\dir\*.bat" devuelve "*.BAT"
                               // ojo que si NO es una mascara devolver 
                               // un string nulo "".
LOCAL cMask
cMask = cFilename( cPathMask )

if !( ( "*" $ cMask ) .or. ( "?" $ cMask ))
   cMask = ""
endif
RETURN ( cMask )


/*******
*/
FUNCTION cFFileName( cPathMask ) // devuelve Nombre y extension
                               // ojo que si es una mascara devolver 
                               // un string nulo "".
LOCAL cFile
cFile = cFilename( cPathMask )

if ( "*" $ cPathMask ) .or. ( "?" $ cPathMask )
   cFile = ""
endif
RETURN ( cFile )

/*******
*/
FUNCTION cFName( cPathMask ) // ojo que si es una mascara devolver 
                             // la parte nombre de la mascara.
LOCAL i, cName
cName = alltrim( cFilename( cPathMask ) )

i = at( ".", cName )
cName = iif( i > 0, left( cName, i-1 ), cName )

RETURN padr( alltrim( cName ), 8 )

/*******
*/
FUNCTION cFExt( cPathMask ) // ojo que si es una mascara devolver 
                            // la parte extensi¢n de la mascara.
LOCAL i, cExt

cExt = alltrim( cFilename( cPathMask ) )

i = rat( ".", cExt )
cExt = iif( i > 0 .and. len( cExt ) > i,;
             right( cExt, len( cExt ) - i ), "" )

RETURN padr( alltrim( cExt ), 3 )

/******
  Devuelve el subdirectorio del Path recibido.
*/
FUNCTION cFSubDir( cPath )   // el Path puede terminar en "\"
                            // ej: de "C:\MIPATH\subdir\" -> "C:\MIPATH\"
                            // ej: de "C:\MIPATH\subdir"  -> "C:\MIPATH\"
LOCAL cSubDir, i

if right( cPath, 1 ) == "\"    // me han dado un path terminado en "\"
   
   cSubDir = cFAcceso( left( cPath, len( cPath ) - 1 ) )

else

   cSubDir = cFAcceso( cPath )

endif

RETURN upper( cSubDir )
