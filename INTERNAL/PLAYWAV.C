// -------------------------------------------------------------------------- //
// Reproduce un fichero Wav en el altavoz del pc.
// -------------------------------------------------------------------------- //

#include <StdIo.h>
#include <Alloc.h>
#include <ConIo.h>
#include <Dos.h>
#include <Bios.h>

typedef unsigned long DWord;
typedef unsigned char Byte;
typedef unsigned int  Word;

typedef struct
{
 	DWord Riff;
    DWord Len;
    DWord Wave;
    DWord Fmt;
    DWord FmtLen;
    Word  FormatTag;
    Word  nChannels;
    DWord nSamples;
    DWord nBytes;
    Word  nBlockAlign;
    Word  nBits;
    DWord Data;
    DWord DatLen;
} WavHead;

void interrupt ( * OldInt8 )( void );
static Word        OldInt8CountMax;
static char far *  BufData;
static DWord       CountData;
static DWord       CountDataMax;
static Byte        Volume;

// -------------------------------------------------------------------------- //
static void near SetTimerFreq( DWord Freq )
{
    Word Rate = 1193182 / Freq;
    outportb( 0x43, 0x36 );
    outportb( 0x40, Rate & 0xFF );
    outportb( 0x40, Rate >> 8 );
    OldInt8CountMax = Freq / 18;
}

// -------------------------------------------------------------------------- //

void interrupt Int8Handler( void )
{
    static Word OldInt8Count = 0;

    if( CountData <= CountDataMax )
    {
        outportb( 0x42, BufData[ CountData++ ] >> Volume );
    }

    if( ++OldInt8Count >= OldInt8CountMax )
    {
        OldInt8Count = 0;
        OldInt8();
    }
    else
    {
        outportb( 0x20, 0x20 );
    }
}

// -------------------------------------------------------------------------- //
void InitSpeaker( DWord Freq, DWord Count )
{
	if( BufData )
    {
        disable();
    	OldInt8 = getvect( 0x08 );
    	setvect( 0x08, Int8Handler );
        SetTimerFreq( Freq );

        outportb( 0x43, 0xB0 );
        outportb( 0x42, 0 );
        outportb( 0x42, 0 );

        outportb( 0x43, 0x90 );
        outportb( 0x61, inportb( 0x61 ) | 0x03 );
        if( Freq <= 11025 )
        {
        	Volume = 1;
        }
        else if( Freq <=  22050 )
        {
        	Volume = 2;
        }
        else
        {
			Volume = 4;
        }
    	CountData =  0;
        CountDataMax = Count;
        enable();
    }
}

// -------------------------------------------------------------------------- //
void DoneSpeaker( void )
{
	disable();
	setvect( 0x08, OldInt8 );
    outportb( 0x43, 0x36 );
    outportb( 0x40, 0 );
    outportb( 0x40, 0 );
    outportb( 0x61, inportb( 0x61 ) & 0xFC );
    enable();
}

// -------------------------------------------------------------------------- //
void main( void )
{
	FILE * Fich;
    WavHead Header;
    DWord Pos;
    Byte * pBuf;
    if( ( Fich = fopen( "RECORD.WAV", "rb" ) ) != NULL )
	{
 		if( fread( &Header, 1, sizeof( WavHead ), Fich ) )
        {
            if( Header.Riff == 0x46464952 )             // 'FFIR'
            {
                if( Header.Wave == 0x45564157  )        // 'EVAW'
                {
                    if( Header.Fmt == 0x20746D66 ) //             // ' tmf'
                    {
                        printf( "El fichero es: \n"
                                "Tipo    : %02d \n"
                                "Canales : %02d \n"
                                "Samples : %010d \n"
                                "Bytes   : %010d \n"
                                "Alineam.: %010d \n"
                                "Bits    : %010d \n"
                                "Longit. : %010ld \n",
                                Header.FormatTag,
                                Header.nChannels,
                                Header.nSamples,
                                Header.nBlockAlign,
                                Header.nBits,
								Header.DatLen );

                        if( Header.DatLen )
                        {
                            BufData = farmalloc( Header.DatLen );
                            if( BufData )
                            {
                                //fread( BufData, 1, Header.DatLen, Fich );
                                Pos = Header.DatLen - 1;
                                pBuf = BufData;
                                while( Pos > 0xFFFE )
                                {
                                    fread( pBuf, 1, 0xFFFE, Fich );
                                    pBuf += 0xFFFE;
                                    Pos  -= 0xFFFE;
                                }
                                if( Pos )
                                {
                                	fread( pBuf, 1, Pos, Fich );
                                }

                                InitSpeaker( Header.nBytes, Header.DatLen );

                                while( CountData <= CountDataMax && !bioskey( 1 ) )
									printf( "Ejecutados %010lu\r", CountData );

                                DoneSpeaker();
                                farfree( BufData );
                            }
                            else
                            {
                                printf( "Error al asignar memoria.\n" );
                            }
                        }
                    }
                    else
                    {
                        printf( "No se ha hallado el formato del fichero.\n" );
                    }
                }
                else
                {
                    printf( "El fichero no es un Wav.\n" );
                }
            }
            else
            {
            	printf( "El fichero no es un RIFF.\n" );
            }
        }
        else
        {
        	printf( "Error leyendo datos del fichero.\n" );
        }
        fclose( Fich );
	}
	else
	{
    	printf( "Error en apertura del fichero.\n" );
	}
}

// -------------------------------------------------------------------------- //
