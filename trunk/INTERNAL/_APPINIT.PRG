#include "FiveDos.ch"

#define USERNUM     PROCNAME
#define GRABALALIB  PROCLINE
#define OPERATION   PROCFILE

// external USERNUM, OPERATION, PROCNAME

//----------------------------------------------------------------------------//

PROC __APPINIT()

   local cInfoEng  := "   To register this evaluation copy of FiveDos, please  ;" + ;
                      "contact the distributor closest to you.  The list of    ;" + ;
                      "distributors can be found in the FiveDos in NG file     ;" + ;
                      "under ABOUT/DISTRIBUTION.                               ; ;" + ;
                      "Your distributor will provide you with the appropriate  ;" + ;
                      "registration code to unlock your version of FiveDos.    ;" + ;
                      "Please contact your distributor for pricing and shipping;" + ;
                      "information.                                            ; ;" + ;
                      "Thank you for evaluating FiveDos!"

   local cExeEng   := "  Before your .EXE file can be run on any other computer;" + ;
                      "but your development machine, it must be UNLOCKED.      ;" + ;
                      "To accomplish this, fill in all the fields including    ;" + ;
                      "your NAME  and the  FULL PATH  to your .EXE. Enter your ;" + ;
                      "Registration  Code which you  received  from  your      ;" + ;
                      "distributor and select UNLOCK.                          "

   local cInfoEsp  := "   Para registrarse y usar normalmente esta versi¢n de  ;" + ;
                      "evaluaci¢n, contacte a su distribuidor m s cercano de   ;" + ;
                      "FiveDos ¢ ll menos ¢ env¡enos un fax al: 95-2834830 y le;" + ;
                      "proporcionaremos  su  n£mero  de  registro.   Revise el ;" + ;
                      "fichero NG de documentaci¢n para consultar el precio y  ;" + ;
                      "detalles.                                               ; ;" + ;
                      "   Le enviaremos el producto completo con todo el c¢digo;" + ;
                      "fuente,  documentaci¢n,  ejemplos  e  informaci¢n  para ;" + ;
                      "actualizaciones.                                        "

   local cExeEsp   := "  Para que su .EXE pueda ser ejecutado en otro ordenador;" + ;
                      "que no sea el suyo debe ser LIBERADO.  Para  ello,      ;" + ;
                      "complete la informaci¢n requerida  con  su NOMBRE  y  el;" + ;
                      "path completo y nombre de su .EXE. As¡ mismo especifique;" + ;
                      "el c¢digo  de  usuario  que  recibi¢  de  nosotros  y   ;" + ;
                      "seleccione UNLOCK.                                      "

   local cInstError := "Application incorrectly installed." + CRLF + ;
                       "Aplicaci¢n no instalada correctamente." + CRLF + ;
                       "Verkeerde installatle van deze applicatie." + CRLF + ;
                       CRLF + ;
                       "Please contact the producer of your application." + CRLF + ;
                       "Por favor contacte con el programador de su aplicaci¢n." + CRLF + ;
                       "Neem a.u.b. kontakt op met de ontwikkelaar;van uw applicatie."

   local cTitle      := "FiveDos 1.0 - Product Registration Process"
   local cTitEsp     := "FiveDos 1.0 - Proceso de Registro del producto"
   local cAtention   := "Attention / Atenci¢n / Opgelet"
   local cLibPrompt  := "FiveDos &Lib path:"
   local cExePrompt  := "FiveDos &Exe path:"

                        // Ojo, no cambiar el orden de las cadenas

   local cCheck      := cInfoEng + cExeEng + cInfoEsp + cExeEsp + ;
                        cInstError + cTitle + cTitEsp + cAtention + ;
                        cLibPrompt + cExePrompt

   local cUserNum   := USERNUM()
   local oDlg       := { || cUserNum:_FIVEDOS := 1 } // Genera sym "__FIVEDOS"
   local nOperation := OPERATION( cCheck )
                                   // Si 0 Registrar Lib
                                   // Si 1 Exe de Lib Reg en m quina ajena
                                   // Si 2 Liberar EXE
                                   // si > 2  CRC de cadenas mal
   local cUser     := Space( 44 )
   local cPath     := Space( 44 )
   local cCode     := Space( 10 )

   // PUBLIC GetList // Mejor que no tenga GetList as¡ READ Peta seguro

   // Esto es para pruebas, HAY QUE COMENTARLO Cuando se descomente
   // REGISTERCRC en FiveFix.c

   // Alert( "PassWord " + __Fix3() + ";pCodeCRC" + str( __Fix4( cCheck ) ) + ";LibraryNum "+ __Fix5() )

   if !( PROCNAME( 0 ) == "__APPINIT" ) // USERNUM( 0 ) ==...

      if nOperation == 1
           GRABALALIB( cInstError, cAtention )
                       
      elseif nOperation < 3

           DEFINE DIALOG oDlg FROM 5, 5 TO 16, 74 ;
              COLOR "N/ BG, N/BG*, BG+/BG, N/W, W/BG" ;
              TITLE ""
                                    
           @ 1,  3 GET cUser PROMPT "&User Name:       " OF oDlg
           @ 3,  3 GET cPath ;
                    PROMPT if( nOperation == 2, cExePrompt, cLibPrompt )  ;
                    OF oDlg

           @ 5,  3 GET cCode PROMPT "R&egister N§:     " OF oDlg

           if nOperation == 0
              @ 5, 47 SAY OemToAnsi( "User Id:  " ) + cUserNum OF oDlg
           endif

           @ 8,  6 BUTTON If( nOperation == 0, " &Register ", " &UnLock " ) ;
                   OF oDlg ACTION ;
                        If( GRABALALIB( cPath, ;
                                        Upper( AllTrim( cCode ) ) ) == 0 , ;
                            MsgInfo( "File correctly registered", "Thanks for using FiveDos" ), ;
                            Alert( "Wrong register number or file error" + CRLF + CRLF + ;
                                   If( nOperation == 0,;
                                   "Remember to write the full path of the .LIB:" + CRLF + ;
                                   "Example: C:\CLIPPER5\FD10\LIB\FiveDos.LIB",;
                                   "Remember to write the full path of your .EXE:" + CRLF + ;
                                   "Example: C:\MYAPP\MYPROG.EXE" ) ) )

           @ 8, 26 BUTTON " &Information " OF oDlg ;
             ACTION ( MsgInfo( If( nOperation == 0, cInfoEng, cExeEng ), cTitle ),;
                      MsgInfo( If( nOperation == 0, OemToAnsi( cInfoEsp ),;
                                   OemToAnsi( cExeEsp ) ), cTitEsp ) )

           @ 8, 49 BUTTON " &Continue " OF oDlg ACTION oDlg:End()

           oDlg:bWhen  := {|| oDlg:cTitle := cTitle, .t. }
           oDlg:bValid := {|| .t. }
           Tone( 948, 2 )
           ACTIVATE DIALOG oDlg CENTERED    ;
                    VALID  .T.              ;
                    WHEN  ( oDlg:cTitle := cTitle, .t. )

      else
         QUIT
      endif

   endif

return

//----------------------------------------------------------------------------//
