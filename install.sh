#!/bin/bash
# 🚀 Baby Claude Cross-Platform Installer

# Colors
CYAN='\033[96m'
GREEN='\033[92m'
YELLOW='\033[93m'
RED='\033[91m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}"
echo "🤖 Baby Claude Installer"
echo "======================="
echo -e "${NC}"

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo -e "${CYAN}🖥️  Detected OS: $MACHINE${NC}"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/venv"

echo -e "${CYAN}📍 Installing in: $SCRIPT_DIR${NC}"

# Function to install Python on different systems
install_python() {
    echo -e "${YELLOW}📥 Python not found. Attempting to install...${NC}"
    
    case $MACHINE in
        Linux)
            if command -v apt-get &> /dev/null; then
                echo -e "${CYAN}🔧 Installing Python using apt...${NC}"
                sudo apt update && sudo apt install -y python3 python3-venv python3-pip
            elif command -v yum &> /dev/null; then
                echo -e "${CYAN}🔧 Installing Python using yum...${NC}"
                sudo yum install -y python3 python3-venv python3-pip
            elif command -v dnf &> /dev/null; then
                echo -e "${CYAN}🔧 Installing Python using dnf...${NC}"
                sudo dnf install -y python3 python3-venv python3-pip
            elif command -v pacman &> /dev/null; then
                echo -e "${CYAN}🔧 Installing Python using pacman...${NC}"
                sudo pacman -S python python-virtualenv python-pip
            else
                echo -e "${RED}❌ Could not find package manager${NC}"
                echo -e "${YELLOW}💡 Please install Python 3.7+ manually${NC}"
                return 1
            fi
            ;;
        Mac)
            if command -v brew &> /dev/null; then
                echo -e "${CYAN}🔧 Installing Python using Homebrew...${NC}"
                brew install python3
            else
                echo -e "${YELLOW}💡 Please install Homebrew first: https://brew.sh/${NC}"
                echo -e "${YELLOW}💡 Or install Python manually: https://www.python.org/downloads/${NC}"
                return 1
            fi
            ;;
        *)
            echo -e "${RED}❌ Automatic Python installation not supported on $MACHINE${NC}"
            echo -e "${YELLOW}💡 Please install Python 3.7+ manually${NC}"
            return 1
            ;;
    esac
}

# Check if Python is available
PYTHON_CMD=""
if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    # Check if it's Python 3
    PYTHON_VERSION=$(python -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
    if [[ $(echo "$PYTHON_VERSION >= 3.7" | bc -l 2>/dev/null || echo "0") -eq 1 ]]; then
        PYTHON_CMD="python"
    fi
fi

if [ -z "$PYTHON_CMD" ]; then
    echo -e "${RED}❌ Python 3.7+ not found!${NC}"
    echo -e "${CYAN}🔧 Would you like to try automatic installation? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        install_python
        # Re-check after installation
        if command -v python3 &> /dev/null; then
            PYTHON_CMD="python3"
        elif command -v python &> /dev/null; then
            PYTHON_VERSION=$(python -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
            if [[ $(echo "$PYTHON_VERSION >= 3.7" | bc -l 2>/dev/null || echo "0") -eq 1 ]]; then
                PYTHON_CMD="python"
            fi
        fi
        
        if [ -z "$PYTHON_CMD" ]; then
            echo -e "${RED}❌ Python installation failed${NC}"
            echo -e "${YELLOW}💡 Please install Python 3.7+ manually and try again${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}💡 Please install Python 3.7+ first:${NC}"
        case $MACHINE in
            Linux)
                echo -e "${YELLOW}   Ubuntu/Debian: sudo apt install python3 python3-venv${NC}"
                echo -e "${YELLOW}   CentOS/RHEL: sudo yum install python3 python3-venv${NC}"
                ;;
            Mac)
                echo -e "${YELLOW}   macOS: brew install python3${NC}"
                echo -e "${YELLOW}   Or download from: https://www.python.org/downloads/${NC}"
                ;;
            *)
                echo -e "${YELLOW}   Download from: https://www.python.org/downloads/${NC}"
                ;;
        esac
        exit 1
    fi
fi

PYTHON_VERSION=$($PYTHON_CMD --version)
echo -e "${GREEN}✅ Python found: $PYTHON_VERSION${NC}"

# Check if pip is available
if ! $PYTHON_CMD -m pip --version &> /dev/null; then
    echo -e "${YELLOW}⚠️  pip not found, installing...${NC}"
    $PYTHON_CMD -m ensurepip --upgrade
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to install pip${NC}"
        echo -e "${YELLOW}💡 Please install pip manually${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ pip is available${NC}"

# Create virtual environment
echo -e "${CYAN}🔧 Creating virtual environment...${NC}"
$PYTHON_CMD -m venv "$VENV_DIR"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to create virtual environment${NC}"
    echo -e "${YELLOW}💡 You might need to install python3-venv:${NC}"
    case $MACHINE in
        Linux)
            echo -e "${YELLOW}   sudo apt install python3-venv${NC}"
            ;;
        Mac)
            echo -e "${YELLOW}   Virtual environment should work with standard Python installation${NC}"
            ;;
    esac
    exit 1
fi

# Activate virtual environment
echo -e "${CYAN}🔌 Activating virtual environment...${NC}"
source "$VENV_DIR/bin/activate"

# Install dependencies
echo -e "${CYAN}📦 Installing dependencies...${NC}"
pip install --upgrade pip
pip install -r requirements.txt

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to install dependencies${NC}"
    exit 1
fi

# Make scripts executable
chmod +x claude install.sh uninstall.sh 2>/dev/null

# Set up .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo -e "${CYAN}🔑 Setting up API key configuration...${NC}"
    cp .env.template .env
    echo -e "${YELLOW}⚠️  Please edit .env file and add your Anthropic API key!${NC}"
    echo -e "${YELLOW}💡 Get your API key from: https://console.anthropic.com/${NC}"
fi

# Create global aliases if user wants them
echo -e "${CYAN}🔗 Would you like to set up global commands? (y/n)${NC}"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    # Detect shell and add aliases
    SHELL_RC=""
    if [ -n "$BASH_VERSION" ]; then
        SHELL_RC="$HOME/.bashrc"
    elif [ -n "$ZSH_VERSION" ]; then
        SHELL_RC="$HOME/.zshrc"
    else
        SHELL_RC="$HOME/.bashrc"  # Default fallback
    fi
    
    ALIAS_BLOCK="
# 🤖 Baby Claude aliases
alias bc=\"$SCRIPT_DIR/claude\"
alias ai=\"$SCRIPT_DIR/claude\"
alias baby-claude=\"$SCRIPT_DIR/claude\"

# Quick question function
ask() {
    if [ \$# -eq 0 ]; then
        echo \"Usage: ask 'your question here'\"
        return 1
    fi
    \"$SCRIPT_DIR/claude\" \"\$@\"
}
"
    
    if ! grep -q "Baby Claude aliases" "$SHELL_RC" 2>/dev/null; then
        echo "$ALIAS_BLOCK" >> "$SHELL_RC"
        echo -e "${GREEN}✅ Global commands added to $SHELL_RC${NC}"
        echo -e "${YELLOW}💡 Run 'source $SHELL_RC' or restart terminal to activate${NC}"
    else
        echo -e "${YELLOW}⚠️  Global commands already exist${NC}"
    fi
fi

deactivate

echo -e "${GREEN}${BOLD}"
echo "🎉 Installation Complete!"
echo "========================"
echo -e "${NC}"
echo -e "${GREEN}✅ Virtual environment created${NC}"
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo -e "${GREEN}✅ Scripts configured${NC}"
echo ""
echo -e "${CYAN}🚀 Next steps:${NC}"
echo -e "  1. Edit .env file with your API key"
if [ "$MACHINE" = "Linux" ] || [ "$MACHINE" = "Mac" ]; then
    echo -e "  2. Run: ${BOLD}./claude${NC} (interactive mode)"
    echo -e "  3. Or: ${BOLD}./claude \"your question\"${NC} (quick mode)"
else
    echo -e "  2. Run: ${BOLD}claude.bat${NC} (interactive mode)"
    echo -e "  3. Or: ${BOLD}claude.bat \"your question\"${NC} (quick mode)"
fi
echo ""
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo -e "${CYAN}🎯 Global commands available after restart:${NC}"
    echo -e "  • ${BOLD}bc${NC} or ${BOLD}ai${NC} (quick access)"
    echo -e "  • ${BOLD}ask \"question\"${NC} (one-shot questions)"
fi
echo ""
echo -e "${YELLOW}💡 Need help? Check README.md${NC}"
