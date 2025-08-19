# 🤖 Baby Claude - Portable AI Assistant

A beautiful, self-contained terminal interface for Claude AI that you can run anywhere!

## ✨ Features

- 🎨 **Beautiful colorized terminal interface** with emojis
- 💬 **Interactive chat mode** with conversation history
- ⚡ **Quick question mode** for one-off queries
- 💾 **Save conversations** to JSON files
- 📊 **Session statistics** and timing
- 🔧 **Built-in commands** (help, history, clear, save, stats, quit)
- 🚀 **One-command setup** - works anywhere
- 📦 **Self-contained** - includes its own virtual environment

## 🚀 Quick Setup

### 1. Download and Setup
```bash
# Option 1: Git clone (if you have a repo)
git clone <your-repo-url> baby-claude
cd baby-claude

# Option 2: Download and extract files
cd baby-claude

# Install
./install.sh
```

### 2. Configure API Key
```bash
# Edit the .env file with your Anthropic API key
nano .env
# or
vim .env
```

### 3. Run Baby Claude
```bash
# Interactive mode
./claude

# Quick question
./claude "What's the weather like?"

# Or use global commands (if installed)
bc "Explain quantum computing"
```

## 📦 What's Included

```
baby-claude/
├── claude.py          # Main Baby Claude application
├── claude             # Main launcher script
├── install.sh         # One-command installer
├── uninstall.sh       # Clean removal script
├── requirements.txt   # Python dependencies
├── .env.template      # API key template
└── README.md          # This file
```

## 🔧 Installation Details

The installer will:
1. ✅ Create a Python virtual environment
2. ✅ Install all required dependencies
3. ✅ Set up global command aliases (`bc`, `ai`, `baby-claude`)
4. ✅ Configure the launcher script
5. ✅ Guide you through API key setup

## 💡 Usage Examples

### Interactive Mode
```bash
./claude
# or (if global commands installed)
bc
ai
baby-claude
```

### Quick Questions
```bash
./claude "Explain machine learning"
bc "What's 15 * 24?"
ask "Write a Python function to sort a list"
```

### Available Commands (Interactive Mode)
- `help` - Show available commands
- `history` - View conversation history
- `clear` - Clear conversation history
- `save` - Save conversation to JSON file
- `stats` - Show session statistics
- `quit` - Exit Baby Claude

## 🌍 Cross-Platform

Works on:
- ✅ Linux (Ubuntu, Debian, CentOS, etc.)
- ✅ macOS
- ✅ Windows WSL
- ✅ Any system with Python 3.7+

## 🔑 API Key Setup

1. Get your API key from [Anthropic Console](https://console.anthropic.com/)
2. Copy `.env.template` to `.env`: `cp .env.template .env`
3. Edit `.env` and replace `your_api_key_here` with your actual API key

## 🎯 Pro Tips

1. **Quick Access**: Use `bc` for fastest launch
2. **One-shot Questions**: Use `bc "question"` for quick answers
3. **History**: Use `save` command to backup important conversations
4. **Portable**: Copy the entire directory anywhere and it just works!

## 🛠️ Troubleshooting

**Python not found**: Install Python 3.7+ first
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install python3 python3-venv

# macOS
brew install python3
```

**Permission denied**: Make scripts executable
```bash
chmod +x install.sh claude uninstall.sh
```

**API errors**: Check your `.env` file has the correct API key

**Dependencies failed**: Update pip and try again
```bash
./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt
```

## 🔄 Moving to Different Systems

Baby Claude is completely portable! Just:
1. Copy the entire directory to your new system
2. Run `./install.sh` (creates new virtual environment)
3. Copy your `.env` file or set up API key again
4. Ready to go!

## 🗑️ Uninstall

```bash
./uninstall.sh
```

This will:
- Remove the virtual environment
- Remove global commands from ~/.bashrc
- Clean up everything safely

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

MIT License - feel free to use and modify!

---

**Happy chatting with Baby Claude! 🚀**
