# GitHub Actions Runners - Docker Setup

Quick setup for self-hosted GitHub Actions runners with LM Studio integration.

## Setup

1. **Copy environment file**:
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` with your values**:
   - `REPO_URL`: Your GitHub repository URL
   - `GITHUB_TOKEN`: Registration token from GitHub
   - `RUNNER_NAME`: Unique name for this runner

3. **Start the runner**:
   ```bash
   docker-compose up -d
   ```

## Files

- `docker-compose.yml`: Service definition
- `Dockerfile.runner`: Runner container image
- `entrypoint.sh`: Container startup script
- `.env.example`: Environment template
- `.env`: Your local configuration (create from example)

## Commands

```bash
# Start runner
docker-compose up -d

# View logs
docker-compose logs -f

# Stop runner
docker-compose down

# Update runner
docker-compose build --no-cache
docker-compose up -d

# Scale to multiple runners
docker-compose --profile multi-runner up -d
```

## Features

- ✅ Direct localhost:1234 access for LM Studio
- ✅ mise tool management integration
- ✅ Docker-in-Docker support
- ✅ Global development tools mounted
- ✅ Auto-restart on failure
- ✅ Health monitoring
- ✅ Clean shutdown handling