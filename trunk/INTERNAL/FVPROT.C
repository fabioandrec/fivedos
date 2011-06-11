
#include <ClipApi.h>
#include <dos.h>

typedef struct
{
    DWORD edi, esi, ebp, reserved, ebx, edx, ecx, eax;
    WORD  flags, es, ds, fs, gs, ip, cs, sp, ss;
} REALMODEINT;

extern DWORD DosLowAlloc( WORD wBytes );
extern void DosLowFree( DWORD SelSeg );
extern BOOL RealModeInt( WORD wIntNo, REALMODEINT * pReal );
extern BOOL bIsExtendedExe( void );




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

BYTE ReadPartSec( BYTE LaUnidad, BYTE Head, WORD SekZyl, void * Buf )

{
    if( bIsExtendedExe() )
    {
        REALMODEINT sInt;

        sInt.eax = 0x00000201;
        asm mov dl, LaUnidad ;
        asm mov dh, Head     ;
        sInt.edx = (LONG) _DX;
        sInt.ecx = SekZyl;
        sInt.es  = FP_OFF( Buf ); // Segmento de modo real.
        sInt.ebx = 0;

        RealModeInt( 0x0013, &sInt );

        return ! ( sInt.flags & 1 );

    }
    else
    {
        asm {
                mov ah, 0x02   ;              /* N§ func para "Read" */
                mov al, 0x01   ;              /* leer un sector      */
                mov dl, LaUnidad ;
                mov dh, Head     ;
                mov cx, SekZyl   ;
                les bx, Buf      ;
                int 0x13         ;
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
    

    if ( ReadPartSec( bUnit, 0, 1, ParSec ) )
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
            _beep_();
    }

    DosLowFree( BootData );

    return FALSE;
}

//---------------------------------------------------------------------------//

CLIPPER cBootData()
{
    void * pPart = (void*) DosLowAlloc( sizeof( PARTSEC ) );

    if( GetProtData( pPart ) )
    {
        _retclen( bIsExtendedExe() ? (LPBYTE) MK_FP( FP_SEG( pPart), 0 ) : pPart, sizeof( PARTSEC ) );
    }
    else
        _retc( "" );
}

//---------------------------------------------------------------------------//
