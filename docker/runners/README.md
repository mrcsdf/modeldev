# GitHub Actions Runner Docker Setup

This directory contains Docker configuration for self-hosted GitHub Actions runners optimized for the global development environment.

## Quick Start

1. **Set environment variables**:
   ```bash
   export GITHUB_TOKEN="your_registration_token"
   export REPO_URL="https://github.com/owner/repo"
   ```

2. **Start the runner**:
   ```bash
   docker-compose up -d
   ```

3. **Monitor logs**:
   ```bash
   docker-compose logs -f
   ```

## Configuration Files

- `docker-compose.yml`: Main service definition
- `Dockerfile.runner`: Runner container image
- `entrypoint.sh`: Container startup script
- `.env.example`: Environment variable template

## Features

- **Isolated execution**: Each job runs in a clean container
- **Tool management**: mise integration for consistent tool versions
- **LLM access**: Direct connection to localhost:1234 (LM Studio)
- **Docker-in-Docker**: Support for containerized workloads
- **Auto-restart**: Resilient to failures and updates

## Security

- Containers run with minimal privileges
- Network isolation with host access only for LLM
- Regular security updates via base image updates
- Token rotation support

## Scaling

Scale runners horizontally:
```bash
docker-compose up --scale github-runner=3 -d
```

Each runner gets a unique name and operates independently.

## Maintenance

- **Update runners**: `docker-compose build --no-cache && docker-compose up -d`
- **Clean up**: `docker system prune -f`
- **Rotate tokens**: Update environment variables and restart