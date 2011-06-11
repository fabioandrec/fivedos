
/* System Strings and Messages indexes.
*/

#ifndef _SYSSTR_CH
#define _SYSSTR_CH

// Language selection with SysLanguage( nLangID ) -> nOldSelection

#define SLG_ENGLISH                     1
#define SLG_SPANISH                     2

#define SLG_MAXLANG                     2


// Sysmenu.prg
#define SST_MOVE                        1
#define SST_RESTORE                     2
#define SST_SIZE                        3
#define SST_MAXIMIZE                    4
#define SST_MINIMIZE                    5
#define SST_CLOSE                       6

// Brw.prg
#define SST_NEW                         7
#define SST_MODIFY                      8
#define SST_DELETE                      9
#define SST_SEARCH                      10
#define SST_PRINT                       11
#define SST_EXIT                        12


// MsgBox.prg
#define SST_OK                          13
#define SST_ALERT                       14
#define SST_INFO                        15
#define SST_STOP                        16
#define SST_MSGSELECT                   17
#define SST_YES                         18
#define SST_NO                          19

#define SST_ACCEPT                      20
#define SST_CANCEL                      21


// GetFile.prg
#define SST_SELFILE                     22
#define SST_MASK                        23
#define SST_FILES                       24
#define SST_INFOLABEL                   25
#define SST_BADPATH                     26

// Varios
#define SST_RETRY                       27
#define SST_IGNORE                      28
#define SST_QUIT                        29
#define SST_HELP                        30
#define SST_DEFAULT                     31


// ErrSys2.prg

//Database.prg                          32
#define SST_BOF                         33
#define SST_EOF

// MsgEnd.prg
#define SST_WANTEND                     34

#define SST_BADDATE                     35

#define SST_NODEVICE                    36
                 
#define SST_MAXSTR                      SST_NODEVICE

#endif
