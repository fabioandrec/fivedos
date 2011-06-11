
void interrupt ( * OldInt8 )( void );

static DWORD    Count = 0;
static BYTE     Flag  = 1;
static DWORD    MicroRetard = 0;

/*
void WaitMicro( LONG MicroSecs )
{
    BYTE port;
    WORD wCount = ( MicroSecs * 1000 ) / 838 ;

    asm {
            in      al,61h                  //Disable the timer by
            and     al,0FEh                 //clearing bit 0 of I/O
            out     61h,al                  //port 61h
            mov     port,al                 //Save the input value

            mov al, 0B0h                    //Program channel 2 for
            out 43h, al                     //mode 0 operation
            mov ax, wCount                  //Set the counter to
            out 42h, al                     //wCount by writing the
            call near ptr dummy             //LSB followd by the MSB
            xchg ah, al
            out 42h, al

//            cli                             //Interrupts off
            mov     al,port                 //Start the timer by
            or      al,01h                  //setting bit 0 of I/O
            out     61h,al                  //port 61h
        }

    do
    {
    asm {
            mov     al,0B0h                 //Program channel 2 for
            out     43h,al                  //mode 0 operation
            in      al,42h                  //Read the count into AX
            mov     ah,al
            in      al,42h
            xchg    ah,al
        }
    } while( _AX );

    asm {
            //*********************************

            mov     al,port                 //Stop the timer
            out     61h,al
//            sti                             //Interrupts on
        }
}
//---------------------------------------------------------------------------//
*/

void interrupt Int8Handler( void )
{
    OldInt8();
    if( Count-- )
        Flag = 0;
}

//---------------------------------------------------------------------------//

void GetMicroRetard( void )
{
    DWORD Counter = 0;
    DWORD wMcSec  = 1;
    DWORD wCount  = 0;


    OldInt8 = getvect( 0x08 );
    setvect( 0x08, Int8Handler );
    Flag  = 0xFF;
    Count = 1; // 55 milisegundos
    while( Flag );
    Count = 1; // 55 milisegundos

    // Bucle que vamos a calibrar
    while( Counter < wMcSec )
    {
        ++wCount;
        if( Flag )
            Counter = wMcSec;
    }

    setvect( 0x08, OldInt8 );

}


// -------------------------------------------------------------------------- //
