@echo off
REM 🐍 Python Auto-Installer for Baby Claude

echo.
echo 🐍 Python Auto-Installer for Baby Claude
echo =======================================
echo.

REM Check if Python is already installed
python --version >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    FOR /F "tokens=*" %%A IN ('python --version') DO SET PYTHON_VERSION=%%A
    echo ✅ Python is already installed: %PYTHON_VERSION%
    echo 🚀 Running Baby Claude installer...
    call install.bat
    exit /b 0
)

echo 📥 Python not found. Starting automatic installation...
echo.

REM Create temp directory
IF NOT EXIST "%TEMP%\baby-claude-setup" mkdir "%TEMP%\baby-claude-setup"
cd /d "%TEMP%\baby-claude-setup"

REM Download Python installer
echo 📦 Downloading Python 3.11...
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe' -OutFile 'python-installer.exe'}"

IF %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to download Python installer
    echo 💡 Please download Python manually from: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo ✅ Python installer downloaded
echo 🔧 Installing Python (this may take a few minutes)...
echo 💡 Make sure to check "Add Python to PATH" if prompted!

REM Run Python installer with silent options
python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0

REM Wait for installation to complete
timeout /t 30 /nobreak >nul

REM Verify installation
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ❌ Python installation failed or PATH not updated
    echo 💡 Please restart your command prompt and try again
    echo 🔄 Or install Python manually from: https://www.python.org/downloads/
    pause
    exit /b 1
)

FOR /F "tokens=*" %%A IN ('python --version') DO SET PYTHON_VERSION=%%A
echo ✅ Python installed successfully: %PYTHON_VERSION%

REM Clean up
cd /d "%~dp0"
rmdir /s /q "%TEMP%\baby-claude-setup"

echo 🚀 Now running Baby Claude installer...
call install.bat
