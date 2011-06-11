// sistema de edici¢n/ creaci¢n de los drivers de impresora.

#include 'fivedos.ch'
#include 'printer.ch' // array definition
static pr_drv // driver under construccion
static Pr_name // Name of driver
static aFiles:={}, aPrinters:={} , aNames:={}


function Main()
    local oWnd, oLbx, nBx:=1
    local lLoop := .t.

    setmcursor( IDC_CLOCK )

    pr_load()

    define window oWnd from 5,5 to 20, 65 title 'Definicion de Impresoras'

    @ 0,0 listbox oLbx var nBx array aNames of oWnd size 35,12 ;
        prompt '&Impresoras' on dblclick editprn( aPrinters[nBx] , aFiles[nBx,1])

    @ 1, 50 button '&Editar' when !empty(aPrinters) of oWnd ;
        action editprn( aPrinters[nBx] , aFiles[nBx,1])

    @ 4, 50 Button '&Nuevo' of oWnd ;
        action newprn(),pr_load(),oLbx:acItems:=aNames, oLbx:reset()

    @ 6, 50 Button "&Otro" of oWnd // a otro directorio

    @ 10, 50 button '&Salir' action oWnd:end(), lLoop := .f.  of oWnd

    activate window oWnd

return nil



static function PR_LOAD()
    local aLoad
    aFiles:={}
    aPrinters:={}
    aNames:={}
    aFiles := directory('*.drv')
    if !empty( aFiles )
        for n:= 1 to len( aFiles )
                aLoad := uLoadObject( aFiles[n,1] )
                aadd( aPrinters, aLoad )
                aadd( aNames, aLoad[ NAME ] )
        next
     else
        aNames := {'*** No hay Impresoras ***'}
    end
return nil

static function EditPrn( aPrinter, cFile )
    local oWnd, lOk := .f.
    local cMask

    DEFAULT CfILE := SPACE(8)

    aPrinter := drv2get(aPrinter)
    cMask := '@S30 '+repicate('999,',20)
    define dialog oWnd from 4,10 to 21,75

    @ 0,0 get aPrinter[ NAME ] prompt 'Descripcion de la impresora' of oWnd
    @ 1,0 get aPrinter[ RIGHT ] prompt 'Copyright del driver       ' picture '@!' of oWnd
    @ 2,0 get aPrinter[ INIT ] Prompt  'INICIA la Impresora        ' picture cMask
    @ 2,0 get aPrinter[ CON ] prompt '&Comprimido on  ' ;
            picture '999,999,999,999,999' of oWnd
    @ 2,40 get aPrinter[ COFF ] prompt 'off' ;
            picture '999,999,999,999,999' of oWnd
    @ 3,0 get aPrinter[ SON ] prompt '&Sunrayado  on  ' ;
            picture '999,999,999,999,999' of oWnd
    @ 3,40 get aPrinter[ SOFF ] prompt 'off' ;
            picture '999,999,999,999,999' of oWnd
    @ 4,0 get aPrinter[ NON ] prompt '&Negrita    on  ' ;
            picture '999,999,999,999,999' of oWnd
    @ 4,40 get aPrinter[ NOFF ] prompt 'off' ;
            picture '999,999,999,999,999' of oWnd
    @ 5,0 get aPrinter[ EON ] prompt '&Expandida  on  ' ;
            picture '999,999,999,999,999' of oWnd
    @ 5,40 get aPrinter[ EOFF ] prompt 'off' ;
            picture '999,999,999,999,999' of oWnd
    @ 6,0 get aPrinter[ PORT ] prompt 'Puerto de Conexion' Picture '!!!!!!!!';
        of oWnd
    if empty( cFIle )
        cFIle := space(8)
        else
        cFIle := cFName( cFile )
    end

    @ 7,0 get cFile prompt '&Fichero' picture '@!' of oWnd
    @ 9,5 BUTTON '&Aceptar' action lOk := .t., oWnd:end() of oWnd
    @ 9,45 button '&Salir' action oWnd:end() of oWnd

    activate dialog oWnd

    if lOk .and. !empty( cFile )
        lSaveObjects( aPrinter, alltrim(cFile)+'.pdf' )
        if aPrinter[ NAME ]= cDefault
            lSaveObjects( aPrinter, 'Default.pdf' )
        end
    end
return nil


function editprn( aDriver, aName )



static function NewPrn()
    local aPrinter := {space(30),;
                       sPace(30),;
                       sPace(20),;
                       sPace(20),;
                       sPace(20),;
                       sPace(20),;
                       sPace(20),;
                       sPace(20),;
                       sPace(20),;
                       sPace(20),;
                       sPace(20),;
                       sPace(20),;
                        }

    editprn(aPrinter)
return nil


static Function drv2get(aPrinter)
    local n,m, cTemp
    local cMask:=',   '
    for n:=3 to len(aPrinter)
        cTemp := ''
        for m:=1 to len(aPrinter[n])
            cTemp+=strzero(chr(substr(aPrinter[n],1,m)))+','
        next
        aPrinter[n]:= cTemp+replicate(cMask,(80-len(cTemp))/4)
    next
return aPrinter

static Function get2drv(aPrinter)
    local n,m, cTemp, cTemp1
    local cMask:=',   '
    for n:=3 to len(aPrinter)
        cTemp := ''
        for m:=1 to len(aPrinter[n])/4
            cTemp1 :=substr(aPrinter[n],(m-1)*4+1),3)
            if !empty( cTemp1)
                cTemp+=chr(val(cTemp1))
            endif
        next
        aPrinter[n]:= cTemp
    next
return aPrinter
