# build.sh

npm run build

rm -rf out/
mkdir out/

mv main.js out/
cp manifest.json out/

cp -r python/ out/

cp -r out/* ~/Documents/personal/.obsidian/plugins/yt-summarizer
