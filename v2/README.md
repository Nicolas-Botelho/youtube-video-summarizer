# YouTube Summarizer

A small tool that takes a YouTube video URL, fetches its transcript, and uses
Gemini (via the `agno` agent framework) to generate a Markdown summary —
either printed to your terminal or saved as a new note in Obsidian.

## What it does

1. Takes a YouTube URL.
2. Pulls the video's transcript with `youtube_transcript_api`.
3. Sends the transcript to a Gemini model through an `agno` Agent, which
   returns a Markdown summary (TL;DR, key points, notable quotes).
4. Either prints that summary to stdout (Python-only use) or creates a new
   note in your vault with it (Obsidian plugin use).

## Technologies used

- **Python** — transcript fetching and summarization (`summarize.py`)
- **[agno](https://github.com/agno-agi/agno)** — agent framework wrapping the Gemini model
- **Google Gemini API** — does the actual summarization
- **[youtube_transcript_api](https://pypi.org/project/youtube-transcript-api/)** — fetches video transcripts
- **TypeScript + Obsidian API** — plugin shell (settings, commands, note creation)
- **esbuild** — bundles the plugin's TypeScript into the `main.js` Obsidian loads

## How to use

### Option A — Just the Python script (no Obsidian)

1. Install dependencies:
   ```bash
   cd python
   python3 -m pip install -r requirements.txt
   ```
2. Get a free Gemini API key from [Google AI Studio](https://aistudio.google.com/apikey).
3. Run it:
   ```bash
   GEMINI_API_KEY=your_key_here python3 summarize.py "https://www.youtube.com/watch?v=VIDEO_ID"
   ```
4. The Markdown summary prints to your terminal.

### Option B — As an Obsidian plugin

1. **Build the plugin** (one time, or after any change to `main.ts`):
   ```bash
   npm install
   npm run build
   ```
   This produces `main.js` in the project root.

2. **Copy the plugin files into your vault:**
   ```
   <YourVault>/.obsidian/plugins/yt-summarizer/
   ├── main.js
   ├── manifest.json
   └── python/
       ├── summarize.py
       ├── requirements.txt
       └── vendor/        (see step 3)
   ```

3. **Make sure the Python dependencies are available.** Either:
   - Install them normally (`pip install -r python/requirements.txt`) and point
     the plugin's "Python executable" setting at that Python, **or**
   - Use a pre-bundled `vendor/` folder (packages installed alongside the
     script, no pip install needed at runtime) — built with:
     ```bash
     cd python
     python3 -m pip install --target=vendor -r requirements.txt
     ```
     Note: a `vendor/` folder only works on the same OS, architecture, and
     Python version it was built on.

4. **Enable the plugin in Obsidian:** Settings → Community plugins → turn off
   Restricted mode → enable "YouTube Summarizer".

5. **First run:** a popup will ask for your Gemini API key (with a link to get
   one). Paste it in — it's saved locally in the vault.

6. **Set the Python path:** Settings → YouTube Summarizer → point "Python
   executable" at a Python 3 binary (e.g. `python3`, or the full path to a venv's
   `python`).

7. **Use it:** open the command palette (Cmd/Ctrl+P) → "Summarize YouTube
   video" → paste a URL. A new note with the summary will be created and opened.