#include "FiveDos.ch"
#include "SysColor.ch"

/*****


#define CLRLBL_NORMAL     1
#define CLRLBL_HILITE     2
#define CLRLBL_HOTKEY     3
#define CLRLBL_HOTKEY_HI  4


#define CLR_WNDCLIENT               1
#define CLR_WNDTITLE_HI             2   // Title/message with focus
#define CLR_WNDBORDER_HI            3   // Border with focus
#define CLR_WNDTITLE                4
#define CLR_WNDBORDER               5
                                        // Dos de reserva...

#define CLR_LABEL                   8
#define CLR_LABEL_HI                9   // with focus
#define CLR_LABELHOT                10
#define CLR_LABELHOT_HI             11  // Hot Char with focus
                                        // uno mas de reserva

#define CLR_PUSHBUTTON              13
#define CLR_PUSHBUTTON_HI           14
#define CLR_PUSHBUTTONHOT           15
#define CLR_PUSHBUTTONHOT_HI        16
                                        // uno mas de reserva

#define CLR_BUTTONBAR               18
#define CLR_BUTTONBAR_HI            19
                                        // uno mas de reserva

#define CLR_BUTTONBMP               21
#define CLR_BUTTONBMP_LEFT          22
#define CLR_BUTTONBMP_RIGHT         23
                                        // uno mas de reserva

#define CLR_CHECKBOX                25
#define CLR_CHECKBOX_HI             26
#define CLR_CHECKBOX_HOT            27
#define CLR_CHECKBOX_OFF            28  // Disable
                                        // uno mas de reserva

#define CLR_GET                     30
#define CLR_GET_HI                  31
                                        // uno mas de reserva

#define CLR_COMBO                   33
#define CLR_COMBO_HI                34
#define CLR_COMBO_ARROW             35
                                        // uno mas de reserva

#define CLR_LISTBOX                 37
#define CLR_LISTBOX_SEL_HI          38
#define CLR_LISTBOX_SEL             39
#define CLR_LISTBOX_MARK            40
#define CLR_LISTBOX_MSEL            41
#define CLR_LISTBOX_MNOFOCUS        42

#define CLR_MENU                    43
#define CLR_MENU_HI                 44
#define CLR_MENU_HOT                45
#define CLR_MENU_HOT_HI             46
#define CLR_MENU_OFF                47
#define CLR_MENU_LEFT               48
#define CLR_MENU_RIGHT              49
                                        // uno mas de reserva

#define CLR_RADIO                   51
#define CLR_RADIO_HI                52
#define CLR_RADIO_HOT               53
#define CLR_RADIO_OFF               54
                                        // uno mas de reserva

#define CLR_RADIOMNU                56
#define CLR_RADIOMNU_HI             57
#define CLR_RADIOMNU_HOT            58
#define CLR_RADIOMNU_OFF            59
                                        // uno mas de reserva

#define CLR_SCROLLBAR               61
#define CLR_SCROLLBARARROWS         62
#define CLR_SCROLLBAR_HI            63
                                        // uno mas de reserva

#define CLR_cBROWSE                 65
                                        // uno mas de reserva


#define CLR_TABTEXTNORMAL           67
#define CLR_TABTEXTFOCUS            68
#define CLR_TABHOTNORMAL            69
#define CLR_TABHOTFOCUS             70
#define CLR_TABNORMAL               71
#define CLR_TABFOCUS                72
                                        // uno mas de reserva

#define SCL_MAXCLR                  73



****/

#include "colores.ch"

static aSysClr := { N_BG       ,;     //    "N/BG   "     // Window
                    N_W_       ,;     //    "N/W*   "
                    W__BG      ,;     //    "W+/BG  "
                    N_W        ,;     //    "N/W    "
                    W_BG       ,;     //    "W/BG   "
                      0        ,;     // SPARE
                      0        ,;     // SPARE
                    N_BG       ,;     //    "N/BG   "     // Label
                    W__BG      ,;     //    "W+/BG  "
                    BG__BG     ,;     //    "BG+/BG "
                    BG__BG     ,;     //    "BG+/BG "
                      0        ,;     // SPARE
                    N_W        ,;     //    "N/W    "     // PushButton
                    W__W       ,;     //    "W+/W   "
                    BG__W      ,;     //    "BG+/W  "
                    BG__W      ,;     //    "BG+/W  "
                      0        ,;     // SPARE
                    N_N_       ,;     //    "N/N*   "     // ButtonBar
                    W__N_      ,;     //    "W+/N*  "
                      0        ,;     // SPARE
                    N_W        ,;     //    "N/W    "     // ButtonBmp
                    W__W       ,;     //    "W+/W   "
                    N_W        ,;     //    "N/W    "
                      0        ,;     // SPARE
                    N_W        ,;     //    "N/W    "     // CheckBox
                    W__W       ,;     //    "W+/W   "
                    BG__W      ,;     //    "BG+/W  "
                    N__W       ,;     //    "N+/W   "
                      0        ,;     // SPARE
                    N_W        ,;     //    "N/W    "     // TGet
                    W__W       ,;     //    "W+/W   "
                      0        ,;     // SPARE
                    N_W        ,;     //    "N/W    "     // TCombo
                    W__W       ,;     //    "W+/W   "
                    W__N       ,;     //    "W+/N   "
                      0        ,;     // SPARE
                    N_W        ,;     //    "N/W    "     // TListBox
                    W__B       ,;     //    "W+/B   "
                    W__W       ,;     //    "W+/W   "
                    GR__W      ,;     //    "GR+W   "           Mark, no actual
                    GR__B      ,;     //    "GR+/B  "           Mark and actual
                    GR__W      ,;     //    "GR+W   "           Mark, actual nofocus
                    W__B       ,;     //    "W+/B   "     // Menus y menuitems
                    B_W        ,;     //    "B/W    "
                    R__B       ,;     //    "R+/B   "
                    R__W       ,;     //    "R+/W   "
                    W_B        ,;     //    "W/B    "
                    B__B       ,;     //    "B+/B   "
                    N__B       ,;     //    "N+/B   "
                      0        ,;     // SPARE
                    N_BG       ,;     //    "N/BG   "     // RadioButton
                    W__BG      ,;     //    "W+/BG  "
                    BG__BG     ,;     //    "BG+/BG "
                    N__BG      ,;     //    "N+/BG  "
                      0        ,;     // SPARE
                    N_W        ,;     //    "N/W    "     // RadioMenus
                    W__W       ,;     //    "W+/W   "
                    BG__W      ,;     //    "BG+/W  "
                    N__W       ,;     //    "N+/W   "
                      0        ,;     // SPARE
                    W_N_       ,;     //    "W/N*   "     // ScrollBar
                    N_W        ,;     //    "N/W    "
                    W__W       ,;     //    "W+/W   "
                      0        ,;     // SPARE
                   "n/w, w+/b, w/b,b/w,gr+/b,w/b" ,;
                      0        ,;     // SPARE
                    W_N_       ,;     //    "W/N*   "     // Tabs
                    N_GR       ,;     //    "N/GR   "
                    GR__N_     ,;     //    "GR+/N* "
                    GR__N      ,;     //    "GR+/GR "
                    N__BG      ,;     //    "N+/BG  "
                    GR_BG      ,;     //    "GR/BG  "
                      0         ;     // SPARE
                  }

//---------------------------------------------------------------------------//

function aSysColor( nClrID )

   if !Empty( nClrID ) .and. IS_NUMBER( nClrID ) .and. nClrID <= SCL_MAXCLR
      return aSysClr[ nClrID ]
   end

return aSysClr

//---------------------------------------------------------------------------//
