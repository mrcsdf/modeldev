#!/usr/bin/env bash
set -euo pipefail

# WSL Global Development Environment Bootstrap
# Supports Ubuntu (apt) and Azure Linux/Mariner (tdnf)
# Run with: bash ~/wsl-bootstrap.sh

# Color output functions
green() { echo -e "\033[32m✓ $1\033[0m"; }
blue() { echo -e "\033[34mℹ $1\033[0m"; }
yellow() { echo -e "\033[33m⚠ $1\033[0m"; }
red() { echo -e "\033[31m✗ $1\033[0m"; }

blue "Starting WSL Global Development Environment Setup..."

# Detect package manager
if command -v apt >/dev/null 2>&1; then 
    PM=apt
    blue "Detected Ubuntu/Debian (apt)"
elif command -v tdnf >/dev/null 2>&1; then 
    PM=tdnf
    blue "Detected Azure Linux/Mariner (tdnf)"
else 
    red "Unsupported distribution - need apt or tdnf"
    exit 1
fi

# Install packages based on package manager
blue "Installing core development packages..."
case "$PM" in
  apt)
    sudo apt update -y
    sudo apt install -y \
      git curl unzip jq python3 python3-pip python3-venv \
      shellcheck shfmt ansible docker.io make gawk ripgrep fd-find \
      software-properties-common build-essential \
      nodejs npm
    green "Ubuntu packages installed"
    ;;
  tdnf)
    # Azure Linux (Mariner)
    sudo tdnf install -y \
      git curl unzip jq python3 python3-pip \
      ShellCheck shfmt ansible docker make gawk ripgrep fd-find \
      nodejs npm
    green "Azure Linux packages installed"
    ;;
esac

# Install mise (global toolchain manager)
blue "Installing mise toolchain manager..."
if ! command -v mise >/dev/null 2>&1; then
    curl -fsSL https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
    
    # Add mise to shell profile
    if ! grep -q "mise activate" ~/.bashrc 2>/dev/null; then
        echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
        green "Added mise to ~/.bashrc"
    fi
    
    # Add mise to zsh if it exists
    if [ -f ~/.zshrc ] && ! grep -q "mise activate" ~/.zshrc 2>/dev/null; then
        echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
        green "Added mise to ~/.zshrc"
    fi
    
    green "mise installed"
else
    green "mise already installed"
fi

# Create mise configuration
blue "Configuring mise global tools..."
mkdir -p ~/.config/mise
cat > ~/.config/mise/config.toml <<'EOF'
[tools]
python = "3.12"
node = "lts"
terraform = "1.9.7"
# Optionals (uncomment as needed):
# golang = "1.22"
# deno = "latest"
# poetry = "latest"

[settings]
experimental = true
trusted_config_paths = ["~/.config/mise"]

# Python configuration
[tools.python]
default = "3.12"

[tools.node]
default = "lts"
EOF
green "mise configuration created"

# Install Python tools via pipx
blue "Installing Python development tools..."
python3 -m pip install --user --upgrade pip pipx
python3 -m pipx ensurepath

# Essential Python tools
PYTHON_TOOLS=(
    "pre-commit"
    "ansible-lint"
    "bandit"
    "flake8"
    "black"
    "isort"
    "mypy"
    "pylint"
    "pytest"
    "bowler"
    "libcst"
)

# Optional tools that might not be available everywhere
OPTIONAL_TOOLS=(
    "tflint"
    "checkov"
)

for tool in "${PYTHON_TOOLS[@]}"; do
    if ! ~/.local/bin/pipx list | grep -q "$tool" 2>/dev/null; then
        blue "Installing $tool..."
        ~/.local/bin/pipx install "$tool" || yellow "Failed to install $tool"
    else
        green "$tool already installed"
    fi
done

for tool in "${OPTIONAL_TOOLS[@]}"; do
    if ! ~/.local/bin/pipx list | grep -q "$tool" 2>/dev/null; then
        blue "Installing optional tool $tool..."
        ~/.local/bin/pipx install "$tool" || yellow "Optional tool $tool not available"
    else
        green "$tool already installed"
    fi
done

# Docker permissions (if Docker group exists)
if getent group docker >/dev/null 2>&1; then
    if ! groups "$USER" | grep -q docker; then
        blue "Adding user to docker group..."
        sudo usermod -aG docker "$USER"
        green "Added $USER to docker group (restart session to take effect)"
    else
        green "User already in docker group"
    fi
fi

# Create directory structure
blue "Creating directory structure..."
mkdir -p ~/.git-templates/hooks
mkdir -p ~/.git-templates/precommit  
mkdir -p ~/.gh-templates/workflows
mkdir -p ~/bin

green "Directory structure created"

# Set up Git configuration
blue "Configuring Git settings..."
git config --global init.templateDir "$HOME/.git-templates"
git config --global core.hooksPath "$HOME/.git-templates/hooks"
git config --global pull.rebase false
git config --global fetch.prune true

# Check if user name/email are set
if ! git config --global user.name >/dev/null 2>&1; then
    yellow "Git user.name not set. Set with: git config --global user.name 'Your Name'"
fi

if ! git config --global user.email >/dev/null 2>&1; then
    yellow "Git user.email not set. Set with: git config --global user.email 'your@email.com'"
fi

green "Git configuration complete"

# Set environment variables for LM Studio (Windows host integration)
blue "Setting up environment variables for LM Studio integration..."
if ! grep -q "OPENAI_BASE_URL" ~/.bashrc; then
    cat >> ~/.bashrc <<'EOF'

# LM Studio integration (Windows host)
export OPENAI_BASE_URL="http://localhost:1234/v1"
export OPENAI_API_KEY="lm-studio"
EOF
    green "Environment variables added to ~/.bashrc"
fi

# Add for zsh too if it exists
if [ -f ~/.zshrc ] && ! grep -q "OPENAI_BASE_URL" ~/.zshrc; then
    cat >> ~/.zshrc <<'EOF'

# LM Studio integration (Windows host)  
export OPENAI_BASE_URL="http://localhost:1234/v1"
export OPENAI_API_KEY="lm-studio"
EOF
    green "Environment variables added to ~/.zshrc"
fi

# Add ~/bin to PATH if not already there
if ! grep -q "$HOME/bin" ~/.bashrc; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    green "Added ~/bin to PATH in ~/.bashrc"
fi

if [ -f ~/.zshrc ] && ! grep -q "$HOME/bin" ~/.zshrc; then
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
    green "Added ~/bin to PATH in ~/.zshrc"
fi

# Create helper functions
blue "Creating shell helper functions..."
cat >> ~/.bashrc <<'EOF'

# Global Development Environment Functions
add_precommit_template() {
    local path="${1:-.}"
    local template="$HOME/.git-templates/precommit/.pre-commit-config.yaml"
    local target="$path/.pre-commit-config.yaml"
    
    if [ -f "$template" ]; then
        cp "$template" "$target"
        (cd "$path" && pre-commit install)
        echo "✓ Pre-commit template installed in $path"
    else
        echo "✗ Template not found at $template"
    fi
}

copy_ci_template() {
    local path="${1:-.}"
    local template="$HOME/.gh-templates/workflows/ci.yaml"
    local target_dir="$path/.github/workflows"
    local target="$target_dir/ci.yaml"
    
    if [ -f "$template" ]; then
        mkdir -p "$target_dir"
        cp "$template" "$target"
        echo "✓ CI template copied to $target"
    else
        echo "✗ CI template not found at $template"
    fi
}

init_global_dev() {
    local path="${1:-.}"
    add_precommit_template "$path"
    copy_ci_template "$path"
    echo "✓ Repository initialized with global dev setup"
}
EOF

if [ -f ~/.zshrc ]; then
    # Add the same functions to zsh
    cat >> ~/.zshrc <<'EOF'

# Global Development Environment Functions  
add_precommit_template() {
    local path="${1:-.}"
    local template="$HOME/.git-templates/precommit/.pre-commit-config.yaml"
    local target="$path/.pre-commit-config.yaml"
    
    if [ -f "$template" ]; then
        cp "$template" "$target"
        (cd "$path" && pre-commit install)
        echo "✓ Pre-commit template installed in $path"
    else
        echo "✗ Template not found at $template"
    fi
}

copy_ci_template() {
    local path="${1:-.}"
    local template="$HOME/.gh-templates/workflows/ci.yaml"
    local target_dir="$path/.github/workflows"
    local target="$target_dir/ci.yaml"
    
    if [ -f "$template" ]; then
        mkdir -p "$target_dir"
        cp "$template" "$target"
        echo "✓ CI template copied to $target"
    else
        echo "✗ CI template not found at $template"
    fi
}

init_global_dev() {
    local path="${1:-.}"
    add_precommit_template "$path"
    copy_ci_template "$path"
    echo "✓ Repository initialized with global dev setup"
}
EOF
fi

green "Shell helper functions added"

green "WSL bootstrap complete!"
blue "Next steps:"
echo "1. Open a new shell to pick up PATH and environment changes"
echo "2. Run 'mise install' to install configured tool versions"
echo "3. Set Git user: git config --global user.name 'Your Name'"
echo "4. Set Git email: git config --global user.email 'your@email.com'"
echo ""
blue "Available functions:"
echo "- add_precommit_template [path]  # Add pre-commit config to repo"
echo "- copy_ci_template [path]        # Add CI workflow to repo"
echo "- init_global_dev [path]         # Full repo initialization"
echo ""
blue "Environment variables set:"
echo "- OPENAI_BASE_URL=http://localhost:1234/v1"
echo "- OPENAI_API_KEY=lm-studio"