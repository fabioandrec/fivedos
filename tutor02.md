tutor02   (notice the graphical mouse on text mode)

![http://img254.imageshack.us/img254/8907/capturegg.png](http://img254.imageshack.us/img254/8907/capturegg.png)

```
#include "FiveDos.ch"

function Main()

   local oWnd

   DEFINE WINDOW oWnd FROM 3, 6 TO 20, 70 ;
          TITLE "Wellcome to FiveDos"     

   SET MESSAGE OF oWnd ;
      TO OemToAnsi( FDCOPYRIGHT ) ;
      CENTERED
      
   @ 2, 2 SAY "Hello" OF oWnd

   ACTIVATE WINDOW oWnd

return nil
```