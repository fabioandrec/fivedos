#include <ClipApi.h>

static BYTE far ASK[] = {
    ' ', 0x50,  '�', 0x51,  '�', 0x51,  '�', 0x51,  '�', 0x51,  '�', 0x51,
    ' ', 0x51,  ' ', 0x10,  ' ', 0x10,  '�', 0xE1,  '�', 0xE1,  '�', 0xE1,
    '�', 0xE1,  ' ', 0x10,  ' ', 0x10,  ' ', 0x10,  ' ', 0x10,  '�', 0xE1,
    '�', 0xE1,  ' ', 0x10,  ' ', 0x10,  ' ', 0x10,  ' ', 0x10,  ' ', 0x10,
    '�', 0xE1,  ' ', 0x10,  ' ', 0x10,  ' ', 0x10,  ' ', 0x50,  '�', 0x51,
    '�', 0x51,  '�', 0x51,  '�', 0x51,  '�', 0x51,  ' ', 0x53};

CLIPPER AskIco()
{
   _retclen( ASK, 70 );
}
