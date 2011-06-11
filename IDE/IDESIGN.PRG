#include "FiveDos.ch"
#include "Styles.ch"

//----------------------------------------------------------------------------//

function DlgNew()

   static oDlg, oDlgTools

   local oWnd, lRunning := .f., nCtrl := 1, cFileRC

   if oDlg == nil

       SetMCursor( IDC_CLOCK )

       oWndMain():DispBegin()

       DEFINE WINDOW oDlg FROM 3, 3 TO 22, 55 TITLE "Nueva Caja de Di logo"

       oDlg:oClient:cChar = "."
       oDlg:oClient:Clear()

       ACTIVATE WINDOW oDlg NOWAIT ;
                VALID ( if( !lRunning, oDlg := nil, ), ;
                        if( oDlgTools != nil .AND. !lRunning, oDlgTools:Close(), ), .t. )

       // Ahora construimos la ventana de herramientas
       DEFINE DIALOG oDlgTools TITLE "Controles" FROM 1, 59 TO 23, 75

       oDlgTools:oClient:nPaintCount++

       @ 1, 1 RADIOMENU nCtrl OF oDlgTools ;
                    ITEMS "&ComboBox", "&Get", "&ListBox", "Scroll&Bar",;
                          "C&heckBox", "&PushButton", "&Say", "&CheckMenu",;
                          "&RadioMenu", "L&abel"

       @ 12, 1 BUTTON " &Add " OF oDlgTools ACTION ControlAdd( oDlg, nCtrl ) ;
               MESSAGE "Add Control"

       @ 12, 8 BUTTON " &Del " OF oDlgTools ACTION ControlDel( oDlg:oClient ) ;
               MESSAGE "Delete Control"

       @ 14, 1 BUTTON " &Red " OF oDlgTools ACTION ControlRedef( oDlg ) ;
               MESSAGE "Redefine Control"

       @ 14, 8 BUTTON " &Try " OF oDlgTools MESSAGE "Try Controls" ;
          ACTION ( lRunning := .t.,;
                   oDlg:Close(),;
                   AEval( oDlg:oClient:aChilds,;
                         { | oCtrl | oCtrl:SetDesign( .f. ) } ),;
                   oWnd := oDlg:oParent,;
                   oDlg:oParent := nil,;
                   oDlg:oClient:cChar := " ",;
                   oDlg:oClient:Clear(),;
                   oDlg:Activate(), ;
                   oDlg:oParent := oWnd,;
                   oDlg:oClient:cChar := ".",;
                   oDlg:oClient:Clear(),;
                   AEval( oDlg:oClient:aChilds, ;
                          { | oCtrl | oCtrl:SetDesign(.t.) } ),;
                   lRunning := .f.,;
                   oDlg:Activate( , .t. ) )

       @ 16, 1 BUTTON " &Gen " OF oDlgTools MESSAGE "Genera .Prg" ;
          ACTION ( MemoWrit( "Temp.prg", GenCode( Odlg ) ),;
                 Alert( "Fichero Temp creado" ) )

       @ 16, 8 BUTTON " R&es " OF oDlgTools ACTION ChangeDlg( oDlg ) ;
               MESSAGE "Change Resource"

       @ 18, 1 BUTTON ";R&C" OF oDlgTools FILE "..\bitmaps\load.bmp" SIZE 5, 2 ;
               ACTION RC_Load( oDlg, cFileRC ) ;
               MESSAGE "Load '.RC'"
               

       @ 18, 8 BUTTON ";&RC" OF oDlgTools FILE "..\bitmaps\save.bmp" SIZE 5, 2 ;
               ACTION RC_Save( oDlg, cFileRC ) ;
               MESSAGE "Save '.RC'"

       oDlgTools:oClient:nPaintCount--

       ACTIVATE DIALOG oDlgTools NOWAIT ;
           VALID ( if( !lRunning, oDlgTools := nil,), ;
                   if( oDlg != nil .AND. !lRunning, oDlg:Close(), ), .t. )

       oWndMain():DispEnd()

       SetMCursor( IDC_ARROW )

   endif

return nil

//---------------------------------------------------------------------------//

static function ControlDel( oClient )

    local nFocus := oClient:nFocussed,;
          nLen   := len( oClient:aChilds )

    if !Empty( nFocus ) .and. nFocus <= nLen
        aDel( oClient:aChilds, nFocus )
        aSize( oClient:aChilds, --nLen )

        oClient:BeginPaint()

        if !Empty( nLen )
           if nFocus > nLen
              nFocus = --oClient:nFocussed
           endif
           oClient:oFocussed:SetFocus( .f. )
           oClient:oFocussed = oClient:aChilds[ nFocus ]
           oClient:oFocussed:SetFocus( .t. )
        else
           oClient:nFocussed = 0
           oClient:oFocussed = nil
        endif
        oClient:Clear()
        oClient:EndPaint()
    endif

return nil

//----------------------------------------------------------------------------//

static function ControlAdd( oDlg, nCtrl )

   local oCtrl, xVar
   local aList  := { "&One", "&Two", "T&hree" }
   local aList1 := { "One", "Two", "Three" }
   local nRow   := 2, nCol := 2
   local lVar1, lVar2, lVar3

   do case
      case nCtrl == CLS_COMBOBOX
           xVar = Space( 10 )
           @ nRow, nCol COMBOBOX oCtrl VAR xVar ARRAY aList1 OF oDlg ;
                           SIZE 8, 4 LABEL "&ComboBox"

      case nCtrl == CLS_EDITTEXT
           xVar = Space( 10 )
           @ nRow, nCol GET oCtrl VAR xVar LABEL "&Get" OF oDlg

      case nCtrl == CLS_LISTBOX
           xVar = Space( 10 )
           @ nRow, nCol LISTBOX oCtrl VAR xVar ARRAY aList OF oDlg ;
                          SIZE 8, 4 LABEL "&ListBox"

      case nCtrl == CLS_SCROLLBAR
           if MsgYesNo( "Horizontal" )
              @ nRow, nCol SCROLLBAR oCtrl SIZE oDlg:nWidth HORIZONTAL OF oDlg
           else
              @ nRow, nCol SCROLLBAR oCtrl SIZE oDlg:nHeight OF oDlg
           endif

      case nCtrl == CLS_CHECKBOX
           xVar = .f.
           @ nRow, nCol CHECKBOX oCtrl VAR xVar LABEL "Check&Box" OF oDlg

      case nCtrl == CLS_PUSHBUTTON
           @ nRow, nCol BUTTON oCtrl PROMPT " &Button " OF oDlg

      case nCtrl == 7  // SAY
           @ nRow, nCol SAY oCtrl PROMPT "&Say" OF oDlg

      case nCtrl == 8  // CHECKMENU
           xVar = .f.
           @ nRow, nCol CHECKMENU oCtrl VARS lVar1, lVar2, lVar3;
                        ARRAY aList ;
                        LABEL "Check&Menu" OF oDlg

      case nCtrl == 9  // RADIOMENU
           xVar = 1
           @ nRow, nCol RADIOMENU oCtrl VAR xVar ;
                        ARRAY aList ;
                        LABEL "&RadioMenu" OF oDlg

      case nCtrl == 10   // LTEXT, CTEXT, RTEXT
           oCtrl = TLabel():New( nRow, nCol, "L&abel",, 8,, oDlg, ,;
                                 nCtrl - CLS_CTEXT + 1 )

   endcase

   if oCtrl != nil
      oCtrl:lDesign  = .t.
      oCtrl:lPainted = .f.
      oDlg:oClient:Clear()
   endif

return nil

//----------------------------------------------------------------------------//

static Function RC_Load( oDlg, cFileRC )

   local oDlgNew := oDlg

   oDlg:DispBegin()
   oDlg:oClient:Destroy()
   oDlg:oClient:oFocussed = nil
   oDlg:oClient:nFocussed = 0
   oDlg:oClient:aChilds   = {}
   oDlg:oClient:cChar     = "."
   oDlg:oClient:lPainted  = .f.
   oDlg:DispEnd()

   cFileRC = if( Empty( cFileRC ), cGetFile( ".\*.rc",;
                                   "Select '.RC' to use" ),;
                 cFileRC )

    if File( cFileRC )

        DEFINE DIALOG oDlgNew RESOURCE oDlg:cVarName FILE cFileRC

        if oDlgNew != nil

            AEval( oDlg:oClient:aChilds, { | oCtrl | oCtrl:SetDesign( .t. ) } )
            oDlg:oClient:Clear()
            Alert( "Fich: '" + cFileRC + "'; ; Resource '" + oDlg:cVarName + ;
                "'; ; LEIDO" )
        endif

    endif

return nil

//----------------------------------------------------------------------------//

static Function RC_Save( oDlg, cFileRC )

    local cFile := cFileRC

    if Empty( cFile )
       cFile = "Temporal.RC"
       lMsgGet( "Fich: '*.RC' a usar", "Nombre : ", @cFile )
       if !Empty( cFile )
          cFileRC = cFile
       endif
    endif

    if Write_Rc( oDlg, cFileRC )
       Alert( "Fich: '" + cFileRC + "'; ; Resource '" + oDlg:cVarName + ;
              "'; ; ESCRITO" )
    endif

return nil

//----------------------------------------------------------------------------//

static function ChangeDlg( oDlg )

   local oDlg2, n,;
         cTitleRC := Pad( oDlg:cTitle, 60 ),;
         cNameRC  := Pad( oDlg:cVarName, 20 )

   DEFINE DIALOG oDlg2 FROM 6, 12 TO 18, 68 ;
      TITLE "Redefinici¢n de una Caja de Di logo"

   @  2,  4 SAY "Recurso : "        OF oDlg2
   @  2, 14 GET cNameRC             OF oDlg2

   @  4,  4 SAY "Titulo  : "        OF oDlg2
   @  4, 14 GET cTitleRC            OF oDlg2

   @  8, 14 BUTTON " &Aceptar "  OF oDlg2 ;
            ACTION ( oDlg:cTitle   := Trim( cTitleRC ),;
                     oDlg:cVarName := Trim( cNameRC ),;
                     oDlg2:End() )
   @  8, 28 BUTTON " &Cancelar " OF oDlg2 ACTION oDlg2:End()

   ACTIVATE WINDOW oDlg2

return nil

//---------------------------------------------------------------------------//

static function ControlRedef( oDlg )

    local oClient := oDlg:oClient
    local aList  := { "&ONE", "&TWO", "T&HREE" }
    local aList1 := { "ONE", "TWO", "THREE" }
    local lVar1, lVar2, lVar3
    local nId, cCtrl,;
          nFocus := oClient:nFocussed,;
          nLen   := len( oClient:aChilds ),;
          oCtrl  := oClient:oFocussed
    local lVar   := .f.,;
          nVar   := 1,;
          cVar   := space( 10 )

    if Empty( nFocus )
       Alert( 'Set the focus on the Control and pressed the button [ Red. ]' )
       return nil
    endif

    oClient:BeginPaint()
    nId   = oCtrl:nGetId()
    cCtrl = oCtrl:ClassName()

    do case
       case cCtrl == "TBUTTON"
            REDEFINE BUTTON oCtrl LABEL "&BUTTON" ID nId OF oDlg ;
                ACTION Tone( 100, 5 ) ;
                WHILE PRESSED Tone( 1000, 1 ) ;
                MESSAGE "Message from TButton"

       case cCtrl == "TCHECKBOX"
            REDEFINE CHECKBOX oCtrl VAR lVar ID nId OF oDlg LABEL "&CHECKBOX" ;
                MESSAGE "Message from TCheckBox"

       case cCtrl == "TRADIO"
            REDEFINE RADIOBUTTON oCtrl ID nId OF oDlg LABEL "&RADIOBUTTON" ;
                MESSAGE "Message from TRadioButton"

       case cCtrl == "TSAY"
            REDEFINE SAY oCtrl PROMPT "&SAY" ID nId OF oDlg

       case cCtrl == "TLABEL"
            REDEFINE LABEL oCtrl PROMPT "&LABEL" ID nId OF oDlg ;
                MESSAGE "Message from TLabel"

       case cCtrl == "TGET"
            REDEFINE GET oCtrl ID nId OF oDlg ;
                LABEL "GET" ;
                MESSAGE "Message from TGet"

       case cCtrl == "TLISTBOX"
            REDEFINE LISTBOX oCtrl VAR nVar ID nId ;
                ARRAY aList OF oDlg ;
                LABEL "&LISTBOX" ;
                ON CHANGE Alert( "Change" ) ;
                MESSAGE "Message from TListBox"

       case cCtrl == "TCHKMENU"
            REDEFINE CHECKMENU oCtrl VARS lVar1, lVar2, lVar3 ID nID ;
                ARRAY aList OF oDlg ;
                LABEL "&CHECKMENU" ;
                MESSAGE "Message from TCheckMenu"

       case cCtrl == "TRADMENU"
            REDEFINE RADIOMENU oCtrl VAR nVar ID nID ;
                ARRAY aList OF oDlg ;
                LABEL "&RADIOMENU" ;
                MESSAGE "Message from TRadioMenu"

       case cCtrl == "TCOMBOBOX"
            REDEFINE COMBOBOX oCtrl VAR cVar ARRAY aList1 OF oDlg ;
                LABEL "&COMBOBOX" ID nID ;
                MESSAGE "Message from TComboBox"

    endcase
    oClient:Clear()
    oClient:EndPaint()

return nil

//---------------------------------------------------------------------------//

