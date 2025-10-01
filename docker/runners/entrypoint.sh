#!/bin/bash
set -e

echo "Starting GitHub Actions Runner..."

# Validate required environment variables
if [ -z "$REPO_URL" ]; then
    echo "Error: REPO_URL environment variable is required"
    exit 1
fi

if [ -z "$REGISTRATION_TOKEN" ]; then
    echo "Error: REGISTRATION_TOKEN environment variable is required"
    exit 1
fi

# Set defaults
RUNNER_NAME=${RUNNER_NAME:-$(hostname)}
RUNNER_LABELS=${RUNNER_LABELS:-"linux,docker,self-hosted"}
RUNNER_GROUP=${RUNNER_GROUP:-"default"}

# Configure runner if not already configured
if [ ! -f .runner ]; then
    echo "Configuring runner..."
    ./config.sh \
        --url "$REPO_URL" \
        --token "$REGISTRATION_TOKEN" \
        --name "$RUNNER_NAME" \
        --labels "$RUNNER_LABELS" \
        --runnergroup "$RUNNER_GROUP" \
        --work "_work" \
        --unattended \
        --replace
fi

# Set up LLM environment for localhost access
export OPENAI_BASE_URL="${OPENAI_BASE_URL:-http://localhost:1234/v1}"
export OPENAI_API_KEY="${OPENAI_API_KEY:-lm-studio}"

# Test LLM connectivity (non-blocking)
echo "Testing LM Studio connectivity..."
if curl -s --max-time 5 "$OPENAI_BASE_URL/models" > /dev/null 2>&1; then
    echo "✓ LM Studio is accessible at $OPENAI_BASE_URL"
else
    echo "⚠ LM Studio not accessible at $OPENAI_BASE_URL (this is optional)"
fi

# Set up mise environment
if [ -f .mise.toml ]; then
    echo "Activating mise environment..."
    eval "$(mise activate bash)"
    mise install
fi

# Function to handle graceful shutdown
cleanup() {
    echo "Shutting down runner..."
    if [ -f .runner ]; then
        ./config.sh remove --token "$REGISTRATION_TOKEN" || true
    fi
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

# Start the runner
echo "Starting runner '$RUNNER_NAME' for $REPO_URL..."
echo "Labels: $RUNNER_LABELS"
echo "Group: $RUNNER_GROUP"

# Run the runner with proper signal handling
exec ./run.sh &
PID=$!

# Wait for the background process and handle signals
wait $PID