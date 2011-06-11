// control for calendar :-))

#include 'Fivedos.ch'
#include 'Inkey.ch'


class tCalendar from tControl

    Data dDay AS DATE
    Data xPos,Ypos as Numeric
    Data bSetGet   as Block
    Data aColors   as Character


    METHOD NEW( xPos, yPos, bSetGet)
    Method Up()
    Method Down()
    Method PrevMonth()
    Method PostMonth()
    Method Refresh()
    Method PrevYear()
    Method PostYear()
