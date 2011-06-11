#include <ClipApi.h>
#include <Dos.h>

// Ejecuta WAVs por el altavoz del PC

extern WORD _bcmp( LPBYTE, LPBYTE, WORD );
extern void sound( WORD wFrec );
extern void soundOn( void );
extern void soundOff( void );

extern void Delay( WORD );
extern void MicroDelay( WORD );

typedef struct
{
    BYTE    riff[ 4 ];  // la marca "RIFF"
    LONG    lTotBytes;  // n§ total de bytes
    char    WAVE[8];    // "WAVEfmt"
    LONG    lDummy;     //
    int     iFormat;    // Suele ser 1: PCM
    WORD    wCanals;    // 1:Mono, 2:Stereo
    LONG    lFrec;      // frecuencia de muestreo
    LONG    lBytesSeg;  // bytes por segundo ( = frec si 8 bits )
    int     iAling;     // bytes por dato
    int     iBitSample; // bits por muestra
    BYTE    DataSec[];  // secuencia de muestras
} WAV;

//---------------------------------------------------------------------------//

void ExecWAV( WAV *v, WORD wWavLen )
{
    WORD wDelay;
    WORD i = 12, j;
    int  iSamp;

    if( _bcmp( v->riff, "RIFF", 4 ) )
        return;

    wDelay = 88 / (WORD) ( (WORD) v->lFrec / (WORD) 1000 );

    // disable();

    while ( i < wWavLen - sizeof( WAV ) )
    {
        for ( j = 0; j < 8; j++ )
        {

            iSamp = 0;
            if (v->iBitSample == 8 )
            {
                if( v->DataSec[ i ] > 128 )
                    iSamp = (int) v->DataSec[ i ];
            }
            else
            {
                if( ( *( WORD* ) ( v->DataSec + i ) ) > 32768 )
                    iSamp = *( int* ) ( v->DataSec + i );
            }


            if( iSamp > 0 )
                sound( iSamp );
            else
                soundOff();

            MicroDelay( wDelay );

            i += v->iAling;
        }

    }
    soundOff();

    // enable();
}

//---------------------------------------------------------------------------//

CLIPPER PlayPCWav( void ) // cWav, nRetardo
{
   ExecWAV( (WAV*) _parc( 1 ), _parclen( 1 ) );
}

//---------------------------------------------------------------------------//
