import os
import httpx

OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "deepseek-coder:6.7b")

STRICT_HTML_PROMPT = """
You are an expert engineering simulator generator.

ABSOLUTE RULES:
- Output ONLY valid HTML
- NO markdown
- NO explanations
- NO backticks
- ONE self-contained HTML file
- All CSS inside <style>
- All JavaScript inside <script>
- Plain JavaScript only
- Calculations in JavaScript
- File must work by double-clicking in a browser

HTML MUST INCLUDE:
- <title>
- Input sliders
- Live calculated results
- Clean professional layout

ENGINEERING SPEC:
Title: {title}
Description: {description}
Inputs: {inputs}
Formulas (convert to JS): {formulas}
"""

async def generate_html(title, description, inputs, formulas):
    prompt = STRICT_HTML_PROMPT.format(
        title=title,
        description=description,
        inputs=", ".join(inputs),
        formulas=", ".join(formulas)
    )

    async with httpx.AsyncClient(timeout=180) as client:
        response = await client.post(
            f"{OLLAMA_BASE_URL}/api/generate",
            json={
                "model": OLLAMA_MODEL,
                "prompt": prompt,
                "stream": False
            }
        )

    return response.json()["response"]
