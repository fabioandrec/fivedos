

/* Generate error log file with Clipper internal stack values.
*/

#define CRLF CHR( 13 ) + CHR( 10 )
#define NTRIM(n)        ( LTrim(Str(n)) )

//---------------------------------------------------------------------------//

function cErrorLog( nProcDeep )

    local i := nProcDeep
    local j
    local cErrorLog := ""
    
    while !Empty( ProcName( ++i ) )
        cErrorLog += "Called from " + Trim(ProcName(i)) + ;
                          "(" + NTRIM(ProcLine(i)) + ")" + CRLF
        cErrorLog += ParamInfo( i )
        cErrorLog += LocalInfo( i )
    end

    cErrorLog += CRLF + "DataBases in use" + CRLF + "================" + CRLF
    for i = 1 to 255
        if ! Empty( Alias( i ) )
            cErrorLog += CRLF + Str( i, 3 ) + ": " + If( Select() == i, "=> ", "   " ) + ;
                            Alias( i ) + CRLF
            cErrorLog += "     Indexes in use" + CRLF
            for j = 1 to 15
                if ! Empty( ( Alias( i ) )->( IndexKey( j ) ) )
                    cErrorLog += Space( 8 ) + ;
                            If( ( Alias( i ) )->( IndexOrd() ) == j, "=> ", "   " ) + ;
                            ( Alias( i ) )->( IndexKey( j ) ) + CRLF
                endif
            next
        endif
    next

    i = 1
    cErrorLog += CRLF + "Classes in use:" + CRLF
    cErrorLog += "===============" + CRLF
    while ! Empty( __ClassNam( i ) )
        cErrorLog += "   " + Str( i, 3 ) + " " + __ClassNam( i++ ) + CRLF
    end

return cErrorLog

//---------------------------------------------------------------------------//

static function ParamInfo( nProcDeep )
    local nParams := ParamCount( ++nProcDeep )
    local i, cInfo, uVal

    if nParams > 0
        cInfo =  " - Parameters Info:" + CRLF
        cInfo += "   Param    Type    Value" + CRLF
        cInfo += "------------------------------------------------------------" + CRLF
    else
        return  "   **  No parameters received  **" + CRLF
    endif

    for i = 1 to    nParams
        uVal = GetParam( nProcDeep, i )
        cInfo += str( i, 8 ) + "      " + ValType( uVal ) + "      " + left( cValToChar( uVal ), 56 ) + CRLF
    next

return cInfo

//---------------------------------------------------------------------------//

static function LocalInfo( nProcDeep )
    local nLocals := LocalCount( ++nProcDeep )
    local i, cInfo, uVal

    if nLocals > 0
        cInfo =  " - Local Vars Info:" + CRLF
        cInfo += "   Local    Type    Value" + CRLF
        cInfo += "------------------------------------------------------------" + CRLF
    else
        return  "   **  No locals defined  **" + CRLF
    endif

    for i = 1 to nLocals
        uVal = GetLocal( nProcDeep, i )
        cInfo += str( i, 8 ) + "      " + ValType( uVal ) + "      " + left( cValToChar( uVal ), 56 ) + CRLF
    next

return cInfo

//---------------------------------------------------------------------------//
