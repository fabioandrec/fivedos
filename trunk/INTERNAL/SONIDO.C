#include <ClipApi.h>

//---------------------------------------------------------------------------//

void soundOn( void ) // Simplemente activa el zumbador
{
    asm {
            in al, 0061h;       // toma los valores del puerto.
            or al, 2;           // activa el altavoz
            out 0061h, al;      // pone nuevos valores en el puerto.
        }
}

//---------------------------------------------------------------------------//

void sound( unsigned int uiFreq )
{
    asm {
            mov cx, uiFreq;

            mov dx, 12h;        // Parte Alta del numerito.
            mov ax, 34deh;      // Parte Baja del num,erito.
            div cx;             // Divide la frecuancia especificada por
                                // 1.193.182 hz ( la frecuencia utilizada
                                // por el reloj del timer ).
            mov cx,ax;          // Ele resultadoi en ax

            mov al, cl;         // el byte bajo para el timer
            out 0042h, al;
            mov al, ch;         // el byte alto para el timer
            out 0042h, al;

            in al, 0061h;       // toma los valores del puerto.
            or al, 3;           // activa el altavoz y el timer
            out 0061h, al;      // pone nuevos valores en el puerto.
        }

}

//---------------------------------------------------------------------------//

void soundOff( void )
{
   asm {
            in al, 0061h;       // get toma el contenido del puerto.
            and al, 11111100b   // apaga el altavoz y el timer.
            out 0061h, al;      // pone los nuevos valores en el puerto.
       }
}

//---------------------------------------------------------------------------//

CLIPPER SOUND( void )
{
 unsigned int uiFreq;
 if( _pcount >= 1 )
     uiFreq = _parni( 1 );  // frecuencias audibles. > 30 Hz.
 else
     uiFreq = 31;
 uiFreq = ( uiFreq > 31 ? uiFreq : 31 );
 sound( uiFreq );
}

//---------------------------------------------------------------------------//

CLIPPER SOUNDOFF()
{
   soundOff();
}

//---------------------------------------------------------------------------//

CLIPPER BEEP( void )
{
    _beep_();
}

//---------------------------------------------------------------------------//

CLIPPER MessageBee( void )
{
    _beep_();
}

//---------------------------------------------------------------------------//
