FROM python:3.12

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m vscode && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vscode
# ...existing code...
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt
# ...existing code...
# Set work directory
WORKDIR /workspace

# Change ownership to the non-root user
RUN chown -R vscode:vscode /workspace

# Switch to the non-root user
USER vscode

# Install Python packages
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt
