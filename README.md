# ModelDev - Global Development Environment

A comprehensive development environment setup that provides consistent tooling, formatting, linting, and AI-powered code reviews across all repositories.

## 🚀 Quick Start

### Windows (PowerShell as Administrator)
```powershell
.\Install-GlobalDev.ps1
```

### Linux/WSL/macOS
```bash
./wsl-bootstrap.sh
```

Both scripts will:
1. Install required tools and packages
2. Set up mise for tool version management  
3. Configure Git with global templates and hooks
4. Install development utilities
5. Set up LM Studio integration

### Self-Hosted CI/CD (Cost-Free)

After setup, configure self-hosted GitHub Actions runners to avoid cloud costs:

```bash
# Quick Docker setup
cd docker/runners
cp .env.example .env
# Edit .env with your GitHub repo and token
docker-compose up -d
```

See [Self-Hosted Runners Guide](docs/self-hosted-runners.md) for complete setup instructions.

## 🛠️ Global Development Environment

This project implements a **global development baseline** that works across every repository on your machine:

### Core Components

1. **🔧 Global Toolchain Manager (mise)**
   - Consistent Python, Node.js, Terraform versions across projects
   - Automatic tool installation per-project
   - Task runner for common development workflows

2. **📝 Global Git Templates**
   - Pre-commit hooks that auto-format and lint code
   - Conventional commit message templates
   - Consistent Git configuration across repositories

3. **⚙️ Global Settings Profile**
   - VS Code user settings for optimal development experience
   - Environment variables for LM Studio/OpenAI integration
   - Consistent formatting and linting configuration

4. **🤖 Local LLM Integration**
   - LM Studio setup for offline AI-powered code reviews
   - GitHub Actions with LLM review automation
   - Self-hosted runners for cost-effective CI/CD

## 📁 Project Structure

```
modeldev/
├── 📄 Install-GlobalDev.ps1       # Windows setup script
├── 📄 wsl-bootstrap.sh            # Linux/WSL setup script  
├── 📁 git-templates/              # Global Git hooks & templates
│   └── hooks/                     # Pre-commit, prepare-commit-msg
├── 📁 bin/                        # Global utility scripts
│   ├── ctx-collect.sh             # Context collection for AI
│   └── run-checks.sh              # Multi-language linting
├── 📁 gh-templates/               # GitHub workflow templates
│   └── workflows/ci.yaml          # CI with LLM review
├── 📁 vscode-settings/            # VS Code configuration
│   ├── settings.json              # User settings
│   └── extensions.json            # Recommended extensions
├── 📁 docker/runners/             # Self-hosted runner setup
│   ├── docker-compose.yml         # Runner services
│   ├── Dockerfile.runner          # Runner container
│   └── entrypoint.sh              # Runner startup script
├── 📁 docs/                       # Documentation
│   ├── dev_setup.md               # Development setup guide
│   └── self-hosted-runners.md     # Runner setup guide
├── 📄 .mise.toml                  # Tool versions & tasks
└── 📄 pyproject.toml              # Python project config
```

## 🔧 Tool Versions (Managed by mise)

- **Python**: 3.12 (latest stable)
- **Node.js**: LTS (latest LTS release) 
- **Terraform**: 1.9.7
- **PowerShell**: 7.4 (Windows)

All versions are automatically installed and managed by mise across projects.

## 🚀 Available Tasks

Use `mise run <task>` to execute these common development workflows:

```bash
mise run test          # Run tests with coverage
mise run lint          # Format and lint code
mise run build         # Build project 
mise run clean         # Clean build artifacts
mise run dev           # Start development server
mise run docs          # Generate documentation
```

## 🤖 LM Studio Integration

### Setup
1. Install [LM Studio](https://lmstudio.ai/)
2. Download a coding model (recommended: CodeLlama, DeepSeek Coder)
3. Start local server on port 1234
4. The environment automatically configures OpenAI-compatible API access

### Features
- **Code Reviews**: Automated PR reviews via GitHub Actions
- **Commit Messages**: AI-generated conventional commit messages
- **Documentation**: Context-aware documentation generation
- **Debugging**: Local AI assistance without cloud dependencies

## 📋 Supported Languages & Tools

### Languages
- **Python**: black, isort, flake8, mypy, pytest
- **JavaScript/TypeScript**: prettier, eslint, jest
- **Shell/PowerShell**: shellcheck, PSScriptAnalyzer
- **Terraform**: terraform fmt, tflint, tfsec
- **Docker**: hadolint
- **YAML/JSON**: yamllint, prettier
- **Markdown**: markdownlint

### Development Tools
- **Git**: Global hooks, templates, and configuration
- **VS Code**: Optimized settings and extensions
- **Docker**: Container development support
- **GitHub Actions**: CI/CD with LLM integration

## 💰 Cost-Effective CI/CD

### Self-Hosted Runners
- **Zero GitHub Actions costs** for private repositories
- **Direct LLM access** via localhost:1234
- **Consistent environment** with local development
- **Docker isolation** for secure execution

### Setup Guide
See [docs/self-hosted-runners.md](docs/self-hosted-runners.md) for:
- Docker-based runner setup
- Security configuration
- Scaling and monitoring
- Integration with LM Studio

## 🔄 Workflow Integration

### For New Repositories
1. Initialize with global settings:
   ```bash
   # Windows
   Start-GlobalDevSetup
   
   # Linux/WSL
   init_global_dev
   ```

2. Copy workflow template:
   ```bash
   cp gh-templates/workflows/ci.yaml .github/workflows/
   ```

3. Set up self-hosted runner (optional):
   ```bash
   cd docker/runners
   cp .env.example .env
   # Edit .env with repo details
   docker-compose up -d
   ```

### For Existing Projects
The global environment automatically applies to all repositories:
- Git hooks work immediately after installation
- mise detects and installs project-specific tool versions
- VS Code settings apply globally
- Utility scripts available system-wide

## 📚 Documentation

- [Development Setup](docs/dev_setup.md) - Detailed installation guide
- [Self-Hosted Runners](docs/self-hosted-runners.md) - CI/CD cost optimization
- [VS Code Workspace](docs/modeldev.code-workspace) - Multi-root workspace

## 🛡️ Security Features

- **Local LLM**: No code sent to external services
- **Isolated runners**: Docker containers for CI execution
- **Token management**: Secure GitHub integration
- **Pre-commit validation**: Security scanning before commits

## 📊 Project Benefits

- **Consistency**: Same tools and settings across all projects
- **Efficiency**: Automated formatting, linting, and testing
- **Cost-effective**: Self-hosted CI avoids cloud charges
- **Privacy**: Local LLM keeps code confidential
- **Quality**: Automated code reviews and security checks

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `mise run lint test` to validate
5. Submit a pull request

The global environment ensures consistent contribution standards across all projects.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

*Transform your development workflow with consistent tooling, local AI assistance, and cost-effective CI/CD across every repository.*

   - Context collection for comprehensive code analysis   ```bash

   pip install -r requirements.txt

### What You Get   ```



✅ **Every new repository inherits**:4. Follow the instructions for integrating the Phi3 and Moma models.

- Automatic code formatting (Black, Prettier, shfmt)

- Comprehensive linting (flake8, shellcheck, ESLint)### Usage

- Security scanning (Bandit, detect-secrets)

- Pre-commit hooks that run fast and safeTo start using the Personal DevLLM:



✅ **AI-powered development**:1. Run the application:

- GitHub Copilot integration in VS Code   ```bash

- Local LLM (LM Studio) for sensitive/offline work   python main.py

- Automated code reviews in CI/CD pipelines   ```



✅ **Multi-language support**:2. Interact with the model to assist you with coding tasks.

- Python, Shell scripts, PowerShell

- JavaScript/TypeScript, JSON, YAML## Contributing

- Terraform, Ansible, Docker

- Markdown documentationContributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) for more information on how to get involved.



## 📁 Project Structure## License



```This project is licensed under the MIT Open Source License - see the [LICENSE](LICENSE) file for details.

modeldev/

├── Install-GlobalDev.ps1      # Windows bootstrap script## Contact

├── wsl-bootstrap.sh           # Linux/WSL bootstrap script

├── bin/                       # Global utility scriptsFor questions or suggestions, feel free to reach out at [mdfern@outlook.com](mailto:mdfern@outlook.com).

│   ├── ctx-collect.sh         # Context collector for reviews
│   └── run-checks.sh          # Fast validation checks
├── git-templates/             # Global Git template directory
│   ├── hooks/                 # Pre-commit and prepare-commit-msg hooks
│   └── precommit/             # Pre-commit configuration template
├── gh-templates/              # GitHub Actions workflow templates
│   └── workflows/ci.yaml      # CI with LLM review integration
├── vscode-settings/           # VS Code configuration templates
│   ├── settings.json          # User settings for optimal development
│   └── extensions.json        # Recommended extensions
├── .mise.toml                 # Tool and task configuration
├── .pre-commit-config.yaml    # Pre-commit hooks configuration
├── pyproject.toml             # Python project configuration
└── src/                       # Project source code
```

## 🚦 Installation Guide

### 1. Windows Setup (Run as Administrator)

```powershell
# Clone this repository
git clone <repository-url>
cd modeldev

# Run the global setup script
.\Install-GlobalDev.ps1

# Optional: Skip package installation if tools already installed
.\Install-GlobalDev.ps1 -SkipPackageInstall

# Optional: Use different LM Studio port
.\Install-GlobalDev.ps1 -LMStudioPort 8080
```

**What this installs**:
- Git, VS Code, Docker Desktop, Python 3.12, Node.js LTS
- Global Git configuration and templates
- Environment variables for LM Studio integration
- PowerShell profile functions

### 2. WSL/Linux Setup

```bash
# Copy and run the bootstrap script
cp wsl-bootstrap.sh ~/
bash ~/wsl-bootstrap.sh
```

**What this installs**:
- Essential development packages (git, curl, shellcheck, etc.)
- mise toolchain manager
- Python development tools via pipx
- Git configuration and environment variables

### 3. LM Studio Setup

1. **Install LM Studio**: Download from [lmstudio.ai](https://lmstudio.ai/)
2. **Configure API Server**:
   - Enable local server in LM Studio
   - Set port to 1234 (or your preferred port)
   - Choose a code-oriented model (7B-14B recommended)
3. **Optional**: Create scheduled task to auto-start LM Studio with API server

### 4. VS Code Configuration

```bash
# Copy global settings (adjust path for your OS)
# Windows:
cp vscode-settings/settings.json "$env:APPDATA/Code/User/settings.json"

# macOS:
cp vscode-settings/settings.json "~/Library/Application Support/Code/User/settings.json"

# Linux:
cp vscode-settings/settings.json "~/.config/Code/User/settings.json"
```

## 🔄 Workflow Integration

### For New Repositories

**Windows PowerShell**:
```powershell
# Initialize a new repository with global dev setup
mkdir my-new-project
cd my-new-project
git init
Start-GlobalDevSetup
```

**Linux/WSL Bash**:
```bash
# Initialize a new repository with global dev setup
mkdir my-new-project
cd my-new-project
git init
init_global_dev
```

### Daily Development

1. **Code with confidence**: Pre-commit hooks catch issues before commit
2. **Get AI assistance**: 
   - Use GitHub Copilot for real-time suggestions
   - Ask local LLM for sensitive code review
3. **Automated CI**: GitHub Actions run comprehensive checks and LLM reviews
4. **Consistent quality**: All repositories follow the same standards

### Available Commands

**Windows PowerShell Functions**:
- `Add-PrecommitTemplate [path]` - Add pre-commit config to repository
- `Copy-CITemplate [path]` - Add CI workflow to repository
- `Start-GlobalDevSetup [path]` - Full repository initialization

**Linux/WSL Bash Functions**:
- `add_precommit_template [path]` - Add pre-commit config to repository
- `copy_ci_template [path]` - Add CI workflow to repository
- `init_global_dev [path]` - Full repository initialization

**Global Scripts** (available in PATH):
- `ctx-collect.sh [output-file]` - Collect repository context for reviews
- `run-checks.sh` - Run fast validation checks across project

**mise Tasks**:
```bash
mise run install    # Install project dependencies
mise run test       # Run all tests
mise run lint       # Run linting and type checks
mise run format     # Format all code
mise run security   # Run security scans
mise run clean      # Clean build artifacts
```

## 🔒 Security Features

- **Secret Detection**: Automatic scanning for API keys, passwords, tokens
- **Security Linting**: Bandit for Python security issues
- **Dependency Scanning**: GitHub Actions security advisories
- **Local LLM Option**: Keep sensitive code analysis offline with LM Studio

## 🌐 Multi-Language Support

| Language | Formatting | Linting | Testing | Security |
|----------|------------|---------|---------|----------|
| Python | Black, isort | flake8, mypy, pylint | pytest | Bandit |
| Shell | shfmt | shellcheck | - | - |
| PowerShell | PSScriptAnalyzer | PSScriptAnalyzer | Pester | PSScriptAnalyzer |
| JavaScript/TS | Prettier | ESLint | Jest/Vitest | npm audit |
| Terraform | terraform fmt | tflint, checkov | terratest | checkov |
| YAML | Prettier | yamllint | - | - |
| JSON | Prettier | Built-in | - | - |
| Markdown | Prettier | markdownlint | - | - |

## 🚀 CI/CD Integration

The included GitHub Actions workflow (`gh-templates/workflows/ci.yaml`) provides:

1. **Code Quality Checks**: Formatting, linting, type checking
2. **Security Scanning**: Secret detection, dependency vulnerabilities
3. **Testing**: Unit tests with coverage reporting
4. **Build & Package**: Python package building, Docker image creation
5. **LLM Code Review**: AI-powered code review on pull requests
6. **Preview Deployments**: Optional preview environment setup

### Setting Up CI

1. **Copy workflow template**:
   ```bash
   mkdir -p .github/workflows
   cp gh-templates/workflows/ci.yaml .github/workflows/
   ```

2. **Configure secrets** (in GitHub repository settings):
   - `LLM_BASE_URL`: Your LLM endpoint (default: OpenAI)
   - `LLM_API_KEY`: API key for LLM service
   - Optional: `OPENAI_API_KEY` as fallback

3. **Customize workflow**: Edit the workflow file to match your project needs

## 🔧 Configuration

### Environment Variables

Set globally by the installation scripts:

```bash
# LM Studio integration
OPENAI_BASE_URL="http://localhost:1234/v1"
OPENAI_API_KEY="lm-studio"

# Development settings
PYTHONUNBUFFERED="1"
FORCE_COLOR="1"
```

### Tool Configuration

- **mise**: `.mise.toml` - Tool versions and task definitions
- **pre-commit**: `.pre-commit-config.yaml` - Hook configuration
- **Python**: `pyproject.toml` - All Python tool settings
- **Git**: Global template in `~/.git-templates/`

## 📚 Advanced Usage

### Custom LLM Integration

```python
# Example: Using the global LLM setup in your scripts
import os
import openai

# Automatically uses global environment variables
client = openai.OpenAI()  # Uses OPENAI_BASE_URL and OPENAI_API_KEY

response = client.chat.completions.create(
    model="local-model",  # Will work with LM Studio
    messages=[{"role": "user", "content": "Review this code..."}]
)
```

### Custom Pre-commit Hooks

Add project-specific hooks to `.pre-commit-config.yaml`:

```yaml
repos:
  # ... existing hooks ...
  
  # Project-specific hooks
  - repo: local
    hooks:
      - id: custom-validation
        name: Custom Validation
        entry: python scripts/validate.py
        language: system
        types: [python]
```

### mise Task Automation

Define custom tasks in `.mise.toml`:

```toml
[tasks.deploy]
description = "Deploy to staging"
run = [
    "mise run test",
    "mise run security", 
    "docker build -t myapp .",
    "kubectl apply -f k8s/"
]
```

## 🤝 Contributing

1. Follow the global development standards (automatically enforced)
2. Use conventional commits (guided by prepare-commit-msg hook)
3. Ensure all checks pass before submitting PR
4. LLM review will provide automated feedback

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🆘 Troubleshooting

### Common Issues

**Pre-commit hooks failing**:
```bash
# Update and reinstall hooks
pre-commit clean
pre-commit install
pre-commit run --all-files
```

**mise tool installation issues**:
```bash
# Clean and reinstall tools
mise cache clear
mise install
```

**LM Studio connection issues**:
- Verify LM Studio API server is running on correct port
- Check environment variables: `echo $OPENAI_BASE_URL`
- Test connection: `curl $OPENAI_BASE_URL/v1/models`

**VS Code integration issues**:
- Reload window after installing extensions
- Check Python interpreter selection
- Verify extension settings in User Settings

### Getting Help

1. Check the [Issues](../../issues) section for common problems
2. Review hook logs in `.git/hooks/` for debugging
3. Use `mise doctor` to diagnose tool installation issues
4. Test individual tools: `black --version`, `flake8 --version`, etc.

## 📧 Contact

For questions or suggestions, feel free to reach out at [mdfern@outlook.com](mailto:mdfern@outlook.com).

---

**Happy coding with your global development environment!** 🎉