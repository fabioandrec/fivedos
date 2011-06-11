
function OpenDbf()

   local cFile := cGetFile( "Clipper DataBase (*.dbf) | *.dbf", "Select a DBF" )

   if ! Empty( cFile )
      USE ( cFile )

      // Quick and easy browses!
      // Fully integrated into a Dialog Box !!!

      Browse( "FiveWin Automatic Browse Power",;
              "Easy Browses without pain...",;
              { || MsgInfo( "This will be executed from first button...", "Info1" ) },;
              { || MsgInfo( "You can atach any action to the buttons...", "Info2" ) },;
              { || MsgInfo( "We also provide full source code of this...", "Info3" ) },;
              { || MsgInfo( "So you can adapt it to your necesities", "Info4" ) } )
      USE
   endif

return nil

//---------------------------------------------------------------------------//

