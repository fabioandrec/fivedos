#pragma inline

#include <dos.h>
#include <ClipApi.h>
#include <Fontdef.h>

// #define PCODEPROT

#define MOUSE_GRAPH  0
#define MOUSE_NORMAL 1

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

CLIPPER GRABALALIB( void );     // PROCLINE()
CLIPPER USERNUM( void );        // PROCNAME()
CLIPPER OPERATION( void );      // PROCFILE()

static void RegName( PCLIPNAME pSymName );

static void pascal _GrabaLaLib( void );
static void pascal _UserNum( void );
static void pascal _Operation( void );
static WORD wOperation( LPBYTE );
static void _saveregs MouseCallBack( void );
void MouseOff( void );
void MouseOn( BYTE );

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

extern BYTE bMouseCursor( void );
extern void SelectMouseCursor( BYTE bSelCursor );

typedef struct {
    BYTE Def[ 3 ][ 16 ];
    BYTE Mask[ 3 ][ 16 ];
    BYTE HotRow;
    BYTE HotCol;
} MOUSEDEF;


typedef struct
{
    WORD wRow;
    WORD wCol;
    BYTE bVer;
    BYTE bHor;
} MOUSEMIX;

//---------------------------------------------------------------------------//

static far MOUSEDEF CrsDef;

//---------------------------------------------------------------------------//

void SetMsCursorDef( MOUSEDEF far * pCursor )
{
    _bcopy( (LPBYTE) &CrsDef, (LPBYTE) pCursor, sizeof( MOUSEDEF ) );
}

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

CLIPPER nCharHeigh( void )
{
    _retni( bCharScanLines() );
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
       pM->wRow = IF( wNewRow >= CrsDef.HotRow, wNewRow - CrsDef.HotRow, 0 );
       pM->wCol = IF( wNewCol >= CrsDef.HotCol, wNewCol - CrsDef.HotCol, 0 );
   }
   else
   {
       pM->wRow = IF( wNewRow >= CrsDef.HotRow / 2, wNewRow - CrsDef.HotRow / 2, 0 );
       pM->wCol = IF( wNewCol >= CrsDef.HotCol / 2, wNewCol - CrsDef.HotCol / 2, 0 );
   }

   pM->bVer  = ( pM->wRow / 8 ) % bCharHeigth;
   pM->bHor  = ( pM->wCol / 8 ) % 9;
   pM->wRow /= ( 8 * bCharHeigth );
   pM->wCol /= ( 8 * 9 );
}

//---------------------------------------------------------------------------//

void SetChar( LPBYTE pFontDef )
{
    WORD  wFlags;

    if( bCharHeigth == 0 )
        bCharHeigth = bCharScanLines();
/*
    wFlags = _FLAGS;
    if( _FLAGS & INTERRUPT_FLAG )
        disable();
*/
    FontBegin();

    _bcopy( GraphVideo() + pFontDef[ 0 ] * 32,
            pFontDef + 1, bCharHeigth );

    FontEnd();
/*
    if( wFlags & INTERRUPT_FLAG )
        enable();
*/
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
****/
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
        _bcopy( ( LPBYTE ) Cursor, ( LPBYTE ) CrsDef.Def, 48 );
        _bcopy( ( LPBYTE ) Mask, ( LPBYTE ) CrsDef.Mask, 48 );
   }
   else
   {
       BYTE i = 0;
       for( b = 0; b < 48; b += 2, i++ )
       {
           if( ! ( i % 8 ) )
               i = b;
           *( ( (LPBYTE) Cursor ) +  i ) = *( (LPBYTE) CrsDef.Def +  b );
           *( ( (LPBYTE) Mask ) + i )    = *( (LPBYTE) CrsDef.Mask + b );
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

   // if( !( pOld == 0 ) )
   if( pOld )
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

   WORD  wFlags = _FLAGS;               // Save flags register: interrupt flag
                                        // ExoSpace mouse support don't clear
   if( _FLAGS & INTERRUPT_FLAG )        // interrupt flag when running under DOS.
       disable();                       // Disable interupts

   if( ! bWorking )
   {
        bWorking = TRUE;
   
        wButton  = _BX;
        wRow     = _DX;
        wCol     = _CX;
        iMickHor = _SI;
        iMickVer = _DI;
        wNewRow    = wRow;
        wNewCol    = wCol;
        wNewButton = wButton;


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
   
    SelectMouseCursor( bSelCursor );

    if( ! bInit )
        MouseInit( MOUSE_NORMAL );

    if( ! bInstaled )
        return;


    if( ! bOnOff )
    {

        bOffs = bOffs ? ( bOffs - 1 ): 0;

        if( ! bOffs )
        {
            bOnOff = TRUE;

            if( bEga )
            {
               if( ! bWorking )
               {
                   WORD  wButton;
                   WORD  wRow   ;
                   WORD  wCol   ;

                   bWorking = TRUE;

                   _AX = 3;
                   asm int 0x33;
                   wButton  = _BX;
                   wRow     = _DX;
                   wCol     = _CX;
                   wNewRow    = wRow;
                   wNewCol    = wCol;
                   wNewButton = wButton;

                   CursorMix( wNewRow, wNewCol, 0, TextVideo(), FALSE );
                   bWorking = FALSE;
               }
            }
            else
            {
               _AX = 0x0001;
               asm int 0x33;
            }
        }
    }
}

//---------------------------------------------------------------------------//

// Deja el Flag Working puesto.....

void SetMouseData( LPBYTE bScrImage )
{
   if( ! bInit )
      MouseInit( MOUSE_NORMAL );

   if( ! bInstaled )
      return;

   while( bWorking );

   bWorking = TRUE;

   if( bOnOff )
   {

        if( bEga )
        {
            _AX = 3;
            asm int 0x33;

                        // Row, Col
            CursorMix( _DX, _CX, 0, bScrImage, FALSE );
        }
        else
        {
            bWorking = FALSE;
            MouseOff();
        }
   }
}

//---------------------------------------------------------------------------//

void MouseRelease( BOOL bSendId )
{
    if( bWorking );
        bWorking = FALSE;

    if( !bOnOff && !bEga )
        MouseOn( 1 );

    if( ++wFlashCount > wLineWidth * 5 && bSendId ) // bCharHeigth * 48 )
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
   WORD  wFlags;

   if( ! bInstaled )
      return;

   while( bWorking );
   bWorking = TRUE;
/*
   wFlags = _FLAGS;
   if( _FLAGS & INTERRUPT_FLAG )
       disable();
*/

   if( bEga )
   {
      bRow = ( wNewRow ) / ( bCharHeigth * 8 );
      bCol = ( wNewCol + 06 ) / ( 9 * 8 );
   }
   else
   {
      _AX = 3;
      asm int 0x33;
      wNewRow    = _DX;
      wNewCol    = _CX;
      wNewButton = _BX;

      bRow = ( wNewRow ) / 8;
      bCol = ( wNewCol ) / 8;
   }

   bLeft   = wNewButton & 1;
   bRight  = wNewButton & 2;
   bCenter = wNewButton & 4;

   bWorking = FALSE;
/*
   if( wFlags & INTERRUPT_FLAG )
       enable();
*/
}

//---------------------------------------------------------------------------//

BOOL bMouseLeft( void )    { return bLeft; }
BOOL bMouseRight( void )   { return bRight; }
BOOL bMouseCenter( void )  { return bCenter; }
BOOL bMousePressed( void ) { return ( bLeft || bRight || bCenter ); }

// ----------------------------------------------------------------------------

void MouseKeyLeft( WORD wKey )   { wKLeft   = wKey; }
void MouseKeyCenter( WORD wKey ) { wKCenter = wKey; }
void MouseKeyRight( WORD wKey )  { wKRight  = wKey; }

// ----------------------------------------------------------------------------

void MouseChars( LPBYTE szMouseChars )
{
  _bcopy( bChars, szMouseChars, 6 );
}

//----------------------------------------------------------------------------//

void MouseSetArea( WORD wTop, WORD wLeft, WORD wBottom, WORD wRight )
{
    if( bInstaled )
    {
        wTop    *= bCharHeigth * 8;
        wLeft   *=  9 * 8;
        wBottom *= bCharHeigth * 8;
        wRight  *=  9 * 8;

       _AX = 8;
       _CX = wTop;
       _DX = wBottom;
       asm int 0x33;

       _AX = 7;
       _CX = wLeft;
       _DX = wRight;
       asm int 0x33;
    }
}

//----------------------------------------------------------------------------//

void MouseSetCursor( WORD wCursor )
{
   if( ( wCursor - 1 ) != bMouseCursor() )
   {
        if( bOnOff )
        {
            MouseOff();
            MouseOn( wCursor );
        }
        else
            SelectMouseCursor( wCursor );

   }
}

//----------------------------------------------------------------------------//

void MouseSetPos( WORD wRow, WORD wCol )
{
   WORD wGrafRow, wGrafCol;

   if( bEga )
   {
        wGrafRow = wRow * bCharHeigth * 8;
        wGrafCol = wCol * 9 * 8;
        _DX = wGrafRow;
        _CX = wGrafCol;
   }
   else
   {
        _DX = wRow;
        _CX = wCol;
   }
   _AX = 4;
   asm int 0x33;
}

//----------------------------------------------------------------------------//

/*****************************************************************************
*
*   RUN TIME PROTECTION
*
*****************************************************************************/

//---------------------------------------------------------------------------//

static void RegName( PCLIPNAME pSymName )
{
    if( pSymName )
    {
        PCLIPSYMBOL pSym = (PCLIPSYMBOL) ( pSymName->pSymbol );

        if( pSym && pSymName->cType == 0 )
        {

            if( !pRegName && pSym->pFunc == (PCLIPFUNC) __APPINIT )
            {
                pRegName = pSymName;
            }

            else
            if( !pGrabaLib && pSym->pFunc == (PCLIPFUNC) GRABALALIB )
            {
                pGrabaLib = pSymName;
            }

            else
            if( !pUserNum && pSym->pFunc == (PCLIPFUNC)  USERNUM )
            {
                pUserNum  = pSymName;
            }

            else
            if( !pOperation && pSym->pFunc == (PCLIPFUNC) OPERATION )
            {
                pOperation  = pSymName;
            }

            else
            if( !pAlert && pSym->pFunc == (PCLIPFUNC)  Alert )
            {
                pAlert  = pSymName;
            }

            else
            if( !pFiveDos && _bcmp( sFiveSymName, pSymName->cName, 12 ) == 0 )
            {
                pFiveDos  = pSymName;
            }

        }
    }

}

//---------------------------------------------------------------------------//

static void * pExePassWord( void )
{
    return MK_FP( wCRC( pFiveDos->cName, 8 ),
                  wCRC( szPassWord( pFiveDos->cName ), 8 ) );
}

//---------------------------------------------------------------------------//

CLIPPER RegisterEx()
{
   PCLIPFUNC pTemp;
   if( ! bInit )
      MouseInit( MOUSE_NORMAL );
   pTemp = ( (PCLIPSYMBOL) pRegName->pSymbol )->pFunc;
   ( (PCLIPSYMBOL) pRegName->pSymbol )->pFunc = __APPINIT;
   
   Register();
   ( (PCLIPSYMBOL) pRegName->pSymbol )->pFunc = pTemp;
}

//---------------------------------------------------------------------------//

static WORD near Register( void )
{
    
    if( !bProteccting  &&  _vmStat( 1 ) > 32 )
    {

#ifdef REGISTERCRC
       /*******
        if( GetRegCRC( (LPBYTE) __APPINIT ) != REGISTERCRC )
        {
            // Nos han sobrescrito la caja de Dialogo de registro.
            // Podriamos tambien meter un error de protecci¢n general,
            // que puede asustar mas y ser mas dificil de localizar.
            __QUIT();  // ­ A joderse tocan !
        }
       ********/
#endif
           ( (PCLIPSYMBOL) pGrabaLib->pSymbol )->pFunc  = _GrabaLaLib;
           ( (PCLIPSYMBOL) pUserNum->pSymbol )->pFunc   = _UserNum;
           ( (PCLIPSYMBOL) pOperation->pSymbol )->pFunc = _Operation;

           bProteccting = TRUE;
           bUserNumCalled = FALSE;

           _PutSym( (PCLIPSYMBOL) pRegName->pSymbol );
           ( ++_tos )->wType = 0;
           _xDo( 0 );

           bProteccting = FALSE;

           ( (PCLIPSYMBOL) pGrabaLib->pSymbol )->pFunc  = GRABALALIB; // PROCLINE
           ( (PCLIPSYMBOL) pUserNum->pSymbol )->pFunc   = USERNUM;    // PROCNAME
           ( (PCLIPSYMBOL) pOperation->pSymbol )->pFunc = OPERATION;  // PROCFILE

           if( !bUserNumCalled && !( ( (PCLIPSYMBOL) pRegName->pSymbol )->pFunc  == _ExeLiberado ) )
           {
              __QUIT();
           }

        return 0;
    }
    else
        return 358;
}

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//

static LPBYTE near u2Hex( WORD wWord )
{
    
    WORD i= 3;
    
    do
    {
        sNumber[ i ] = 48 + ( wWord & 0x000F );

        if( sNumber[ i ] > 57 )
            sNumber[ i ] += 7;

        wWord >>= 4;

    } while( i-- > 0 );

    sNumber[ 4 ] = 0;

    return sNumber;

}

//---------------------------------------------------------------------------//

/**********************************************************************/
/* ReadPartSec : Lee un sector de partici¢n del disco duro a          */
/*               un buffer                                            */
/* Entrada: - Unidad : C¢digo BIOS de la unidad (0x80, 0x81 etc.)     */
/*- Head     : N£mero del cabezal de lectura/escritura----------------*/
/*- SekZyl   : N§ de sector y cilindro en formato BIOS----------------*/
/*- Buf      : buffer, en el que se carga el primer sector------------*/
/* Salida : TRUE, si se pudo leer el sector sin problemas             */
/* sino FALSE                                                         */
/**********************************************************************/

static BYTE near ReadPartSec( BYTE bDiskUnit, BYTE Head, WORD SekZyl, void * Buf )

{
    if( bIsExtendedExe() )
    {
        REALMODEINT sInt;

        sInt.eax = 0x00000201 ;    // Leer UN sector
        asm mov dl, bDiskUnit ;
        asm mov dh, Head      ;
        sInt.edx = (LONG) _DX ;
        sInt.ecx = SekZyl     ;
        sInt.es  = FP_OFF( Buf ); // Segmento de modo real.
        sInt.ebx = 0          ;

        RealModeInt( 0x0013, &sInt );

        return ! ( sInt.flags & 1 );

    }
    else
    {
        asm {
                mov ah, 0x02      ;              /* N§ func para "Read" */
                mov al, 0x01      ;              /* leer un sector      */
                mov dl, bDiskUnit ;
                mov dh, Head      ;
                mov cx, SekZyl    ;
                les bx, Buf       ;
                int 0x13          ;
            }
        return ! ( _FLAGS & 1 );
    }
}

//---------------------------------------------------------------------------//

#define BOOTSIZE 512

typedef struct
{
    BYTE VarData1[ 16 ];    // Datos variables de un Sistema operativo a otro
    BYTE FixData[ 21 ];     // Datos fijos. Propios del disco duro de la m quina
    WORD VarData2;          // Datos variables de un Sistema operativo a otro
    DWORD NumSer;           // Datos fijos. Propios del disco duro de la m quina
    BYTE BootPrg[ BOOTSIZE - ( 16 + 21 + 2 + 4 ) ]; // El programa de arranque
                            // del Sistema Operativo. O mejor dicho: el que
                            // llama al programa de arranque del S.O.
} BOOTDATA;

//---------------------------------------------------------------------------//

static BOOL near GetProtData( void * ParSec ) // ()
{

    BYTE       bUnit = 0x80;             // Disco C
    SECPOS     Sector0;
    DWORD      BootData = DosLowAlloc( sizeof( BOOTDATA) );
    

    if ( BootData && ReadPartSec( bUnit, 0, 1, ParSec ) )
    {
        PARSPTR pPart = bIsExtendedExe() ? (PARSPTR) MK_FP( FP_SEG( ParSec), 0 ) : ParSec;
        BOOTDATA * pBoot = bIsExtendedExe() ? (BOOTDATA*) MK_FP( FP_SEG( (void*) BootData ), 0 ) : (BOOTDATA*) BootData;

        Sector0.SecZyl  = pPart->PartTable[ 0 ].StartSec.SecZyl;
        Sector0.Head    = pPart->PartTable[ 0 ].StartSec.Head;

        if( ReadPartSec( bUnit, Sector0.Head, Sector0.SecZyl, (PARSPTR) BootData ) )
        {
            _bcopy( pPart->DataPlus, pBoot->FixData, 21 );
            _bcopy( pPart->DataPlus + 21, (LPBYTE) ( &pBoot->NumSer ), 4 );

            DosLowFree( BootData );
            return TRUE;
        }
        else
        {
            DosLowFree( BootData );
            _beep_();
        }
    }

    DosLowFree( BootData );

    return FALSE;
}

//---------------------------------------------------------------------------//

static LPBYTE near szLibNum( void )
{

    void * pPart = (void*) DosLowAlloc( sizeof( PARTSEC ) );

    if( pPart && GetProtData( pPart ) )
    {
        LPBYTE pProtData = (LPBYTE) ( bIsExtendedExe() ? MK_FP( FP_SEG( pPart), 0 ) : pPart );

        _bcopy( sLibNum,
                (LPBYTE) u2Hex( wCRC( pProtData, 512 ) ),
                4 );

        _bcopy( sLibNum + 4,
                (LPBYTE) u2Hex( wCRC( ( (PARSPTR) pProtData )->DataPlus, 25 ) ),
                4 );

        sLibNum[ 8 ] = 0;
    }

    DosLowFree( (DWORD) pPart );

    return sLibNum;

}

//---------------------------------------------------------------------------//

static LPBYTE near szUserNum( LPBYTE szLibraryNum )
{
    int i;
    for( i = 0; i < 8; i++ )
        szLibraryNum[ i ] = szLibraryNum[ i ] + 17 + i % 3;


    szLibraryNum[ 8 ] = 0;
    bUserNumCalled = TRUE;

    return szLibraryNum;

}


//---------------------------------------------------------------------------//

static int wBuffScan( LPSTR buf, WORD wLen, LPSTR pStr, WORD wStrLen )
{
    int i = 0;

    while( i < wLen )
    {
         i = i + _bscan( buf + i, wLen - i, pStr[ 0 ] );

         if( i < wLen && _bcmp( buf + i, pStr, wStrLen ) == 0 )
         {
             return i;
         }
         i++;
    }

    return -1;
}

//---------------------------------------------------------------------------//

#define BUFF_LEN  4096  // OJO, entero con signo.

static LONG buscar( int fn, LPSTR szMARK, int iLen )
{
      int i, r;
      char * buf;
      long pos = 0L;
      
      buf = _xgrab( BUFF_LEN );

      if (fn != -1)
      {
         while( ( r = _tread( fn, buf, BUFF_LEN ) ) >= iLen )
         {
              i = wBuffScan( buf, r,  szMARK, iLen );

              if( i != -1 )
              {
                  _xfree( buf );
                  return pos + i;
              }

              if( r < BUFF_LEN )
              {
                  _xfree( buf );
                  return 0L;
              }

              pos += BUFF_LEN - iLen;
              _tlseek( fn, - iLen, 1 );
         }
      }

      _xfree( buf );

      return (0L);
}

//---------------------------------------------------------------------------//

static LPBYTE near szPassWord( LPBYTE szUserNumber )
{
    _bcopy( szPassword, szUserNumber, 8 );

    _bcopy( szPassword,     u2Hex( wCRC( szPassword    , 4 ) ), 4 );
    _bcopy( szPassword + 4, u2Hex( wCRC( szPassword + 4, 4 ) ), 4 );

    return szPassword;
}

//---------------------------------------------------------------------------//

static PCLIPSYMBOL RegLibSymbol( LPBYTE pBuffer )
{
    pBuffer[ 0 ] = '_';
    pBuffer[ 1 ] = '_';
    _bcopy( pBuffer + 2, szLibNum(), 9 );
    pBuffer[ 11 ] = 0;
    return _Chk_Sym( pBuffer );

}

//---------------------------------------------------------------------------//

static CLIPPER _GrabaLaLib()  // ( cFile, cPassword  )
{
     int  h, g;
     LONG  dnd             = 0L;
     BYTE sTemp[ 12 ];
     void * ExePassWord;
     WORD wOper          = wOperation( sTemp );
     WORD wHeader;

     if( wOper == 1 )  //
     {
        /* OJO con esto
        MessageBox( ( hWndApp ? GetActiveWindow() : 0 ),
                    _parc( 1 ), _parc( 2 ), MB_ICONEXCLAMATION );
        */
        /*
        _PutSym( (PCLIPSYMBOL) pAlert->pSymbol );
        ( ++_tos )->wType = 0;
        _PutC( _parc( 1 ) );
        _PutC( _parc( 2 ) );
        _xDo( 2 );
        */
        MsgAlert();
        __QUIT();
     }
     else  // RegLib o RegExe
     {
        if( !_parc( 1 ) || !_parc( 2 ) )
            return;

        if( _bcmp( (LPBYTE) szPassWord( szUserNum( szLibNum() ) ), _parc( 2 ), 8 ) != 0 )
        {
            _retni( ERRPASSW );
            return;
        }

        h = _topen( _parc( 1 ), 2 );

        if( h == -1 )
        {
            _retni( NOOPEN );
            return;
        }

        _tlseek( h, dnd, 0 );

        if( wOper == 2 ) // Este exe es de una lib registrada en esta m quina
        {                // Liberamos un exe.

            _tread( h, ( LPBYTE ) &wHeader, 2 );
            if( wHeader != 0x5A4D )       // esto NO es un EXE
            {
               _retni( NOBUSCA );
               _tclose( h );
               return;
            }

            _tlseek( h, dnd, 0 );
            dnd = buscar( h, sTemp, 12 );

            if( dnd == 0L ) // el exe a liberar no es de una lib registrada.
            {
                _retni( NOBUSCA );
            }
            else
            {
                ExePassWord = pExePassWord();

                _tlseek( h, dnd + 12, 0 );
                _twrite( h, (LPBYTE) &ExePassWord, 4 );
                _retni( 0 );

            }

        }
        else
        {   // Liberamos la Lib.

            dnd = buscar( h, sFiveSymName, 12 );
            if( dnd == 0L )
            {
                _retni( NOBUSCA );
            }
            else
            {
                do
                {
                    _tlseek( h, dnd, 0 );
                    // sTemp contiene la cadena del numero de LIB con "__" delante.
                    _twrite( h, sTemp, 11 );
                    _tlseek( h, 0, 0 );
                    dnd = buscar( h, sFiveSymName, 12 );
                } while( !( dnd == 0L ) );

                // SOLO EN MEMORIA EN ESTA EJECUCION. Para dar buen "feeling"
                ( (PCLIPSYMBOL) pRegName->pSymbol )->pFunc = _ExeLiberado;
                _retni( 0 );
            }
        }

        _tclose( h );

     }
}

//---------------------------------------------------------------------------//

static CLIPPER _UserNum()
{
    _retclen( szUserNum( szLibNum() ), 8 );
}

//---------------------------------------------------------------------------//

static WORD wOperation( LPBYTE pName )
{
    PCLIPSYMBOL pSym = RegLibSymbol( pName );

    return pFiveDos->cName[ 7 ] == 'O' ? 0 : ( pSym == 0 ? 1 : 2 );
}

//---------------------------------------------------------------------------//

static CLIPPER _Operation() // si 0 Registrar Lib,
{                           // si 1 Exe de Lib registrada en m quina ajena.
                            // si 2 Registrar un exe.
                            // SI > 2 La caja de registrar terminar  la app.
    BYTE sTemp[ 12 ];
#ifdef REGISTERCRC
    if( wCRC( _parc( 1 ), _parclen( 1 ) ) == REGISTERCRC )
        _retnl( wOperation( sTemp ) );
    else
    {
        _retnl( 7573 );
        pRegName->pSymbol = (LPBYTE) __QUIT;
    }

#else
    _retnl( wOperation( sTemp ) );
#endif
}

//---------------------------------------------------------------------------//

#ifndef REGISTERCRC

CLIPPER GETREGCRC()
{
    // _retnl( GetRegCRC( (LPBYTE) __APPINIT ) );
    _retnl( wCRC( _parc( 1 ), _parclen( 1 ) )  );
}

#endif

//---------------------------------------------------------------------------//

#ifndef REGISTERCRC

CLIPPER GETPASSWORD()
{
    _retclen( szPassWord( szUserNum( szLibNum() ) ), 8 );
}

#endif

//---------------------------------------------------------------------------//

#ifndef REGISTERCRC

CLIPPER GETLIBNUM()
{
    _retclen( szLibNum(), 8 );
}

#endif

//---------------------------------------------------------------------------//
#ifdef PCODEPROT
static void near AppInitPatch( LPBYTE DestCode )
{
   WORD  selCode = FP_SEG( DestCode );
   WORD  selData;
   LPBYTE pByte;

   selData = CreateDSAlias( selCode );
   pByte   = (LPBYTE) MK_FP( selData, FP_OFF( DestCode ) );  // pCode __AppInit

   pByte[ 0 ] = 0x28;
   pByte[ 1 ] = 0x00;
   pByte[ 2 ] = 0x11;
   pByte[ 3 ] = 0x01;

   // FreeSelector( selData );

}
#endif
//---------------------------------------------------------------------------//
