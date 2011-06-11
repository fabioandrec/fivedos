// Nuevo plateamiento para la redefinici¢n de caracteres para el modo EGA
//
// Basicamente la redefinici¢n se aloja en los caracteres griegos de la
// Tabla: la parte alta de la misma.
// y los dieciseis primeros de la tabla.

// El resto ser† redefinible por el usuario v°a reserva de caracteres
// al modulo carroom: bien v°a fichero "ini" ¢ funcion de iniciaci¢n.

// La reserva se efectuar† indicando a carrrom que zonas son redefinibles
// encargandose este modulo a partir de entonces del mantenieminto de
// este recurso...


/*
------------------------------------------------------------------------------
        0             20           40    (        60   <
        1            21           41    )        61   =
        2            22           42    *        62   >
        3            23           43    +        63   ?
        4            24           44    ,        64   @
        5            25           45    -        65   A
        6            26            46    .        66   B
        7            27           47    /        67   C
        8            28           48    0        68
        9             29           49    1        69
       10             30           50    2        70
       11            31           51    3        71
       12            32            52    4        72
       13            33   !        53    5        73
       14            34   "        54    6        74
       15            35   #        55    7        75
       16            36   $        56    8        76
       17            37   %        57    9        77
       18            38   &        58    :        78
       19            39   '        59    ;        79
------------------------------------------------------------------------------
       80            100           120            140   å
       81            101           121            141   ç
       82            102           122            142   é
       83            103           123   {        143   è
       84            104           124   |        144   ê
       85            105           125   }        145   ë
       86            106           126   ~        146   í
       87            107           127           147   ì
       88            108           128   Ä        148   î
       89            109           129   Å        149   ï
       90            110           130   Ç        150   ñ
       91   [        111           131   É        151   ó
       92   \        112           132   Ñ        152   ò
       93   ]        113           133   Ö        153   ô
       94   ^        114           134   Ü        154   ö
       95   _        115           135   á        155   õ
       96   `        116           136   à        156   ú
       97   a        117           137   â        157   ù
       98   b        118           138   ä        158   û
       99   c        119           139   ã        159   ü
------------------------------------------------------------------------------
      160   †        180   ¥       200   »        220   ‹
      161   °        181   µ       201   …        221   ›
      162   ¢        182   ∂       202            222   ﬁ
      163   £        183   ∑       203   À        223   ﬂ
      164   §        184   ∏       204   Ã        224   ‡
      165   •        185   π       205   Õ        225   ·
      166   ¶        186   ∫       206   Œ        226   ‚
      167   ß        187   ª       207   œ        227   „
      168   ®        188   º       208   –        228   ‰
      169   ©        189   Ω       209   —        229   Â
      170   ™        190   æ       210   “        230   Ê
      171   ´        191   ø       211   ”        231   Á
      172   ¨        192   ¿       212   ‘        232   Ë
      173   ≠        193   ¡       213   ’        233   È
      174   Æ        194   ¬       214   ÷        234   Í
      175   Ø        195   √       215   ◊        235   Î
      176   ∞        196   ƒ       216   ◊        236   Ï
      177   ±        197   ≈       217   Ÿ        237   Ì
      178   ≤        198   ∫       218   ⁄        238   Ó
      179   ≥        199   «       219   €        239   Ô
-----------------------------------------------------------------------------
      240           250   ˙
      241   Ò        251   ˚
      242   Ú        252   ¸
      243   Û        253   ˝
      244   Ù        254   ˛
      245   ı        255   ˇ
      246   ˆ
      247   ˜
      248   ¯
      249   ˘
-----------------------------------------------------------------------------
*/

#define MOUSE1          224
#define MOUSE2          225
#define MOUSE3          226
#define MOUSE4          227
#define MOUSE5          228
#define MOUSE6          229


#define BORDERLEFT      230      //
#define BORDERRIGHT     231      //
#define BORDERUPLEFT    232      //
#define BORDERTOP       233      //
#define BORDERUPRIGHT   234      //
#define CORNERDLEFT     235      //
#define BORDERBOTTOM    236      //
#define CORNERDRIGHT    237      //

#define CLOSELEFT       238      //
#define CLOSERIGHT      239      //

#define MAXIMIZELEFT    240      //
#define MAXIMIZERIGHT   241      //

#define MINIMIZELEFT    242      //
#define MINIMIZERIGHT   243      //

#define RESTORELEFT     244      //
#define RESTORERIGHT    245      //

#define ARROWUPLEFT     246      //
#define ARROWUPRIGHT    247      //

#define ARROWDNLEFT     248      //
#define ARROWDNRIGHT    249      //

#define ARROWLFLEFT     250      //
#define ARROWLFRIGHT    251      //

#define ARROWRGLEFT     252      //
#define ARROWRGRIGHT    253      //

#define THUMBLEFT       254      //
#define THUMBRIGHT      255      //

#define LEFTRADIO         1      //
#define CENTERRADIO1      2      // Empty
#define CENTERRADIO2      3      // Filled
#define RIGHTRADIO        4      //


#define LEFTCHECK         5      //
#define CENTERCHECK1      6      // Empty
#define CENTERCHECK2      7      // Checked
#define RIGHTCHECK        8      //


#define EIGHTFILL         9      //

/* YA NO QUEDAN libres y reservados para la CUA :-(( */
#define POINT_NW         10      //  Point at North-West
#define POINT_NE         11      //  Point at North-East
#define POINT_SE         12      //  Point at South-East
#define POINT_SW         13      //  Point at South-West

#define MENUITEMCHK      14      // Redefinido
#define MENUITEMCHKFOC   15      // Redefinido

#define MENUITEMOPEN     16      // No necesita redefinici¢n
#define SINGLERIGHTARROW 16      // No necesita redefinici¢n
#define SINGLELEFTARROW  17      // No necesita redefinici¢n

#define TABLEFT          18
#define TABRIGHT         19

#define FILLCHAR         32      //   No es redefindo

