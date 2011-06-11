#include 'fivedos.ch'
#include "FONTDEF.H"
#include "SysColor.ch"

// folders al estilo fivewin ....

CLASS tfolder from tPage

    DATA aPrompts  AS ARRAY       // Label of folder's array
    DATA aPos      AS ARRAY      // Offset of labels
    DATA aColors   AS ARRAY

   METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) INLINE ;
    ::aColors:=aSetColors(),;
    SUPER:New( nTop, nLeft, nBottom, nRight, oWnd ),;
        ::aPrompts:={},;
        ::aPos:={},;
        self

   METHOD Click( nMrow, nMcol, lDouble )
   method Refresh()

   METHOD Organize()

    METHOD KeyPressed( nKey )

    METHOD IsHotKey( cKey )

    METHOD SetFocus( lOnOff ) inline Super:SetFocus( lOnOff ),;
                                     if( !lOnOff,::refresh(),)
ENDCLASS


//----------------------------------------------------------------

METHOD Organize()
    local n
    ::Beginpaint()
    ::box( 0, 0, ::nHeight -1, ::nWidth -1, ' '+;
    chr( BORDERBOTTOM )+chr( BORDERBOTTOM )+ chr( BORDERRIGHT ) +;
    chr( CORNERDRIGHT )+ chr( BORDERBOTTOM )+chr( CORNERDLEFT )+;
    CHR( BORDERLEFT ), ::nColor)
    ::aPos := aSize(::aPos, len( ::aPrompts ) )
    ::aPos[1] := 1
    ::cHotKey := cGetHotKey( ::aPrompts[1] )
    if len( ::aPrompts ) > 1
        for n:= 2 to len( ::aPrompts )
            ::aPos[n]:= 2+ nLabelLen( ::aPrompts[ n - 1] ) +::aPos[ n-1 ]
            ::cHotKey+= cGetHotKey( ::aPrompts[n] )
        next
    endif

    for n:=1 to Len( ::aPrompts )
        ::sayHOT(1, ::aPOs[n], ::aPrompts[n], ::aColors[ CLRLBL_NORMAL ],;
        ::aColors[ CLRLBL_HOTKEY ] )
        ::say(1, ::aPOs[n] -1 , chr( FOLDERCORNER ), ::aColors[ CLRLBL_NORMAL ] )
    next
    ::EndPaint()
return nil

//----------------------------------------------------------------
METHOD Refresh CLASS tFolder
    local n
    ::beginpaint()
    Super:refresh()
    ::organize()
        if ::lFocussed
         ::sayHot(1,::aPos[ ::nIndex ],::aPrompts[ ::nIndex ],;
            ::aColors[ CLRLBL_HILITE ],::aColors[ CLRLBL_HOTKEY_HI ])
         else
         ::sayHot(1,::aPos[ ::nIndex ],::aPrompts[ ::nIndex ],;
            ::aColors[ CLRLBL_NORMAL ],::aColors[ CLRLBL_HOTKEY ])
        endif
    // Oganize botom of ALL folder
    ::say(2,0, chr( BORDERUPLEFT ) + replicate( chr( BORDERTOP ),;
          ::nWidth - 2 )+ chr( BORDERUPRIGHT ),::aColors[ CLRLBL_NORMAL ])

     if ::nIndex  = 1
            // Left Border of folder
            ::say(2,0, chr( BORDERLEFT )+space( nLabelLen( ::aPrompts[1] )+1 );
            ,::aColors[ CLRLBL_NORMAL ])
     elseif ::nIndex  < len(::aPos)
            ::say(2,::aPos[ ::nIndex ]-1, space(nLabelLen( ::aPrompts[ ::nIndex ]) +2 ) ,;
            ::aColors[ CLRLBL_NORMAL ])
      end
      if ::nIndex  = Len( ::aPos )
            // Last Folder
            ::say(2 ,::aPos[ ::nIndex ]-1, space( ::nWidth- ::aPos[ ::nIndex ])+;
             chr( BORDERRIGHT ),::aColors[ CLRLBL_NORMAL ])
       end
//   endcase

    ::endpaint()
return nil

//---------------------------------------------------------------------

METHOD Click( nMRow, nMCol, lDouble )

    local nCol    := nMCol - ::nLeft()
    local nRow    := nMRow - ::nTop()
    local nWidth  := ::oWnd:nWidth
    local aChilds := ::aChilds
    local nPos    := 0
    local nCurrent := 1

    if nRow =1 // est  en los folders
         While nCurrent < Len( ::aPrompts )
           if nCol >= nPos .and. nCol < ::aPos[ nCurrent +1 ]
               exit // ese es .....
             else
               nCurrent ++
               nPos := ::aPos[ nCurrent ]
           end
        end
        ::SetPage( nCurrent )
        ::Refresh()
      else
        Super:Click(nMRow,nMCol, lDouble )
    end
return nil

//-----------------------------------------------------------

method KeyPressed( nKey )
    local nIndex
    nKey := ::oFocussed:KeyPressed( nKey )
    if nKey > 0
         if chr(nKey) $ ::cHotKey
             // Por si hay un folder sin HotKey
             nIndex := ascan( ::aPrompts, {|x| cGetHotKey(x)=chr(nKey) })
             if nIndex > 0
                 ::setpage(nIndex)
                 ::refresh()
                 nKey := 0
             end
         end
    end
return nKey

//---------------------------------------------------------
METHOD IsHotKey( cKey )
return  cKey $ ::cHotKey
