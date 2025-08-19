@echo off
REM 🤖 Baby Claude Windows Launcher

REM Colors for Windows (limited)
SET "CYAN=[96m"
SET "GREEN=[92m"
SET "YELLOW=[93m"
SET "RED=[91m"
SET "BOLD=[1m"
SET "NC=[0m"

REM Get script directory
SET "SCRIPT_DIR=%~dp0"
SET "VENV_DIR=%SCRIPT_DIR%venv"
SET "CLAUDE_SCRIPT=%SCRIPT_DIR%claude.py"
SET "ENV_FILE=%SCRIPT_DIR%.env"

REM Check if virtual environment exists
IF NOT EXIST "%VENV_DIR%" (
    echo %RED%❌ Virtual environment not found!%NC%
    echo %YELLOW%💡 Please run install.bat first%NC%
    pause
    exit /b 1
)

REM Check if .env file exists
IF NOT EXIST "%ENV_FILE%" (
    echo %RED%❌ .env file not found!%NC%
    echo %YELLOW%💡 Please copy .env.template to .env and add your API key%NC%
    pause
    exit /b 1
)

REM Check if API key is set
findstr /C:"your_api_key_here" "%ENV_FILE%" >nul
IF %ERRORLEVEL% EQU 0 (
    echo %RED%❌ Please set your API key in .env file%NC%
    echo %YELLOW%💡 Edit .env and replace 'your_api_key_here' with your actual API key%NC%
    pause
    exit /b 1
)

REM Activate virtual environment and run Claude
call "%VENV_DIR%\Scripts\activate.bat"
python "%CLAUDE_SCRIPT%" %*
call deactivate
