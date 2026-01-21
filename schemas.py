from pydantic import BaseModel
from typing import List

class GenerateHTMLRequest(BaseModel):
    title: str
    description: str
    inputs: List[str]
    formulas: List[str]

class GenerateHTMLResponse(BaseModel):
    html: str
