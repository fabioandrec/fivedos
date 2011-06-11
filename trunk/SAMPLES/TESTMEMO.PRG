#include "FiveDos.ch"

function main()
    local cTemp, oWnd

    cTemp:=memoread('prueba.txt')

    define dialog oWnd from 5,5 to  20,65 title 'Prueba de Multiline'

    tMemo():New( 0, 0, 50, 12, {|x|if (x=nil,cTemp,(cTemp:=x))}, 'Prueba de memoedit',;
             'Prueba de Memoedit', , oWnd, )

    activate dialog oWnd

return nil
