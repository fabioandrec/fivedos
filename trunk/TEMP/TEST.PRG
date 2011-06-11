#include 'fivedos.ch'


function test

    local oWnd, oLbx
    local array := { {'1','2','3','4','5','6','7','8','9','0'},;
                    {'q','w','e','r','t','y','u','i','o','p',},;
                    {'1','2','3','4','5','6','7','8','9','0'}}


    define dialog oWnd from 0,0 to 23,70

    @ 0,0 listbox olbx fields array of oWnd size 20,20

    activate dialog oWnd
