# ---- Base image ----
FROM python:3.11-slim

# ---- System dependencies ----
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    zstd \
    && rm -rf /var/lib/apt/lists/*

# ---- Install Ollama ----
RUN curl -fsSL https://ollama.com/install.sh | sh

# ---- Working directory ----
WORKDIR /app

# ---- Python dependencies ----
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- App code ----
COPY . .

# ---- Ollama config ----
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODELS=/root/.ollama

# ---- Pull FREE coding model ----
RUN bash -c "ollama serve & \
    until curl --silent --output /dev/null --fail http://localhost:11434/api/tags; do \
        echo 'Waiting for Ollama server to start...'; \
        sleep 1; \
    done; \
    ollama pull deepseek-coder:6.7b"

# ---- Expose port ----
EXPOSE 8000

# ---- Start Ollama + FastAPI ----
CMD ["bash", "-c", "ollama serve & uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}"]