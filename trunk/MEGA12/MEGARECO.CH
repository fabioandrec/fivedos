// Fichero Include de Mega Records

// Fichero de cabecera para las definiciones de la libreria FiveDos.
#include "FiveDos.ch"
#include "SysStr.ch"
#include "Colores.ch"

#command SET LANGUAGE TO <nLang> => SysLanguage( <nLang> )

// Versi¢n del programa
#define M_R_VERSION "1.2"

// Contadores
#define CONT_CLI        1
#define CONT_PRO        2
#define CONT_FAC        3
//#define CONT_ALM        4  // No se usa en almacen c¢digos sucesivos.

// De clientes
#define TAM_CLIENTES   10
#define CLI_CODIGO      1
#define CLI_ULTFECHA    2
#define CLI_NOMBRE      3
#define CLI_NIF         4
#define CLI_DOMICILIO   5
#define CLI_POBLACION   6
#define CLI_CODPOST     7
#define CLI_TELEFONO    8
#define CLI_CANTIDAD    9
#define CLI_DESCUENTO  10

// De indices de cliente
#define ORD_CLI_CODIGO  1
#define ORD_CLI_NOMBRE  2
#define ORD_CLI_NIF     3
#define ORD_CLI_FECHA   4

// De proveedores
#define TAM_PROVEEDOR   7
#define PRO_CODIGO      1
#define PRO_NOMBRE      2
#define PRO_NIF         3
#define PRO_DOMICILIO   4
#define PRO_POBLACION   5
#define PRO_CODPOST     6
#define PRO_TELEFONO    7

// De indices de proveedores
#define ORD_PRO_CODIGO  1
#define ORD_PRO_NOMBRE  2
#define ORD_PRO_NIF     3

// De Almacen
#define TAM_ALMACEN    13
#define ALM_CODIGO      1
#define ALM_NOMBRE      2
#define ALM_TIPO        3
#define ALM_CANT        4
#define ALM_CANTMIN     5
#define ALM_PVP         6
#define ALM_PCOST       7
#define ALM_ALTA        8
#define ALM_UBICACION   9
#define ALM_CODPROVEE  10
#define ALM_NOMBREPRO  11
#define ALM_DOMICIPRO  12
#define ALM_TELEFOPRO  13

// De indices de almacen
#define ORD_ALM_CODIGO  1
#define ORD_ALM_NOMBRE  2
#define ORD_ALM_TIPO    3

// De Facturaci¢n.
#define TAM_FACTURACION 6
#define FAC_CODIGO      1
#define FAC_CODCLI      2
#define FAC_FECHA       3
#define FAC_HORA        4
#define FAC_ACLIENTE    5
#define FAC_ADESCFACT   6

// De indices de facturaci¢n.
#define ORD_FAC_CODIGO  1
#define ORD_FAC_CODCLI  2
#define ORD_FAC_CODDIA  3

// De datos del cliente de una factura.
#define FAC_CLI_NOM     1
#define FAC_CLI_NIF     2
#define FAC_CLI_DOM     3
#define FAC_CLI_POB     4
#define FAC_CLI_COD     5
#define FAC_CLI_TEL     6
#define FAC_CLI_CAN     7
#define FAC_CLI_ULT     8

// De Descripci¢n de Facturaci¢n.
#define TAM_DESCFACT    6
#define DES_CODPRO      1
#define DES_NOMBRE      2       // Se coje en la base Almac‚n
#define DES_CANT        3
#define DES_PVP         4
#define DES_DESCU       5
#define DES_PARCIAL     6       // Se calcula al obtener datos

// De indices de Descripci¢n de facturaci¢n.
#define ORD_DES_CODIGO  1
#define ORD_DES_CODPRO  2

// Indices para macros de 'recursos bitmaps'

#define IMG_VAR     acImage
#define IMG_VARNAME "acImage"

#define IMG_EXIT   "[ 1 ]"
#define IMG_INFO   "[ 2 ]"
#define IMG_CLOCK3 "[ 3 ]"
#define IMG_CALC   "[ 4 ]"
#define IMG_CALEND "[ 5 ]"
#define IMG_DISPLAY "[ 6 ]"
#define IMG_TOP    "[ 7 ]"
#define IMG_LEFT   "[ 8 ]"
#define IMG_RIGHT  "[ 9 ]"
#define IMG_BOTTOM "[ 10 ]"
#define IMG_EDIT   "[ 11 ]"
#define IMG_ADD    "[ 12 ]"
#define IMG_TRASH  "[ 13 ]"
#define IMG_SEEK   "[ 14 ]"
#define IMG_PRINTER "[ 15 ]"


// ---------------------------- Fin del Include ----------------------------- //
