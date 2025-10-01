# GitHub Authentication Setup Guide

You have **three authentication options** for your self-hosted runners. Choose the one that works best for you:

## Option 1: GitHub CLI Authentication (Recommended ✅)

This is the **easiest and most secure** method using your regular GitHub login.

### Step 1: Install GitHub CLI on Windows

```powershell
# Install GitHub CLI if not already installed
winget install --id GitHub.cli
# Or via Chocolatey: choco install gh
```

### Step 2: Authenticate with GitHub

```powershell
# Login to GitHub (opens browser for authentication)
gh auth login

# Choose:
# ? What account do you want to log into? → GitHub.com
# ? What is your preferred protocol for Git operations? → HTTPS
# ? Authenticate Git with your GitHub credentials? → Yes
# ? How would you like to authenticate GitHub CLI? → Login with a web browser
```

### Step 3: Verify Authentication

```powershell
# Test that authentication works
gh auth status
gh repo list --limit 5
```

### Step 4: Configure Runner

```powershell
cd e:\modeldev\docker\runners

# Create .env file (no token needed!)
@"
REPO_URL=https://github.com/mrcsdf/modeldev
RUNNER_NAME=local-runner
RUNNER_LABELS=linux,docker,self-hosted,llm
"@ | Out-File .env -Encoding utf8
```

### Step 5: Start Runner

```powershell
# The runner will automatically get tokens using your GitHub login
docker-compose up -d
```

**Benefits:**

- ✅ Uses your existing GitHub account (no tokens to manage)
- ✅ Automatically refreshes authentication
- ✅ More secure than long-lived tokens
- ✅ Works with 2FA and SSO

---

## Option 2: Registration Token (Quick Setup)

For quick testing or if GitHub CLI doesn't work in your environment.

### Step 1: Get Registration Token

1. Go to your GitHub repository
2. Navigate to **Settings** → **Actions** → **Runners**
3. Click **"New self-hosted runner"**
4. Choose **Linux** and **x64**
5. Copy the token from the configuration command (starts with `AASB...`)

### Step 2: Configure Runner

```powershell
cd e:\modeldev\docker\runners

# Create .env file with token
@"
REPO_URL=https://github.com/mrcsdf/modeldev
GITHUB_TOKEN=AASB... # Your registration token here
RUNNER_NAME=local-runner
RUNNER_LABELS=linux,docker,self-hosted,llm
"@ | Out-File .env -Encoding utf8
```

**Note:** Registration tokens expire after 1 hour, so you'll need to get a new one if setup takes longer.

---

## Option 3: Personal Access Token (Long-term)

Best for automation or when you need long-lived authentication.

### Step 1: Create Personal Access Token

1. Go to **GitHub.com** → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. Click **"Generate new token"** → **"Generate new token (classic)"**
3. Set **Expiration** (90 days recommended)
4. Select these **scopes**:
   - `repo` (Full control of private repositories)
   - `workflow` (Update GitHub Action workflows)
   - `admin:org` → `read:org` (Read org membership - if using org repos)

### Step 2: Configure Runner

```powershell
cd e:\modeldev\docker\runners

# Create .env file with PAT
@"
REPO_URL=https://github.com/mrcsdf/modeldev
GITHUB_TOKEN=ghp_your_personal_access_token_here
RUNNER_NAME=local-runner
RUNNER_LABELS=linux,docker,self-hosted,llm
"@ | Out-File .env -Encoding utf8
```

**Benefits:**

- ✅ Long-lived (up to 1 year)
- ✅ Works for multiple repositories
- ✅ Can be used in automation scripts

---

## Starting Your Runner

Once you've configured authentication using any method above:

```powershell
# Navigate to runners directory
cd e:\modeldev\docker\runners

# Start the runner
docker-compose up -d

# Check that it's running
docker-compose logs -f github-runner
```

## Verify Runner is Connected

1. Go to your GitHub repository
2. Navigate to **Settings** → **Actions** → **Runners**
3. You should see your runner listed as **"Online"** with a green dot

## Testing Your Runner

Create a simple workflow to test:

```yaml
# .github/workflows/test-runner.yml
name: Test Self-Hosted Runner
on:
  workflow_dispatch: # Manual trigger for testing

jobs:
  test:
    runs-on: [self-hosted, llm]
    steps:
      - name: Test runner environment
        run: |
          echo "Runner is working!"
          python3 --version
          node --version
          docker --version
```

## Troubleshooting

### If runner won't connect:

```powershell
# Check logs for errors
docker-compose logs github-runner

# Check GitHub CLI authentication (if using Option 1)
gh auth status

# Rebuild container if needed
docker-compose build --no-cache
```

### If authentication fails:

- **Option 1 (GitHub CLI)**: Run `gh auth refresh`
- **Option 2 (Registration Token)**: Get a new token (they expire in 1 hour)
- **Option 3 (PAT)**: Check token hasn't expired and has correct scopes

## Security Best Practices

- 🔒 Use GitHub CLI authentication when possible (most secure)
- 🔒 Rotate Personal Access Tokens regularly
- 🔒 Use repository-specific tokens when possible
- 🔒 Monitor runner activity in GitHub Settings
- 🔒 Keep the runner container updated

## Next Steps

Once your runner is connected:

1. Create GitHub Actions workflows using `runs-on: [self-hosted, llm]`
2. Configure LM Studio for AI-assisted development
3. Set up repository-specific CI/CD pipelines
4. Scale with additional runners using `docker-compose --profile multi-runner up -d`

Your self-hosted runner is now ready for unlimited GitHub Actions with LM Studio integration! 🎉
