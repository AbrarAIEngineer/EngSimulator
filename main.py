from fastapi import FastAPI
from dotenv import load_dotenv
from schemas import GenerateHTMLRequest, GenerateHTMLResponse
from ai_generator import generate_html

load_dotenv()

app = FastAPI(
    title="Free Engineering HTML Simulator Generator",
    version="1.0.0"
)

@app.post("/generate-html", response_model=GenerateHTMLResponse)
async def generate_html_endpoint(payload: GenerateHTMLRequest):
    html = await generate_html(
        title=payload.title,
        description=payload.description,
        inputs=payload.inputs,
        formulas=payload.formulas
    )
    return {"html": html}
