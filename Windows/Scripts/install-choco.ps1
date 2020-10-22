Set-ExecutionPolicy Bypass -Scope Process -Force
Write-Host "##################### Installing chocolety via remote PS1 script. #####################"
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
Write-Host "##################### Finished intalling chocolety package manager. #####################"
