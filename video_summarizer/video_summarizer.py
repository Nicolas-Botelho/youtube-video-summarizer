from agno.agent import Agent
from agno.tools.youtube import YouTubeTools
from youtube_transcript_api import YouTubeTranscriptApi
from dotenv import load_dotenv
import re
from fastapi import FastAPI
from pydantic import BaseModel

class reqModel(BaseModel):
  url: str

load_dotenv()

def llm_summarizer(agent: Agent, url: str):
    yta = YouTubeTranscriptApi()
    trasncript = ""

    try:
        fetched = yta.fetch("zs_zpMnwNMs", languages=['pt', 'en', 'sp', 'fr'])
        for snippet in fetched:
            trasncript += snippet.text + "\n"
    except:
        trasncript = "no transcript"
    
    return agent.run('# Video URL\n' + url + f"\n\n# Transcript\n{trasncript}").content

api = FastAPI()

@api.get("/")
def health_check():
  return {"status" : "OK"}

@api.post("/summarize")
def run_summarize(req: reqModel):
  prompt = f"""
# Task
You are a video summarizer especialist.
You are tasked with summarizing the video below focusing on its context and main points.

# Instructions
- Answer in english only
- Answer with text only
- Make your answer in topics, following the main points of the video
- The first topic must be a introduction to the general context of the video and the last topic must a conclusion
- If you can not use the Youtube Tool in any meaningful way, use the given transcript
"""

  print(req)

  summarizer_agent = Agent(
    name="summarizer_agent",
    model="google:gemini-2.5-flash",
    tools=[YouTubeTools()],
    instructions=prompt,
    markdown=True,
    telemetry=True)

  return {"data": llm_summarizer(summarizer_agent, req.url)}