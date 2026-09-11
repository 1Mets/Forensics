function Start-PersistentScript {
    param ([string]$Url)
    
    $command = "powershell -NoExit -ExecutionPolicy Bypass -Command `"iex (irm '$Url')`""
    Start-Process cmd.exe -Verb RunAs -ArgumentList "/k $command"
}

Start-PersistentScript "https://raw.githubusercontent.com/1Mets/Forensics/refs/heads/main/Start.ps1"
Start-PersistentScript "https://raw.githubusercontent.com/MeowTonynoh/Tonynoh-PS1/main/JVM-Inspector.ps1"
Start-PersistentScript "https://raw.githubusercontent.com/MeowTonynoh/MeowModAnalyzer/main/MeowModAnalyzer.ps1"
Start-PersistentScript "https://raw.githubusercontent.com/p1aegg/powershell/refs/heads/main/ClassLoaderDump.ps1"

iwr -Uri "https://github.com/1Mets/Forensics/raw/refs/heads/main/downloader.exe" -OutFile "$env:USERPROFILE\Downloads\ToolDownloader.exe"

Start "$env:USERPROFILE\Downloads\ToolDownloader.exe"
