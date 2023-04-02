####CREDIT AND FULL INSTRUCTIONS AND USERSCRIPTS https://github.com/xiaoxiaoflood/firefox-scripts
# download and extract fx-folder.zip to Firefox installation folder
$fxZipUrl = "https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/fx-folder.zip"
$fxZipPath = "$env:ProgramFiles\Mozilla Firefox\fx-folder.zip"
Invoke-WebRequest -Uri $fxZipUrl -OutFile $fxZipPath
Expand-Archive -Path $fxZipPath -DestinationPath "$env:ProgramFiles\Mozilla Firefox" -Force

# get the latest Firefox profile folder
$profileFolderPath = "$env:APPDATA\Mozilla\Firefox\Profiles\*.default-release"
$latestProfileFolder = Get-ChildItem -Path $profileFolderPath | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
$chromeFolderPath = Join-Path $latestProfileFolder.FullName "chrome"

# create the chrome folder if it doesn't exist
if (!(Test-Path $chromeFolderPath)) {
    New-Item -ItemType Directory -Path $chromeFolderPath | Out-Null
}

# prompt the user for the desired scripts and extensions
$choices = [System.Management.Automation.Host.ChoiceDescription[]]@("&Scripts", "&Extensions", "&Both")
$chosen = $host.ui.PromptForChoice("Choose scripts and/or extensions to install", "Select one of the following options:", $choices, 0)

# download and extract the chosen zip file to the chrome folder
switch ($chosen) {
    0 { $utilsZipUrl = "https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/utils_scripts_only.zip" }
    1 { $utilsZipUrl = "https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/utils_extensions_only.zip" }
    2 { $utilsZipUrl = "https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/utils.zip" }
}
$utilsZipPath = Join-Path $chromeFolderPath "utils.zip"
Invoke-WebRequest -Uri $utilsZipUrl -OutFile $utilsZipPath
Expand-Archive -Path $utilsZipPath -DestinationPath $chromeFolderPath -Force

# Check if the user has chosen to download rebuild_userChrome.uc.js
if ($chosen -eq 0 -or $chosen -eq 2) {
    $rebuildUCChoices = [System.Management.Automation.Host.ChoiceDescription[]]@("&Yes", "&No")
    $rebuildUCChosen = $host.ui.PromptForChoice("Download rebuild_userChrome.uc.js?", "Do you want a button for managing scripts?", $rebuildUCChoices, 1)
    $downloadRebuildUC = ($rebuildUCChosen -eq 0) 
    if ($downloadRebuildUC) {
        $rebuildUCUrl = "https://raw.githubusercontent.com/xiaoxiaoflood/firefox-scripts/master/chrome/rebuild_userChrome.uc.js"
        $latestProfileFolder = Get-ChildItem -Path $profileFolderPath | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
        $chromeFolderPath = Join-Path $latestProfileFolder.FullName "chrome"
        $rebuildUCPath = Join-Path $chromeFolderPath "rebuild_userChrome.uc.js"
        Invoke-WebRequest -Uri $rebuildUCUrl -OutFile $rebuildUCPath
    }
}
    

#Remove zips
Remove-Item $fxZipPath, $utilsZipPath -Force

# clear Firefox startup cache
firefox -silent -nosplash -setDefaultBrowser -CreateProfile "temp" | Out-Null
Remove-Item -Recurse -Force "$env:APPDATA\Mozilla\Firefox\Profiles\temp"
Start-Process firefox -ArgumentList "about:support, taskkill /IM firefox.exe /F" -Wait
