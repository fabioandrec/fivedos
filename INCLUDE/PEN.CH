
/*----------------------------------------------------------------------------//
!short: Pens */

#xcommand DEFINE PEN <oPen> ;
             [ STYLE <nStyle> ] ;
             [ WIDTH <nWidth> ] ;
             [ COLOR <nRGBColor> ] ;
             [ <of: OF, WINDOW, DIALOG> <oWnd> ] ;
       => ;
          <oPen> := TPen():New( <nStyle>, <nWidth>, <nRGBColor>, <oWnd> )

#xcommand ACTIVATE PEN <oPen> => <oPen>:Activate()

#define P_SINGLE        ( CHR(218) + CHR(196) + CHR(191) + CHR(179) + ;
                          CHR(217) + CHR(196) + CHR(192) + CHR(179)   )

#define P_DOUBLE        ( CHR(201) + CHR(205) + CHR(187) + CHR(186) + ;
                       CHR(188) + CHR(205) + CHR(200) + CHR(186)   )


#define P_SINGLE_DOUBLE ( CHR(214) + CHR(196) + CHR(183) + CHR(186) + ;
                          CHR(189) + CHR(196) + CHR(211) + CHR(186)   )


#define P_DOUBLE_SINGLE ( CHR(213) + CHR(205) + CHR(184) + CHR(179) + ;
                             CHR(190) + CHR(205) + CHR(212) + CHR(179)   )

#define P_SHADOW1 "∞∞∞∞∞∞∞∞"
#define P_SHADOW2 "±±±±±±±±"
#define P_SHADOW3 "≤≤≤≤≤≤≤≤"

#define P_BOLD    "€€€€€€€€"

#define P_STYLES 8
