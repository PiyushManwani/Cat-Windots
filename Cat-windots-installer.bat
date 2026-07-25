@echo off
setlocal EnableDelayedExpansion
title Cat-Windots Installer
color 0D

cd /d "%~dp0"

:: Auto-detect layout: script can sit either OUTSIDE Cat-Windots\
:: (next to the folder) or be placed INSIDE Cat-Windots\ itself.
set "HERE=%~dp0"
if "%HERE:~-1%"=="\" set "HERE=%HERE:~0,-1%"

set "DOTS="
if exist "%HERE%\Cat-Windots\Dots-Apply" goto :FOUND_NESTED
if exist "%HERE%\Dots-Apply" goto :FOUND_HERE
goto :NOT_FOUND

:FOUND_NESTED
set "DOTS=%HERE%\Cat-Windots"
goto :LAYOUT_DONE

:FOUND_HERE
set "DOTS=%HERE%"
goto :LAYOUT_DONE

:NOT_FOUND
:LAYOUT_DONE

cls
echo.
echo  =================================================================
echo.
echo        /\_____/\    Cat-Windots Installer
echo       /  o   o  \   Catppuccin Mocha Windows Setup
echo      ( ==  ^|  == )
echo       )         (
echo      (           )
echo     ( (  )   (  ) )
echo    (__(__)___(__)__)
echo.
echo  =================================================================
echo.
echo  This script will:
echo    [1]  Check / install Winget
echo    [2]  Install core apps (GlazeWM, YASB, Starship, WinTerminal...)
echo    [3]  Install fonts (JetBrainsMono Nerd Font)
echo    [4]  Install optional apps (Discord, Spotify, YouTube Music, VSCode)
echo    [5]  Install Windhawk (taskbar + start menu styler)
echo    [6]  Apply Catppuccin Mocha Windows theme
echo    [7]  Copy config files (GlazeWM, YASB, Starship, Terminal)
echo    [8]  Apply ExplorerBlurMica
echo    [9]  Run Neura AI installer
echo.
echo  Place this script next to, or inside, the Cat-Windots\ folder
echo.
echo  =================================================================
echo.

:: Verify we found a valid Cat-Windots structure
if not defined DOTS (
    echo  [FAIL] Cannot find the Cat-Windots dotfiles next to this script.
    echo.
    echo         Looked for:
    echo           %HERE%\Cat-Windots\Dots-Apply
    echo           %HERE%\Dots-Apply
    echo.
    echo         This .bat file must be placed either:
    echo           - In the same folder as Cat-Windots\  ^(next to it^), or
    echo           - Directly inside the Cat-Windots\ folder itself
    echo.
    echo         Current script location: %HERE%
    echo.
    dir /b "%HERE%"
    echo.
    pause
    exit /b 1
)
echo  [OK] Found dotfiles at: %DOTS%
echo.

:: ---- Elevation check + auto-relaunch as Admin ----
fsutil dirty query %systemdrive% >nul 2>&1
if errorlevel 1 (
    echo  [WARN] Not running as Administrator. Re-launching elevated...
    echo.
    set "SELF=%~f0"
    powershell -NoProfile -Command "Start-Process cmd.exe -ArgumentList '/k \"cd /d %~sdp0 && %~s0\"' -Verb RunAs"
    exit /b
)

echo  [OK] Running as Administrator.
echo.
pause

:: ============================================================
:: [1] WINGET
:: ============================================================
cls
echo.
echo  [1/9] Checking winget...
echo  -----------------------------------------------------------------
winget --version >nul 2>&1
if errorlevel 1 (
    echo  [INFO] winget not found. Opening Microsoft Store...
    start ms-windows-store://pdp/?productid=9NBLGGH4NNS1
    echo.
    echo  Install "App Installer" from the Store, then press any key.
    pause
    winget --version >nul 2>&1
    if errorlevel 1 (
        echo  [FAIL] winget still not found. Cannot continue.
        pause
        exit /b 1
    )
)
echo  [OK] winget ready.

:: ============================================================
:: [2] CORE APPS
:: ============================================================
cls
echo.
echo  [2/9] Installing core apps...
echo  -----------------------------------------------------------------

echo.
echo  -- GlazeWM --
winget install --id glzr-io.glazewm -e --accept-source-agreements --accept-package-agreements

echo.
echo  -- YASB (Yet Another Status Bar) --
winget install --id AmN.yasb -e --accept-source-agreements --accept-package-agreements

echo.
echo  -- Starship prompt --
winget install --id Starship.Starship -e --accept-source-agreements --accept-package-agreements

echo.
echo  -- Windows Terminal --
winget install --id Microsoft.WindowsTerminal -e --accept-source-agreements --accept-package-agreements

echo.
echo  -- Windhawk --
winget install --id RamenSoftware.Windhawk -e --accept-source-agreements --accept-package-agreements

echo.
echo  -- Zen Browser --
winget install --id MozillaZen.ZenBrowser -e --accept-source-agreements --accept-package-agreements

echo.
echo  -- Git --
winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements

echo.
echo  [OK] Core apps done.
pause

:: ============================================================
:: [3] FONTS
:: ============================================================
cls
echo.
echo  [3/9] Installing JetBrainsMono Nerd Font...
echo  -----------------------------------------------------------------
echo.
winget install --id DEVCOM.JetBrainsMonoNerdFont -e --accept-source-agreements --accept-package-agreements
if errorlevel 1 (
    echo.
    echo  [INFO] winget font install failed. Trying manual download...
    set "FONT_ZIP=%TEMP%\JetBrainsMono.zip"
    set "FONT_DIR=%TEMP%\JetBrainsMono"
    powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip' -OutFile '%TEMP%\JetBrainsMono.zip'"
    powershell -NoProfile -Command "Expand-Archive -Path '%TEMP%\JetBrainsMono.zip' -DestinationPath '%TEMP%\JetBrainsMono' -Force"
    powershell -NoProfile -Command "$sh = (New-Object -ComObject Shell.Application).Namespace(0x14); Get-ChildItem '%TEMP%\JetBrainsMono\*.ttf' | ForEach-Object { $sh.CopyHere($_.FullName) }"
    echo  [OK] Fonts installed manually.
) else (
    echo  [OK] JetBrainsMono Nerd Font installed.
)
pause

:: ============================================================
:: [4] OPTIONAL APPS
:: ============================================================
cls
echo.
echo  [4/9] Optional apps
echo  -----------------------------------------------------------------
echo.
set "OPT_APPS=Y"
set /p OPT_APPS="  Install Discord, Spotify, YouTube Music, VSCode? (Y/n): "
if /i "!OPT_APPS!"=="n" goto :SKIP_OPT

echo.
echo  -- Discord --
winget install --id Discord.Discord -e --accept-source-agreements --accept-package-agreements

echo.
echo  -- Spotify --
winget install --id Spotify.Spotify -e --accept-source-agreements --accept-package-agreements

echo.
echo  -- YouTube Music (th-ch) --
winget install --id th-ch.YouTubeMusic -e --accept-source-agreements --accept-package-agreements

echo.
echo  -- Visual Studio Code --
winget install --id Microsoft.VisualStudioCode -e --accept-source-agreements --accept-package-agreements

echo.
echo  [OK] Optional apps done.
:SKIP_OPT
pause

:: ============================================================
:: [5] WINDHAWK MODS (manual)
:: ============================================================
cls
echo.
echo  [5/9] Windhawk mod configs
echo  -----------------------------------------------------------------
echo.
echo  Windhawk settings must be imported through its UI.
echo.
echo  Steps:
echo    1. Open Windhawk
echo    2. Find and install "Windows 11 Taskbar Styler"
echo       Settings tab - Advanced - paste contents of:
echo       taskbar.json  (opening folder now)
echo    3. Find and install "Windows 11 Start Menu Styler"
echo       Settings tab - Advanced - paste contents of:
echo       startmenu.json
echo.
set "WINDHAWK_DIR=%DOTS%\Dots-Apply\Windhawk"
if exist "%WINDHAWK_DIR%" (
    explorer "%WINDHAWK_DIR%"
)
pause

:: ============================================================
:: [6] CATPPUCCIN THEME
:: ============================================================
cls
echo.
echo  [6/9] Applying Catppuccin Mocha theme...
echo  -----------------------------------------------------------------
echo.

set "THEME_SRC=%DOTS%\Themes\Catppuccin"
set "THEME_DEST=%SystemRoot%\Resources\Themes\Catppuccin"
set "USER_THEMES=%APPDATA%\Microsoft\Windows\Themes"

echo  Creating theme directories...
if not exist "%THEME_DEST%\Icons\Mocha"        mkdir "%THEME_DEST%\Icons\Mocha"
if not exist "%THEME_DEST%\Previews\Mocha"     mkdir "%THEME_DEST%\Previews\Mocha"
if not exist "%THEME_DEST%\Shell\NormalColor"  mkdir "%THEME_DEST%\Shell\NormalColor"
if not exist "%THEME_DEST%\Wallpapers"         mkdir "%THEME_DEST%\Wallpapers"
if not exist "%USER_THEMES%"                   mkdir "%USER_THEMES%"

echo  Copying .msstyles, icons, wallpapers...
xcopy /y /e /q "%THEME_SRC%\*" "%THEME_DEST%\" >nul

echo  Copying .theme files...
copy /y "%DOTS%\Themes\Catppuccin - Mocha.theme"          "%USER_THEMES%\" >nul
copy /y "%DOTS%\Themes\Catppuccin - Mocha NA.theme"       "%USER_THEMES%\" >nul
copy /y "%DOTS%\Themes\Catppuccin - Mocha Night.theme"    "%USER_THEMES%\" >nul
copy /y "%DOTS%\Themes\Catppuccin - Mocha Night NA.theme" "%USER_THEMES%\" >nul

echo  [OK] Theme files copied.
echo.
echo  IMPORTANT: You need SecureUxTheme to use custom .msstyles themes.
echo  Download: https://github.com/namazso/SecureUxTheme
echo  After installing it, go to Settings - Personalisation - Themes
echo  and pick "Catppuccin - Mocha".
echo.
echo  Opening Personalisation settings...
start ms-settings:personalization-themes
pause

:: ============================================================
:: [7] CONFIG FILES
:: ============================================================
cls
echo.
echo  [7/9] Copying config files...
echo  -----------------------------------------------------------------
echo.

:: GlazeWM
set "GLAZEWM_CONF=%USERPROFILE%\.glaze-wm"
if not exist "%GLAZEWM_CONF%" mkdir "%GLAZEWM_CONF%"
copy /y "%DOTS%\Dots-Apply\Glazewm\config.yaml" "%GLAZEWM_CONF%\config.yaml" >nul
echo  [OK] GlazeWM   : %GLAZEWM_CONF%\config.yaml

:: YASB
set "YASB_CONF=%APPDATA%\yasb"
if not exist "%YASB_CONF%" mkdir "%YASB_CONF%"
copy /y "%DOTS%\Dots-Apply\YASB\config.yaml" "%YASB_CONF%\config.yaml" >nul
copy /y "%DOTS%\Dots-Apply\YASB\styles.css"  "%YASB_CONF%\styles.css"  >nul
echo  [OK] YASB      : %YASB_CONF%\

:: Starship
set "STARSHIP_CONF=%USERPROFILE%\.config"
if not exist "%STARSHIP_CONF%" mkdir "%STARSHIP_CONF%"
copy /y "%DOTS%\Dots-Apply\Starship\starship.toml" "%STARSHIP_CONF%\starship.toml" >nul
echo  [OK] Starship  : %STARSHIP_CONF%\starship.toml

:: Add starship init to PowerShell profile if missing
set "PS_PROFILE=%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if not exist "%USERPROFILE%\Documents\PowerShell" mkdir "%USERPROFILE%\Documents\PowerShell"
findstr /i "starship" "%PS_PROFILE%" >nul 2>&1
if errorlevel 1 (
    echo. >> "%PS_PROFILE%"
    echo # Starship prompt >> "%PS_PROFILE%"
    echo Invoke-Expression (^&starship init powershell) >> "%PS_PROFILE%"
    echo  [OK] Starship  : init added to PowerShell profile
) else (
    echo  [OK] Starship  : already in PowerShell profile, skipped
)

:: Windows Terminal - try both possible store/sideload paths
set "WT_CONF="
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState" (
    set "WT_CONF=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
)
if exist "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState" (
    set "WT_CONF=%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState"
)
if defined WT_CONF (
    copy /y "%DOTS%\Dots-Apply\Terminal\settings.json" "%WT_CONF%\settings.json" >nul
    echo  [OK] Terminal  : %WT_CONF%\settings.json
) else (
    echo  [WARN] Terminal: config folder not found yet ^(open Terminal once first^).
    echo         Then manually copy:
    echo         %DOTS%\Dots-Apply\Terminal\settings.json
)

echo.
echo  [OK] All configs applied.
pause

:: ============================================================
:: [8] EXPLORERBLURMICA
:: ============================================================
cls
echo.
echo  [8/9] ExplorerBlurMica...
echo  -----------------------------------------------------------------
echo.

set "EBM_DIR=%DOTS%\Dots-Apply\Explorer"
set "EBM_DLL=%EBM_DIR%\ExplorerBlurMica.dll"

if not exist "%EBM_DLL%" (
    echo  [FAIL] ExplorerBlurMica.dll not found at:
    echo         %EBM_DLL%
    echo  Skipping.
    goto :SKIP_EBM
)

echo  Registering DLL...
regsvr32 /s "%EBM_DLL%"
if errorlevel 1 (
    echo  [FAIL] regsvr32 failed. Make sure you are running as Administrator.
) else (
    echo  [OK] DLL registered.
    echo  Restarting Explorer...
    taskkill /F /IM explorer.exe >nul 2>&1
    timeout /t 2 >nul
    start explorer.exe
    echo  [OK] Explorer restarted.
)
:SKIP_EBM
pause

:: ============================================================
:: [9] NEURA AI
:: ============================================================
cls
echo.
echo  [9/9] Neura AI
echo  -----------------------------------------------------------------
echo.
set "NEURA_INSTALL=Y"
set /p NEURA_INSTALL="  Install Neura AI (local Ollama AI assistant)? (Y/n): "
if /i "!NEURA_INSTALL!"=="n" goto :SKIP_NEURA

:: Use a variable to avoid inline space-in-path issues
set "NEURA_BAT=%DOTS%\Dots-Apply\neura ai\install.bat"
if exist "%NEURA_BAT%" (
    echo  Launching Neura AI installer...
    call "%NEURA_BAT%"
) else (
    echo  [WARN] Neura install.bat not found at expected location.
    echo         %NEURA_BAT%
)
:SKIP_NEURA

:: ============================================================
:: DONE
:: ============================================================
cls
echo.
echo  =================================================================
echo.
echo   Setup complete!
echo.
echo   [v] winget verified
echo   [v] GlazeWM, YASB, Starship, Windows Terminal installed
echo   [v] Windhawk, Zen Browser, Git installed
echo   [v] JetBrainsMono Nerd Font installed
echo   [v] Catppuccin theme files copied to system
echo   [v] GlazeWM  config  -^> %USERPROFILE%\.glaze-wm\
echo   [v] YASB     config  -^> %APPDATA%\yasb\
echo   [v] Starship config  -^> %USERPROFILE%\.config\starship.toml
echo   [v] Terminal settings copied
echo   [v] ExplorerBlurMica registered
echo.
echo   REMAINING MANUAL STEPS:
echo.
echo   1. Windhawk: import taskbar.json + startmenu.json in the
echo      Windhawk UI for each mod's Advanced settings tab
echo.
echo   2. Theme: install SecureUxTheme patcher, then apply
echo      Catppuccin - Mocha from Settings ^> Themes
echo      https://github.com/namazso/SecureUxTheme
echo.
echo   3. Restart your PC for all changes to take full effect.
echo.
echo  =================================================================
echo.
pause
exit /b 0