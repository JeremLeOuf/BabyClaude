#!/bin/bash
# 🗑️ Baby Claude Uninstaller

# Colors
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
CYAN='\033[96m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${RED}${BOLD}"
echo "🗑️ Baby Claude Uninstaller"
echo "=========================="
echo -e "${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${YELLOW}⚠️  This will remove Baby Claude and all its data.${NC}"
echo -e "${CYAN}Continue? (y/N)${NC}"
read -r response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}✅ Uninstall cancelled${NC}"
    exit 0
fi

# Remove virtual environment
if [ -d "$SCRIPT_DIR/venv" ]; then
    echo -e "${CYAN}🔧 Removing virtual environment...${NC}"
    rm -rf "$SCRIPT_DIR/venv"
    echo -e "${GREEN}✅ Virtual environment removed${NC}"
fi

# Remove aliases from bashrc
if grep -q "Baby Claude aliases" ~/.bashrc 2>/dev/null; then
    echo -e "${CYAN}🔗 Removing global commands...${NC}"
    # Create a backup
    cp ~/.bashrc ~/.bashrc.backup
    # Remove the Baby Claude section
    sed '/# 🤖 Baby Claude aliases/,/^$/d' ~/.bashrc.backup > ~/.bashrc
    echo -e "${GREEN}✅ Global commands removed (backup saved as ~/.bashrc.backup)${NC}"
fi

echo -e "${GREEN}${BOLD}"
echo "🎉 Uninstall Complete!"
echo "====================="
echo -e "${NC}"
echo -e "${YELLOW}💡 You can safely delete this directory now${NC}"
echo -e "${YELLOW}🔄 Restart your terminal to complete removal${NC}"
