/*  DbfEdit()

    to be included in several samples
*/
//---------------------------------------------------------------------------//

static function DbfEdit( oLbx, oDbf, lNew )

   local oDlg

   DEFINE DIALOG oDlg FROM 6, 12 TO 19, 70 ;
      TITLE "Edit Client"

   oDbf:SetBuffer( .t. )

   if !Empty( lNew )
        oDbf:Blank()
   else
        oDbf:Load()
   endif

   @  2,  2 GET oDbf:Name OF oDlg ;
            PROMPT "&Nombre:"

   @  4, 32 CHECKBOX oDbf:FiveDos PROMPT "&FiveDos" OF oDlg
   @  5, 32 CHECKBOX oDbf:Dialog  PROMPT "&Dialog " OF oDlg
   @  6, 32 CHECKBOX oDbf:Objects PROMPT "&Objects" OF oDlg

   @  4,  2 GET oDbf:Level OF oDlg ;
            PROMPT "Ni&vel :"

   @ 10, 15 BUTTON " &Aceptar "  OF oDlg ;
            ACTION  if( !empty( lNew ), oDbf:Append(), ), ;
                    oDbf:Save(), ;
                    oLbx:Refresh(), ;
                    oDlg:End()
   @ 10, 28 BUTTON " &Cancelar " OF oDlg ACTION oDlg:End()

   ACTIVATE WINDOW oDlg

   oDbf:SetBuffer( .f. )

return nil

//---------------------------------------------------------------------------//
