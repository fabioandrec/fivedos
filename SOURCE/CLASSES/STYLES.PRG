#include "styles.ch"

static acStyles, acCtrlStyles, anStyles, anCtrlStyles

//----------------------------------------------------------------------------//

function acStyles()

   if acStyles == NIL

      acStyles = ;
        { ;
          { ;                          // WINDOW style constants.
            "WS_OVERLAPPED"        ,;
            "WS_EX_DLGMODALFRAME"  ,;
            "WS_EX_NOPARENTNOTIFY" ,;
            "WS_EX_TOPMOST"        ,;
            "WS_EX_ACCEPTFILES"    ,;
            "WS_EX_TRANSPARENT"    ,;
            "WS_BORDER"            ,;
            "WS_CAPTION"           ,;
            "WS_CHILD"             ,;
            "WS_CLIPCHILDREN"      ,;
            "WS_CLIPSIBLINGS"      ,;
            "WS_DISABLED"          ,;
            "WS_DLGFRAME"          ,;
            "WS_GROUP"             ,;
            "WS_HSCROLL"           ,;
            "WS_ICONIC"            ,;
            "WS_MAXIMIZE"          ,;
            "WS_MAXIMIZEBOX"       ,;
            "WS_MINIMIZE"          ,;
            "WS_MINIMIZEBOX"       ,;
            "WS_OVERLAPPEDWINDOW"  ,;
            "WS_POPUP"             ,;
            "WS_POPUPWINDOW"       ,;
            "WS_SIZEBOX"           ,;
            "WS_SYSMENU"           ,;
            "WS_TABSTOP"           ,;
            "WS_THICKFRAME"        ,;
            "WS_VISIBLE"           ,;
            "WS_VSCROLL"            ;
          },;
          { ;                          // DIALOG style constants
            "DS_ABSALIGN"   ,;
            "DS_SYSMODAL"   ,;
            "DS_LOCALEDIT"  ,;
            "DS_SETFONT"    ,;
            "DS_MODALFRAME" ,;
            "DS_NOIDLEMSG"   ;
          },;
          { ;                          // BUTTON class style constants
            "BS_PUSHBUTTON"      ,;
            "BS_DEFPUSHBUTTON"   ,;
            "BS_CHECKBOX"        ,;
            "BS_AUTOCHECKBOX"    ,;
            "BS_GROUPBOX"        ,;
            "BS_AUTORADIOBUTTON" ,;
            "BS_3STATE"          ,;
            "BS_AUTO3STATE"      ,;
            "BS_LEFTTEXT"        ,;
            "BS_AUTO3STATE"      ,;
            "BS_OWNERDRAW"       ,;
            "BS_RADIOBUTTON"      ;
          },;
          { ;                          // COMBOBOX class style constants
            "CBS_SIMPLE"            ,;
            "CBS_DROPDOWN"          ,;
            "CBS_DROPDOWNLIST"      ,;
            "CBS_AUTOHSCROLL"       ,;
            "CBS_OEMCONVERT"        ,;
            "CBS_SORT"              ,;
            "CBS_DISABLENOSCROLL"   ,;
            "CBS_HASSTRINGS"        ,;
            "CBS_OWNERDRAWFIXED"    ,;
            "CBS_OWNERDRAWVARIABLE"  ;
          },;
          { ;                          // LISTBOX class style constants
            "LBS_NOTIFY"            ,;
            "LBS_OWNERDRAWFIXED"    ,;
            "LBS_USETABSTOPS"       ,;
            "LBS_DISABLENOSCROLL"   ,;
            "LBS_EXTENDEDSEL"       ,;
            "LBS_HASSTRINGS"        ,;
            "LBS_MULTICOLUMN"       ,;
            "LBS_SETCOLUMNWIDTH"    ,;
            "LBS_MULTIPLESEL"       ,;
            "LBS_NOINTEGRALHEIGHT"  ,;
            "LBS_NOREDRAW"          ,;
            "LBS_OWNERDRAWVARIABLE" ,;
            "LBS_SORT"              ,;
            "LBS_STANDARD"          ,;
            "LBS_WANTKEYBOARDINPUT"  ;
          },;
          { ;                          // SCROLLBAR class style constants
            "SBS_HORZ"                    ,;
            "SBS_VERT"                    ,;
            "SBS_BOTTOMALIGN"             ,;
            "SBS_LEFTALIGN"               ,;
            "SBS_RIGHTALIGN"              ,;
            "SBS_SIZEBOXTOPLEFTALIGN"     ,;
            "SBS_SIZEBOX"                 ,;
            "SBS_SIZEBOXBOTTOMRIGHTALIGN" ,;
            "SBS_TOPALIGN"                 ;
          },;
          { ;                          // EDIT class style constants
            "ES_LEFT"       ,;
            "ES_RIGHT"      ,;
            "ES_MULTILINE"  ,;
            "ES_AUTOHSCROLL",;
            "ES_AUTOVSCROLL",;
            "ES_CENTER"     ,;
            "ES_LOWERCASE"  ,;
            "ES_NOHIDESEL"  ,;
            "ES_OEMCONVERT" ,;
            "ES_PASSWORD"   ,;
            "ES_READONLY"   ,;
            "ES_UPPERCASE"  ,;
            "ES_WANTRETURN"  ;
          },;
          { ;                          // ICON class style constants
            "SS_ICON"        ;
          },;
          { ;                          // PEN class style constants
            "PS_SOLID"      ,;
            "PS_DASH"       ,;
            "PS_DOT"        ,;
            "PS_DASHDOT"    ,;
            "PS_DASHDOTDOT" ,;
            "PS_NULL"       ,;
            "PS_INSIDEFRAME";
          },;
          { ;                          // BRUSH class style constants
            "BS_SOLID"      ,;
            "BS_NULL"       ,;
            "BS_HOLLOW"     ,;
            "BS_HATCHED"    ,;
            "BS_PATTERN"    ,;
            "BS_INDEXED"    ,;
            "BS_DIBPATTERN"  ;
          },;
          { ;                          // CLASS style constants
            "CS_VREDRAW"         ,;
            "CS_HREDRAW"         ,;
            "CS_KEYCVTWINDOW"    ,;
            "CS_DBLCLKS"         ,;
            "CS_OWNDC"           ,;
            "CS_CLASSDC"         ,;
            "CS_PARENTDC"        ,;
            "CS_NOKEYCVT"        ,;
            "CS_NOCLOSE"         ,;
            "CS_SAVEBITS"        ,;
            "CS_BYTEALIGNCLIENT" ,;
            "CS_BYTEALIGNWINDOW" ,;
            "CS_GLOBALCLASS"      ;
          },;
          { ;                          // static CONTROL style constants.
            "SS_LEFT"       ,;
            "SS_BLACKRECT"  ,;  // COLOR_WINDOWFRAME.
            "SS_SIMPLE"     ,;
            "SS_BLACKFRAME" ,;  // COLOR_WINDOWFRAME.
            "SS_CENTER"     ,;
            "SS_GRAYRECT"   ,;  // COLOR_BACKGROUND.
            "SS_GRAYFRAME"  ,;  // COLOR_BACKGROUND.
            "SS_RIGHT"      ,;
            "SS_WHITEFRAME" ,;  // COLOR_WINDOW.
            "SS_WHITERECT"   ;
          },;
          { ;                          // HATCH style constants.
            "HS_HORIZONTAL" ,;
            "HS_VERTICAL"   ,;
            "HS_FDIAGONAL"  ,;
            "HS_BDIAGONAL"  ,;
            "HS_CROSS"      ,;
            "HS_DIAGCROSS"   ;
          } ;
        }
     endif

return acStyles

//----------------------------------------------------------------------------//

function anStyles()

   if anStyles == NIL

      anStyles = ;
        { ;
          { ;                          // WINDOW style constants.
            WS_OVERLAPPED        ,;
            WS_EX_DLGMODALFRAME  ,;
            WS_EX_NOPARENTNOTIFY ,;
            WS_EX_TOPMOST        ,;
            WS_EX_ACCEPTFILES    ,;
            WS_EX_TRANSPARENT    ,;
            WS_BORDER            ,;
            WS_CAPTION           ,;
            WS_CHILD             ,;
            WS_CLIPCHILDREN      ,;
            WS_CLIPSIBLINGS      ,;
            WS_DISABLED          ,;
            WS_DLGFRAME          ,;
            WS_GROUP             ,;
            WS_HSCROLL           ,;
            WS_ICONIC            ,;
            WS_MAXIMIZE          ,;
            WS_MAXIMIZEBOX       ,;
            WS_MINIMIZE          ,;
            WS_MINIMIZEBOX       ,;
            WS_OVERLAPPEDWINDOW  ,;
            WS_POPUP             ,;
            WS_POPUPWINDOW       ,;
            WS_SIZEBOX           ,;
            WS_SYSMENU           ,;
            WS_TABSTOP           ,;
            WS_THICKFRAME        ,;
            WS_VISIBLE           ,;
            WS_VSCROLL            ;
          },;
          { ;                          // DIALOG style constants
            DS_ABSALIGN   ,;
            DS_SYSMODAL   ,;
            DS_LOCALEDIT  ,;
            DS_SETFONT    ,;
            DS_MODALFRAME ,;
            DS_NOIDLEMSG   ;
          },;
          { ;                          // BUTTON class style constants
            BS_PUSHBUTTON      ,;
            BS_DEFPUSHBUTTON   ,;
            BS_CHECKBOX        ,;
            BS_AUTOCHECKBOX    ,;
            BS_GROUPBOX        ,;
            BS_AUTORADIOBUTTON ,;
            BS_3STATE          ,;
            BS_AUTO3STATE      ,;
            BS_LEFTTEXT        ,;
            BS_AUTO3STATE      ,;
            BS_OWNERDRAW       ,;
            BS_RADIOBUTTON      ;
          },;
          { ;                          // COMBOBOX class style constants
            CBS_SIMPLE            ,;
            CBS_DROPDOWN          ,;
            CBS_DROPDOWNLIST      ,;
            CBS_AUTOHSCROLL       ,;
            CBS_OEMCONVERT        ,;
            CBS_SORT              ,;
            CBS_DISABLENOSCROLL   ,;
            CBS_HASSTRINGS        ,;
            CBS_OWNERDRAWFIXED    ,;
            CBS_OWNERDRAWVARIABLE  ;
          },;
          { ;                          // LISTBOX class style constants
            LBS_NOTIFY            ,;
            LBS_OWNERDRAWFIXED    ,;
            LBS_USETABSTOPS       ,;
            LBS_DISABLENOSCROLL   ,;
            LBS_EXTENDEDSEL       ,;
            LBS_HASSTRINGS        ,;
            LBS_MULTICOLUMN       ,;
            LBS_SETCOLUMNWIDTH    ,;
            LBS_MULTIPLESEL       ,;
            LBS_NOINTEGRALHEIGHT  ,;
            LBS_NOREDRAW          ,;
            LBS_OWNERDRAWVARIABLE ,;
            LBS_SORT              ,;
            LBS_STANDARD          ,;
            LBS_WANTKEYBOARDINPUT  ;
          },;
          { ;                          // SCROLLBAR class style constants
            SBS_HORZ                    ,;
            SBS_VERT                    ,;
            SBS_BOTTOMALIGN             ,;
            SBS_LEFTALIGN               ,;
            SBS_RIGHTALIGN              ,;
            SBS_SIZEBOXTOPLEFTALIGN     ,;
            SBS_SIZEBOX                 ,;
            SBS_SIZEBOXBOTTOMRIGHTALIGN ,;
            SBS_TOPALIGN                 ;
          },;
          { ;                          // EDIT class style constants
            ES_LEFT       ,;
            ES_RIGHT      ,;
            ES_MULTILINE  ,;
            ES_AUTOHSCROLL,;
            ES_AUTOVSCROLL,;
            ES_CENTER     ,;
            ES_LOWERCASE  ,;
            ES_NOHIDESEL  ,;
            ES_OEMCONVERT ,;
            ES_PASSWORD   ,;
            ES_READONLY   ,;
            ES_UPPERCASE  ,;
            ES_WANTRETURN  ;
          },;
          { ;                          // ICON class style constants
            SS_ICON        ;
          },;
          { ;                          // PEN class style constants
            PS_SOLID      ,;
            PS_DASH       ,;
            PS_DOT        ,;
            PS_DASHDOT    ,;
            PS_DASHDOTDOT ,;
            PS_NULL       ,;
            PS_INSIDEFRAME;
          },;
          { ;                          // BRUSH class style constants
            BS_SOLID      ,;
            BS_NULL       ,;
            BS_HOLLOW     ,;
            BS_HATCHED    ,;
            BS_PATTERN    ,;
            BS_INDEXED    ,;
            BS_DIBPATTERN  ;
          },;
          { ;                          // CLASS style constants
            CS_VREDRAW         ,;
            CS_HREDRAW         ,;
            CS_KEYCVTWINDOW    ,;
            CS_DBLCLKS         ,;
            CS_OWNDC           ,;
            CS_CLASSDC         ,;
            CS_PARENTDC        ,;
            CS_NOKEYCVT        ,;
            CS_NOCLOSE         ,;
            CS_SAVEBITS        ,;
            CS_BYTEALIGNCLIENT ,;
            CS_BYTEALIGNWINDOW ,;
            CS_GLOBALCLASS      ;
          },;
          { ;                          // static CONTROL style constants.
            SS_LEFT       ,;
            SS_BLACKRECT  ,;  // COLOR_WINDOWFRAME.
            SS_SIMPLE     ,;
            SS_BLACKFRAME ,;  // COLOR_WINDOWFRAME.
            SS_CENTER     ,;
            SS_GRAYRECT   ,;  // COLOR_BACKGROUND.
            SS_GRAYFRAME  ,;  // COLOR_BACKGROUND.
            SS_RIGHT      ,;
            SS_WHITEFRAME ,;  // COLOR_WINDOW.
            SS_WHITERECT   ;
          },;
          { ;                          // HATCH style constants.
            HS_HORIZONTAL ,;
            HS_VERTICAL   ,;
            HS_FDIAGONAL  ,;
            HS_BDIAGONAL  ,;
            HS_CROSS      ,;
            HS_DIAGCROSS   ;
          } ;
        }
     endif

return anStyles

//----------------------------------------------------------------------------//

function acCtrlStyles()

   if acCtrlStyles == NIL

      if acStyles == NIL
         acStyles()
      endif

      acCtrlStyles = ;
        { ;                                         // COMBOBOX
          { ;                    // COMBOBOX styles
            acStyles[ CBS_ ],;
            { ;                  // Windows Styles
              "WS_DISABLED",;
              "WS_GROUP"   ,;
              "WS_TABSTOP" ,;
              "WS_VSCROLL"  ;
            },;
            { ;                  // Default Styles
              "WS_TABSTOP" ,;
              "CBS_SIMPLE"  ;
            } ;
          },;
          { ;                                         // EDIT
            acStyles[ ES_ ],;    // EDIT styles
            { ;                  // Windows Styles
              "WS_DISABLED",;
              "WS_GROUP"   ,;
              "WS_HSCROLL" ,;
              "WS_TABSTOP" ,;
              "WS_VSCROLL"  ;
            },;
            { ;                  // Default Styles
              "ES_LEFT"    ,;
              "WS_BORDER"  ,;
              "WS_TABSTOP"  ;
            } ;
          },;                                         // LISTBOX
          { ;                    
            acStyles[ LBS_ ],;    // LISTBOX styles
            { ;                   // Windows Styles
              "WS_BORDER"   ,;
              "WS_DISABLED" ,;
              "WS_VSCROLL"   ;
            },;
            { ;                   // Default Styles
              "LBS_NOTIFY"  ,;
              "WS_VSCROLL"  ,;
              "WS_BORDER"    ;
            } ;
          },;                                         // SCROLLBAR
          { ;
            acStyles[ SBS_ ],;    // SCROLLBAR styles
            { ;                   // Windows Styles
              "WS_TABSTOP"  ,;
              "WS_DISABLED" ,;
              "WS_GROUP"     ;
            },;
            { ;                   // Default Styles
              "SBS_HORZ"    ;
            } ;
          },;                                         // CHECKBOX
          { ;                    // BUTTON styles
            acStyles[ BS_ ],;
            { ;                  // Windows Styles
              "WS_DISABLED",;
              "WS_TABSTOP" ,;
              "WS_GROUP"    ; 
            },;
            { ;                  // Default Styles
              "BS_CHECKBOX",;
              "WS_TABSTOP"  ;
            } ;
          },;                                           // PUSHBUTTON
          { ;                    // BUTTON styles
            acStyles[ BS_ ],;
            { ;                  // Windows Styles
              "WS_TABSTOP" ,;
              "WS_DISABLED",;
              "WS_GROUP"    ;
            },;
            { ;                  // Default Styles
              "BS_PUSHBUTTON",;
              "WS_TABSTOP"    ;
            } ;
          },;                                         // DEFPUSHBUTTON
          { ;                    // BUTTON styles
            acStyles[ BS_ ],;
            { ;                  // Windows Styles
              "WS_DISABLED",;
              "WS_GROUP"   ,;
              "WS_TABSTOP"  ;
            },;
            { ;                  // Default Styles
              "BS_DEFPUSHBUTTON",;
              "WS_TABSTOP"       ;
            } ;
          },;                                         // GROUPBOX
          { ;                    // BUTTON styles
            acStyles[ BS_ ],;
            { ;                  // Windows Styles
              "WS_DISABLED",;
              "WS_TABSTOP"  ;
            },;
            { ;                  // Default Styles
              "BS_GROUPBOX",;
              "WS_TABSTOP"  ;
            } ;
          },;                                         // RADIOBUTTON
          { ;                    // BUTTON styles
            acStyles[ BS_ ],;
            { ;                  // Windows Styles
              "WS_TABSTOP" ,;
              "WS_DISABLED",;
              "WS_GROUP"    ;
            },;
            { ;                  // Default Styles
              "BS_PUSHBUTTON",;
              "WS_TABSTOP"    ;
            } ;
          },;                                         // LTEXT
          { ;                    // BUTTON styles
            acStyles[ BS_ ],;
            { ;                  // Windows Styles
              "WS_GROUP" ;          // is always set for static text .
            },;
            { ;                  // Default Styles
              "SS_LEFT"  ,;
              "WS_GROUP"  ;
            } ;
          },;                                         // CTEXT
          { ;                    // BUTTON styles
            acStyles[ BS_ ],;
            { ;                  // Windows Styles
              "WS_GROUP" ;          // is always set for static text .
            },;
            { ;                  // Default Styles
              "SS_CENTER" ,;
              "WS_GROUP"   ;
            } ;
          },;                                         // RTEXT
          { ;                    // BUTTON styles
            acStyles[ BS_ ],;
            { ;                  // Windows Styles
              "WS_GROUP" ;          // is always set for static text .
            },;
            { ;                  // Default Styles
              "SS_RIGHT" ,;
              "WS_GROUP"  ;
            } ;
          },;
          { ;                                         // DIALOG
            acStyles[ DS_ ],;    // DIALOG styles
            acStyles[ WS_ ],;    // Windows Styles
            { ;                  // Default Styles
              "WS_POPUP"  ,;
              "WS_BORDER" ,;
              "WS_SYSMENU" ;
            } ;
          },;
          { ;                                         // CONTROL
            { "" }         ,;    // DIALOG styles
            { "" }         ,;    // Windows Styles
            { "" }          ;    // Default Styles
          } ;
        }

     endif

return acCtrlStyles

//----------------------------------------------------------------------------//

function anCtrlStyles()

   if anCtrlStyles == NIL

      if anStyles == NIL
         anStyles()
      endif

      anCtrlStyles = ;
        { ;                                         // COMBOBOX
          { ;                    // COMBOBOX styles
            anStyles[ CBS_ ],;
            { ;                  // Windows Styles
              WS_DISABLED,;
              WS_GROUP   ,;
              WS_TABSTOP ,;
              WS_VSCROLL ;
            },;
            { ;                  // Default Styles
              WS_TABSTOP,;
              CBS_SIMPLE;
            } ;
          },;
          { ;                                         // EDIT
            anStyles[ ES_ ],;    // EDIT styles
            { ;                  // Windows Styles
              WS_DISABLED,;
              WS_GROUP   ,;
              WS_HSCROLL ,;
              WS_TABSTOP ,;
              WS_VSCROLL  ;
            },;
            { ;                  // Default Styles
              ES_LEFT    ,;
              WS_BORDER  ,;
              WS_TABSTOP  ;
            } ;
          },;                                         // LISTBOX
          { ;                    
            anStyles[ LBS_ ],;    // LISTBOX styles
            { ;                   // Windows Styles
              WS_BORDER   ,;
              WS_DISABLED ,;
              WS_VSCROLL   ;
            },;
            { ;                   // Default Styles
              LBS_NOTIFY  ,;
              WS_VSCROLL  ,;
              WS_BORDER    ;
            } ;
          },;                                         // SCROLLBAR
          { ;
            anStyles[ SBS_ ],;    // SCROLLBAR styles
            { ;                   // Windows Styles
              WS_TABSTOP  ,;
              WS_DISABLED ,;
              WS_GROUP     ;
            },;
            { ;                   // Default Styles
              SBS_HORZ    ;
            } ;
          },;                                         // CHECKBOX
          { ;                    // BUTTON styles
            anStyles[ BS_ ],;
            { ;                  // Windows Styles
              WS_DISABLED,;
              WS_TABSTOP ,;
              WS_GROUP    ; 
            },;
            { ;                  // Default Styles
              BS_CHECKBOX,;
              WS_TABSTOP  ;
            } ;
          },;                                           // PUSHBUTTON
          { ;                    // BUTTON styles
            anStyles[ BS_ ],;
            { ;                  // Windows Styles
              WS_TABSTOP ,;
              WS_DISABLED,;
              WS_GROUP    ;
            },;
            { ;                  // Default Styles
              BS_PUSHBUTTON,;
              WS_TABSTOP    ;
            } ;
          },;                                         // DEFPUSHBUTTON
          { ;                    // BUTTON styles
            anStyles[ BS_ ],;
            { ;                  // Windows Styles
              WS_DISABLED,;
              WS_GROUP   ,;
              WS_TABSTOP  ;
            },;
            { ;                  // Default Styles
              BS_DEFPUSHBUTTON,;
              WS_TABSTOP       ;
            } ;
          },;                                         // GROUPBOX
          { ;                    // BUTTON styles
            anStyles[ BS_ ],;
            { ;                  // Windows Styles
              WS_DISABLED,;
              WS_TABSTOP  ;
            },;
            { ;                  // Default Styles
              BS_GROUPBOX,;
              WS_TABSTOP  ;
            } ;
          },;                                         // RADIOBUTTON
          { ;                    // BUTTON styles
            anStyles[ BS_ ],;
            { ;                  // Windows Styles
              WS_TABSTOP ,;
              WS_DISABLED,;
              WS_GROUP    ;
            },;
            { ;                  // Default Styles
              BS_PUSHBUTTON,;
              WS_TABSTOP    ;
            } ;
          },;                                         // LTEXT
          { ;                    // BUTTON styles
            anStyles[ BS_ ],;
            { ;                  // Windows Styles
              WS_GROUP ;          // is always set for static text .
            },;
            { ;                  // Default Styles
              SS_LEFT  ,;
              WS_GROUP  ;
            } ;
          },;                                         // CTEXT
          { ;                    // BUTTON styles
            anStyles[ BS_ ],;
            { ;                  // Windows Styles
              WS_GROUP ;          // is always set for static text .
            },;
            { ;                  // Default Styles
              SS_CENTER ,;
              WS_GROUP   ;
            } ;
          },;                                         // RTEXT
          { ;                    // BUTTON styles
            anStyles[ BS_ ],;
            { ;                  // Windows Styles
              WS_GROUP ;          // is always set for static text .
            },;
            { ;                  // Default Styles
              SS_RIGHT ,;
              WS_GROUP  ;
            } ;
          },;
          { ;                                         // DIALOG                    
            anStyles[ DS_ ],;    // DIALOG styles
            anStyles[ WS_ ],;    // Windows Styles
            { ;                  // Default Styles
              WS_POPUP  ,;
              WS_BORDER ,;
              WS_SYSMENU ;
            } ;
          },;
          { ;                                         // CONTROL
            { 0 }         ,;    // DIALOG styles
            { 0 }         ,;    // Windows Styles
            { 0 }          ;    // Default Styles
          } ;
        }

     endif

return anCtrlStyles


//----------------------------------------------------------------------------//
// VERSIONINFO
/*
    FILEVERSION
    PRODUCTVERSION
    FILEFLAGSMASK
    FILEFLAGS
    FILEOS
    FILETYPE
    FILESUBTYPE
*/
//----------------------------------------------------------------------------//

//                                                         ... to be continued.
