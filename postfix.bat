@echo off

Title Confirming clean
echo.
echo Please wait.
echo.

reg query HKLM\Software\Classes\CLSID\{F3130CDB-AA52-4C3A-AB32-85FFC23AF9C1}\InprocServer32 | find /i "wbemess.dll" > null
if %errorlevel% == 0 goto not_infected
if %errorlevel% == 1 goto infected

reg query HKCU\Software\Classes\clsid\{42aedc87-2188-41fd-b9a3-0c966feabec1}
if %errorlevel% == 0 goto not_infected
if %errorlevel% == 1 goto infected

:not_infected
cls
echo.
echo Congrats, Sirefef.P is no longer loading
echo.
echo Cleaning up the remnants of the infection
goto detect

:infected
echo.
echo The fix didn't work. Please seek additional assitance.
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
if %Version% == XP goto XP_clean
if %Version% == Vista goto Vista_clean
if %Version% == 7 goto 7_clean

:XP_clean
for /f "usebackq delims=" %%i in (`dir /A:H /B %windir%\Installer`) do set bad_dir=%%
rmdir /s /q %windir%\Installer\%bad_dir%
rmdir /s /q %appdata%\%bad_dir%
goto done

:Vista_clean
for /f "usebackq delims=" %%i in (`dir /A:H /B %windir%\Installer`) do set bad_dir=%%
rmdir /s /q %windir%\Installer\%bad_dir%
rmdir /s /q %localappdata%\%bad_dir%
goto done

:7_clean
for /f "usebackq delims=" %%i in (`dir /A:H /B %windir%\Installer`) do set bad_dir=%%
rmdir /s /q %windir%\Installer\%bad_dir%
rmdir /s /q %localappdata%\%bad_dir%
goto done

:done
cls
Title Repair done
echo.
echo Repair has been completed
echo.
del %0
rmdir /s /q /sirefefp_fix
pause
exit

:error
cls
echo.
echo An unexpected error has occured.
echo.
pause
exit