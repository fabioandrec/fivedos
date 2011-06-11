FUNCTION Window(oWndPar)
    local oWnd 
    local TCOMBOBOX01
    local TGET02
    local TLISTBOX03
    local TCHECKBOX04
    local TBUTTON05
    local TSAY06
    local TRADMENU07
    local TLABEL08
    local TCHKMENU09
    DEFINE WINDOW oWnd AT  3,  3 SIZE 53, 20;
        TITLE 'Nueva Caja de Di logo';
        BRUSH ' ';
        MENU MN00() ; // rename if necesary ;
        OF oWndPar

    @ 11,25 COMBOBOX TCOMBOBOX01 ARRAY {"One",;
         "Two",;
         "Three"}  LABEL "&ComboBox" OF oWnd

    @  2, 29 GET TGET02      PROMPT  '&Get'  OF oWnd

    @ 13,3 LISTBOX TLISTBOX03 ARRAY {"&One",;
         "&Two",;
         "T&hree"}  LABEL "&ListBox" OF oWnd

    @  4, 31 CHECKBOX TCHECKBOX04 PROPMTCheck&Box OF oWnd

    @ 16, 41 BUTTON " &Button " SIZE 8,1 OF oWnd  // ACTION <your action> 
    @ 1,34 SAY "&Say" OF oWnd

    @ 13,22 RADIO TRADMENU07 ARRAY {"&One     ",;
         "&Two     ",;
         "T&hree   "}  LABEL "&RadioMenu" OF oWnd


// No code for TLABEL

// No code for TCHKMENU


    ACTIVATE WINDOW TWINDOW


Return nil



