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
if %prompt% == Y goto sanity
if %prompt% == y goto sanity
goto quiting

:infected
cls
echo.
echo Sirefef.P infection found on this machine
echo.
pause
goto sanity

:sanity
if not exist "\sirefefp_fix\postfix.bat" goto error
goto repair

:repair
cls
reg add HKLM\Software\Classes\CLSID\{F3130CDB-AA52-4C3A-AB32-85FFC23AF9C1}\InprocServer32 /ve /t reg_expand_sz /d ^%systemroot^%\system32\wbem\wbemess.dll /f
reg delete HKCU\Software\Classes\clsid\{42aedc87-2188-41fd-b9a3-0c966feabec1} /f
goto check

:check
reg query HKLM\Software\Classes\CLSID\{F3130CDB-AA52-4C3A-AB32-85FFC23AF9C1}\InprocServer32 | find /i "wbemess.dll" > null
if %errorlevel% == 0 goto detect
if %errorlevel% == 1 goto still_infected

reg query HKCU\Software\Classes\clsid\{42aedc87-2188-41fd-b9a3-0c966feabec1}
if %errorlevel% == 0 goto detect
if %errorlevel% == 1 goto still_infected

:still_infected
echo.
echo Something didn't go as planned here.
pause
goto error

:detect
SET Version=Unknown

VER | FINDSTR /IL "5.1."
IF %ERRORLEVEL% EQU 0 SET Version=XP > null

VER | FINDSTR /IL "6.0."
IF %ERRORLEVEL% EQU 0 SET Version=Vista > null

VER | FINDSTR /IL "6.1."
IF %ERRORLEVEL% EQU 0 SET Version=7 > null

if %Version% == Unknown goto error
if %Version% == XP goto XP_start
if %Version% == Vista goto Vista_start
if %Version% == 7 goto 7_start

:XP_start
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce /v postfix /t reg_sz /d "\sirefefp_fix\postfix.bat" /f > null
goto done

:Vista_start
schtasks /create /sc onlogon /tn postfix /tr "\sirefefp_fix\postfix.bat" /RL HIGHEST /F
goto done

:7_start
schtasks /create /sc onlogon /tn postfix /tr "\sirefefp_fix\postfix.bat" /RL HIGHEST /F
goto done

:done
cls
Title Fix done
echo.
echo Fix has been completed
echo.
echo Reboot your PC to clean up
echo.
pause
exit

:error
cls
echo.
echo An unexpected error has occured.
echo.
pause
exit

:quiting
cls
echo.
echo Repair Cancelled.
echo.
pause
exit

::(C) 2012 Derek Morton
:: This tool is free software licensed under GPLv3. See LICENSE.txt for complete details.