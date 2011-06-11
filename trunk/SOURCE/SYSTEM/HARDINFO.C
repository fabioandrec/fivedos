/* HardInfo.c

   Sintaxis : wHardInfo()   Sin parametros. Para "C".


  Devuelve :     N§ de dos bytes unsigned char con codigo de equipo
                 segun la INT 11h de la rom BIOS.

  Bit's          Significado
  ====================================================================
  14-15          N§ de impreosras instaladas.
  
  13             1 Modem interno ( Solo PC y XT )
                 1 Un impresora conectada ( PCjr )
  
  12             1 adaptador de juagos instalado.
  
  9-11           N§ de Puertos Serie instalados.
  
  8              Reservado.
  
  6-7            N§ de floppys ( si bit 0 = 1 )
                 00 = 1, 01 = 2, 10 = 3, 11 = 4
  
  4-5            Modo de video inicial.
                 00 Reservado
                 01 texto color 40x25
                 10 texto color 80x25
                 11 monocromo 80x25

  2-3            Tama¤o RAM placa madre( Solo primeros PC y PCjr )
                 00 = 16Kb, 01 = 32Kb, 10 = 48Kb, 11 = 64 Kb.

  2              1 Disp¢sitivo apuntador instalado ( PS/2 )
  1              1 Coprocesador matem tico instalado.
  0              1 Hay unidades de disco flexible instaladas.


*/

#include <ClipApi.h>

//---------------------------------------------------------------------------//

WORD wHardInfo( void )
{
   asm int 11h;

   return _AX;
}

//---------------------------------------------------------------------------//

CLIPPER nHardInfo()
{
    _retni( wHardInfo() );
}

//---------------------------------------------------------------------------//

CLIPPER nFloppys( void )
{
    WORD wInfo = wHardInfo();

    if( wInfo & 1 )  // Hay floppys
    {
        /*
            192 = 11 000000    Test bit's 6 y 7
            128 = 10 000000
             64 = 01 000000
              0 = 00 000000
        */

        _retni( 1 + ( ( wInfo & 192 ) >> 6 ) );

    }
    else
        _retni( 0 );

}

//---------------------------------------------------------------------------//

CLIPPER nLPTPorts()
{

    /*  192 * 256 = 49152 = 1100 0000 0000 0000   Test bit's 14 y 15
        128 * 256 = 32768 = 1000 0000 0000 0000
         64 * 256 = 16384 = 0100 0000 0000 0000
          0 * 256 =     0 = 0000 0000 0000 0000
    */

    _retni( ( wHardInfo() & 0xC000 ) / 0x4000 );
}

//---------------------------------------------------------------------------//

CLIPPER nSerPorts()
{
    /*
        14 * 256 = 0000 1110 0000 0000   Test bit's 9, 10 y 11
        12 * 256 = 0000 1100 0000 0000
        10 * 256 = 0000 1010 0000 0000
         8 * 256 = 0000 1000 0000 0000
         6 * 256 = 0000 0110 0000 0000
         4 * 256 = 0000 0100 0000 0000
         2 * 256 = 0000 0010 0000 0000
         0 * 256 = 0000 0000 0000 0000
    */

    _retni( ( wHardInfo() & 0x0E00 ) >> 9 );
}

//---------------------------------------------------------------------------//
