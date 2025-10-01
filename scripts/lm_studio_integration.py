#!/usr/bin/env python3
"""
LM Studio Integration Test and Helper
Tests connectivity to LM Studio and provides utilities for AI-assisted development.
"""

import json
import os
import sys
from typing import Dict, List, Optional

import requests


class LMStudioClient:
    """Client for interacting with LM Studio local server."""
    
    def __init__(self, base_url: str = "http://localhost:1234"):
        self.base_url = base_url.rstrip('/')
        self.session = requests.Session()
        self.session.timeout = 30
    
    def health_check(self) -> bool:
        """Check if LM Studio is running and accessible."""
        try:
            response = self.session.get(f"{self.base_url}/health")
            return response.status_code == 200
        except requests.RequestException:
            return False
    
    def get_models(self) -> List[Dict]:
        """Get available models from LM Studio."""
        try:
            response = self.session.get(f"{self.base_url}/v1/models")
            if response.status_code == 200:
                return response.json().get("data", [])
            return []
        except requests.RequestException:
            return []
    
    def chat_completion(self, messages: List[Dict], model: Optional[str] = None) -> Optional[str]:
        """Send a chat completion request to LM Studio."""
        try:
            payload = {
                "messages": messages,
                "temperature": 0.7,
                "max_tokens": 1000,
                "stream": False
            }
            
            if model:
                payload["model"] = model
            
            response = self.session.post(
                f"{self.base_url}/v1/chat/completions",
                json=payload,
                headers={"Content-Type": "application/json"}
            )
            
            if response.status_code == 200:
                result = response.json()
                return result["choices"][0]["message"]["content"]
            return None
        except requests.RequestException:
            return None


def test_connectivity():
    """Test LM Studio connectivity and basic functionality."""
    print("🤖 Testing LM Studio Integration...")
    
    client = LMStudioClient()
    
    # Test health check
    print("📡 Checking LM Studio connectivity...")
    if not client.health_check():
        print("❌ LM Studio is not accessible at localhost:1234")
        print("💡 Make sure LM Studio is running with local server enabled")
        return False
    
    print("✅ LM Studio is accessible!")
    
    # Test models
    print("🔍 Checking available models...")
    models = client.get_models()
    if not models:
        print("⚠️  No models found or models endpoint not available")
        print("💡 Make sure a model is loaded in LM Studio")
        return False
    
    print(f"✅ Found {len(models)} model(s):")
    for model in models:
        print(f"   - {model.get('id', 'Unknown')}")
    
    # Test chat completion
    print("💬 Testing chat completion...")
    test_messages = [
        {"role": "user", "content": "Say 'Hello from GitHub Actions!' if you can hear me."}
    ]
    
    response = client.chat_completion(test_messages)
    if response:
        print(f"✅ Chat completion successful!")
        print(f"🤖 Response: {response}")
        return True
    else:
        print("❌ Chat completion failed")
        return False


def code_review(file_path: str, model: Optional[str] = None) -> Optional[str]:
    """Perform AI code review on a file."""
    if not os.path.exists(file_path):
        print(f"❌ File not found: {file_path}")
        return None
    
    with open(file_path, 'r', encoding='utf-8') as f:
        code_content = f.read()
    
    client = LMStudioClient()
    
    messages = [
        {
            "role": "system",
            "content": """You are an expert code reviewer. Analyze the provided code for:
1. Code quality and best practices
2. Potential bugs or security issues
3. Performance improvements
4. Documentation and readability
5. Adherence to language conventions

Provide constructive feedback in a clear, actionable format."""
        },
        {
            "role": "user",
            "content": f"Please review this code file ({file_path}):\n\n```\n{code_content}\n```"
        }
    ]
    
    print(f"🤖 Performing AI code review on {file_path}...")
    return client.chat_completion(messages, model)


def suggest_improvements(file_path: str, model: Optional[str] = None) -> Optional[str]:
    """Get AI suggestions for code improvements."""
    if not os.path.exists(file_path):
        print(f"❌ File not found: {file_path}")
        return None
    
    with open(file_path, 'r', encoding='utf-8') as f:
        code_content = f.read()
    
    client = LMStudioClient()
    
    messages = [
        {
            "role": "system",
            "content": """You are a senior software engineer. Suggest specific improvements for the provided code:
1. Refactoring opportunities
2. Better error handling
3. Performance optimizations
4. Modern language features
5. Testing improvements

Provide concrete, implementable suggestions with code examples where helpful."""
        },
        {
            "role": "user",
            "content": f"Suggest improvements for this code ({file_path}):\n\n```\n{code_content}\n```"
        }
    ]
    
    print(f"💡 Getting AI improvement suggestions for {file_path}...")
    return client.chat_completion(messages, model)


def main():
    """Main function for command-line usage."""
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python lm_studio_integration.py test              # Test connectivity")
        print("  python lm_studio_integration.py review <file>     # Code review")
        print("  python lm_studio_integration.py improve <file>    # Suggest improvements")
        return
    
    command = sys.argv[1]
    
    if command == "test":
        success = test_connectivity()
        sys.exit(0 if success else 1)
    
    elif command == "review" and len(sys.argv) >= 3:
        file_path = sys.argv[2]
        result = code_review(file_path)
        if result:
            print("\n📝 Code Review Results:")
            print("=" * 50)
            print(result)
        else:
            print("❌ Code review failed")
            sys.exit(1)
    
    elif command == "improve" and len(sys.argv) >= 3:
        file_path = sys.argv[2]
        result = suggest_improvements(file_path)
        if result:
            print("\n💡 Improvement Suggestions:")
            print("=" * 50)
            print(result)
        else:
            print("❌ Failed to get improvement suggestions")
            sys.exit(1)
    
    else:
        print("❌ Invalid command or missing file argument")
        sys.exit(1)


if __name__ == "__main__":
    main()