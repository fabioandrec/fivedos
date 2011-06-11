#include 'fivedos.ch'
#include "FONTDEF.H"
#include "SysColor.ch"
// intento de crear folders al estilo fivewin ....

CLASS tfolder from tView

    DATA aPrompt, aDialogs, aPos  AS ARRAY       // array de controles e im genes
    DATA aColors   AS Array
    DATA   nOption, nTabSize      as NUMERIC

    METHOD New( nTop, nLeft, nWidth, nHeight, cColor, cChar, oWnd, cMessage, ;
        bWhen, bValid, aPrompts, lUpdate ) CONSTRUCTOR
    METHOD PAINT()
    METHOD SetOption( nOption )
ENDCLASS


//-------------------------------------------------------------------------
METHOD New( nTop, nLeft, nWidth, nHeight, cColor, cChar, oWnd, cMessage, ;
        bWhen, bValid, aPrompts ) CLASS tFolder
    loca n
// default colors from tView

    DEFAULT aPrompts := {"&One","&Two","T&rhee"}

    Super:new( nTop, nLeft, nWidth, nHeight, cColor, cChar, oWnd, cMessage, ;
        bWhen, bValid )

    ::aPrompt  := aPrompts
    ::aDialogs := array ( len( aPrompts ) )
    ::nOption  := 1
    ::aPos:=array( len( ::aPrompt ) )
    ::lUpdate := lUpdate

    // create internal dialogs
    aeval( ::aDialogs, {|x| x:=tView():new( nTop+3, nLeft+1, nWidth-2,;
         nHeight-2) } )

    if len( ::aPrompt ) > 1
        ::aPos[1] := 1
        for n:= 2 to len( ::aPrompt )
            ::aPos[n]:= 2+ nLabelLen( ::aPrompt[ n - 1] ) +::aPos[ n-1 ]
        next
    endif

    ::aColors = aSetColors( cColor )   // no va -> ::SetColors( cColor )


    ::paint()
    ::SetOption( 1 )

return Self


//----------------------------------------------------------------
METHOD PAINT CLASS tFolder
 local n

    ::box( 0, 0, ::nHeight -1, ::nWidth -1, ' '+;
    chr( BORDERBOTTOM )+chr( BORDERBOTTOM )+ chr( BORDERRIGHT ) +;
    chr( CORNERDRIGHT )+ chr( BORDERBOTTOM )+chr( CORNERDLEFT )+;
    CHR( BORDERLEFT ), ::nColor)
    ::say(2,0, chr( BORDERUPLEFT ) + replicate( chr( BORDERTOP ),;
          ::nWidth - 2 )+ chr( BORDERUPRIGHT ),::aColors[ CLRLBL_NORMAL ])
    for n:=1 to Len( ::aPrompt )
        ::sayHOT(1, ::aPOs[n], ::aPrompt[n], ::aColors[ CLRLBL_NORMAL ],;
        ::aColors[ CLRLBL_HOTKEY ] )
        ::say(1, ::aPOs[n] -1 , chr( FOLDERCORNER ), ::aColors[ CLRLBL_NORMAL ] )
    next
return nil

//---------------------------------------------------------------------

METHOD SetOption( nOption ) CLASS tFolder
    alert(str(nOption))
    if nOption != ::nOption
    alert('paso 1')
         ::sayHot(1,::aPos[::nOption],::aPrompt[::nOption],;
            ::aColors[ CLRLBL_NORMAL ],::aColors[ CLRLBL_HOTKEY ])
        if ::lFocussed
        alert('focussed')
         ::sayHot(1,::aPos[nOption],::aPrompt[nOption],;
            ::aColors[ CLRLBL_HILITE ],::aColors[ CLRLBL_HOTKEY_HI ])
         else
         alert('no Focussed')
         ::sayHot(1,::aPos[nOption],::aPrompt[nOption],;
            ::aColors[ CLRLBL_NORMAL ],::aColors[ CLRLBL_HOTKEY ])
        endif
    // draw botom of ALL folder
    ::say(2,0, chr( BORDERUPLEFT ) + replicate( chr( BORDERTOP ),;
          ::nWidth - 2 )+ chr( BORDERUPRIGHT ),::aColors[ CLRLBL_NORMAL ])

    do case
        case nOption = 1
            // Left Border of folder
            ::say(2,0, chr( BORDERLEFT )+space( nLabelLen( ::aPrompt[nOption] ) ),;
            ,::aColors[ CLRLBL_NORMAL ])
        case nOption < len(::aPos)
            ::say(1,::aPos[nOption], space(nLabelLen( ::aPrompt[nOption])) ,;
            ::aColors[ CLRLBL_NORMAL ])
        Case nOption = Len( ::aPos )
            ::say(1 ,::aPos[nOption], space( ::nWidth- ::aPos[nOption]) ,;
            ::aColors[ CLRLBL_NORMAL ])
   endcase
   alert(str(nOption))
  ::UpdateOwner()
    ::nOption := nOption
    endif
return nil


//---------------------------------------------------------------------

static function aSetColors( cColor )

    local n, aColors, aSysClr

    if IS_ARRAY( cColor )
       aColors = cColor
    else
       aColors = array( 4 )
       aSysClr = aSysColor()

       aColors[ CLRLBL_NORMAL ]    = if( Empty( n := nStrColor( cColor, 1 ) ), ;
                                         aSysClr[ CLR_LABEL ], n )
       aColors[ CLRLBL_HILITE ]    = if( Empty( n := nStrColor( cColor, 2 ) ), ;
                                         aSysClr[ CLR_LABEL_HI ], n )
       aColors[ CLRLBL_HOTKEY ]    = if( Empty( n := nStrColor( cColor, 3 ) ), ;
                                         aSysClr[ CLR_LABELHOT ], n )
       aColors[ CLRLBL_HOTKEY_HI ] = if( Empty( n := nStrColor( cColor, 4 ) ), ;
                                         aSysClr[ CLR_LABELHOT_HI ], n )
    endif

return aColors


