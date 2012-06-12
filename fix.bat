@echo off

Title Sirefef.P Removal Tool
cls
echo.
echo This tool helps remove Sirefef.P
echo.
echo This variant can be identifed by an "n" file
echo found in Process Explorer in DLL view for explorer.exe
echo.
pause

reg query HKLM\Software\Classes\CLSID\{F3130CDB-AA52-4C3A-AB32-85FFC23AF9C1}\InprocServer32 | find /i "wbemess.dll" > null
if %errorlevel% == 0 goto not_infected
if %errorlevel% == 1 goto infected

:not_infected
cls
echo.
echo Sirefef.P does not seem to be present on this machine
echo.
set /p prompt= Are you sure you want to continue? (Y or N) 
if %prompt% == Y goto repair
if %prompt% == y goto repair
goto quiting

:infected
cls
echo.
echo Sirefef.P infection found on this machine
echo.
pause
goto repair

:repair
cls
echo.
echo Doing repair
reg add HKLM\Software\Classes\CLSID\{F3130CDB-AA52-4C3A-AB32-85FFC23AF9C1}\InprocServer32 /ve /t reg_expand_sz /d ^%systemroot^%\system32\wbem\wbemess.dll /f
reg delete HKCU\Software\Classes\clsid\{42aedc87-2188-41fd-b9a3-0c966feabec1} /f
goto done

:done
cls
echo.
echo Repair has been completed
echo.
echo Reboot your PC to complete the repair
echo.

:quiting
cls
echo.
echo Repair Cancelled.
echo.