import {
	App,
	Modal,
	Notice,
	Plugin,
	PluginSettingTab,
	Setting,
	normalizePath,
} from "obsidian";
import { spawn } from "child_process";
import * as path from "path";

interface YTSummarizerSettings {
	geminiApiKey: string;
	pythonPath: string; // e.g. "python3" or an absolute path to a venv's python
	hasCompletedFirstRun: boolean;
}

const DEFAULT_SETTINGS: YTSummarizerSettings = {
	geminiApiKey: "",
	pythonPath: "python3",
	hasCompletedFirstRun: false,
};

export default class YTSummarizerPlugin extends Plugin {
	settings: YTSummarizerSettings;

	async onload() {
		await this.loadSettings();

		this.addSettingTab(new YTSummarizerSettingTab(this.app, this));

		this.addCommand({
			id: "summarize-youtube-video",
			name: "Summarize YouTube video",
			callback: () => this.handleSummarizeCommand(),
		});

		// First-run check: if there's no key yet, prompt for it once the
		// workspace is ready, rather than blocking onload().
		if (!this.settings.geminiApiKey) {
			this.app.workspace.onLayoutReady(() => {
				new ApiKeySetupModal(this.app, this, (key) => {
					this.settings.geminiApiKey = key;
					this.settings.hasCompletedFirstRun = true;
					this.saveSettings();
					new Notice("Gemini API key saved.");
				}).open();
			});
		}
	}

	async loadSettings() {
		this.settings = Object.assign({}, DEFAULT_SETTINGS, await this.loadData());
	}

	async saveSettings() {
		await this.saveData(this.settings);
	}

	private async handleSummarizeCommand() {
		if (!this.settings.geminiApiKey) {
			new Notice("Set up your Gemini API key first (plugin settings).");
			new ApiKeySetupModal(this.app, this, (key) => {
				this.settings.geminiApiKey = key;
				this.saveSettings();
			}).open();
			return;
		}

		new VideoUrlModal(this.app, async (url) => {
			if (!url) return;
			const notice = new Notice("Fetching transcript and summarizing…", 0);
			try {
				const summary = await this.runSummarizer(url);
				await this.createSummaryNote(url, summary);
				new Notice("Summary note created.");
			} catch (err) {
				console.error(err);
				new Notice(`Summarization failed: ${(err as Error).message}`);
			} finally {
				notice.hide();
			}
		}).open();
	}

	private runSummarizer(url: string): Promise<string> {
		return new Promise((resolve, reject) => {
			const scriptPath = path.join(
				this.manifest.dir ? this.app.vault.adapter.basePath : "",
				this.manifest.dir ?? "",
				"python",
				"summarize.py"
			);

			const child = spawn(this.settings.pythonPath, [scriptPath, url], {
				env: {
					...process.env,
					GEMINI_API_KEY: this.settings.geminiApiKey,
				},
			});

			let stdout = "";
			let stderr = "";

			child.stdout.on("data", (chunk) => (stdout += chunk.toString()));
			child.stderr.on("data", (chunk) => (stderr += chunk.toString()));

			child.on("error", (err) => reject(err));

			child.on("close", (code) => {
				if (code === 0) {
					resolve(stdout.trim());
				} else {
					reject(new Error(stderr.trim() || `Python exited with code ${code}`));
				}
			});
		});
	}

	private async createSummaryNote(url: string, summary: string) {
		const fileName = normalizePath(`YouTube Summary ${Date.now()}.md`);
		const content = `---\nsource: ${url}\ncreated: ${new Date().toISOString()}\n---\n\n${summary}\n`;
		const file = await this.app.vault.create(fileName, content);
		await this.app.workspace.getLeaf(true).openFile(file);
	}
}

/** Modal shown on first run (and reachable any time the key is missing). */
class ApiKeySetupModal extends Modal {
	private plugin: YTSummarizerPlugin;
	private onSubmit: (key: string) => void;

	constructor(app: App, plugin: YTSummarizerPlugin, onSubmit: (key: string) => void) {
		super(app);
		this.plugin = plugin;
		this.onSubmit = onSubmit;
	}

	onOpen() {
		const { contentEl } = this;
		contentEl.createEl("h2", { text: "Set up YouTube Summarizer" });
		contentEl.createEl("p", {
			text:
				"To summarize videos, this plugin needs a Gemini API key. " +
				"Get a free one from Google AI Studio, then paste it below.",
		});

		const link = contentEl.createEl("a", {
			text: "Get a Gemini API key →",
			href: "https://aistudio.google.com/apikey",
		});
		link.style.display = "block";
		link.style.marginBottom = "1em";

		let inputValue = "";
		new Setting(contentEl).setName("Gemini API key").addText((text) => {
			text.setPlaceholder("AIza...").onChange((value) => (inputValue = value));
			text.inputEl.type = "password";
			text.inputEl.style.width = "100%";
		});

		new Setting(contentEl).addButton((btn) =>
			btn
				.setButtonText("Save")
				.setCta()
				.onClick(() => {
					if (!inputValue.trim()) {
						new Notice("Please enter a key.");
						return;
					}
					this.onSubmit(inputValue.trim());
					this.close();
				})
		);
	}

	onClose() {
		this.contentEl.empty();
	}
}

class VideoUrlModal extends Modal {
	private onSubmit: (url: string) => void;

	constructor(app: App, onSubmit: (url: string) => void) {
		super(app);
		this.onSubmit = onSubmit;
	}

	onOpen() {
		const { contentEl } = this;
		contentEl.createEl("h2", { text: "Summarize YouTube video" });

		let url = "";
		new Setting(contentEl).setName("Video URL").addText((text) => {
			text.setPlaceholder("https://www.youtube.com/watch?v=...");
			text.inputEl.style.width = "100%";
			text.onChange((v) => (url = v));
			text.inputEl.focus();
			text.inputEl.addEventListener("keydown", (e) => {
				if (e.key === "Enter") {
					this.onSubmit(url.trim());
					this.close();
				}
			});
		});

		new Setting(contentEl).addButton((btn) =>
			btn
				.setButtonText("Summarize")
				.setCta()
				.onClick(() => {
					this.onSubmit(url.trim());
					this.close();
				})
		);
	}

	onClose() {
		this.contentEl.empty();
	}
}

class YTSummarizerSettingTab extends PluginSettingTab {
	plugin: YTSummarizerPlugin;

	constructor(app: App, plugin: YTSummarizerPlugin) {
		super(app, plugin);
		this.plugin = plugin;
	}

	display(): void {
		const { containerEl } = this;
		containerEl.empty();

		new Setting(containerEl)
			.setName("Gemini API key")
			.setDesc("From Google AI Studio (aistudio.google.com/apikey). Stored locally in this vault's plugin data.")
			.addText((text) =>
				text
					.setPlaceholder("AIza...")
					.setValue(this.plugin.settings.geminiApiKey)
					.onChange(async (value) => {
						this.plugin.settings.geminiApiKey = value.trim();
						await this.plugin.saveSettings();
					})
			);

		new Setting(containerEl)
			.setName("Python executable")
			.setDesc("Path to python3 (or a venv's python) that has agno + youtube_transcript_api installed.")
			.addText((text) =>
				text
					.setPlaceholder("python3")
					.setValue(this.plugin.settings.pythonPath)
					.onChange(async (value) => {
						this.plugin.settings.pythonPath = value.trim() || "python3";
						await this.plugin.saveSettings();
					})
			);
	}
}