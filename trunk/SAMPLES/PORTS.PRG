

function main()

    local nKey

    cls

    @ 0, 1 say "0x60"
    @ 1, 1 say "0x61"
    @ 2, 1 say "0x62"
    @ 3, 1 say "0x63"
    @ 4, 1 say "0496"

    while ( nKey := inkey() ) != 27
        @ 0, 7 say i2binary( Port60H() )
        @ 1, 7 say i2binary( Port61H() )
        @ 2, 7 say i2binary( Port62H() )
        @ 3, 7 say i2binary( Port63H() )
        @ 4, 7 say i2binary( Base496H() )
    end
return nil
