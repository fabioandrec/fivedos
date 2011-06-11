@ECHO OFF
CLS
ECHO ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
ECHO ³ FiveDos 1.0 - Octubre 94          Construyendo un EXE para Clipper en DOS   ³
ECHO ³                                   Building an EXE for Clipper in DOS        ³
ECHO ³ (c) A.Linares, F.Pulp¢n, C.G¢mez, J.Mariano                                 ³
ECHO ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ECHO.

if A%1 == A GOTO :SINTAX
if NOT EXIST %1.prg GOTO :NOEXIST

ECHO Llamando al compilador de Clipper...
clipper %1 /n/w/i..\include %2
rem IF ERRORLEVEL 1 GOTO EXIT

REM If you don't use a Dos extender like Blinker 3, ExoSpace or
REM CauseWay, comment next four lines...

if NOT EXIST extend.prg GOTO :NOCOMPEXT
if EXIST extend.obj GOTO :NOCOMPEXT
clipper extend.prg
IF ERRORLEVEL 1 GOTO EXIT

:NOCOMPEXT

ECHO ÿ
ECHO Llamando al enlazador...

BLINKER fi %1 @..\include\blinker map a,s
rem RTLink fi %1 @..\include\rtlink
rem \causeway\wl32 /m  %1, extend ..\lib\fivedos.lib ..\lib\501_520.lib c:\causeway\lsclp52.lib
rem exospace fi %1 @..\include\exospace.lnk
IF ERRORLEVEL 1 GOTO LINKERROR
ECHO * El ejecutable ha sido construido satisfactoriamente *
ECHO ÿ
smartdrv /C
GOTO EXIT

:LINKERROR
PAUSE * Han habido errores al enlazar *
GOTO EXIT

:SINTAX
ECHO    SINTAXIS: Build [Programa]     {-- No especifiques la extensi¢n .PRG
ECHO                                   {-- Don't specify .PRG extension
GOTO EXIT

:NOEXIST
ECHO Not exist the specified PRG - No existe el fichero PRG especificado

:EXIT
