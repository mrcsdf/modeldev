FROM mcr.microsoft.com/vscode/devcontainers/python:3.9
# Set the working directory
WORKDIR /workspace
# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install .NET SDK
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x dotnet-install.sh \
    && ./dotnet-install.sh --install-dir /usr/share/dotnet --channel 8.0 \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Install Scala and Spark
RUN apt-get update && apt-get install -y scala spark
