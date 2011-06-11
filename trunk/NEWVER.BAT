set FDOSFILE=FDOS13R1

cd obj
del _appinit.obj
del mstext.obj
cd..
call mfd.bat

cd samples
call clean.bat
cd..
cd ide
call clean.bat
cd..

pkzip -P %FDOSFILE% readme.txt whatsnew.txt bitmaps\*.* -x*.~bm
del ide\obj\*.obj
pkzip -P -r %FDOSFILE% -x*.exe ide\*.* -xide\*.ntx icons\*.* include\*.* -x*.map -x*.bak -xintern\*.* -xinternal\*.*
pkzip -P %FDOSFILE% lib\FiveDos.lib lib\501_520.lib
pkzip -P %FDOSFILE% manual\*.ng manual\*.hlp
pkzip -P %FDOSFILE% source\classes\*.PRG source\function\*.PRG
pkzip -P %FDOSFILE% -r -x*.exe samples\*.* -x*.map -x*.ntx -x*.exe -x*.obj -x*.bak -x*.bif


pkzip -z<version %FDOSFILE%

rem zip2exe %FDOSFILE%.zip
rem del %FDOSFILE%.zip
rem del %FDOSFILE%.ins
ren %FDOSFILE%.exe %FDOSFILE%.ins
