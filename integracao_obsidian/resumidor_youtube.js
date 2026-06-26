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
            Headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                url: videoUrl
            })
        })
        console.log(responseData)
        // responseData = JSON.stringify(responseData)
        // console.log(responseData)

        // const responseData = JSON.stringify({
        //     "data": "Here are the main ideas from the video, summarizing Itachi Uchiha's story:\n\n*   Itachi was a prodigy of the Uchiha clan and the best ninja in Konoha.\n*   Having grown up in war, he developed strong ideals for peace and understood the devastation war brings.\n*   He learned of his clan's plan for a rebellion, which would lead to another war.\n*   He accepted a secret mission to prevent this war by eliminating his entire clan.\n*   His only condition was that his younger brother, Sasuke, be spared, so Sasuke could grow up and escape the clan's cycle of hatred.\n*   On a dark night, he massacred his clan, including his parents, an act that caused him immense personal trauma and tears.\n*   He became a \"traitor ninja\" and later joined the Akatsuki, enduring the hatred and misunderstanding of others.\n*   He intentionally allowed Sasuke to believe he was a villain, cultivating his brother's hatred so that Sasuke would grow strong and eventually avenge their clan.\n*   Itachi viewed Sasuke's future vengeance as a \"favor,\" believing it would allow him to finally \"fade\" from his \"colorless world\" and bring an end to his suffering.\n*   In his final moments, or through a posthumous message, he expressed his deep regret and love for Sasuke, asking for forgiveness for the pain he caused."
        // } )

        searchingNotice.hide();
        new Notice('Resposta do agente recebida')

        // const data = JSON.parse(responseData);
        const data = responseData.json
        console.log(data['data'])

        const textoFinal = `\n## Resumo do Vídeo: ${videoUrl}\n\n${data.data}\n`;
        const activeFile = await getActiveFile(params)
        // console.log(textoFinal)

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