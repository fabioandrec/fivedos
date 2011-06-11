
#ifndef Win_Styles
#define Win_Styles

#define WS_                        1       // WINDOW    styles.
#define DS_                        2       // DIALOG     "  "
#define BS_                        3       // BUTTON     "  "
#define CBS_                       4       // COMBOBOX   "  "
#define LBS_                       5       // LISTBOX    "  "
#define SBS_                       6       // SCROLLBAR  "  "
#define ES_                        7       // EDIT       "  "
#define IS_                        8       // ICON       "  "
#define PS_                        9       // PEN        "  "
#define BH_                       10       // BRUSH      "  "     // BS_
#define CS_                       11       // CLASS      "  "
#define SS_                       12       // STATIC control   "  "
#define HS_                       13       // HATCH      styles

// Standard de windows
#define CLS_COMBOBOX               1
#define CLS_EDITTEXT               2
#define CLS_LISTBOX                3
#define CLS_SCROLLBAR              4
#define CLS_CHECKBOX               5
#define CLS_PUSHBUTTON             6
#define CLS_DEFPUSHBUTTON          7
#define CLS_GROUPBOX               8
#define CLS_RADIOBUTTON            9
#define CLS_LTEXT                 10
#define CLS_CTEXT                 11
#define CLS_RTEXT                 12
#define CLS_DIALOG                13
#define CLS_CONTROL               14

// A¤adidas de fivedos
#define CLS_SAY                   15
#define CLS_RADIOMENU             16
#define CLS_CHECKMENU             17

// Acceso a array de estilos.
#define _CLS_PARENTSTYLES          1
#define _CLS_WINSTYLES             2
#define _CLS_DEFAULT               3

/****** Pen styles *********************************************************/

#define PS_SOLID            0
#define PS_DASH             1
#define PS_DOT              2
#define PS_DASHDOT          3
#define PS_DASHDOTDOT       4
#define PS_NULL             5
#define PS_INSIDEFRAME      6


/****** Brush styles *******************************************************/

#define BS_SOLID            0
#define BS_NULL             1
#define BS_HOLLOW           BS_NULL
#define BS_HATCHED          2
#define BS_PATTERN          3
#define BS_INDEXED          4
#define BS_DIBPATTERN       5


/****** Hatch styles *******************************************************/

#define HS_HORIZONTAL       0
#define HS_VERTICAL         1
#define HS_FDIAGONAL        2
#define HS_BDIAGONAL        3
#define HS_CROSS            4
#define HS_DIAGCROSS        5


/****** Window styles *******************************************************/

/* no definidas */
#define WS_SIZEBOX                   0 // 0x000L
#define WS_ICONIC                    0 // 0x000L

/* Basic window types */
#define WS_OVERLAPPED                0 // 0x000L
#define WS_POPUP            2147483648 // 0x80000000L
#define WS_CHILD            1073741824 // 0x40000000L

/* Clipping styles */
#define WS_CLIPSIBLINGS     67108864 // 0x04000000L
#define WS_CLIPCHILDREN     33554432 // 0x02000000L

/* Generic window states */
#define WS_VISIBLE          268435456 // 0x10000000L
#define WS_DISABLED         134217728 // 0x08000000L

/* Main window states */
#define WS_MINIMIZE         536870912 // 0x20000000L
#define WS_MAXIMIZE          16777216 // 0x01000000L

/* Main window styles */
#define WS_CAPTION         12582912 // 0x00C00000L /* WS_BORDER | WS_DLGFRAME  */
#define WS_BORDER           8388608 // 0x00800000L
#define WS_DLGFRAME         4194304 // 0x00400000L
#define WS_VSCROLL          2097152 // 0x00200000L
#define WS_HSCROLL          1048576 // 0x00100000L
#define WS_SYSMENU           524288 // 0x00080000L
#define WS_THICKFRAME        262144 // 0x00040000L
#define WS_MINIMIZEBOX       131072 // 0x00020000L
#define WS_MAXIMIZEBOX        65536 // 0x00010000L

/* Control window styles */
#define WS_GROUP            131072 // 0x00020000L
#define WS_TABSTOP           65536 // 0x00010000L

/* Common Window Styles */
#define WS_OVERLAPPEDWINDOW (WS_OVERLAPPED + WS_CAPTION + WS_SYSMENU +;
                             WS_THICKFRAME + WS_MINIMIZEBOX + WS_MAXIMIZEBOX)
#define WS_POPUPWINDOW      (WS_POPUP + WS_BORDER + WS_SYSMENU)
#define WS_CHILDWINDOW      (WS_CHILD)

/* Extended Window Styles */
#define WS_EX_DLGMODALFRAME   1 // 0x00000001L
#define WS_EX_NOPARENTNOTIFY  4 // 0x00000004L

#define WS_EX_TOPMOST         8 // 0x00000008L
#define WS_EX_ACCEPTFILES    16 // 0x00000010L
#define WS_EX_TRANSPARENT    32 // 0x00000020L


/****** Dialog styles *****************************************************/

#define DS_ABSALIGN           1 // 0x01L
#define DS_SYSMODAL           2 // 0x02L
#define DS_LOCALEDIT         32 // 0x20L
#define DS_SETFONT           64 // 0x40L
#define DS_MODALFRAME       128 // 0x80L
#define DS_NOIDLEMSG        256 // 0x100L


/****** Class styles *******************************************************/

#define CS_VREDRAW              1 // 0x0001
#define CS_HREDRAW              2 // 0x0002

#define CS_KEYCVTWINDOW         4 // 0x0004

#define CS_DBLCLKS              8 // 0x0008

#define CS_OWNDC               32 // 0x0020
#define CS_CLASSDC             64 // 0x0040
#define CS_PARENTDC           128 // 0x0080

#define CS_NOKEYCVT           256 // 0x0100

#define CS_NOCLOSE            512 // 0x0200

#define CS_SAVEBITS          2048 // 0x0800

#define CS_BYTEALIGNCLIENT   4096 // 0x1000
#define CS_BYTEALIGNWINDOW   8192 // 0x2000

#define CS_GLOBALCLASS      16384 // 0x4000


/****** Static control styles ***********************************************/

#define SS_LEFT               0 // 0x00000000L
#define SS_CENTER             1 // 0x00000001L
#define SS_RIGHT              2 // 0x00000002L
#define SS_ICON               3 // 0x00000003L
#define SS_BLACKRECT          4 // 0x00000004L
#define SS_GRAYRECT           5 // 0x00000005L
#define SS_WHITERECT          6 // 0x00000006L
#define SS_BLACKFRAME         7 // 0x00000007L
#define SS_GRAYFRAME          8 // 0x00000008L
#define SS_WHITEFRAME         9 // 0x00000009L
#define SS_SIMPLE            11 // 0x0000000BL
#define SS_LEFTNOWORDWRAP    12 // 0x0000000CL
#define SS_NOPREFIX         128 // 0x00000080L


/****** Button styles *****************************************************/

#define BS_PUSHBUTTON        0 // 0x00000000L
#define BS_DEFPUSHBUTTON     1 // 0x00000001L
#define BS_CHECKBOX          2 // 0x00000002L
#define BS_AUTOCHECKBOX      3 // 0x00000003L
#define BS_RADIOBUTTON       4 // 0x00000004L
#define BS_3STATE            5 // 0x00000005L
#define BS_AUTO3STATE        6 // 0x00000006L
#define BS_GROUPBOX          7 // 0x00000007L
#define BS_USERBUTTON        8 // 0x00000008L
#define BS_AUTORADIOBUTTON   9 // 0x00000009L
#define BS_OWNERDRAW        11 // 0x0000000BL
#define BS_LEFTTEXT         32 // 0x00000020L


/****** Edit styles *******************************************************/

#define ES_LEFT                0 // 0x00000000L
#define ES_CENTER              1 // 0x00000001L
#define ES_RIGHT               2 // 0x00000002L
#define ES_MULTILINE           4 // 0x00000004L
#define ES_UPPERCASE           8 // 0x00000008L
#define ES_LOWERCASE          16 // 0x00000010L
#define ES_PASSWORD           32 // 0x00000020L
#define ES_AUTOVSCROLL        64 // 0x00000040L
#define ES_AUTOHSCROLL       128 // 0x00000080L
#define ES_NOHIDESEL         256 // 0x00000100L
#define ES_OEMCONVERT       1024 // 0x00000400L
#define ES_READONLY         2048 // 0x00000800L
#define ES_WANTRETURN       4096 // 0x00001000L


/****** Scroll bar styles *************************************************/

#define SBS_HORZ                    0 // 0x0000L
#define SBS_VERT                    1 // 0x0001L
#define SBS_TOPALIGN                2 // 0x0002L
#define SBS_LEFTALIGN               2 // 0x0002L
#define SBS_BOTTOMALIGN             4 // 0x0004L
#define SBS_RIGHTALIGN              4 // 0x0004L
#define SBS_SIZEBOXTOPLEFTALIGN     2 // 0x0002L
#define SBS_SIZEBOXBOTTOMRIGHTALIGN 4 // 0x0004L
#define SBS_SIZEBOX                 8 // 0x0008L


/****** Listbox styles ****************************************************/

#define LBS_NOTIFY                1  // 0x0001L
#define LBS_SORT                  2  // 0x0002L
#define LBS_NOREDRAW              4  // 0x0004L
#define LBS_MULTIPLESEL           8  // 0x0008L
#define LBS_OWNERDRAWFIXED       16  // 0x0010L
#define LBS_OWNERDRAWVARIABLE    32  // 0x0020L
#define LBS_HASSTRINGS           64  // 0x0040L
#define LBS_USETABSTOPS         128  // 0x0080L
#define LBS_NOINTEGRALHEIGHT    256  // 0x0100L
#define LBS_MULTICOLUMN         512  // 0x0200L
#define LBS_WANTKEYBOARDINPUT  1024  // 0x0400L
#define LBS_EXTENDEDSEL        2048  // 0x0800L
#define LBS_DISABLENOSCROLL    4096  // 0x1000L

/* no definida */
#define LBS_SETCOLUMNWIDTH        0  // 0x2000L

#define LBS_STANDARD          (LBS_NOTIFY + LBS_SORT + WS_VSCROLL + WS_BORDER)


/****** Combo box styles **************************************************/

#define CBS_SIMPLE               1 // 0x0001L
#define CBS_DROPDOWN             2 // 0x0002L
#define CBS_DROPDOWNLIST         3 // 0x0003L
#define CBS_OWNERDRAWFIXED      16 // 0x0010L
#define CBS_OWNERDRAWVARIABLE   32 // 0x0020L
#define CBS_AUTOHSCROLL         64 // 0x0040L
#define CBS_OEMCONVERT         128 // 0x0080L
#define CBS_SORT               256 // 0x0100L
#define CBS_HASSTRINGS         512 // 0x0200L
#define CBS_NOINTEGRALHEIGHT  1024 // 0x0400L
#define CBS_DISABLENOSCROLL   2048 // 0x0800L

#endif
