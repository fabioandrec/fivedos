#pragma inline

#include <dos.h>
#include <ClipApi.h>
#include <Fontdef.h>

// #define PCODEPROT

#define CARRY_FLAG      0x0001
#define PARTITY_FLAG    0x0004
#define AUXILIARY_FLAG  0x0010
#define ZERO_FLAG       0x0040
#define SIGN_FLAG       0x0080
#define TRAP_FLAG       0x0100
#define INTERRUPT_FLAG  0x0200
#define DIRECTION_FLAG  0x0400
#define OVERFLOW_FLAG   0x0800


#define EVE_TERMINA      0x510C
#define EVE_SYSDOWN      0x510B   // una por bajada de syslevel.
#define EVE_TERMINA_INI  0x510A   // antes de las ventanas alert no se si siempre
                                  // un alt_c lo provoca tambi‚n.
#define EVE_INKEY_IDLE   0x5108   // siempre que el buffer est  vac¡o en inkey().


#define EVE_PROT         0x4008   // Cada no se cuantos Flashes....

extern CLIPPER nMsgAlert( void );
extern CLIPPER MsgAlert( void );
extern CLIPPER Alert( void );
extern CLIPPER SetCua( void );
extern CLIPPER __QUIT( void );

extern WORD wScrMaxRow( void );
extern WORD wScrMaxCol( void );

extern BOOL FDosLinkDbg( void );

static WORD far hEventHandler = 0;

static WORD far wRowOld = 0, far wColOld = 0;
static BYTE far Back[ 6 ];
static BYTE far bChars[ 6 ] = { MOUSE1, MOUSE2, MOUSE3, MOUSE4, MOUSE5, MOUSE6 };
static BOOL far bInit = 0, far bOnOff = 0;
static BYTE far bRow = 0, far bCol = 0;  // Coordenadas de texto del cursor del rat¢n
static WORD far wLineWidth  = 0;     // Ancho de la pantalla multiplicado por 2
static WORD far wScreenSize = 0;     // Tamma¤o del buffer de video.
static BYTE far bCharHeigth = 0;     // Alto de una celdilla de caracter
static BOOL far bLeft, far bCenter, far bRight;
static WORD far wKLeft, far wKCenter, far wKRight;
static BYTE far bOffs;
static BOOL far bWorking = FALSE;
static BOOL far bEga = 0;
static BOOL far bInstaled;
static WORD far wNewRow = 0, far wNewCol = 0, far wNewButton = 0;


/*************** BEGIN PROTECTION *******************/

#define  GRABAOK    0
#define  NOOPEN     1
#define  NOBUSCA    2
#define  ERRPASSW   3
#define  NOLEE      4
#define  NOGRABA    5
#define  NOPC       6
#define  NOTABLA    7
#define  NOBIOS     8


#define USERNUM        PROCNAME
#define GRABALALIB     PROCLINE
#define OPERATION        PROCFILE
#define GETPASSWORD    __Fix3
#define GETREGCRC      __Fix4
#define GETLIBNUM      __Fix5

typedef void ( REGNAME )( PCLIPNAME );

extern CLIPPER __APPINIT( void );
extern void pascal __QUIT( void );
WORD _Weed_eatr( REGNAME far * pRegFunc );

CLIPPER GRABALALIB( void );  // PROCLINE()
CLIPPER USERNUM( void );     // PROCNAME()
CLIPPER OPERATION( void );     // PROCFILE()

static void RegName( PCLIPNAME pSymName );

static void pascal _GrabaLaLib( void );
static void pascal _UserNum( void );
static void pascal _Operation( void );
static WORD wOperation( LPBYTE );

#ifdef PCODEPROT
static void near AppInitPatch( LPBYTE DestCode );
#endif

static void * pExePassWord( void );
static WORD near Register( void );


#define     M16 0xA001      /* crc-16 mask */

static LPBYTE near u2Hex( WORD );
static LPBYTE near szPassWord( LPBYTE szUserNumber );
static LPBYTE near szUserNum( LPBYTE szLibNum );
static LPBYTE near szLibNum( void );

extern WORD _vmStat( WORD );
extern WORD _bcmp( LPBYTE, LPBYTE, WORD );
extern WORD _bscan( LPBYTE, WORD, BYTE );

typedef struct
{
    DWORD edi, esi, ebp, reserved, ebx, edx, ecx, eax;
    WORD  flags, es, ds, fs, gs, ip, cs, sp, ss;
} REALMODEINT;

extern DWORD DosLowAlloc( WORD wBytes );
extern void DosLowFree( DWORD SelSeg );
extern BOOL RealModeInt( WORD wIntNo, REALMODEINT * pReal );
extern BOOL bIsExtendedExe( void );
extern WORD CreateDSAlias( WORD selCode );

#define HI(x) ( *((BYTE *) (&x)+1) )    /*devuelve byte alto de un WORD*/
#define LO(x) ( *((BYTE *) &x) )        /*devuelve byte bajo de un WORD*/

/*== Declaraci¢n de tipos ============================================*/

typedef struct {                   /*describe la posici¢n de un sector*/
                BYTE Head;              /*cabezal de lectura/escritura*/
                WORD SecZyl;                 /*n§ de sector y cilindro*/
               } SECPOS;

typedef struct {                  /*entrada en la tabla de particiones*/
                BYTE          Status;            /*estado de partici¢n*/
                SECPOS        StartSec;                /*primer sector*/
                BYTE          PartTyp;             /*tipo de partici¢n*/
                SECPOS        EndSec;                  /*£ltimo sector*/
                unsigned long SecOfs;      /*offset del sector de arr.*/
                unsigned long SecAnz;                 /*n§ de sectores*/
               } PARTENTRY;

typedef struct {                         /*describe el sector de part.*/
                BYTE      BootCode[ 0x1BE ];
                PARTENTRY PartTable[ 4 ];
                WORD      IdCode;                             /*0xAA55*/

                BYTE      DataPlus[ 25 ];  // Datos extra del sector 0
               } PARTSEC;

typedef PARTSEC far *PARSPTR; /*puntero al sector de partici¢n en mem.*/


static WORD far wFlashCount     = 358;
static BOOL far bEnding         = FALSE;
static BOOL far bUserNumCalled  = FALSE;

static BYTE far bProteccting    = FALSE;

static PCLIPNAME far pRegName   = 0;
static PCLIPNAME far pGrabaLib  = 0;
static PCLIPNAME far pUserNum   = 0;
static PCLIPNAME far pOperation = 0;
static PCLIPNAME far pFiveDos   = 0;
static PCLIPNAME far pAlert     = 0;

static BYTE far sFiveSymName[ 12 ] = "__FIVEDOS\0\0\0";
static BYTE far sNumber[ 5 ];
static BYTE far sLibNum[ 9 ];
static BYTE far szPassword[ 8 ];

#define REGISTERCRC  54409

/*************** END PROTECTION *******************/


LPBYTE TextVideo( void );
LPBYTE GraphVideo( void );
LPBYTE BaseSegment( void );




static BYTE far Arrow[ 3 ][ 16 ] = {
                                {  0x00,     // 00000000
                                   0x40,     // 01000000
                                   0x60,     // 01100000
                                   0x70,     // 01110000
                                   0x78,     // 01111000
                                   0x7C,     // 01111100
                                   0x7E,     // 01111110
                                   0x7F,     // 01111111
                                   0x7F,     // 01111111
                                   0x7F,     // 01111111
                                   0x7C,     // 01111100
                                   0x66,     // 01100110
                                   0x46,     // 01000110
                                   0x03,     // 00000011
                                   0x03,     // 00000011
                                   0x00 },   // 00000000
                                {  0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x80,     // 10000000
                                   0xC0,     // 11000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00 },   // 00000000
                                 { 0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00,     // 00000000
                                   0x00 } }; // 00000000

static BYTE far ArrowMask[ 3 ][ 16 ] = { {
                                    0xC0,    // 11000000
                                    0xE0,    // 11100000
                                    0xF0,    // 11110000
                                    0xF8,    // 11111000
                                    0xFC,    // 11111100
                                    0xFE,    // 11111110
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xEF,    // 11101111
                                    0xE7,    // 11100111
                                    0x07,    // 00000111
                                    0x03 },  // 00000011
                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x80,    // 10000000
                                    0xC0,    // 11000000
                                    0xE0,    // 11100000
                                    0xE0,    // 11100000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x80,    // 10000000
                                    0x80,    // 10000000
                                    0x80 },  // 10000000
                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 } } ; // 00000000

static BYTE far RightArrow[ 3 ][ 16 ] = {
                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x08,    // 00001000
                                    0x18,    // 00011000
                                    0x38,    // 00111000
                                    0x7F,    // 01111111
                                    0x7F,    // 01111111
                                    0x38,    // 00111000
                                    0x18,    // 00011000
                                    0x08,    // 00001000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 },  // 00000000

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x40,    // 01000000
                                    0x60,    // 01100000
                                    0x70,    // 01110000
                                    0xF8,    // 11111000
                                    0xF8,    // 11111000
                                    0x70,    // 01110000
                                    0x60,    // 01100000
                                    0x40,    // 01000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 },  // 00000000

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 }}; // 00000000

static BYTE far RightMask[ 3 ][ 16 ] = {
                                  { 0x00,    // 00000000
                                    0x0C,    // 00001100
                                    0x1C,    // 00011100
                                    0x3C,    // 00111100
                                    0x7F,    // 01111111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0x7F,    // 01111111
                                    0x3C,    // 00111100
                                    0x1C,    // 00011100
                                    0x0C,    // 00001100
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 },  // 00000000
                                  { 0x00,    // 00000000
                                    0xC0,    // 11000000
                                    0xE0,    // 11100000
                                    0xF0,    // 11110000
                                    0xF8,    // 11111000
                                    0xFC,    // 11111100
                                    0xFC,    // 11111100
                                    0xF8,    // 11111000
                                    0xF0,    // 11110000
                                    0xE0,    // 11100000
                                    0xC0,    // 11000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 },  // 00000000
                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 }}; // 00000000

static BYTE far DownArrow[ 3 ][ 16 ] = {
                                  { 0x00,    // 00000000
                                    0x0C,    // 00001100
                                    0x1E,    // 00011110
                                    0x3F,    // 00111111
                                    0x7F,    // 01111111
                                    0x0C,    // 00001100
                                    0x0C,    // 00001100
                                    0x0C,    // 00001100
                                    0x0C,    // 00001100
                                    0x7F,    // 01111111
                                    0x3F,    // 00111111
                                    0x1E,    // 00011110
                                    0x0C,    // 00001100
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 },  // 00000000

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x80,    // 10000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x80,    // 10000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 },  // 00000000

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 }}; // 00000000

static BYTE far DownMask[ 3 ][ 16 ] = {
                                  { 0x0C,    // 00001100
                                    0x1E,    // 00011110
                                    0x3F,    // 00111111
                                    0x7F,    // 01111111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0x1E,    // 00011110
                                    0x1E,    // 00011110
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0x7F,    // 01111111
                                    0x3F,    // 00111111
                                    0x1E,    // 00011110
                                    0x0C,    // 00001100
                                    0x00,    // 00000000
                                    0x00 },  // 00000000
                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x80,    // 10000000
                                    0xC0,    // 11000000
                                    0x80,    // 10000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x80,    // 10000000
                                    0xC0,    // 11000000
                                    0x80,    // 10000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 },  // 00000000
                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 }}; // 00000000


static BYTE far Clock[ 3 ][ 16 ] = {
                                  { 0x00,    // 00000000
                                    0x7F,    // 01111111
                                    0x60,    // 01100000
                                    0x61,    // 01100001
                                    0x32,    // 00110010
                                    0x35,    // 00110101
                                    0x1A,    // 00011010
                                    0x0F,    // 00001111
                                    0x0F,    // 00001111
                                    0x18,    // 00011000
                                    0x30,    // 00110000
                                    0x30,    // 00110000
                                    0x62,    // 01100010
                                    0x65,    // 01100101
                                    0x7F,    // 01111111
                                    0x00 },  // 00000000
                                  { 0x00,    // 00000000
                                    0xFC,    // 11111100
                                    0x2C,    // 00101100
                                    0x5C,    // 01011100
                                    0xB8,    // 10111000
                                    0x58,    // 01011000
                                    0xB0,    // 10110000
                                    0xE0,    // 11100000
                                    0xE0,    // 11100000
                                    0x30,    // 00110000
                                    0x18,    // 00011000
                                    0x18,    // 00011000
                                    0x8C,    // 10001100
                                    0x4C,    // 01001100
                                    0xFC,    // 11111100
                                    0x00 },  // 00000000
                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 }}; // 00000000

static BYTE far ClockMask[ 3 ][ 16 ] = {
                                  { 0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFE,    // 11111110
                                    0x7D,    // 01111101
                                    0x7A,    // 01111010
                                    0x3D,    // 00111101
                                    0x1F,    // 00011111
                                    0x1F,    // 00011111
                                    0x3F,    // 00111111
                                    0x7F,    // 01111111
                                    0x7F,    // 01111111
                                    0xFD,    // 11111101
                                    0xFA,    // 11111010
                                    0xFF,    // 11111111
                                    0xFF },  // 11111111
                                  { 0xFE,    // 11111110
                                    0xFE,    // 11111110
                                    0xDE,    // 11011110
                                    0xBE,    // 10111110
                                    0x7C,    // 01111100
                                    0xBC,    // 10111100
                                    0x78,    // 01111000
                                    0xF0,    // 11110000
                                    0xF0,    // 11110000
                                    0xF8,    // 11111000
                                    0xFC,    // 11111100
                                    0xFC,    // 11111100
                                    0x7E,    // 01111110
                                    0xBE,    // 10111110
                                    0xFE,    // 11111110
                                    0xFE },  // 11111110
                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 }}; // 00000000

static BYTE far CrossArrow[ 3 ][ 16 ] = {
                                  { 0x00,    // 00000000
                                    0x01,    // 00000001
                                    0x03,    // 00000011
                                    0x07,    // 00000111
                                    0x01,    // 00000001
                                    0x11,    // 00010001
                                    0x31,    // 00110001
                                    0x7F,    // 01111111
                                    0x7F,    // 01111111
                                    0x31,    // 00110001
                                    0x11,    // 00010001
                                    0x01,    // 00000001
                                    0x07,    // 00000111
                                    0x03,    // 00000011
                                    0x01,    // 00000001
                                    0x00 },  // 00000000

                                  { 0x00,    // 00000000
                                    0x80,    // 10000000
                                    0xC0,    // 11000000
                                    0xE0,    // 11100000
                                    0x80,    // 10000000
                                    0x88,    // 10001000
                                    0x8C,    // 10001100
                                    0xFE,    // 11111110
                                    0xFE,    // 11111110
                                    0x8C,    // 10001100
                                    0x88,    // 10001000
                                    0x80,    // 10000000
                                    0xE0,    // 11100000
                                    0xC0,    // 11000000
                                    0x80,    // 10000000
                                    0x00 },  // 00000000

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 }}; // 00000000

static BYTE far CrossMask[ 3 ][ 16 ] = {
                                  { 0x01,    // 00000001
                                    0x03,    // 00000011
                                    0x07,    // 00000111
                                    0x0F,    // 00001111
                                    0x1F,    // 00011111
                                    0x3B,    // 00111011
                                    0x7F,    // 01111111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0x7F,    // 01111111
                                    0x3B,    // 00111011
                                    0x1F,    // 00011111
                                    0x0F,    // 00001111
                                    0x07,    // 00000111
                                    0x03,    // 00000011
                                    0x01 },  // 00000001

                                  { 0x80,    // 10000000
                                    0xC0,    // 11000000
                                    0xE0,    // 11100000
                                    0xF0,    // 11110000
                                    0xF8,    // 11111000
                                    0xDC,    // 11011100
                                    0xFE,    // 11111110
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFE,    // 11111110
                                    0xDC,    // 11011100
                                    0xF8,    // 11111000
                                    0xF0,    // 11110000
                                    0xE0,    // 11100000
                                    0xC0,    // 11000000
                                    0x80 },  // 10000000

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 }}; // 00000000

static BYTE far HandPoint[ 3 ][ 16 ] = {
                                  { 0x0C,    // 00001100
                                    0x1E,    // 00011110
                                    0x1E,    // 00011110
                                    0x1F,    // 00011111
                                    0x1D,    // 00011101
                                    0x6D,    // 01101101
                                    0xED,    // 11101101
                                    0xFD,    // 11111101
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0x7F,    // 01111111
                                    0x3F,    // 00111111
                                    0x1F,    // 00011111
                                    0x1F,    // 00011111
                                    0x0F },  // 00001111

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0xFE,    // 11111110
                                    0xB7,    // 10110111
                                    0xB7,    // 10110111
                                    0xB7,    // 10110111
                                    0xB7,    // 10110111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFE,    // 11111110
                                    0xFE,    // 11111110
                                    0xFE,    // 11111110
                                    0xFE,    // 11111110
                                    0xFE },  // 11111110

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 }}; // 00000000


static BYTE far HandMask[ 3 ][ 16 ] = {
                                  { 0x0C,    // 00001100
                                    0x1E,    // 00011110
                                    0x1E,    // 00011110
                                    0x1F,    // 00011111
                                    0x1D,    // 00011101
                                    0x6D,    // 01101101
                                    0xED,    // 11101101
                                    0xFD,    // 11111101
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0x7F,    // 01111111
                                    0x3F,    // 00111111
                                    0x1F,    // 00011111
                                    0x1F,    // 00011111
                                    0x0F },  // 00001111

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0xFE,    // 11111110
                                    0xB7,    // 10110111
                                    0xB7,    // 10110111
                                    0xB7,    // 10110111
                                    0xB7,    // 10110111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFF,    // 11111111
                                    0xFE,    // 11111110
                                    0xFE,    // 11111110
                                    0xFE,    // 11111110
                                    0xFE,    // 11111110
                                    0xFE },  // 11111110

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 }}; // 00000000

static BYTE far SizeNWSE[ 3 ][ 16 ] = {
                                  { 0x00,    // 00000000
                                    0x7E,    // 01111110
                                    0x7C,    // 01111100
                                    0x7C,    // 01111100
                                    0x7E,    // 01111110
                                    0x4F,    // 01001111
                                    0x07,    // 00000111
                                    0x03,    // 00000011
                                    0x01,    // 00000001
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 },  // 00000000

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x80,    // 10000000
                                    0xC0,    // 11000000
                                    0xE0,    // 11100000
                                    0xF2,    // 11110010
                                    0x7E,    // 01111110
                                    0x3E,    // 00111110
                                    0x3E,    // 00111110
                                    0x7E,    // 01111110
                                    0x00,    // 00000000
                                    0x00 },  // 00000000

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 }}; // 00000000


static BYTE far SizeNWSEMask[ 3 ][ 16 ] = {
                                  { 0xFE,    // 11111110
                                    0xFE,    // 11111110
                                    0xFC,    // 11111100
                                    0xFC,    // 11111100
                                    0xFE,    // 11111110
                                    0xCF,    // 11001111
                                    0x07,    // 00000111
                                    0x03,    // 00000011
                                    0x01,    // 00000001
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 },  // 00000000

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x80,    // 10000000
                                    0xC0,    // 11000000
                                    0xE0,    // 11100000
                                    0xF3,    // 11110011
                                    0x7F,    // 01111111
                                    0x3F,    // 00111111
                                    0x3F,    // 00111111
                                    0x7F,    // 01111111
                                    0x7F,    // 01111111
                                    0x00 },  // 00000000

                                  { 0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00,    // 00000000
                                    0x00 }}; // 00000000

static LPBYTE far pCursors[] =  {
                                    ( LPBYTE ) Arrow,
                                    ( LPBYTE ) RightArrow,
                                    ( LPBYTE ) DownArrow,
                                    ( LPBYTE ) CrossArrow,
                                    ( LPBYTE ) HandPoint,
                                    ( LPBYTE ) SizeNWSE,
                                    ( LPBYTE ) Clock
                                };

static LPBYTE far pMasks[]   =  {
                                    ( LPBYTE ) ArrowMask,
                                    ( LPBYTE ) RightMask,
                                    ( LPBYTE ) DownMask,
                                    ( LPBYTE ) CrossMask,
                                    ( LPBYTE ) HandMask,
                                    ( LPBYTE ) SizeNWSEMask,
                                    ( LPBYTE ) ClockMask
                                };


static BYTE far pHots[ 7 ][ 2 ] = {
                                    {  8,  8 },
                                    { 40, 64 },
                                    { 64, 40 },
                                    { 64, 64 },
                                    {  0, 40 },
                                    {  8,  8 },
                                    { 56, 56 },
                                  };

static BYTE far bCursor = 0;


typedef struct
{
    WORD wRow;
    WORD wCol;
    BYTE bVer;
    BYTE bHor;
} MOUSEMIX;

//---------------------------------------------------------------------------//

BYTE bMouseCursor( void ) { return bCursor; }

//---------------------------------------------------------------------------//

BOOL bIsEga( void )
{
   _AH = 0x12;
   _BX = 0xFF10;
   asm int 0x10;

   return ( _BX != 0xFF10 );
}

// ----------------------------------------------------------------------------
/*************
void KeyStuff( unsigned int uiKey )
{
   unsigned int uiTail        = peek( 0, 0x041C );
   unsigned int uiBufferStart = peek( 0, 0x0480 );
   unsigned int uiBufferEnd   = peek( 0, 0x0482 );

   poke( 0, 0x0400 + uiTail, uiKey );
   uiTail += 2;
   poke( 0, 0x041C, ( uiTail >= uiBufferEnd ) ? uiBufferStart: uiTail );
}
****************/
//---------------------------------------------------------------------------//

static void near FontBegin( void )  // Copia el font a RAM
{
   outport( 0x3C4, 0x0402 );
   outport( 0x3C4, 0x0704 );
   outport( 0x3C4, 0x0300 );

   outport( 0x3CE, 0x0204 );
   outport( 0x3CE, 0x0005 );
   outport( 0x3CE, 0x0006 );
}

// ----------------------------------------------------------------------------

static void near FontEnd( void )  // Copia el font a la tarjeta
{
   outport( 0x3C4, 0x0302 );
   outport( 0x3C4, 0x0304 );
   outport( 0x3C4, 0x0300 );

   outport( 0x3CE, 0x0004 );
   outport( 0x3CE, 0x1005 );
   outport( 0x3CE, 0x0E06 );
}

// ----------------------------------------------------------------------------

// Standard Stack Frame
#pragma option -k
static BYTE bCharScanLines( void )
{
   _AX = 0x1130;
   _BH = 0;
   asm int 0x10;  // Ojo que toca BP

   return _CX;
}
#pragma option -k-

// ----------------------------------------------------------------------------

void MouseReset( void )
{
   while( bWorking );

   bWorking = TRUE;

   _AX = 0;
   asm int 0x33;

   if( bInit )
   {
        FDosLinkDbg();  // UnLink
        ( (PCLIPSYMBOL) pAlert->pSymbol )->pFunc = (PCLIPFUNC) Alert;
   }

   bInit = bWorking = FALSE;

}

//---------------------------------------------------------------------------//

// Enable FastCall and optimizations
#pragma option -pr -O2


//---------------------------------------------------------------------------//

static int near abs( int Number )
{
   asm mov ax, Number;

   if( _AX > 0x7FFF )
   {
      asm neg ax;
   }
   
   return _AX;
}

//---------------------------------------------------------------------------//

static void near CopyCharDef( BYTE bDest, BYTE bOrigin )
{
   char * pFont = GraphVideo();

   _bcopy( pFont + bDest * 32, pFont + bOrigin * 32, bCharHeigth );
}

//---------------------------------------------------------------------------//

static void near ChangeDef( BYTE bDest, LPBYTE pbBlock, LPBYTE pbMask, BYTE bStart,
                       BYTE bEnd )
{
   LPBYTE pFont = GraphVideo() + bDest * 32;
   WORD  b;
   WORD  wEnd  = ( ( bEnd < ( bCharHeigth - 1 ) ) ? ( ( bCharHeigth - 1 ) - bEnd ): 0 );
   pbMask  += wEnd;
   pbBlock += wEnd;

   pFont += bStart;

   for( b = bStart; b <= bEnd; b++ )
        * pFont = ( * pFont++ & * pbMask++ ) | * pbBlock++;
}



//---------------------------------------------------------------------------//

static BYTE near bPower( BYTE bTimes )
{
   BYTE bResult = 1, b;

   for( b = 0; b < bTimes; b++ )
      bResult *= 2;

   return bResult;
}


//---------------------------------------------------------------------------//

// Disable FastCall: C Calling convention
#pragma option -p-

//---------------------------------------------------------------------------//

static void near MouseCalc( MOUSEMIX* pM,  WORD wNewRow, WORD wNewCol )
{
   if( bCharHeigth > 8 )
   {
       pM->wRow = IF( wNewRow >= pHots[ bCursor ][ 0 ], wNewRow - pHots[ bCursor ][ 0 ], 0 );
       pM->wCol = IF( wNewCol >= pHots[ bCursor ][ 1 ], wNewCol - pHots[ bCursor ][ 1 ], 0 );
   }
   else
   {
       pM->wRow = IF( wNewRow >= pHots[ bCursor ][ 0 ] / 2, wNewRow - pHots[ bCursor ][ 0 ] / 2, 0 );
       pM->wCol = IF( wNewCol >= pHots[ bCursor ][ 1 ] / 2, wNewCol - pHots[ bCursor ][ 1 ] / 2, 0 );
   }

   pM->bVer  = ( pM->wRow / 8 ) % bCharHeigth;
   pM->bHor  = ( pM->wCol / 8 ) % 9;
   pM->wRow /= ( 8 * bCharHeigth );
   pM->wCol /= ( 8 * 9 );
}

//---------------------------------------------------------------------------//

void SetChar( LPBYTE pFontDef )
{
    WORD  wFlags = _FLAGS;

    if( bCharHeigth == 0 )
        bCharHeigth = bCharScanLines();

    if( _FLAGS & INTERRUPT_FLAG )
        disable();

    FontBegin();

    _bcopy( GraphVideo() + pFontDef[ 0 ] * 32,
            pFontDef + 1, bCharHeigth );

    FontEnd();

    if( wFlags & INTERRUPT_FLAG )
        enable();

}

//---------------------------------------------------------------------------//
/****
void SetCharMaps( BYTE map0, BYTE map1)
{
    BYTE bFlags = ( map0 & 3 ) + ( ( map0 & 4 ) << 2 ) +
                  ( ( map1 & 3 ) << 2 ) + ( ( map1 & 4 ) << 3 );
    asm {
            mov ax, 0x1103 // Programar Character-Map-Select-Register
            mov bl, bFlags
            int 0x10
        }
}
***/

//---------------------------------------------------------------------------//

static void CursorMix( WORD wRow, WORD wCol, LPBYTE pOld, LPBYTE pNew,
                       BOOL bWaitRetrace )
{
   BYTE Cursor[ 3 ][ 16 ];
   BYTE Mask[ 3 ][ 16 ];
   BYTE b, bRest1, bRest2, bShift;
   MOUSEMIX mMix;
   LPBYTE pOldMax = pOld + wScreenSize;
   LPBYTE pNewMax = pNew + wScreenSize;

   MouseCalc( &mMix, wRow, wCol );

   bShift = bPower( mMix.bHor ) - 1;

   if( pOld )
       pOld += ( wRowOld * wLineWidth ) + ( wColOld * 2 );

   pNew += ( mMix.wRow * wLineWidth ) + ( mMix.wCol * 2 ),

   wRowOld = mMix.wRow;
   wColOld = mMix.wCol;

   if( bCharHeigth > 8 )
   {
        _bcopy( ( LPBYTE ) Cursor, ( LPBYTE ) pCursors[ bCursor ], 48 );
        _bcopy( ( LPBYTE ) Mask, ( LPBYTE ) pMasks[ bCursor ], 48 );
   }
   else
   {
       BYTE i = 0;
       for( b = 0; b < 48; b += 2, i++ )
       {
           if( ! ( i % 8 ) )
               i = b;
           *( ( (LPBYTE) Cursor ) +  i ) = *( pCursors[ bCursor ] +  b );
           *( ( (LPBYTE) Mask ) + i )    = *( pMasks[ bCursor ] + b );
       }
   }

   for( b = 0; b < bCharHeigth; b++ )
   {
      bRest1 = ( Cursor[ 0 ][ b ] & bShift ) << ( 8 - mMix.bHor );
      bRest2 = ( Cursor[ 1 ][ b ] & bShift ) << ( 8 - mMix.bHor );
      Cursor[ 0 ][ b ] >>= mMix.bHor;
      Cursor[ 1 ][ b ] >>= mMix.bHor;
      Cursor[ 2 ][ b ] >>= mMix.bHor;
      Cursor[ 1 ][ b ] |= bRest1;
      Cursor[ 2 ][ b ] |= bRest2;

      bRest1 = ( Mask[ 0 ][ b ] & bShift ) << ( 8 - mMix.bHor );
      bRest2 = ( Mask[ 1 ][ b ] & bShift ) << ( 8 - mMix.bHor );
      Mask[ 0 ][ b ] >>= mMix.bHor;
      Mask[ 0 ][ b ] = ~Mask[ 0 ][ b ];
      Mask[ 1 ][ b ] >>= mMix.bHor;
      Mask[ 1 ][ b ] |= bRest1;
      Mask[ 1 ][ b ] = ~Mask[ 1 ][ b ];
      Mask[ 2 ][ b ] >>= mMix.bHor;
      Mask[ 2 ][ b ] |= bRest2;
      Mask[ 2 ][ b ] = ~Mask[ 2 ][ b ];
   }

   if( bWaitRetrace )
   {
       while( !( ( inport( 0x3DA ) & 8 ) == 8 ) );
       while( !( ( inport( 0x3DA ) & 8 ) == 0 ) );
   }

   if( !( pOld == 0 ) )
   {
        pOld[ 0 ] = Back[ 0 ];
        pOld[ 2 ] = Back[ 1 ];
        pOld[ 4 ] = Back[ 2 ];
        pOld += wLineWidth;
        if( pOld < pOldMax )
        {
            pOld[ 0 ] = Back[ 3 ];
            pOld[ 2 ] = Back[ 4 ];
            pOld[ 4 ] = Back[ 5 ];
        }
   }

   Back[ 0 ] = pNew[ 0 ];
   Back[ 1 ] = pNew[ 2 ];
   Back[ 2 ] = pNew[ 4 ];
   pNew += wLineWidth;
   Back[ 3 ] = pNew[ 0 ];
   Back[ 4 ] = pNew[ 2 ];
   Back[ 5 ] = pNew[ 4 ];

   FontBegin();

   CopyCharDef( bChars[ 0 ], Back[ 0 ] );
   CopyCharDef( bChars[ 1 ], Back[ 1 ] );
   CopyCharDef( bChars[ 2 ], Back[ 2 ] );

   ChangeDef( bChars[ 0 ], Cursor[ 0 ], Mask[ 0 ], mMix.bVer, bCharHeigth - 1 );
   ChangeDef( bChars[ 1 ], Cursor[ 1 ], Mask[ 1 ], mMix.bVer, bCharHeigth - 1 );
   ChangeDef( bChars[ 2 ], Cursor[ 2 ], Mask[ 2 ], mMix.bVer, bCharHeigth - 1 );

   if( mMix.bVer )
   {
       CopyCharDef( bChars[ 3 ], Back[ 3 ] );
       CopyCharDef( bChars[ 4 ], Back[ 4 ] );
       CopyCharDef( bChars[ 5 ], Back[ 5 ] );

       ChangeDef( bChars[ 3 ], Cursor[ 0 ], Mask[ 0 ], 0, mMix.bVer - 1 );
       ChangeDef( bChars[ 4 ], Cursor[ 1 ], Mask[ 1 ], 0, mMix.bVer - 1 );
       ChangeDef( bChars[ 5 ], Cursor[ 2 ], Mask[ 2 ], 0, mMix.bVer - 1 );
   }

   FontEnd();

   if( mMix.bVer && pNew < pNewMax )
   {
        pNew[ 0 ] = bChars[ 3 ];
        pNew[ 2 ] = bChars[ 4 ];
        pNew[ 4 ] = bChars[ 5 ];
   }
   pNew -= wLineWidth;
   pNew[ 0 ] = bChars[ 0 ];
   pNew[ 2 ] = bChars[ 1 ];
   pNew[ 4 ] = bChars[ 2 ];

}

// ----------------------------------------------------------------------------

static void _saveregs MouseCallBack( void )
{
   WORD  wButton;
   WORD  wRow   ;
   WORD  wCol   ;
   int   iMickHor;
   int   iMickVer;

   WORD  wFlags = _FLAGS;          // Save flags register: interrupt flag
                                   // ExoSpace mouse support don't clear
   if( _FLAGS & INTERRUPT_FLAG )   // interrupt flag when running under DOS.
       disable();                  // Disable interupts

   
   wButton  = _BX;
   wRow     = _DX;
   wCol     = _CX;
   iMickHor = _SI;
   iMickVer = _DI;
   wNewRow    = wRow;
   wNewCol    = wCol;
   wNewButton = wButton;

   if( ! bWorking )
   {
       bWorking = TRUE;

       {
          if( bOnOff && ( iMickHor || iMickVer ) && bEga )
          {
             bOffs  = ( bOffs ) ? ( bOffs - 1 ): 0;

             if( ! bOffs )
             {
                LPBYTE pVideo = TextVideo();

                asm {
                        mov ax, 0x000B
                        int 0x33
                    }

                CursorMix( wRow, wCol, pVideo, pVideo,
                           ( abs( iMickHor ) + abs( iMickVer ) ) < 6 );

             }
          }
       }

       bWorking = FALSE;
   }

   if( wFlags & INTERRUPT_FLAG )   // Restore interrupt flag if necesary.
       enable();
}

//---------------------------------------------------------------------------//
#ifdef PCODEPROT
static LPBYTE near GetPCode( LPBYTE pFunc )
{
    // secuencia del final del pCode...
    // static BYTE pReturn[ 4 ] = { 0x2E, 0x02, 0x00, 0x5F };

    return (LPBYTE) MK_FP( FP_SEG( pFunc ),
                              ( (WORD far *) ( pFunc + 1 ) )[ 0 ] );
}
#endif
//---------------------------------------------------------------------------//

static WORD near wCRC( LPBYTE Buffer, WORD wLen )
{
    WORD wCrc = 0;
    WORD index;
    WORD i;
    WORD c;

    for( index = 0; index < wLen; index++ )
    {
        c = (WORD) Buffer[ index ];

        c <<= 8;
        for( i = 0; i < 8; i++ )
        {
            if( ( wCrc ^ c ) & 0x8000)
               wCrc = ( wCrc << 1 ) ^ M16;
            else
               wCrc <<= 1;

            c <<= 1;
        }
    }

    return wCrc;
}

//---------------------------------------------------------------------------//

static void EventHandler( EVENT * oEvent )
{
   if( oEvent->wMessage == EVE_TERMINA && ! bEnding )
   {
        bEnding = TRUE;
        _PutSym( _Get_Sym( "SETCUA" ) );
        ( ++_tos )->wType = 0;
        _PutL( 0 );
        _xDo( 1 );

   }
   else if( oEvent->wMessage == EVE_PROT && ! bEnding && ! bWorking )
   {
       bEnding = TRUE;

       wFlashCount = Register();

       bEnding = FALSE;

   }
   
}

//----------------------------------------------------------------------------

static void near Link( void )
{
    nMsgAlert();
    Alert();
    SetCua();
}

//---------------------------------------------------------------------------//

// Se llama aqu¡ en lugar de a __APPINIT() cuando exe funciona normalmente.
static CLIPPER _ExeLiberado( void )
{
}

//----------------------------------------------------------------------------

static void near ProtIni( void )
{
    if( ! pAlert )
    {
    #ifdef PCODEPROT
        #ifdef REGISTERCRC
           AppInitPatch( GetPCode( (LPBYTE) __APPINIT ) );
        #endif
    #endif

        _Weed_eatr( RegName );

        

        if( ( (PCLIPSYMBOL) pFiveDos->pSymbol )->pFunc == (PCLIPFUNC) pExePassWord() ||
            _bcmp( pFiveDos->cName + 2, szLibNum(), 8 ) == 0 )
            ( (PCLIPSYMBOL) pRegName->pSymbol )->pFunc = (PCLIPFUNC) _ExeLiberado;

        // Registra la funcion.
        hEventHandler = _evRegReceiverFunc( (EVENTFUNCP) EventHandler, 0x6001 );

    }
    // Redirecciona Alert() a nMsgAlert()
    ( (PCLIPSYMBOL) pAlert->pSymbol )->pFunc = (PCLIPFUNC) nMsgAlert;
}

//---------------------------------------------------------------------------//

void MouseInit( BYTE bNormalMouse )
{
   // WORD wScreenHeigth = (WORD) * ( BaseSegment() + 0x484 );
   // WORD wScreenWidth  = (WORD) * ( BaseSegment() + 0x44A );
   WORD wScreenHeigth = wScrMaxRow() + 1;
   WORD wScreenWidth  = wScrMaxCol() + 1;

   WORD wHorRes, wVerRes;

   bEga        = bIsEga() && ! bNormalMouse;
   bInit       = TRUE;
   bOffs       = 0;
   wLineWidth  = wScreenWidth * 2;
   wScreenSize = wLineWidth * wScreenHeigth;
   bCharHeigth = bCharScanLines();

   wHorRes = ( wScreenWidth - 1 ) * 8 * 9;
   wVerRes = ( wScreenHeigth * 8 * bCharHeigth ) - bCharHeigth; //  + 50;  // 8

   _AX = 0;
   asm int 0x33;
   bInstaled = _AX != 0;

   if( bInstaled && bEga )
   {
      _AX = 0xF;
      _CX = 1;                    // Horizontal sensibility
      _DX = 1;                    // Vertical sensibility
      asm int 0x33;

      _CX =   0;                  // Defines Horizontal resolution
      _DX = wHorRes;
      _AX = 7;
      asm int 0x33;

      _CX =   0;                  // Defines Vertical resolution
      _DX = wVerRes;
      _AX = 8;
      asm int 0x33;

      _ES = FP_SEG( MouseCallBack );
      _DX = FP_OFF( MouseCallBack );
      _CX = 0x7F;                 // When moves, Button Pressed or Button Released
      _AX = 0x000C;               // Event handler
      asm int 0x33;
   }
   ProtIni();
   FDosLinkDbg();

}


//----------------------------------------------------------------------------

void MouseOn( BYTE bSelCursor )
{
   

   bCursor = IF( bSelCursor > 0 && bSelCursor < 8 , bSelCursor - 1, bCursor );

   if( ! bInit )
      MouseInit( 0 );

   if( ! bInstaled )
      return;

   if( ! bWorking )
   {
      bWorking = TRUE;

      if( ! bOnOff )
      {
         bOffs = bOffs ? ( bOffs - 1 ): 0;

         if( ! bOffs )
         {
            bOnOff = TRUE;

            if( bEga )
            {
               WORD  wButton;
               WORD  wRow   ;
               WORD  wCol   ;
               _AX = 3;
               asm int 0x33;
               wButton  = _BX;
               wRow     = _DX;
               wCol     = _CX;
               wNewRow    = wRow;
               wNewCol    = wCol;
               wNewButton = wButton;

               CursorMix( wNewRow, wNewCol, 0, TextVideo(), FALSE );

            }
            else
            {
               _AX = 0x0001;
               asm int 0x33;
            }
         }
      }
      

      bWorking = FALSE;
   }
}

//---------------------------------------------------------------------------//

// Deja el Flag Working puesto.....

void SetMouseData( LPBYTE bScrImage )
{
   if( ! bInit )
      MouseInit( 0 );

   if( ! bInstaled )
      return;

   while( bWorking );

   bWorking = TRUE;

   if( bEga && bOnOff )
   {
       _AX = 3;
       asm int 0x33;
                // Row, Col
       CursorMix( _DX, _CX, 0, bScrImage, FALSE );

   }
}

//---------------------------------------------------------------------------//

void MouseRelease( void )
{
    if( bWorking );
        bWorking = FALSE;

    if( ++wFlashCount > wLineWidth * 5 ) // bCharHeigth * 48 )
        _evSendId( EVE_PROT, hEventHandler );
}

//---------------------------------------------------------------------------//

void MouseOff( void )
{
   LPBYTE pVideo = TextVideo();

   if( ! bInstaled )
      return;

   while( bWorking );

   bWorking = TRUE;
   if( bOnOff )
   {
      bOnOff = FALSE;

      if( bEga )
      {
         LPBYTE pMText = pVideo + ( wRowOld * wLineWidth ) + ( wColOld * 2 );

         pMText[ 0 ] = Back[ 0 ];
         pMText[ 2 ] = Back[ 1 ];
         pMText[ 4 ] = Back[ 2 ];
         pMText +=  wLineWidth;
         pMText[ 0 ] = Back[ 3 ];
         pMText[ 2 ] = Back[ 4 ];
         pMText[ 4 ] = Back[ 5 ];
      }
      else
      {
         _AX = 2;
         asm int 0x33;
      }
      

   }
   bOffs++;
   bWorking = FALSE;
}

//---------------------------------------------------------------------------//

void SetDbgActive( BOOL bDbgOn )
{
    if( bDbgOn )
    {
        MouseOff();
        // Redirecciona nMsgAlert() a Alert()
        ( (PCLIPSYMBOL) pAlert->pSymbol )->pFunc = (PCLIPFUNC) Alert;
        if( bProteccting )
            __QUIT();
    }
    else
    {
        MouseOn( 0 );
        // Redirecciona Alert() a nMsgAlert()
        ( (PCLIPSYMBOL) pAlert->pSymbol )->pFunc = (PCLIPFUNC) nMsgAlert;
    }
}

//---------------------------------------------------------------------------//

BYTE bMouseRow() { return bRow; }
BYTE bMouseCol() { return bCol; }

//---------------------------------------------------------------------------//

void MouseUpdate()  // Actualiza los valores del rat¢n
{
   WORD  wFlags = _FLAGS;

   if( ! bInstaled )
      return;

   while( bWorking );

   if( _FLAGS & INTERRUPT_FLAG )
        disable();

   bWorking = TRUE;

   if( bEga )
   {
      bRow = ( wNewRow ) / ( bCharHeigth * 8 );
      bCol = ( wNewCol + 06 ) / ( 9 * 8 );
   }
   else
   {
      bRow = ( wNewRow ) / 8;
      bCol = ( wNewCol ) / 8;
   }

   bLeft   = wNewButton & 1;
   bRight  = wNewButton & 2;
   bCenter = wNewButton & 4;

   bW                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         