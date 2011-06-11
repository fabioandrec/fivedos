/*************
*   Errsys2.prg
*   From Standard Clipper 5.0 error handler
*   Proced from FiveDos
*   Compile:  /m/n/w
*/

#include "error.ch"
#include "FiveDos.ch"
#include "SysStr.ch"


#define NTRIM(n)        ( LTrim(Str(n)) )

/*************
*    ErrorSys()
*
*    Note:  automatically executes at startup
*/
/*
proc ErrorSys()
    ErrorBlock( { | e | ErrorDialog( e ) } )
return
*/

/*************
*   ErrorDialog()
*/
function ErrorDialog( e )                  // -> logical  or quits App.

    local oDlg
    local lRet                                    // if lRet == nil -> default action: QUIT
    local i, cMessage, aStack := {}
    local nButtons := 1
    local lLog := .F., cTemp, nFile

    local aSysMsg := aSysStr()

    // by default, division by zero yields zero
    if ( e:genCode == EG_ZERODIV )
        return (0)
    end


    // for network open error, set NETERR() and subsystem default
    if ( e:genCode == EG_OPEN .and. e:osCode == 32 .and. e:canDefault )

        NetErr(.t.)
        return .f.                                 // Warning: Exiting!

    end


    // for lock error during APPEND BLANK, set NETERR() and subsystem default
    if ( e:genCode == EG_APPENDLOCK .and. e:canDefault )

        NetErr(.t.)
        return .f.                                 // OJO SALIDA

    endif

    if e:canRetry
        nButtons++
    endif

    if e:canDefault
        nButtons++
    endif


    // build error message
    cMessage := ErrorMessage(e)


    i := 2
    while ( i < 74 )

        if !Empty(ProcName(i))
            AAdd( aStack, "Called from " + Trim(ProcName(i)) + ;
                "(" + NTRIM(ProcLine(i)) + ")" )
        endif

        i++
    end

    DEFINE DIALOG oDlg AT nil, nil SIZE 67, 17 ;
        TITLE ( F2VERSION + " Error dialog box" )

    @ 1, 2 SAY cMessage COLOR "gr+/bg" OF oDlg

    i = aStack[ 1 ]

    @  3, 2 LISTBOX i ;
            ARRAY aStack OF oDlg ;
            SIZE 45 , 9 ;
            PROMPT '&Pila de Llamadas'

    @ 13, 11 CHECKBOX lLog PROMPT '&Generar "Error.log"' OF oDlg

    @ if( nButtons > 1, 4, 7 ), 50 BUTTON "&Quit"           ;
                                        SIZE 12, 3          ;
                                        ACTION oDlg:Close()   ;
                                        OF oDlg

    if e:canRetry
        @ if( nButtons == 2, 10, 9 ), 50 BUTTON "&Retry"    ;
                                        SIZE 12, 1          ;
                                        ACTION ( lRet := .t., oDlg:Close() ) ;
                                        OF oDlg
    endif

    if e:canDefault
        @ 12, 50 BUTTON "De&fault"      ;
                            SIZE 12, 1  ;
                            ACTION ( lRet := .f., oDlg:Close() ) ;
                            OF oDlg

    endif

    ACTIVATE DIALOG oDlg

    if lLog
        
        if ( nFile := FOpen( 'Error.log', 2 ) ) < 0
            FCreate( 'error.log', 0 )
            nFile = FOpen( 'Error.log', 2 )
        else
            FSeek( nFile, 0, 2 )            // salto al final del fichero ...
        endif

        cTemp    = "------>" + dtoc( date() ) + "  " + time() + CRLF
        cMessage = "------>" + cMessage + CRLF
        FWrite( nFile, cTemp, len( cTemp ) )
        FWrite( nFile, @cMessage )

        /*
        for i = 1 TO len( aStack )
            cTemp = "   " + aStack[ i ] + CRLF
            FWrite( nFile, cTemp, len( cTemp ) )
        next
        */

        cTemp = cErrorLog( 2 )
        FWrite( nFile, cTemp, len( cTemp ) )

        FClose( nFile )

    endif

    if lRet == nil
        ErrorLevel( 1 )
        QUIT                                // --------->  OJO QUIT
    endif

return lRet

//---------------------------------------------------------------------------//

/*************
*    ErrorMessage()
*/
static func ErrorMessage(e)

    // start error message
    local cMessage := if( empty( e:osCode ), ;
        if( e:severity > ES_WARNING, "Error ", "Warning " ),;
        "(Error DOS " + NTRIM(e:osCode) + ") " )

    // add subsystem name if available
    cMessage += if( ValType( e:subsystem ) == "C",;
        e:subsystem()                ,;
        "???" )

    // add subsystem's error code if available
    cMessage += if( ValType( e:subCode ) == "N",;
        "/" + NTRIM( e:subCode )   ,;
        "/???" )
    // add error description if available
    if ( ValType(e:description) == "C" )
        cMessage += "  " + e:description
    end

    // add either filename or operation
    cMessage += if( !Empty( e:filename ),;
        ": " + e:filename   ,;
        if( !Empty( e:operation ),;
        ": " + e:operation   ,;
        "" ) )
return cMessage

//---------------------------------------------------------------------------//
