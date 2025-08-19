#!/usr/bin/env python3
"""
🤖 Baby Claude - Your Personal AI Assistant
A beautiful and enhanced Claude interface with colors, emojis, and features!
"""

from dotenv import load_dotenv # type: ignore
import os
import sys
import datetime
import json
from anthropic import Anthropic # type: ignore
from typing import List, Dict
from pathlib import Path

# Color codes for beautiful terminal output
class Colors:
    """Centralized color definitions with cross-platform support"""
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    
    # Custom colors
    CLAUDE = '\033[38;5;129m'  # Purple for Claude
    USER = '\033[38;5;45m'     # Cyan for user
    SYSTEM = '\033[38;5;208m'  # Orange for system
    
    @classmethod
    def colorize(cls, text: str, color: str) -> str:
        """Helper method to colorize text"""
        return f"{color}{text}{cls.ENDC}"

class BabyClaude:
    def __init__(self):
        load_dotenv()
        self.client = Anthropic(api_key=os.getenv('ANTHROPIC_API_KEY'))
        self.conversation_history: List[Dict] = []
        self.session_start = datetime.datetime.now()
        
        # Configuration - can be moved to environment variables
        self.model = os.getenv('CLAUDE_MODEL', 'claude-3-5-haiku-20241022')
        self.max_tokens = int(os.getenv('MAX_TOKENS', '4000'))
        self.save_dir = Path(os.getenv('SAVE_DIR', '.'))
        
    def print_header(self):
        """Print a beautiful header for Baby Claude"""
        welcome_msg = "✨ Welcome! I'm here to help you with anything."
        tips_msg = "💡 Tips: Type 'help' for commands, 'quit' to exit"
        session_msg = f"📅 Session started: {self.session_start.strftime('%Y-%m-%d %H:%M:%S')}"
        
        header = f"""
{Colors.colorize('╔══════════════════════════════════════════════╗', Colors.BOLD + Colors.CLAUDE)}
{Colors.colorize('║  🤖 Baby Claude - Your Personal AI Assistant ║', Colors.BOLD + Colors.CLAUDE)}
{Colors.colorize('║          Powered by Anthropic Claude         ║', Colors.BOLD + Colors.CLAUDE)}
{Colors.colorize('║       Proudly developed by @JeremLeOuf       ║', Colors.BOLD + Colors.CLAUDE)}
{Colors.colorize('╚══════════════════════════════════════════════╝', Colors.BOLD + Colors.CLAUDE)}

{Colors.colorize(welcome_msg, Colors.OKCYAN)}
{Colors.colorize(tips_msg, Colors.WARNING)}
{Colors.colorize(session_msg, Colors.OKGREEN)}
"""
        print(header)
    
    def print_help(self):
        """Show available commands with improved formatting"""
        commands = [
            ("help", "Show this help menu"),
            ("history", "Show conversation history"),
            ("clear", "Clear conversation history"),
            ("save", "Save conversation to file"),
            ("stats", "Show session statistics"),
            ("quit", "Exit Baby Claude")
        ]
        
        print(f"\n{Colors.colorize('🔧 Available Commands:', Colors.BOLD + Colors.HEADER)}")
        for cmd, desc in commands:
            print(Colors.colorize(f"• {cmd:<8} - {desc}", Colors.OKBLUE))
        
        print(Colors.colorize("\n🌟 Just type your question and I'll help!", Colors.OKCYAN))
    
    def print_stats(self):
        """Show session statistics with improved formatting"""
        duration = datetime.datetime.now() - self.session_start
        stats_data = [
            ("⏱️  Duration", str(duration).split('.')[0]),
            ("💬 Messages exchanged", str(len(self.conversation_history))),
            ("🚀 Started", self.session_start.strftime('%H:%M:%S')),
            ("🤖 Model", self.model)
        ]
        
        print(f"\n{Colors.colorize('📊 Session Statistics:', Colors.BOLD + Colors.HEADER)}")
        for label, value in stats_data:
            print(Colors.colorize(f"{label}: {value}", Colors.OKGREEN))
    
    def save_conversation(self):
        """Save conversation to a JSON file with improved error handling"""
        if not self.conversation_history:
            print(Colors.colorize("📝 No conversation to save yet!", Colors.WARNING))
            return
            
        timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = self.save_dir / f"claude_conversation_{timestamp}.json"
        
        conversation_data = {
            'session_start': self.session_start.isoformat(),
            'session_end': datetime.datetime.now().isoformat(),
            'model': self.model,
            'messages': self.conversation_history
        }
        
        try:
            # Ensure save directory exists
            self.save_dir.mkdir(exist_ok=True)
            
            with open(filename, 'w', encoding='utf-8') as f:
                json.dump(conversation_data, f, indent=2, ensure_ascii=False)
            print(Colors.colorize(f"💾 Conversation saved to: {filename}", Colors.OKGREEN))
        except Exception as e:
            print(Colors.colorize(f"❌ Error saving conversation: {e}", Colors.FAIL))
    
    def chat_with_claude(self, message: str) -> str:
        """Send message to Claude and get response"""
        try:
            # Show thinking animation
            print(Colors.colorize("🤔 Claude is thinking...", Colors.CLAUDE), end="", flush=True)
            
            response = self.client.messages.create(
                model=self.model,
                max_tokens=self.max_tokens,
                messages=[{"role": "user", "content": message}]
            )
            
            # Clear the thinking message
            print("\r" + " " * 30 + "\r", end="")
            
            claude_response = response.content[0].text
            
            # Store in conversation history
            self.conversation_history.append({
                'timestamp': datetime.datetime.now().isoformat(),
                'user': message,
                'claude': claude_response
            })
            
            return claude_response
            
        except Exception as e:
            return f"❌ Error communicating with Claude: {e}"
    
    def show_history(self):
        """Display conversation history with improved formatting"""
        if not self.conversation_history:
            print(Colors.colorize("📜 No conversation history yet!", Colors.WARNING))
            return
            
        print(f"\n{Colors.colorize('📜 Conversation History:', Colors.BOLD + Colors.HEADER)}")
        for i, exchange in enumerate(self.conversation_history, 1):
            timestamp = datetime.datetime.fromisoformat(exchange['timestamp']).strftime('%H:%M:%S')
            print(f"\n{Colors.colorize(f'[{timestamp}] Exchange {i}:', Colors.SYSTEM)}")
            
            user_msg = exchange['user'][:100] + ('...' if len(exchange['user']) > 100 else '')
            claude_msg = exchange['claude'][:100] + ('...' if len(exchange['claude']) > 100 else '')
            
            print(Colors.colorize(f"👤 You: {user_msg}", Colors.USER))
            print(Colors.colorize(f"🤖 Claude: {claude_msg}", Colors.CLAUDE))
    
    def handle_command(self, command: str) -> bool:
        """Handle built-in commands. Returns True if command was handled."""
        command_map = {
            'quit': lambda: self._quit_command(),
            'help': lambda: self.print_help(),
            'history': lambda: self.show_history(),
            'clear': lambda: self._clear_command(),
            'save': lambda: self.save_conversation(),
            'stats': lambda: self.print_stats()
        }
        
        handler = command_map.get(command.lower())
        if handler:
            handler()
            return True
        return False
    
    def _quit_command(self):
        """Handle quit command"""
        print(Colors.colorize("\n👋 Goodbye! Thanks for chatting with Baby Claude!", Colors.OKCYAN))
        return True
    
    def _clear_command(self):
        """Handle clear command"""
        self.conversation_history.clear()
        print(Colors.colorize("🧹 Conversation history cleared!", Colors.OKGREEN))
    
    def run(self):
        """Main chat loop with improved command handling"""
        self.print_header()
        
        try:
            while True:
                # Get user input with beautiful prompt
                user_input = input(f"\n{Colors.colorize('👤 You: ', Colors.USER + Colors.BOLD)}").strip()
                
                if not user_input:
                    continue
                
                # Handle commands - if it's a command, continue to next iteration
                if self.handle_command(user_input):
                    if user_input.lower() == 'quit':
                        break
                    continue
                
                # Get Claude's response
                response = self.chat_with_claude(user_input)
                
                # Display Claude's response with beautiful formatting
                print(f"\n{Colors.colorize('🤖 Claude:', Colors.CLAUDE + Colors.BOLD)}")
                print(Colors.colorize(response, Colors.CLAUDE))
                
        except KeyboardInterrupt:
            print(Colors.colorize("\n\n👋 Goodbye! Thanks for chatting with Baby Claude!", Colors.OKCYAN))
        except Exception as e:
            print(Colors.colorize(f"\n❌ An error occurred: {e}", Colors.FAIL))

def main():
    """Entry point for Baby Claude"""
    if len(sys.argv) > 1:
        # Quick mode: ask a single question
        question = " ".join(sys.argv[1:])
        claude = BabyClaude()
        print(Colors.colorize(f"👤 Question: {question}", Colors.USER))
        response = claude.chat_with_claude(question)
        print(Colors.colorize(f"\n🤖 Claude: {response}", Colors.CLAUDE))
    else:
        # Interactive mode
        claude = BabyClaude()
        claude.run()

if __name__ == "__main__":
    main()
