// generacion del c¢digo para el generador .. ide
#include "FiveDos.ch"
#include "fontdef.h"
function gencode( oBject, nOrder )
    local cCode  := ""
    local ClassName := ""
    local n

    DEFAULT nOrder := 0


    if Valtype( oBject ) != 'O'
        return 'LLamada Erronea con tipo ' + valtype( oBject )
    endif

    ClassName := oBject:ClassName()

    do case
        //  WINDOWS ----------
        Case ClassName == 'TWINDOW'
             // apertura de la funcion
            cCode += "FUNCTION Window("+ if( !Object:lmodal,;
                 "oWndPar", "") + ")" + CRLF

            cCode += "    local oWnd " + CRLF

            for n:= 1 to len ( Object:oClient:aChilds )
                cCode += "    local " + Object:oCLient:aChilds[ n ]:cVarName +;
                strzero( n, 2) + CRLF
            end
            if !empty( Object:oBar )
                cCode += "    local " +Object:oBar:cVarName + CRLF
            end

            // la ventana
            cCode += "    DEFINE " + IF( Object:lModal, "DIALOG ", "WINDOW " )
            cCode +=  "oWnd AT " + transform( Object:nTop, "99") +;
                         ", "+transform( Object:nLeft, "99")
            cCode += " SIZE "+ transform( Object:nWidth, "99") +;
                         ", "+transform( Object:nheight, "99")

            if !Empty( Object:cTitle )
                cCode += ";" + CRLF +"        TITLE '" + Object:cTitle +"'"
            end

            cCode += ";" + CRLF + "        BRUSH '" + Object:cChar +"'"

            if Object:oMenu != nil
                cCode += ";" + CRLF + "        MENU MN" + strzero( nOrder , 2);
                + "() ; // rename if necesary "
            end

        /*
            if ! Object:lMinimize
                cCode += ";" + CRLF + "        NOMINIMIZE"
            endif

            if ! Object:Maximize
                cCode += ";" + CRLF + "         NOMAXIMIZE"
            end
        */
            if  ! Object:lDrag
                cCode += ";" + CRLF + "         NOMOVE"
            end

            if !Object:lModal
                cCode += ";" + CRLF + "        OF oWndPar"+ CRLF +CRLF
              else
                cCode +=  CRLF +CRLF
            end

            if !empty( Object:oBar )
                cCode += gencode( Object:oBar , )
            end

            // ya se que el bucle es optimizable ... pero asi lo puedo 'debugear'

            for n:= 1 to len ( Object:oClient:aChilds )
                cCode += GenCode( Object:oCLient:aChilds[ n ],  n  ,;
                 Object:cVarName )
            end


            for n:= 1 to len( Object:aWindows )
                cCode += "    oWnd"+strzero( n, 2)+"()"+ CRLF
            next

            // if Object:lModal
                cCode += CRLF+ CRLF+ "    ACTIVATE WINDOW " + Object:cVarName
            // end

            cCode += CRLF +CRLF+ CRLF+ "Return nil" + CRLF +CRLF +CRLF+ CRLF

            for n:= 1 to len( Object:aWindows )
                cCode += GenCode( Object:aWindows[ n ], nOrder)
            next

            if Object:oMenu != nil .and. len( Object:oMenu:aChilds ) > 1
                cCode += 'FUNCTION MNU'+ strzero( nOrder, 2) +"()" +CRLF
                cCode += gencode( Object:oMenu , nOrder , 'oBar' )
                cCode += "RETURN oMenu" + CRLF
            end

        Case ClassName == 'TGET'

           //  GET --------------------------------------

            cCode += "    @ " + Transform( Object:nTop ,"99" )+ ", " +;
                 Transform( Object:nLeft, "99" )
            cCode += " GET " + alltrim( Object:cVarName ) + strzero(nOrder,2) +;
                        " "

            if !empty( Object:oLabel:cText )
                 cCode += "     PROMPT  '" + Object:oLabel:cText + "' "
            end

            if !empty( Object:cMessage )
                 cCode += "     MESSAGE "+ Object:cMessage
            end
            cCode += " OF oWnd" + CRLF +CRLF

        Case ClassName == 'TSAY'
            // TSAY -------------------------------------

            cCode += "    @ "+ alltrim( str( Object:nTop ) ) + "," +;
                         alltrim( str( Object:nLeft ) )
            cCode += ' SAY "' + Eval( Object:bGetText ) +'" OF oWnd' +;
                         CRLF + CRLF

        Case ClassName == 'TLISTBOX'
            // TLISTBOX -----------------------------------------

            cCode += "    @ "+ alltrim( str( Object:nTop ) ) + "," +;
                         alltrim( str( Object:nLeft ) )
            cCode += " LISTBOX "+ Object:cVarName+strzero( nOrder, 2 ) +;
                     " ARRAY {"
            cCOde += '"' + Object:acItems[ 1 ] + '"'
            for n := 2 to len ( Object:acItems )
                cCOde += ',;' + CRLF + '         "' + Object:acItems[ n ] + '"'
            next
            cCode += "} "
            if Object:nLabel = 1
                cCode += ' LABEL "' + Object:oLabel:cText + '"'
            end
            cCode +=' OF oWnd' + CRLF + CRLF

        case ClassName == 'TRADMENU'
            // TRadio Menu ------------------------------------------

            cCode += "    @ "+ alltrim( str( Object:nTop ) ) + "," +;
                         alltrim( str( Object:nLeft ) )
            cCode += " RADIO "+ Object:cVarName+strzero( nOrder, 2 ) +;
                     " ARRAY {"
            cCOde += '"' + Object:aChilds[ 1 ]:cText + '"'
            for n := 2 to len ( Object:aChilds )
                cCOde += ',;' + CRLF + '         "' + Object:aChilds[ n ]:cText;
                 + '"'
            next
            cCode += "} "
            if Object:nHeight > len( Object:aChilds )
                cCode += ' LABEL "' + Object:oLabel:cText + '"'
            end
            cCode +=' OF oWnd' + CRLF + CRLF

        case ClassName == 'TBUTTON'

            cCode += "    @ "
            cCode += Transform( Object:nTop, "99" ) + ", "
            cCode += Transform( Object:nLeft, "99" )
            if !empty( Object:cBmpChars )
                 cCode += '  FILE "' + Object:cBmp +'"'
            end
            cCode += ' BUTTON "' + substr( Object:oLabel:cText, len( Object:cBmpChars ) + 1,;
                  len( Object:oLabel:cText ) ) + '"'
            cCode +=' SIZE ' + alltrim( str( Object:nWidth - 1 )) + "," +;
                          alltrim( str( Object:nHeight -1 ))

            cCode  += " OF oWnd  // ACTION <your action> " + CRLF

        Case ClassName == 'TCHECKBOX'

            cCode += "    @ "
            cCode += Transform( Object:nTop, "99" ) + ", "
            cCode += Transform( Object:nLeft, "99" )
            cCOde += ' CHECKBOX '+ Object:cVarName + strzero( nOrder, 2 )
            cCode += ' PROPMT' + Object:cText
            cCode += " OF oWnd" + CRLF + CRLF

        Case ClassName == 'TBTNBAR'
            tock()
            cCode += '    DEFINE BAR '+ Object:cVarNAme +' OF oWnd'+  CRLF
            for n:=1 to len ( oBject:aChilds )
                cCode += '    DEFINE BUTTON'
                if !empty( Object:aChilds[ n ]:cBmp )
                    cCode += ' FILE '+ Object:aChilds[ n ]:cBmp
                end
                if len( Object:aChilds[ n ]:cChars ) > ;
                        Len( Object:aChilds[ n ]:cBmp )
                    cCode += ' PROMPT "' + substr( Object:aChilds[ n ]:cChars,;
                            Len( Object:aChilds[ n ]:cBmp )+1 , ;
                            Len( Object:aChilds[ n ]:cChars ) ) + '"'
                 endif
                 cCode += ' OF oWnd' + CRLF
           next

        case ClassName == 'TSCROLLBAR'
            cCode +=  "    @ "
            cCode += Transform( Object:nTop, "99" ) + ", "
            cCode += Transform( Object:nLeft, "99" )
            cCode += ' SCROLLBAR '+ Object:cVarName + strzero( nOrder, 2 )
            cCode += if( Object:lHorizontal,' HORIZONTAL ',' VERTICAL ')
            cCode += '  SIZE '+ tran( Object:nLen + if( Object:lHorizontal,;
                  5 , 2 ), '99') + CRLF + CRLF

        Case ClassName == 'TCOMBOBOX'
            // COMBOBOX -----------------------------------------

            cCode += "    @ "+ alltrim( str( Object:nTop ) ) + "," +;
                         alltrim( str( Object:nLeft ) )
            cCode += " COMBOBOX "
            cCode += Object:cVarName+strzero( nOrder, 2 ) +;
                     " ARRAY {"
            cCOde += '"' + Object:oList:acItems[ 1 ] + '"'
            for n := 2 to len ( Object:oList:acItems )
                cCOde += ',;' + CRLF + '         "' + Object:oList:acItems[ n ] + '"'
            next
            cCode += "} "
            if ! empty( Object:oLabel:cText )
                cCode += ' LABEL "' + Object:oLabel:cText + '"'
            end
            cCode +=' OF oWnd' + CRLF + CRLF


        case ClassName == 'TMENUBAR'
            if len( Object:aChilds ) > 1
                // hay algo m s que el menu del sistema
                nOrder := 0
                cCode += '  MENU oMenu' + CRLF
                nOrder++
                for n:= 2 to len( oBject:aChilds ) // nos saltamos el menu del sistema
                    cCode += '       MENUITEM "' + Object:aChilds[ n ]:cItem + '"'
                    if !empty( Object:aChilds[ n ]:cMessage )
                        cCode += ' MESSAGE "' + Object:aChilds[ n ]:cMessage+ '"'
                    end
                    if Object:aChilds[ n ]:nShortCut > 0
                        cCode += ' SHORTCUT ' +;
                         strzero( Object:aChilds[ n ]:nShortCut , 3 )
                    end
                    cCode += ' // Action <Your action>' + CRLF
                    if valtype( Object:aChilds[ n ]:oSubMenu ) == 'O'
                        cCode += gencode( Object:aChilds[ n ]:oSubMenu ,;
                            nOrder)
                    end
               next

                 cCode += '    ENDMENU' + CRLF
           end
        case ClassName == 'TMENUBOX'

            cCode += space( 8 + nOrder*4 ) + 'MENU'+ CRLF
            nOrder++
            for n:= 1 to len( oBject:aChilds )
                cCode += space( 8 + nOrder*4 ) + 'MENUITEM "';
                     + Object:aChilds[ n ]:cItem + '"'
                if !empty( Object:aChilds[ n ]:cMessage )
                    cCode += ' MESSAGE "' + Object:aChilds[ n ]:cMessage + '"'
                end
                if Object:aChilds[ n ]:nShortCut > 0
                    cCode += ' SHORTCUT ' +;
                     strzero( Object:aChilds[ n ]:nShortCut , 3 )
                end
                cCode += ' // Action <Your action>' + CRLF
                if valtype( Object:aChilds[ n ]:oSubMenu ) == 'O'
                    cCode += gencode( Object:aChilds[ n ]:oSubMenu ,;
                        nOrder)
                end

            next

            nOrder --
            cCode += space( 8 + nOrder*4 ) + 'ENDMENU' + CRLF
        oTherWise
            cCode += CRLF + '// No code for ' + ClassName + CRLF


    endcase

return cCode

