# Youtube videos summarizer

A Youtube videos summarizer local plugin for Obsidian using Gemini API.

## Technologies
- Python
- Agno
- Node
- Obsidian

## How to use
### Python
1. Create a venv: `python -m venv .venv`
2. Install the requirements: `pip install -r requirements.txt`
3. Go to video_summarizer folder
4. Run: `uvicorn video_summarizer:api --port 8000 --reload`

### Obsidian Plugin
1. Open Obsidian
2. Settings -> Community plugins -> Browse -> Search and download QuickAdd
3. Copy this [file](./obsidian_integration/youtube_summarizer.js) to the Obsidian's vault folder
4. Go to QuickAdd settings (Settings -> Community plugins) -> Choices & Packages -> Change the Choice from Template to Macro and give it a name -> Add Choice
5. In Obsidian, use `Ctrl+P` to open the command pallete and search for the added Choice's name
6. Add the desired youtube url as a share link (like this: `https://youtu.be/XXXXXXXXXXX?si=XXXXXXXXXXXXXXXXX`) -> Click 'OK' and wait the written summary be writen