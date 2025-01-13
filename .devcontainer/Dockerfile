# Use the official Python 3.9 image
FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -ms /bin/bash vscode
USER vscode

# Set the working directory
WORKDIR /workspace

# Install Python dependencies
COPY requirements.txt /workspace/
RUN pip install --no-cache-dir -r requirements.txt

# Expose the container
CMD [ "bash" ]
