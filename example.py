from agno.agent import Agent
from agno.tools.youtube import YouTubeTools
# from agno.tools.visualization import VisualizationTools
from agno.media import Video
from youtube_transcript_api import YouTubeTranscriptApi
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
- If you can not use the Youtube Tool in any meaningful way, use the given transcript
"""

hello_world = Agent(
  name="hw",
  model="google:gemini-2.5-flash",
  tools=[YouTubeTools()],
  instructions=prompt,
  markdown=True,
  telemetry=True)

# url = "https://youtu.be/GmwaJnj6pfY?si=DN0KDmlW70cLlw6V"
url = "https://youtu.be/zs_zpMnwNMs?si=m04Rhxf-OFniH12e"
# url = "https://www.youtube.com/watch?v=dQw4w9WgXcQ&pp=ygUXbmV2ZXIgZ29ubmEgZ2l2ZSB5b3UgdXA%3D"

yta = YouTubeTranscriptApi()
trasncript = ""

try:
  fetched = yta.fetch("zs_zpMnwNMs", languages=['pt', 'en', 'sp', 'fr'])
  for snippet in fetched:
    trasncript += snippet.text + "\n"
except:
  trasncript = "no transcript"
finally:
  result = hello_world.run('# Video URL\n' + url + f"\n\n# Transcript\n{trasncript}")

  print(result.content)
  print(result.metrics)
