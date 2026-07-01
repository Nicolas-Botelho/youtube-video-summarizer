#!/usr/bin/env python3
"""
Summarizes a YouTube video using an agno Agent equipped with YouTubeTools and
a transcript-fallback tool, exactly like the original FastAPI prototype —
just wrapped as a CLI so the Obsidian plugin can call it as a subprocess.

Usage:
    GEMINI_API_KEY=xxxx python summarize.py "https://www.youtube.com/watch?v=VIDEO_ID"

Prints the markdown summary to stdout. All diagnostic/error output goes to
stderr so the caller (the Obsidian plugin) can cleanly separate the two.
"""

import argparse
import os
import re
import sys

# Make the bundled "vendor" folder (pip-installed packages shipped alongside
# this script) importable, taking priority over anything installed system-wide.
_VENDOR_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "vendor")
if os.path.isdir(_VENDOR_DIR) and _VENDOR_DIR not in sys.path:
    sys.path.insert(0, _VENDOR_DIR)

from agno.agent import Agent
from agno.tools.youtube import YouTubeTools
from youtube_transcript_api import YouTubeTranscriptApi


def get_youtube_id(url: str):
    pattern = r'(?:v=|\/shorts\/|\/embed\/|\/v\/|youtu\.be\/)([a-zA-Z0-9_-]{11})'
    match = re.search(pattern, url)
    return match.group(1) if match else None


def video_transcript(url: str) -> str:
    """
    Args:
      url: youtube video url
    Returns:
      transcript: given url video transcript
    """
    yta = YouTubeTranscriptApi()
    transcript = ""
    try:
        fetched = yta.fetch(get_youtube_id(url), languages=['pt', 'en', 'sp', 'fr'])
        for snippet in fetched:
            transcript += snippet.text + "\n"
    except Exception:
        transcript = "no transcript"

    return transcript


SUMMARIZER_PROMPT = """
# Task
You are a video summarizer especialist.
You are tasked with summarizing the video below focusing on its context and main points.
# Instructions
- Answer in english only
- Answer with text only
- Make your answer in topics, following the main points of the video
- The first topic must be a introduction to the general context of the video and the last topic must a conclusion
- If you can not use the Youtube Tool in any meaningful way, use the video transcript tool
"""


def summarize(video_url: str) -> str:
    summarizer_agent = Agent(
        name="summarizer_agent",
        model="google:gemini-2.5-flash",
        tools=[YouTubeTools(), video_transcript],
        instructions=SUMMARIZER_PROMPT,
        markdown=True,
        telemetry=True,
    )
    response = summarizer_agent.run('# Video URL\n' + video_url)
    return response.content


def main():
    parser = argparse.ArgumentParser(description="Summarize a YouTube video with an agno agent.")
    parser.add_argument("url", help="YouTube video URL")
    args = parser.parse_args()

    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("GEMINI_API_KEY environment variable not set.", file=sys.stderr)
        sys.exit(2)

    # agno's "google:<model-id>" shorthand reads the key from GOOGLE_API_KEY,
    # so map the plugin's single GEMINI_API_KEY setting onto it here.
    os.environ.setdefault("GOOGLE_API_KEY", api_key)

    try:
        summary_md = summarize(args.url)
        if not summary_md or not summary_md.strip():
            print("Agent returned an empty response.", file=sys.stderr)
            sys.exit(3)
    except Exception as e:  # noqa: BLE001 - we want a clean one-line failure for the plugin
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)

    print(summary_md)


if __name__ == "__main__":
    main()