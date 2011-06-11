
#include <ClipApi.h>

typedef struct _RCT_
{
    int  iTop;
    int  iLeft;
    WORD wWidth;
    WORD wHeight;
} RCT;

typedef RCT far  * LPRCT;
typedef RCT near * PRCT;

typedef struct
{
    WORD wType;
    LONG lDummy;
    RCT  rct;
} CLIPRECT;

typedef CLIPRECT near * PCLIPRECT;
typedef CLIPRECT far * LPCLIPRECT;

void SetRect( LPRCT pRct, int iTop, int  iLeft,
                          WORD wWidth, WORD wHeight );

void RectNew( PCLIPVAR pNewVarRct, int iTop, int  iLeft,
                       WORD wWidth, WORD wHeight );


LPRCT GetRectParam( WORD wParam );

void ScreenRect( LPRCT pRct );

int RectRight( LPRCT pRct );

int RectBottom( LPRCT pRct );

BOOL bOverRect( LPRCT pRct, int iRow, int iCol );

BOOL bIntoRect( LPRCT pRct, int iRow, int iCol );

BOOL bBorderRect( LPRCT pRct, int iRow, int iCol );

// pSrc est  posicionado respecto de pTgt
// y pResult est  posicionado respecto de pTgt.
// o sea: pResult es el el trozo de pSrc que coincide con pTgt.
// devuelve TRUE si existe la interseccion.
BOOL bIntersecRect( LPRCT pTgt, LPRCT pSrc, LPRCT pResult );
