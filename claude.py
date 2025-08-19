#!/usr/bin/env python3
"""
🤖 Baby Claude - Your Personal AI Assistant
A beautiful and enhanced Claude interface with colors, emojis, and features!
"""

from dotenv import load_dotenv
import os
import sys
import datetime
import json
from anthropic import Anthropic
from typing import List, Dict

# Color codes for beautiful terminal output
class Colors:
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

class BabyClaude:
    def __init__(self):
        load_dotenv()
        self.client = Anthropic(api_key=os.getenv('ANTHROPIC_API_KEY'))
        self.conversation_history: List[Dict] = []
        self.session_start = datetime.datetime.now()
        
    def print_header(self):
        """Print a beautiful header for Baby Claude"""
        header = f"""
{Colors.BOLD}{Colors.CLAUDE}╔══════════════════════════════════════════════╗
║  🤖 Baby Claude - Your Personal AI Assistant ║
║          Powered by Anthropic Claude          ║
╚══════════════════════════════════════════════╝{Colors.ENDC}

{Colors.OKCYAN}✨ Welcome! I'm here to help you with anything.{Colors.ENDC}
{Colors.WARNING}💡 Tips: Type 'help' for commands, 'quit' to exit{Colors.ENDC}
{Colors.OKGREEN}📅 Session started: {self.session_start.strftime('%Y-%m-%d %H:%M:%S')}{Colors.ENDC}
"""
        print(header)
    
    def print_help(self):
        """Show available commands"""
        help_text = f"""
{Colors.BOLD}{Colors.HEADER}🔧 Available Commands:{Colors.ENDC}
{Colors.OKBLUE}• help{Colors.ENDC}     - Show this help menu
{Colors.OKBLUE}• history{Colors.ENDC}  - Show conversation history
{Colors.OKBLUE}• clear{Colors.ENDC}    - Clear conversation history
{Colors.OKBLUE}• save{Colors.ENDC}     - Save conversation to file
{Colors.OKBLUE}• stats{Colors.ENDC}    - Show session statistics
{Colors.OKBLUE}• quit{Colors.ENDC}     - Exit Baby Claude

{Colors.OKCYAN}🌟 Just type your question and I'll help!{Colors.ENDC}
"""
        print(help_text)
    
    def print_stats(self):
        """Show session statistics"""
        duration = datetime.datetime.now() - self.session_start
        stats = f"""
{Colors.BOLD}{Colors.HEADER}📊 Session Statistics:{Colors.ENDC}
{Colors.OKGREEN}⏱️  Duration: {str(duration).split('.')[0]}{Colors.ENDC}
{Colors.OKGREEN}💬 Messages exchanged: {len(self.conversation_history)}{Colors.ENDC}
{Colors.OKGREEN}🚀 Started: {self.session_start.strftime('%H:%M:%S')}{Colors.ENDC}
"""
        print(stats)
    
    def save_conversation(self):
        """Save conversation to a JSON file"""
        if not self.conversation_history:
            print(f"{Colors.WARNING}📝 No conversation to save yet!{Colors.ENDC}")
            return
            
        timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"claude_conversation_{timestamp}.json"
        
        conversation_data = {
            'session_start': self.session_start.isoformat(),
            'session_end': datetime.datetime.now().isoformat(),
            'messages': self.conversation_history
        }
        
        try:
            with open(filename, 'w', encoding='utf-8') as f:
                json.dump(conversation_data, f, indent=2, ensure_ascii=False)
            print(f"{Colors.OKGREEN}💾 Conversation saved to: {filename}{Colors.ENDC}")
        except Exception as e:
            print(f"{Colors.FAIL}❌ Error saving conversation: {e}{Colors.ENDC}")
    
    def chat_with_claude(self, message: str) -> str:
        """Send message to Claude and get response"""
        try:
            # Show thinking animation
            print(f"{Colors.CLAUDE}🤔 Claude is thinking...{Colors.ENDC}", end="", flush=True)
            
            response = self.client.messages.create(
                model="claude-3-5-sonnet-20241022",
                max_tokens=4000,
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
        """Display conversation history"""
        if not self.conversation_history:
            print(f"{Colors.WARNING}📜 No conversation history yet!{Colors.ENDC}")
            return
            
        print(f"\n{Colors.BOLD}{Colors.HEADER}📜 Conversation History:{Colors.ENDC}")
        for i, exchange in enumerate(self.conversation_history, 1):
            timestamp = datetime.datetime.fromisoformat(exchange['timestamp']).strftime('%H:%M:%S')
            print(f"\n{Colors.SYSTEM}[{timestamp}] Exchange {i}:{Colors.ENDC}")
            print(f"{Colors.USER}👤 You: {exchange['user'][:100]}{'...' if len(exchange['user']) > 100 else ''}{Colors.ENDC}")
            print(f"{Colors.CLAUDE}🤖 Claude: {exchange['claude'][:100]}{'...' if len(exchange['claude']) > 100 else ''}{Colors.ENDC}")
    
    def run(self):
        """Main chat loop"""
        self.print_header()
        
        try:
            while True:
                # Get user input with beautiful prompt
                user_input = input(f"\n{Colors.USER}{Colors.BOLD}👤 You: {Colors.ENDC}").strip()
                
                if not user_input:
                    continue
                    
                # Handle commands
                if user_input.lower() == 'quit':
                    print(f"\n{Colors.OKCYAN}👋 Goodbye! Thanks for chatting with Baby Claude!{Colors.ENDC}")
                    break
                elif user_input.lower() == 'help':
                    self.print_help()
                    continue
                elif user_input.lower() == 'history':
                    self.show_history()
                    continue
                elif user_input.lower() == 'clear':
                    self.conversation_history.clear()
                    print(f"{Colors.OKGREEN}🧹 Conversation history cleared!{Colors.ENDC}")
                    continue
                elif user_input.lower() == 'save':
                    self.save_conversation()
                    continue
                elif user_input.lower() == 'stats':
                    self.print_stats()
                    continue
                
                # Get Claude's response
                response = self.chat_with_claude(user_input)
                
                # Display Claude's response with beautiful formatting
                print(f"\n{Colors.CLAUDE}{Colors.BOLD}🤖 Claude:{Colors.ENDC}")
                print(f"{Colors.CLAUDE}{response}{Colors.ENDC}")
                
        except KeyboardInterrupt:
            print(f"\n\n{Colors.OKCYAN}👋 Goodbye! Thanks for chatting with Baby Claude!{Colors.ENDC}")
        except Exception as e:
            print(f"\n{Colors.FAIL}❌ An error occurred: {e}{Colors.ENDC}")

def main():
    """Entry point for Baby Claude"""
    if len(sys.argv) > 1:
        # Quick mode: ask a single question
        question = " ".join(sys.argv[1:])
        claude = BabyClaude()
        print(f"{Colors.USER}👤 Question: {question}{Colors.ENDC}")
        response = claude.chat_with_claude(question)
        print(f"\n{Colors.CLAUDE}🤖 Claude: {response}{Colors.ENDC}")
    else:
        # Interactive mode
        claude = BabyClaude()
        claude.run()

if __name__ == "__main__":
    main()