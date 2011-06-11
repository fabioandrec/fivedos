@echo off
SET PATH=C:\Clip53\BIN;C:\Clip00\BIN;C:\Clip00\NG;%PATH%
SET INCLUDE=C:\FiveTech\FiveDOS\INCLUDE;C:\Clip53\INCLUDE;
SET LIB=C:\FiveTech\FiveDOS\LIB;C:\Clip53\LIB;c:\Clip00\lib;
SET OBJ=C:\FiveTech\FiveDOS\OBJ;C:\Clip53\OBJ;c:\Clip00\obj;
rem set clippercmd=
PROMPT - FiveDOS $P$g
IF "%1==" GOTO DEFECTO
CD %1
GOTO FIN
:DEFECTO
cd c:\FiveTech\FiveDOS\lolo
:FIN
