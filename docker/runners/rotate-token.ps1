# Rotate GitHub Actions runner registration token and restart runners
# Usage: Run from E:\modeldev\docker\runners as an administrator or appropriate user

param()

# Get fresh registration token
Write-Output "Fetching new registration token..."
$tokenResp = gh api repos/mrcsdf/modeldev/actions/runners/registration-token --method POST | ConvertFrom-Json
$token = $tokenResp.token

if (-not $token) {
    Write-Error "Failed to obtain token from GitHub API"
    exit 1
}

Write-Output "Got token: $($token.Substring(0,8))..."

# Backup .env
Copy-Item .env .env.bak -Force

# Replace GITHUB_TOKEN in .env
(Get-Content .env) -replace 'GITHUB_TOKEN=.*','GITHUB_TOKEN=' + $token | Set-Content .env
Write-Output "Updated .env with new token"

# Restart runners
Write-Output "Restarting runner containers..."
docker compose down
Start-Sleep -Seconds 2
docker compose up -d

Write-Output "Done. Runner logs (tail 20):"
docker compose logs --tail=20
