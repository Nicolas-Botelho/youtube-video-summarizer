from agno.agent import Agent
from agno.tools.youtube import YouTubeTools
# from agno.tools.visualization import VisualizationTools
from agno.media import Video
import os
from dotenv import load_dotenv

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
"""

hello_world = Agent(
  name="hw",
  model="google:gemini-2.5-flash",
  tools=[YouTubeTools()],
  instructions=prompt,
  markdown=True,
  telemetry=True)

url = "https://youtu.be/GmwaJnj6pfY?si=DN0KDmlW70cLlw6V"

result = hello_world.run(url)

print(result.content)
print(result.metrics)
