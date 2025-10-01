#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Global Development Environment Bootstrap for Windows

.DESCRIPTION
    Sets up a comprehensive development environment with:
    - Core development tools (Git, VS Code, Docker, Python, Node.js)
    - Global Git templates with hooks
    - LM Studio integration for local LLM
    - Pre-commit configurations
    - Global toolchain management with mise

.PARAMETER SkipPackageInstall
    Skip winget package installation (if tools already installed)

.PARAMETER LMStudioPort
    Port for LM Studio API server (default: 1234)

.EXAMPLE
    .\Install-GlobalDev.ps1

.EXAMPLE
    .\Install-GlobalDev.ps1 -SkipPackageInstall -LMStudioPort 8080
#>

param(
    [switch]$SkipPackageInstall,
    [int]$LMStudioPort = 1234
)

# Color output functions
function Write-SuccessMessage { param([string]$Message) Write-Output "✓ $Message" }
function Write-InfoMessage { param([string]$Message) Write-Output "ℹ $Message" }
function Write-WarningMessage { param([string]$Message) Write-Output "⚠ $Message" }
function Write-ErrorMessage { param([string]$Message) Write-Output "✗ $Message" }

Write-InfoMessage "Starting Global Development Environment Setup..."

# Core packages installation
if (-not $SkipPackageInstall) {
    Write-InfoMessage "Installing core development packages via winget..."

    $packages = @(
        @{Id = "Git.Git"; Name = "Git"},
        @{Id = "Microsoft.VisualStudioCode"; Name = "VS Code"},
        @{Id = "Docker.DockerDesktop"; Name = "Docker Desktop"},
        @{Id = "Python.Python.3.12"; Name = "Python 3.12"},
        @{Id = "OpenJS.NodeJS.LTS"; Name = "Node.js LTS"}
    )

    foreach ($pkg in $packages) {
        try {
            Write-InfoMessage "Installing $($pkg.Name)..."
            winget install -e --id $pkg.Id --accept-source-agreements --accept-package-agreements
            Write-SuccessMessage "$($pkg.Name) installed"
        }
        catch {
            $errorMsg = $_.Exception.Message
            Write-WarningMessage "Failed to install $($pkg.Name): $errorMsg"
        }
    }

    Write-InfoMessage "Please install LM Studio manually from https://lmstudio.ai/"
    Write-WarningMessage "After installation, configure LM Studio to start API server on port $LMStudioPort"
} else {
    Write-InfoMessage "Skipping package installation"
}

# Global Git configuration
Write-InfoMessage "Configuring global Git settings..."
try {
    git config --global init.templateDir "$env:USERPROFILE\.git-templates"
    git config --global core.hooksPath "$env:USERPROFILE\.git-templates\hooks"
    git config --global pull.rebase false
    git config --global fetch.prune true
    git config --global user.name "$(git config user.name)" 2>$null
    if (-not $?) {
        $name = Read-Host "Enter your Git username"
        git config --global user.name $name
    }
    git config --global user.email "$(git config user.email)" 2>$null
    if (-not $?) {
        $email = Read-Host "Enter your Git email"
        git config --global user.email $email
    }
    Write-SuccessMessage "Git configuration complete"
}
catch {
    $errorMsg = $_.Exception.Message
    Write-ErrorMessage "Git configuration failed: $errorMsg"
}

# Create directory structure
Write-InfoMessage "Creating directory structure..."
$directories = @(
    "$env:USERPROFILE\.git-templates\hooks",
    "$env:USERPROFILE\.git-templates\precommit",
    "$env:USERPROFILE\.config\mise",
    "$env:USERPROFILE\.gh-templates\workflows",
    "$env:USERPROFILE\bin"
)

foreach ($dir in $directories) {
    try {
        New-Item -Force -ItemType Directory $dir | Out-Null
        Write-SuccessMessage "Created directory: $dir"
    }
    catch {
        $errorMsg = $_.Exception.Message
        Write-ErrorMessage "Failed to create directory ${dir}: $errorMsg"
    }
}

# Set environment variables for LM Studio integration
Write-InfoMessage "Setting environment variables for LM Studio integration..."
try {
    [Environment]::SetEnvironmentVariable("OPENAI_BASE_URL", "http://localhost:${LMStudioPort}/v1", "User")
    [Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "lm-studio", "User")
    Write-SuccessMessage "Environment variables set for LM Studio on port $LMStudioPort"
}
catch {
    $errorMsg = $_.Exception.Message
    Write-ErrorMessage "Failed to set environment variables: $errorMsg"
}

# Add user bin to PATH if not already present
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
$binPath = "$env:USERPROFILE\bin"
if ($userPath -notlike "*$binPath*") {
    try {
        [Environment]::SetEnvironmentVariable("PATH", "$userPath;$binPath", "User")
        Write-SuccessMessage "Added $binPath to user PATH"
    }
    catch {
        $errorMsg = $_.Exception.Message
        Write-ErrorMessage "Failed to update PATH: $errorMsg"
    }
}

# Create PowerShell profile function for pre-commit template
Write-InfoMessage "Setting up PowerShell profile functions..."
$profileContent = @'

# Global Development Environment Functions
function Add-PrecommitTemplate {
    <#
    .SYNOPSIS
        Copies starter pre-commit config into a repository
    #>
    param([string]$Path = ".")

    $templatePath = "$env:USERPROFILE\.git-templates\precommit\.pre-commit-config.yaml"
    $targetPath = Join-Path $Path ".pre-commit-config.yaml"

    if (Test-Path $templatePath) {
        Copy-Item $templatePath -Destination $targetPath -Force
        Push-Location $Path
        try {
            pre-commit install
            Write-Host "✓ Pre-commit template installed" -ForegroundColor Green
        }
        catch {
            Write-Host "⚠ Pre-commit not found. Install with: pip install pre-commit" -ForegroundColor Yellow
        }
        finally {
            Pop-Location
        }
    } else {
        Write-Host "✗ Template not found at $templatePath" -ForegroundColor Red
    }
}

function Copy-CITemplate {
    <#
    .SYNOPSIS
        Copies CI workflow template to current repository
    #>
    param([string]$Path = ".")

    $templatePath = "$env:USERPROFILE\.gh-templates\workflows\ci.yaml"
    $targetDir = Join-Path $Path ".github\workflows"
    $targetPath = Join-Path $targetDir "ci.yaml"

    if (Test-Path $templatePath) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Copy-Item $templatePath -Destination $targetPath -Force
        Write-Host "✓ CI template copied to $targetPath" -ForegroundColor Green
    } else {
        Write-Host "✗ CI template not found at $templatePath" -ForegroundColor Red
    }
}

function Start-GlobalDevSetup {
    <#
    .SYNOPSIS
        Initialize a new repository with global dev templates
    #>
    param([string]$Path = ".")

    Push-Location $Path
    try {
        Add-PrecommitTemplate
        Copy-CITemplate
        Write-Host "✓ Repository initialized with global dev setup" -ForegroundColor Green
    }
    finally {
        Pop-Location
    }
}

'@

try {
    if (Test-Path $PROFILE) {
        $currentProfile = Get-Content $PROFILE -Raw
        if ($currentProfile -notlike "*Add-PrecommitTemplate*") {
            Add-Content $PROFILE $profileContent
            Write-SuccessMessage "PowerShell profile functions added"
        } else {
            Write-InfoMessage "PowerShell profile functions already exist"
        }
    } else {
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
        Set-Content $PROFILE $profileContent
        Write-SuccessMessage "PowerShell profile created with functions"
    }
}
catch {
    $errorMsg = $_.Exception.Message
    Write-ErrorMessage "Failed to update PowerShell profile: $errorMsg"
}

Write-SuccessMessage "Global Development Environment setup completed!"
Write-InfoMessage @"

Next steps:
1. Restart your PowerShell session to load new functions
2. Install LM Studio from https://lmstudio.ai/ if not already done
3. Configure LM Studio to start API server on port $LMStudioPort
4. Run the WSL bootstrap script in your Linux environment
5. Use Add-PrecommitTemplate in repositories to set up pre-commit hooks

Available functions in new PowerShell sessions:
- Add-PrecommitTemplate [path]  # Add pre-commit config to repo
- Copy-CITemplate [path]        # Add CI workflow to repo
- Start-GlobalDevSetup [path]   # Full repo initialization

Environment variables set:
- OPENAI_BASE_URL=http://localhost:${LMStudioPort}/v1
- OPENAI_API_KEY=lm-studio
"@
