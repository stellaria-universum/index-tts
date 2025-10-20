# Use the CUDA 12.8 DEVELOPMENT image, which includes nvcc and build tools
FROM nvidia/cuda:12.8.0-devel-ubuntu24.04 AS base

# Set environment variables for Python and networking
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=7860 \
    HF_ENDPOINT="https://hf-mirror.com" \
    DEBIAN_FRONTEND=noninteractive

# Install system dependencies, including python3.10, git, and git-lfs
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.10 \
    python3-pip \
    python3-venv \
    build-essential \
    git \
    git-lfs \
    curl \
    libsndfile1 \
    ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/python3 /usr/bin/python

# Initialize git-lfs for the system
RUN git lfs install

# Create a non-root user 'appuser' for better security
RUN useradd -m -u 1001 appuser

# Set the working directory
WORKDIR /app

# Clone the repository
RUN git clone -b main https://github.com/stellaria-universum/index-tts .

# Download large repository files with git lfs pull
RUN git lfs pull

# Install 'uv' and 'huggingface-hub' globally
RUN python3 -m pip install --no-cache-dir -U uv "huggingface-hub[cli]" --break-system-packages

# Change ownership of the app directory
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Use 'uv' to sync and install dependencies
RUN uv sync --all-extras

# Ensure checkpoints folder exists (will be bound to host volume)
RUN mkdir -p /app/checkpoints

# Create directories for outputs and prompts
RUN mkdir -p /app/outputs /app/prompts

# Expose the port
EXPOSE 7860

# Define volumes for persisting data
VOLUME [ "/app/checkpoints", "/app/outputs", "/app/prompts" ]

# On container startup:
# - Download model only if missing (so it lands in the mounted volume)
# - Then run the app
CMD if [ ! -d "/app/checkpoints/IndexTTS-2" ]; then \
        echo "Downloading IndexTTS-2 model to /app/checkpoints..."; \
        huggingface-cli download IndexTeam/IndexTTS-2 --local-dir=/app/checkpoints; \
    else \
        echo "Model already exists in /app/checkpoints, skipping download."; \
    fi && \
    uv run webui.py


