@echo off

Title Sirefef.P Removal Tool
cls
echo.
echo This tool helps remove Sirefef.P
echo.
echo This variant can be identifed by an "n" file
echo found in Process Explorer in DLL view for explorer.exe

reg query HKLM\CLSID\{F3130CDB-AA52-4C3A-AB32-85FFC23AF9C1}\InprocServer32 | find /i "wbemess.dll" > null
if %errorlevel% == 0 goto not_infected
if %errorlevel% == 1 goto infected

:not_infected
cls
echo.
echo Sirefef.P does not seem to be present on this machine
echo.
set /p question= Are you sure you want to continue? (Y or N)
if %question% == Y goto repair
if %question% == y goto repair
goto quiting

:infected
cls
echo.
echo Sirefef.P infection found on this machine
echo.
set /p question2= Ready to start repair? (Y or N)
if %question2% == Y goto repair
if %question2% == y goto repiar
goto quiting

:repair
cls
echo.
echo Doing repair
reg add HKLM\CLSID\{F3130CDB-AA52-4C3A-AB32-85FFC23AF9C1}\InprocServer32 /ve /t reg_expand_sz /d ^%systemroot^%\system32\wbem\wbemess.dll
reg delete HKCU\Software\Classes\clsid\{42aedc87-2188-41fd-b9a3-0c966feabec1}
goto done

:done
cls
echo.
echo Repair has been completed
echo.
echo Reboot your PC to complete the repair

:quiting
cls
echo.
echo Repair Cancelled.