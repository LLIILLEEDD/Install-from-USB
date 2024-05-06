@echo off
:: Скрипт создан для переноса файлов флешки в корень диска и последуюущую автоматическую установку некоторых программ. Залит на Гитхабе. 
:: Тут есть еще что допиливать, но уже скрипт активно используется в моей практике.
:: The script was created to transfer files from a flash drive to the root of the disk and then automatically install some programs. Uploaded to Github.
:: There is still something to be completed here, but the script is already actively used in my practice.

:: Находим букву диска флешки
:: Find the drive letter of the flash drive
for /f "tokens=2 delims==" %%D in ('wmic logicaldisk where drivetype^=2 get deviceid /value') do (
    set "flashDrive=%%D"
    goto :continue
)
:continue

if not defined flashDrive (
    echo [31mFlash drive not found[0m
    exit /b
)

:: Определяем пути
:: Defining paths
set "sourceFolder=%flashDrive%\install"
set "targetFolder=C:\install"
set "installLogFile=%targetFolder%\InstallLog.txt"
set "desktopPath=%USERPROFILE%\Desktop"
set "desktopLogFile=%desktopPath%\InstallLog.txt"

:: Создаем папку install на C:\ диске
:: Create an install folder on the C:\ drive
if not exist "%targetFolder%" (
    mkdir "%targetFolder%"
    echo C:\install folder created
)

:: Добавляем в Windows Defender исключение
:: Add exceptions to Windows Defender
powershell -Command Add-MpPreference -ExclusionPath "%targetFolder%" -Force
echo Exception added to Windows Defender

echo.
echo.
echo.
echo         [33mLEEETS GOOOO[0m
echo.
echo.
echo.

:: Копируем файлы с флешки в таргет
:: Copy files from the flash drive to the target
xcopy "%sourceFolder%\*" "%targetFolder%\" /s /e /i /h /y
echo.
echo.

:: Логируем создание папки
:: Logging the creation of a folder
call :Log "Files successfully copied from %sourceFolder% to %targetFolder%"
echo.

:: Установка программ
:: Installing programs
call :InstallProgram "7zipSetup.exe" "/S" "7-Zip"
call :InstallProgram "Notepad.8.6.4.exe" "/S /I" "Notepad++"
call :InstallProgram "AdobeAcrobat.exe" "/S" "Adobe Acrobat Reader"
call :InstallProgram "ChromeSetup.exe" "/silent /install" "Google Chrome"
call :InstallProgram "Driver.Booster.exe" "/SILENT" "Driver Booster"
call :InstallProgram "FirefoxSetup.msi" "/q" "Mozilla Firefox"
call :InstallProgram "FSViewerSetup78.exe" "/S" "FastStone Image Viewer"
call :InstallProgram "Flameshot-12.1.0-win64.msi" "/qn" "Flameshot"
call :InstallProgram "JavaSetup.exe" "/s" "Java"
call :InstallProgram "naps2.msi" "/q" "Naps2"
call :InstallProgram "PDF-XChange.exe" "/S /I" "PDF-XChange"
call :InstallProgram "ThunderbirdSetup.exe" "/S" "Mozilla Thunderbird"
call :InstallProgram "vlcwin64.exe" "/S" "VLC Media Player"
echo.
echo.
echo.
echo         [32mWELL DONE BRO[0m
echo.
echo.
echo.
pause
exit /b

:InstallProgram
"%targetFolder%\%~1" %~2
if errorlevel 1 (
    call :Log "Error during installation of %3."
) else (
    call :Log "%~3 installed successfully."
)

goto :eof

:Log
echo %DATE% %TIME% - %* >> "%installLogFile%"
echo %DATE% %TIME% - %* >> "%desktopLogFile%"
echo %DATE% %TIME% - %*

goto :eof

:: Автор: LLIILLEEDD
:: Author: LLIILLEEDD
