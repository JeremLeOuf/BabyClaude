# 🤖 Baby Claude - Cross-Platform AI Assistant

A beautiful, self-contained terminal interface for Claude AI that works on **Windows, macOS, and Linux**!

## ✨ Features

- 🎨 **Beautiful colorized terminal interface** with emojis
- 💬 **Interactive chat mode** with conversation history
- ⚡ **Quick question mode** for one-off queries
- 💾 **Save conversations** to JSON files
- 📊 **Session statistics** and timing
- 🔧 **Built-in commands** (help, history, clear, save, stats, quit)
- 🚀 **One-command setup** - works anywhere
- 📦 **Self-contained** - includes its own virtual environment
- 🐍 **Auto-detects and installs Python** if needed

## 🌍 Cross-Platform Support

### 🐧 Linux & 🍎 macOS
```bash
./install.sh
./claude
```

### 🪟 Windows
```cmd
install.bat
claude.bat
```

### 🐍 No Python? No Problem!
- **Linux/macOS**: The installer can automatically install Python
- **Windows**: Use `install-python.bat` for automatic Python installation

## 🚀 Quick Setup

### Option 1: Automatic (Recommended)

#### Windows
```cmd
REM If Python is not installed:
install-python.bat

REM If Python is already installed:
install.bat
claude.bat
```

#### Linux/macOS
```bash
# Auto-installs Python if needed
./install.sh
./claude
```

### Option 2: Manual Python Install
1. Download Python from [python.org](https://www.python.org/downloads/)
2. Run the installer (check "Add Python to PATH" on Windows)
3. Run the Baby Claude installer

## 📦 What's Included

```
baby-claude/
├── claude.py              # Main Baby Claude application
├── claude                 # Linux/macOS launcher
├── claude.bat             # Windows launcher
├── install.sh             # Linux/macOS installer
├── install.bat            # Windows installer
├── install-python.bat     # Windows Python auto-installer
├── uninstall.sh           # Clean removal (Linux/macOS)
├── requirements.txt       # Python dependencies
├── .env.template          # API key template
└── README.md              # This file
```

## 🔧 Installation Features

The installer automatically:
1. ✅ **Detects your operating system**
2. ✅ **Checks for Python installation**
3. ✅ **Offers to install Python if missing**
4. ✅ **Creates isolated virtual environment**
5. ✅ **Installs all dependencies**
6. ✅ **Sets up global commands** (`bc`, `ai`, `ask`)
7. ✅ **Configures API key template**

## 💡 Usage Examples

### Interactive Mode
```bash
# Linux/macOS
./claude

# Windows
claude.bat

# Global commands (after installation)
bc
ai
baby-claude
```

### Quick Questions
```bash
# Linux/macOS
./claude "Explain machine learning"
bc "What's 15 * 24?"
ask "Write a Python function"

# Windows
claude.bat "Explain machine learning"
```

### Available Commands (Interactive Mode)
- `help` - Show available commands
- `history` - View conversation history
- `clear` - Clear conversation history
- `save` - Save conversation to JSON file
- `stats` - Show session statistics
- `quit` - Exit Baby Claude

## 🔑 API Key Setup

1. Get your API key from [Anthropic Console](https://console.anthropic.com/)
2. Copy `.env.template` to `.env`
3. Edit `.env` and replace `your_api_key_here` with your actual API key

## 🎯 Pro Tips

1. **Quick Access**: Use `bc` for fastest launch
2. **One-shot Questions**: Perfect for quick answers
3. **History**: Use `save` to backup conversations
4. **Portable**: Copy entire directory anywhere
5. **Cross-Platform**: Same commands work everywhere

## 🛠️ Troubleshooting

### Python Issues
**"Python not found"**
- **Windows**: Run `install-python.bat`
- **Linux**: `sudo apt install python3 python3-venv`
- **macOS**: `brew install python3`

**"Permission denied"**
- **Linux/macOS**: `chmod +x install.sh claude`
- **Windows**: Run as Administrator if needed

**"pip not found"**
- Usually auto-installed with Python
- Manual fix: `python -m ensurepip --upgrade`

### API Issues
**"API key not found"**
- Check `.env` file exists and contains your key
- Make sure you copied `.env.template` to `.env`

**"Model deprecated"**
- Update claude.py to use newer model
- Check [Anthropic docs](https://docs.anthropic.com/) for latest models

### Platform-Specific

#### Windows
- **PowerShell Execution Policy**: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
- **Long Path Support**: Enable in Windows settings if needed

#### Linux
- **Virtual Environment**: `sudo apt install python3-venv`
- **Build Tools**: `sudo apt install build-essential`

#### macOS
- **Xcode Tools**: `xcode-select --install`
- **Homebrew**: Install from [brew.sh](https://brew.sh/)

## 🔄 Moving Between Systems

Baby Claude is completely portable:

1. **Package it**: Copy the entire directory
2. **Move it**: Transfer to any Windows/macOS/Linux system
3. **Install**: Run the appropriate installer
4. **Configure**: Copy your `.env` file or set up API key
5. **Ready**: Works exactly the same way!

## 🗑️ Uninstall

### Linux/macOS
```bash
./uninstall.sh
```

### Windows
```cmd
REM Manual removal:
rmdir /s venv
REM Remove from Programs & Features if installed globally
```

## 🚀 Advanced Usage

### Global Commands Setup
After installation, you get these global commands:
- `bc` - Quick Baby Claude access
- `ai` - Alternative quick access
- `ask "question"` - One-shot questions
- `baby-claude` - Full name launcher

### Conversation Management
- All conversations stored in memory during session
- Use `save` to export to JSON files
- Use `history` to review past exchanges
- Use `clear` to start fresh

### Customization
- Edit `claude.py` to modify colors, prompts, or behavior
- Modify launchers for different default arguments
- Add custom commands to the interactive mode

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

MIT License - feel free to use and modify!

---

**Happy chatting with Baby Claude on any platform! 🚀**
