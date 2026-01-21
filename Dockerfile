# ---- Base image ----
FROM python:3.11-slim

# ---- System dependencies (EXPLICIT) ----
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    zstd \
    && zstd --version \
    && rm -rf /var/lib/apt/lists/*

# ---- Install Ollama (after zstd exists) ----
RUN curl -fsSL https://ollama.com/install.sh | sh

# ---- Working directory ----
WORKDIR /app

# ---- Python dependencies ----
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- App code ----
COPY . .

# ---- Ollama environment ----
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODELS=/root/.ollama

# ---- Pull SMALL model (Railway-safe) ----
RUN ollama pull phi-3:mini

# ---- Expose port ----
EXPOSE 8000

# ---- Start Ollama + FastAPI ----
CMD ["bash", "-c", "ollama serve & uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}"]
