# Self-Hosted GitHub Actions Runners Setup

This guide explains how to set up self-hosted GitHub Actions runners to work with the global development environment, including local LLM integration via LM Studio.

## Benefits of Self-Hosted Runners

- **Cost Savings**: Avoid GitHub Actions minutes charges
- **Local LLM Access**: Direct access to localhost:1234 for LM Studio
- **Better Performance**: Use your own hardware resources
- **Environment Control**: Consistent with local development setup

## Prerequisites

- Linux machine or WSL2 environment (Windows with WSL works great)
- Docker installed (for containerized runners)
- GitHub repository admin access
- LM Studio running on localhost:1234

## Quick Setup

### 1. Repository Settings

In your GitHub repository:
1. Go to Settings → Actions → Runners
2. Click "New self-hosted runner"
3. Select Linux and follow the provided commands

### 2. Basic Runner Installation

```bash
# Download and extract runner
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz

# Configure runner (use your repo's specific token)
./config.sh --url https://github.com/OWNER/REPO --token YOUR_TOKEN

# Install as service
sudo ./svc.sh install
sudo ./svc.sh start
```

### 3. Docker-Based Runner (Recommended)

Create `docker-compose.yml` for isolated, reproducible runners:

```yaml
version: '3.8'
services:
  github-runner:
    build:
      context: .
      dockerfile: Dockerfile.runner
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./runner-data:/home/runner
    environment:
      - REPO_URL=https://github.com/OWNER/REPO
      - REGISTRATION_TOKEN=${GITHUB_TOKEN}
    restart: unless-stopped
    network_mode: host  # Required for localhost:1234 access
```

### 4. Runner Dockerfile

Create `Dockerfile.runner`:

```dockerfile
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \\
    curl wget git jq build-essential \\
    python3 python3-pip nodejs npm \\
    docker.io && \\
    rm -rf /var/lib/apt/lists/*

# Install mise for tool management
RUN curl https://mise.run | sh
ENV PATH="/root/.local/bin:$PATH"

# Install GitHub Actions runner
WORKDIR /home/runner
RUN curl -o actions-runner-linux-x64.tar.gz -L \\
    https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz && \\
    tar xzf ./actions-runner-linux-x64.tar.gz && \\
    rm actions-runner-linux-x64.tar.gz

# Configure and run
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
```

### 5. Runner Entrypoint

Create `entrypoint.sh`:

```bash
#!/bin/bash
set -e

# Configure runner if not already configured
if [ ! -f .runner ]; then
    ./config.sh --url $REPO_URL --token $REGISTRATION_TOKEN --labels linux,docker --unattended
fi

# Start runner
exec ./run.sh
```

## LM Studio Integration

### Network Configuration

Ensure LM Studio is accessible from runners:

```bash
# On Windows host, allow WSL access
netsh interface portproxy add v4tov4 listenport=1234 listenaddress=0.0.0.0 connectport=1234 connectaddress=localhost

# Test LLM access
curl http://localhost:1234/v1/models
```

### Repository Secrets

Set these in GitHub repository settings:

- `LLM_BASE_URL`: `http://localhost:1234/v1` (optional, defaults to localhost)
- `LLM_API_KEY`: `lm-studio` (optional, defaults to lm-studio)

## Runner Management

### Start/Stop Services

```bash
# Service-based runners
sudo systemctl start github-actions-runner
sudo systemctl stop github-actions-runner

# Docker-based runners
docker-compose up -d
docker-compose down
```

### Monitor Runner Status

```bash
# Check runner logs
sudo journalctl -u github-actions-runner -f

# Docker logs
docker-compose logs -f github-runner
```

### Update Runners

```bash
# Service-based
cd actions-runner
sudo ./svc.sh stop
./config.sh remove --token YOUR_REMOVE_TOKEN
# Download new version and reconfigure

# Docker-based
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Security Considerations

### Runner Isolation

- Use Docker containers for isolation
- Limit runner user permissions
- Regularly update runner software

### Network Security

```bash
# Firewall rules for LM Studio
sudo ufw allow from 172.16.0.0/12 to any port 1234  # Docker networks
sudo ufw allow from 127.0.0.1 to any port 1234      # Localhost
```

### Token Management

- Use fine-grained personal access tokens
- Rotate registration tokens regularly
- Monitor runner activity in GitHub

## Troubleshooting

### Common Issues

1. **Runner offline**: Check service status and logs
2. **LLM connection failed**: Verify localhost:1234 accessibility
3. **Docker permission denied**: Add runner user to docker group
4. **Out of disk space**: Clean up Docker images and containers

### Debug Commands

```bash
# Test LLM connectivity
curl -H "Authorization: Bearer lm-studio" http://localhost:1234/v1/models

# Check runner status
./run.sh --check

# Verify Docker access
docker ps
```

### Log Locations

- Service logs: `/var/log/github-actions-runner/`
- Docker logs: `docker-compose logs`
- System logs: `journalctl -u github-actions-runner`

## Advanced Configuration

### Multiple Runners

```yaml
# docker-compose.yml for multiple runners
version: '3.8'
services:
  runner-1:
    build: .
    environment:
      - RUNNER_NAME=runner-1
      - RUNNER_LABELS=linux,docker,worker-1
    volumes:
      - ./runner-1-data:/home/runner
    
  runner-2:
    build: .
    environment:
      - RUNNER_NAME=runner-2
      - RUNNER_LABELS=linux,docker,worker-2
    volumes:
      - ./runner-2-data:/home/runner
```

### Auto-scaling with Docker Swarm

```yaml
# docker-stack.yml
version: '3.8'
services:
  github-runner:
    image: your-runner-image
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 1G
```

## Integration with Global Dev Environment

The runners automatically inherit the global development environment:

- **mise configuration**: Tool versions managed via `.mise.toml`
- **Git templates**: Pre-commit hooks and standards
- **Utility scripts**: `ctx-collect.sh`, `run-checks.sh` available
- **LLM integration**: Direct localhost access for code reviews

## Cost Analysis

Self-hosted runners eliminate GitHub Actions charges:

- **GitHub-hosted**: $0.008/minute (Linux)
- **Self-hosted**: Only hardware costs
- **Break-even**: ~125 minutes/month of CI usage

This setup pays for itself quickly while providing better LLM integration and development environment consistency.