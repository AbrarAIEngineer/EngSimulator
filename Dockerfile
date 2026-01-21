# ---- Base image ----
FROM python:3.11-slim

# ---- System deps ----
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ---- Install Ollama ----
RUN curl -fsSL https://ollama.com/install.sh | sh

# ---- Set working directory ----
WORKDIR /app

# ---- Copy Python deps ----
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- Copy app code ----
COPY . .

# ---- Ollama config ----
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODELS=/root/.ollama

# ---- Pull FREE coding model at build time ----
RUN ollama pull deepseek-coder:6.7b

# ---- Expose FastAPI port ----
EXPOSE 8000

# ---- Start Ollama + FastAPI ----
CMD ["bash", "-c", "ollama serve & uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}"]
