@echo off
setlocal EnableExtensions DisableDelayedExpansion
cd /d "%~dp0"

echo ========================================
echo        NotionNext Windows Launcher
echo ========================================
echo.

where node >nul 2>nul
if errorlevel 1 goto NODE_MISSING

set "PATH=%PATH%;%APPDATA%\npm;%ProgramFiles%\nodejs"
where yarn >nul 2>nul
if errorlevel 1 goto INSTALL_YARN

goto CHECK_CONFIG

:NODE_MISSING
echo Node.js was not found.
echo Please install Node.js 22 LTS from https://nodejs.org/
pause
exit /b 1

:INSTALL_YARN
echo Yarn was not found. Installing Yarn 1.22.22...
where corepack >nul 2>nul
if not errorlevel 1 (
  call corepack enable
  call corepack prepare yarn@1.22.22 --activate
)
set "PATH=%PATH%;%APPDATA%\npm;%ProgramFiles%\nodejs"
where yarn >nul 2>nul
if errorlevel 1 (
  call npm.cmd install --global yarn@1.22.22
)
set "PATH=%PATH%;%APPDATA%\npm;%ProgramFiles%\nodejs"
where yarn >nul 2>nul
if errorlevel 1 (
  echo Could not install Yarn.
  echo Please open a new Command Prompt and run this file again.
  pause
  exit /b 1
)

goto CHECK_CONFIG

:CHECK_CONFIG
if exist ".env.local" goto INSTALL_DEPS

echo.
echo First run setup.
echo Enter the 32-character Notion Page ID only.
set /p "NOTION_PAGE_ID=Notion Page ID: "
if "%NOTION_PAGE_ID%"=="" (
  echo No Page ID was entered.
  pause
  exit /b 1
)
>".env.local" echo NOTION_PAGE_ID=%NOTION_PAGE_ID%
echo Configuration saved.

:INSTALL_DEPS
if exist "node_modules" goto START_APP

echo.
echo Installing packages. This may take several minutes...
call yarn install --frozen-lockfile
if errorlevel 1 (
  echo Package installation failed.
  pause
  exit /b 1
)

:START_APP
echo.
echo Starting NotionNext...
echo Open http://localhost:3000 in your browser.
echo Press Ctrl+C to stop the website.
echo.
call yarn dev
pause
