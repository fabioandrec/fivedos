// salvapantallas, experimiento

#include 'fontdef.h'


//---------------------------------------------------------------------------//

function scrsaver()
    local x:=0, y:=0, n:=0
    local ax:=1,ay:=0.5
    local nOldColor,nOldCursor
    local nCOLOR := 1, nCount := 0, nKey := 0

    moff()
    save screen
    nOldColor:=setcolor()
    set color to
    nOldCursor:=setcursor()
    setcursor(0)
    cls
    do while nKey == 0 .and. lIsIdle() .and. !lMPressed()
        dispbegin()
        @ y,x say '    '
        x+=ax
        y+=ay
        @ y,x say chr(LEFTRADIO)+CHR(CENTERRADIO2)+CHR(RIGHTRADIO) color str(nColor,3)+'/n'
        VertRetrace()
        dispend()
        if x >= 77 .or. x <= 0
            ax =- ax
        end
        if y >= 23 .or. y <= 0
            ay =- ay
        end
        nKey := nMKeyWait() // inkey(.05)
        mUpdate()
        nCount++
        if nCount > 50
            nColor++
            if nColor >15
             nColor=1
            end
            nCount := 0
        end
    enddo
    restore screen
    setcursor(nOldCursor)
    setcolor(nOldColor)
    mon()
return nil

//---------------------------------------------------------------------------//

function MouseWalk()
    local x := 1, y := 0, ax := 2, ay := 2
    local nColor := 1, nCount := 0
    local nOldColor, nOldCursor, nMOld := nMCursor()
    local nMaxCol := MaxCol() * 8 - 8, nMaxRow := MaxRow() * nCharHeight()
    local aOldDac := aGetDac( 7 )
    local aClr    := aGetDac( 7 ), nClr := 1

    MOff()
    SAVE SCREEN
    nOldColor   :=  SetColor( "" )
    nOldCursor  :=  SetCursor( 0 )
    CLS
    MOn()
    CursorHand()

    while nMKeyWait() == 0 .and. !lMPressed()
        x += ax
        y += ay
        if x > nMaxCol .or. x <= 0
            ax =- ax
            if ++nColor > 3
               nColor=1
            endif
        end
        if y > nMaxRow .or. y <= 0
            ay =- ay
            if ++nColor > 3
                nColor=1
            endif
        end
        MOff()
        SetMGPos( y * 8, x * 9 )
        MOn()
        SetDac( 7, aClr[ 1 ], aClr[ 2 ], aClr[ 3 ] )
        VertRetrace()
        
        aClr[ nColor ] += nClr

        if aClr[ nColor ] > 63
            aClr[ nColor ] = 63
            nClr = -1
        elseif aClr[ nColor ] < 0
            aClr[ nColor ] = 0
            nClr = 1
        end

    end

    MOff()
    SetDac( 7, aOlddac[ 1 ], aOlddac[ 2 ], aOlddac[ 3 ] )
    restore screen
    setcursor(nOldCursor)
    setcolor(nOldColor)
    MOn( nMOld )

return nil

//---------------------------------------------------------------------------//

