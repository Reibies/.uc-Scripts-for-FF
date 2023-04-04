#!/bin/bash
 
# download and extract fx-folder.zip to Firefox installation folder
fxZipUrl="https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/fx-folder.zip"
fxZipPath="/tmp/fx-folder.zip"
wget -O $fxZipPath $fxZipUrl
sudo unzip -o $fxZipPath -d /opt/firefox/

# get the latest Firefox profile folder
profileFolderPath="$HOME/.mozilla/firefox/*.default-release"
latestProfileFolder=$(ls -td $profileFolderPath | head -1)
chromeFolderPath="$latestProfileFolder/chrome"

# create the chrome folder if it doesn't exist
if [ ! -d $chromeFolderPath ]; then
    mkdir $chromeFolderPath
fi

# prompt the user for the desired scripts and extensions
options=("Scripts" "Extensions" "Both")
PS3="Choose scripts and/or extensions to install: "
select chosen in "${options[@]}"
do
    case $chosen in
        "Scripts")
            utilsZipUrl="https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/utils_scripts_only.zip"
            break;;
        "Extensions")
            utilsZipUrl="https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/utils_extensions_only.zip"
            break;;
        "Both")
            utilsZipUrl="https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/utils.zip"
            break;;
        *) echo "Invalid option";;
    esac
done

utilsZipPath="$chromeFolderPath/utils.zip"
wget -O $utilsZipPath $utilsZipUrl
sudo unzip -o $utilsZipPath -d $chromeFolderPath

# Check if the user has chosen to download rebuild_userChrome.uc.js
if [ $chosen == "Scripts" ] || [ $chosen == "Both" ]; then
    read -p "Download rebuild_userChrome.uc.js? (y/n) " yn
    case $yn in
        [Yy]* )
            rebuildUCUrl="https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/chrome/rebuild_userChrome.uc.js"
            rebuildUCPath="$chromeFolderPath/rebuild_userChrome.uc.js"
            wget -O $rebuildUCPath $rebuildUCUrl
            ;;
        [Nn]* ) ;;
        * ) echo "Please answer yes or no.";;
    esac
fi

zenity --info --title="Download Complete" --text="Thank you for downloading!\nCredit: https://github.com/xiaoxiaoflood/firefox-scripts.\nCheck the above link for more userscripts to install."

# Remove zips
rm -f $fxZipPath $utilsZipPath

# clear Firefox startup cache
firefox -silent -nosplash -setDefaultBrowser -CreateProfile "temp" >/dev/null
rm -rf "$latestProfileFolder/temp"
killall firefox
