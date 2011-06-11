#include "FiveDos.ch"
#include "SysStr.ch"

static aSysStr := { ;
                      { " &Move"        ,;        //    1
                        " &Restore "    ,;        //    2
                        " &Size "       ,;        //    3
                        " Ma&ximize "   ,;        //    4
                        " Mi&nimize "   ,;        //    5
                        " &Close "      ,;        //    6
                        " &New "        ,;        //    7
                        " &Modify "     ,;        //    8
                        " &Delete "     ,;        //    9
                        " &Search "     ,;        //    10
                        " &Print "      ,;        //    11
                        " &Exit "       ,;        //    12
                        "   &Ok   "     ,;        //    13
                        "Atention"      ,;        //    14
                        "Information"   ,;        //    15
                        "Stop"          ,;        //    16
                        "Please, select",;        //    17
                        "   &Yes   "    ,;        //    18
                        "   &No   "     ,;        //    19
                        " &Accept "     ,;        //    20
                        " &Cancel "     ,;        //    21
                        "Select a file" ,;        //    22
                        " &Mask "       ,;        //    23
                        " &Files "      ,;        //    24
                        " &Information ",;        //    25
                        "Bad Path"      ,;        //    26
                        " &Retry "      ,;        //    27
                        " &Ignore "     ,;        //    28
                        " &Quit "       ,;        //    29
                        " &Help "       ,;        //    30
                        " De&fault "    ,;        //    31
                        "Begin of File" ,;        //    32
                        "End of File"   ,;        //    33
                        "Do you want to end execution;and return to DOS ?", ; // 34
                        "Bad Date, Try again" ,;   //   35
                        "Diver %1 Not found;Printer wil not work propertli"; //36
                      },;
                      { " &Mover "      ,;        //    1
                        " &Restaurar "  ,;        //    2
                        " &Tama¤o "     ,;        //    3
                        " Ma&ximizar "  ,;        //    4
                        " Mi&nimizar "  ,;        //    5
                        " &Cerrar "     ,;        //    6
                        " &Nuevo "      ,;        //    7
                        " &Modificar "  ,;        //    8
                        " &Eliminar "   ,;        //    9
                        " &Buscar "     ,;        //    10
                        " &Imprimir "   ,;        //    11
                        " &Salir "      ,;        //    12
                        " &Vale "       ,;        //    13
                        "Atenci¢n"      ,;        //    14
                        "Informaci¢n"   ,;        //    15
                        "Pare"          ,;        //    16
                        "Por favor, selecione",;  //    17
                        "   &Si   "     ,;        //    18
                        "   &No   "     ,;        //    19
                        " &Aceptar "    ,;        //    20
                        " &Cancelar "   ,;        //    21
                        "Seleccione un fichero",; //    22
                        " &M scara "    ,;        //    23
                        " &Ficheros "   ,;        //    24
                        " &Informaci¢n ",;        //    25
                        "Via de acceso erronea",; //    26
                        "&Reintentar"   ,;        //    27
                        "&Ignorar"      ,;        //    28
                        "&Terminar"     ,;        //    29
                        "&Ayuda"        ,;        //    30
                        "De&fecto"      ,;        //    31
                        "Principio de Fichero" ,; //    32
                        "Fin de Fichero"   ,;     //    33
                        "¨ Desea terminar la ejecuci¢n;y volver al DOS ?", ; // 34
                        " Fecha incorrecta; intentelo de nuevo" ,; // 35
                        "El Gestor %1 no se encuentra;La Impresora no funcionar  correctamente"; //36
                      } ;
                  }

static nLang := SLG_ENGLISH

//----------------------------------------------------------------------------//

function aSysStr( nStrID )

   if !Empty( nStrID ) .and. IS_NUMBER( nStrID ) .and. nStrID <= SST_MAXSTR
      return aSysStr[ nLang ][ nStrID ]
   end

return aSysStr[ nLang ]

//----------------------------------------------------------------------------//

function SysLanguage( nLanguage )

   local nOld := nLang

   if !Empty( nLanguage ) .and. nLanguage <= SLG_MAXLANG
      nLang = nLanguage
   endif

return nOld

//---------------------------------------------------------------------------//
