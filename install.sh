#!/bin/bash
# 🚀 Baby Claude Installer

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

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/venv"

echo -e "${CYAN}📍 Installing in: $SCRIPT_DIR${NC}"

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 not found! Please install Python 3.7+ first${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Python 3 found: $(python3 --version)${NC}"

# Create virtual environment
echo -e "${CYAN}🔧 Creating virtual environment...${NC}"
python3 -m venv "$VENV_DIR"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to create virtual environment${NC}"
    echo -e "${YELLOW}💡 You might need to install python3-venv: sudo apt install python3-venv${NC}"
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
chmod +x claude
chmod +x install.sh

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
    # Add aliases to bashrc
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
    
    if ! grep -q "Baby Claude aliases" ~/.bashrc 2>/dev/null; then
        echo "$ALIAS_BLOCK" >> ~/.bashrc
        echo -e "${GREEN}✅ Global commands added to ~/.bashrc${NC}"
        echo -e "${YELLOW}💡 Run 'source ~/.bashrc' or restart terminal to activate${NC}"
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
echo -e "  2. Run: ${BOLD}./claude${NC} (interactive mode)"
echo -e "  3. Or: ${BOLD}./claude \"your question\"${NC} (quick mode)"
echo ""
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo -e "${CYAN}🎯 Global commands available after restart:${NC}"
    echo -e "  • ${BOLD}bc${NC} or ${BOLD}ai${NC} (quick access)"
    echo -e "  • ${BOLD}ask \"question\"${NC} (one-shot questions)"
fi
echo ""
echo -e "${YELLOW}💡 Need help? Check README.md or run: ./claude help${NC}"
