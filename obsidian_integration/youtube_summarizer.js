module.exports = async (params) => {
    // 1. Solicita a URL do vídeo ao usuário
    const videoUrl = await params.quickAddApi.inputPrompt("Cole a URL do vídeo do YouTube:");
    if (!videoUrl) return;

    let searchingNotice = new Notice("Buscando transcrição e gerando resumo...", 0);

    try {
        const agenteUrl = 'http://127.0.0.1:8000/summarize';

        let responseData = await requestUrl({
            url: agenteUrl,
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                url: videoUrl
            })
        })

        searchingNotice.hide();
        new Notice('Resposta do agente recebida')

        const data = responseData.json

        const textoFinal = `\n## Resumo do Vídeo: ${videoUrl}\n\n${data.data}\n`;
        const activeFile = await getActiveFile(params)

        params.app.vault.append(activeFile, textoFinal)
        
        new Notice('Resumo adicionado com sucesso!');
        return ""
    } catch (error) {
        searchingNotice.hide()
        new Notice('Erro ao processar o vídeo ou chamar o agente. ' + error);
        console.error(error);
    }
};

async function getActiveFile(params) {
    try {
        let activeFile = app.workspace.getActiveFile()

        if (activeFile && activeFile.extension === "md") {
            return activeFile;
        }

        const desiredName = await params.quickAddApi.inputPrompt("Insira o nome para novo arquivo")
        if (!desiredName) {
            new Notice("Criação de arquivo cancelada!")
            return null
        }

        let finalPath = `${desiredName}.md`

        let counter = 1
        while (params.app.vault.getAbstractFileByPath(finalPath)) {
            finalPath = `${desiredName} ${counter}.md`
            counter++
        }

        const newFile = await params.app.vault.create(finalPath, "")
        await app.workspace.getLeaf(false).openFile(newFile);

        return newFile;
    } catch (error) {
        new Notice("Erro ao obter arquivo: " + error)
    }
}