from agno.agent import Agent
from agno.tools.youtube import YouTubeTools
from agno.media import Video
from youtube_transcript_api import YouTubeTranscriptApi
from notion_client import Client
from dotenv import load_dotenv, dotenv_values
import re

load_dotenv()

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

    # return agent.run('# Video URL\n' + url).content


def write_in_notion(text: str):
    nc = Client(auth=dotenv_values()["NOTION_TOKEN"])

    new_page = nc.pages.create(
        parent={
            "page_id":dotenv_values()["PAGE_ID"]
        },
        properties={
            "title": {
                "title": [
                    {"text": {
                        "content": "Video Summary"
                    }}
                ]
            }
        }
    )

    length = 1500

    chunks = [text[0+i:length+i] for i in range(0, len(text), length)]

    for c in chunks:
        nc.blocks.children.append(
            block_id=new_page["id"],
            children=[
                {
                    "object": "block",
                    "type": "paragraph",
                    "paragraph": {
                        "rich_text": [
                            {
                                "type": "text",
                                "text": {
                                    "content": c
                                }
                            }
                        ]
                    }
                }
            ]
        )

summarizer_agent = Agent(
  name="summarizer_agent",
  model="google:gemini-2.5-flash",
  tools=[YouTubeTools()],
  instructions=prompt,
  markdown=True,
  telemetry=True)

# url = "https://youtu.be/GmwaJnj6pfY?si=DN0KDmlW70cLlw6V"
url = "https://youtu.be/zs_zpMnwNMs?si=m04Rhxf-OFniH12e"

write_in_notion(llm_summarizer(summarizer_agent, url))