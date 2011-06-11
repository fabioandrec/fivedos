// disktree

#include 'FiveDos.ch'
#include 'Tree.Ch'


function Main()
    local oWnd, oTree, oLbx

    ALTD()

    TREE otree BITMAPS "Open.bmp", "Open2.bmp"

    BuildTree( 'c:\fivedos\')

    ENDTREE


    define Dialog oWnd from 0,0 to 15,60

    @ 0,0 listbox oLbx Tree oTree size 58,10 of oWnd

    @ 12, 25 button ' &Exit of Tree' of oWnd action oWnd:End()

    activate dialog oWnd centered

return nil

function BuildTree(cPath)
    local aDir, n

    aDir := DirectorY( cPath ,'D')

    if len(aDir) > 2 // .and. aDir[ 1,1 ] == '.'

        TREEITEM cPath + '  <DIRECTORY>'
        TREE

        for n:=1  to  len(aDir)

            if !aDir[n,1] $ '..'
                if 'D' $ aDir[ n, 5 ]
                    ? cPath+aDir[n,1]+'\'
                    BuildTree(cPath+aDir[n,1]+'\')
                else
                    TREEITEM pad(aDir[n,1],11)+' '+trans( aDir[n,2], '99,999,999');
                        +' '+dtoc(aDir[n,3])+' '+aDir[n,4]
                    ? cPath+aDir[n,1]
                end
            end
        next

        ENDTREE

    end

return nil
