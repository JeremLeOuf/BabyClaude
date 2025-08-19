@echo off
REM 🚀 Baby Claude Windows Installer

echo.
echo 🤖 Baby Claude Installer
echo =======================
echo.

REM Get script directory
SET "SCRIPT_DIR=%~dp0"
SET "VENV_DIR=%SCRIPT_DIR%venv"

echo 📍 Installing in: %SCRIPT_DIR%

REM Check if Python is installed
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ❌ Python not found!
    echo.
    echo 💡 Python is required to run Baby Claude.
    echo 📥 Please install Python from: https://www.python.org/downloads/
    echo.
    echo ✅ Make sure to check "Add Python to PATH" during installation
    echo.
    pause
    echo.
    echo 🔄 After installing Python, run this installer again.
    pause
    exit /b 1
)

FOR /F "tokens=*" %%A IN ('python --version') DO SET PYTHON_VERSION=%%A
echo ✅ Python found: %PYTHON_VERSION%

REM Check if pip is available
python -m pip --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ❌ pip not found!
    echo 💡 Installing pip...
    python -m ensurepip --upgrade
    IF %ERRORLEVEL% NEQ 0 (
        echo ❌ Failed to install pip
        pause
        exit /b 1
    )
)

echo ✅ pip is available

REM Create virtual environment
echo 🔧 Creating virtual environment...
python -m venv "%VENV_DIR%"
IF %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to create virtual environment
    echo 💡 Make sure you have python3-venv installed
    pause
    exit /b 1
)

REM Activate virtual environment
echo 🔌 Activating virtual environment...
call "%VENV_DIR%\Scripts\activate.bat"

REM Install dependencies
echo 📦 Installing dependencies...
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
IF %ERRORLEVEL% NEQ 0 (
    echo ❌ Failed to install dependencies
    pause
    exit /b 1
)

REM Set up .env file if it doesn't exist
IF NOT EXIST ".env" (
    echo 🔑 Setting up API key configuration...
    copy .env.template .env
    echo ⚠️  Please edit .env file and add your Anthropic API key!
    echo 💡 Get your API key from: https://console.anthropic.com/
)

call deactivate

echo.
echo 🎉 Installation Complete!
echo ========================
echo ✅ Virtual environment created
echo ✅ Dependencies installed
echo ✅ Scripts configured
echo.
echo 🚀 Next steps:
echo   1. Edit .env file with your API key
echo   2. Run: claude.bat (interactive mode)
echo   3. Or: claude.bat "your question" (quick mode)
echo.
echo 💡 Need help? Check README.md
echo.
pause
