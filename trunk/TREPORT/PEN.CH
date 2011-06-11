
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

