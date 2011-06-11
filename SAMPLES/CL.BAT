@ECHO OFF
CLS
ECHO ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
ECHO ³ FiveDos 1.0 - December 94       CA-Clipper, xBase & OOPS development power ³Ü
ECHO ³ (c) FiveTech, 1993-4             for Microsoft Windows, IBM-OS2 and MsDos  ³Û
ECHO ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
ECHO ÿ ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ECHO ÿ

if A%1 == A GOTO :SINTAX
if NOT EXIST %1.prg GOTO :NOEXIST

ECHO Llamando al compilador de Clipper...
\clipper5\bin\clipper %1 /n/w/i..\include;\clipper5\include
IF ERRORLEVEL 1 GOTO EXIT

REM If you don't use a Dos extender like Blinker 3, ExoSpace or
REM CauseWay, comment next four lines...

if NOT EXIST extend.prg GOTO :NOCOMPEXT
if EXIST extend.obj GOTO :NOCOMPEXT
\clipper5\bin\clipper extend.prg
IF ERRORLEVEL 1 GOTO EXIT

:NOCOMPEXT

ECHO ÿ
ECHO Llamando al enlazador...

if /%2 == //p goto BLINKERP
if /%2 == //P goto BLINKERP

if /%2 == //r goto rtlink
if /%2 == //R goto rtlink

if /%2 == //e goto ExoSpace
if /%2 == //E goto ExoSpace

if /%2 == //b goto BLINKER
if /%2 == //B goto BLINKER

if /%2 == //c goto CAUSEWAY
if /%2 == //C goto CAUSEWAY

rem Por defecto coge BLINKER en modo real
:BLINKER
echo BLINKER EN MODO REAL
BLINKER file %1 lib fivedos
goto ENDLINK

:BLINKERP
echo BLINKER EN MODO PROTEGIDO
BLINKER file %1 @..\include\blinker
goto ENDLINK

:RTLink
echo RTLINK EN MODO REAL
RTLINK file %1 @..\include\RTLink
goto ENDLINK

:ExoSpace
echo EXOSPACE EN MODO PROTEGIDO
EXOSPACE file %1 @..\include\EXOSPACE
goto ENDLINK

:CAUSEWAY
echo CAUSEWAY EN MODO PROTEGIDO DE 32 BIT
WL32 /lc:\clipper5\cwdef\blinker.def FILE %1 @..\include\cw.lnk
goto ENDLINK

:ENDLINK
IF ERRORLEVEL 1 GOTO LINKERROR
ECHO * El ejecutable ha sido construido satisfactoriamente *
ECHO ÿ
%1
GOTO EXIT

:LINKERROR
PAUSE * Han habido errores al enlazar *
GOTO EXIT

:SINTAX
ECHO    SINTAXIS: Build [Programa] /op    {-- No especifiques la extensi¢n .PRG
ECHO                                      {-- Don't specify .PRG extension
echo    Siendo op P o p blinker protegido
echo              R o r RTLink  real
echo              C o c CauseWay protegido 32 bit
echo              E o e ExoSpace protegido
echo              B o b Blinker real por defecto
ECHO ÿ
ECHO ÿ
GOTO EXIT

:NOEXIST
ECHO Not exist the specified PRG - No existe el fichero PRG especificado

:EXIT
