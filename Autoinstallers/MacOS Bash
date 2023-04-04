#!/bin/bash

# download and extract fx-folder.zip to Firefox installation folder
fxZipUrl="https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/fx-folder.zip"
fxZipPath="/Applications/Firefox.app/Contents/Resources/fx-folder.zip"
curl -o $fxZipPath $fxZipUrl
unzip -o $fxZipPath -d "/Applications/Firefox.app/Contents/Resources/"

# get the latest Firefox profile folder
profileFolderPath="$HOME/Library/Application Support/Firefox/Profiles/*.default-release/"
latestProfileFolder=$(ls -dt $profileFolderPath | head -n1)
chromeFolderPath="$latestProfileFolder/chrome"

# create the chrome folder if it doesn't exist
if [ ! -d "$chromeFolderPath" ]; then
    mkdir "$chromeFolderPath"
fi

# prompt the user for the desired scripts and extensions
echo "Choose scripts and/or extensions to install:"
echo "1. Scripts"
echo "2. Extensions"
echo "3. Both"
read -p "Enter your choice (1/2/3): " choice

# download and extract the chosen zip file to the chrome folder
case $choice in
    1) utilsZipUrl="https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/utils_scripts_only.zip";;
    2) utilsZipUrl="https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/utils_extensions_only.zip";;
    3) utilsZipUrl="https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/utils.zip";;
esac

utilsZipPath="$chromeFolderPath/utils.zip"
curl -o $utilsZipPath $utilsZipUrl
unzip -o $utilsZipPath -d $chromeFolderPath

# Check if the user has chosen to download rebuild_userChrome.uc.js
if [ $choice = "1" ] || [ $choice = "3" ]; then
    read -p "Do you want a button for managing scripts? (y/n): " downloadRebuildUC
    if [ $downloadRebuildUC = "y" ]; then
        rebuildUCUrl="https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/chrome/rebuild_userChrome.uc.js"
        rebuildUCPath="$chromeFolderPath/rebuild_userChrome.uc.js"
        curl -o $rebuildUCPath $rebuildUCUrl
    fi
fi

echo ""
echo "Thank you for downloading!"
echo "Credit: https://github.com/xiaoxiaoflood/firefox-scripts."
echo "Check the above link for more userscripts to install."

# clear Firefox startup cache
/Applications/Firefox.app/Contents/MacOS/firefox -silent -setDefaultBrowser -CreateProfile "temp" > /dev/null 2>&1
rm -rf "$HOME/Library/Application Support/Firefox/Profiles/temp"
/Applications/Firefox.app/Contents/MacOS/firefox "about:support"
killall "firefox"
