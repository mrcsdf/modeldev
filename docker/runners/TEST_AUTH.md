# Quick Test Script for GitHub CLI Authentication

## Test 1: Check if GitHub CLI is installed and working

```powershell
# Check if GitHub CLI is installed
gh --version

# Check authentication status
gh auth status
```

## Test 2: Test repository access

```powershell
# List your repositories (should work if authenticated)
gh repo list --limit 5

# Test API access to specific repo (replace with your repo)
gh api repos/yourusername/yourrepo/actions/runners
```

## Test 3: Container with GitHub CLI

Once the build completes:

```powershell
# Test GitHub CLI in container (using host auth)
docker run --rm -v ${env:USERPROFILE}/.config/gh:/home/runner/.config/gh:ro --entrypoint gh github-runners-github-runner --version

# Test API access from container
docker run --rm -v ${env:USERPROFILE}/.config/gh:/home/runner/.config/gh:ro --entrypoint gh github-runners-github-runner auth status
```

## If you don't have GitHub CLI yet:

```powershell
# Install GitHub CLI
winget install --id GitHub.cli

# Restart terminal, then authenticate
gh auth login
```

This will make the runner setup much easier - no more manual token management!
