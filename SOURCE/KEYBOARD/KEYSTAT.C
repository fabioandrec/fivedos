#include <ClipApi.h>
#include <dos.h>


extern LPBYTE BaseSegment( void );  // en dpmi.c
extern BOOL bKeyAlt( void );        // en keywait.c

//---------------------------------------------------------------------------//

BYTE bKeyStat( void )
{
   return(  BaseSegment()[ 0x0417 ] & 8 );
}

//---------------------------------------------------------------------------//

CLIPPER lKeyAlt( void )
{
    _retl( bKeyAlt() );
}

//---------------------------------------------------------------------------//

CLIPPER nKeyStat( void )
{
    _retni( bKeyStat() );
}

//---------------------------------------------------------------------------//
