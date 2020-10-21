Write-Host "##################### Installing choco packs. #####################"
write-host "Installing Git via chocolatey."
. $env:programdata\chocolatey\choco.exe install -y git

Write-Host "Installing 7ZIP via chocolatey."
. $env:programdata\chocolatey\choco.exe install -y 7zip

Write-Host "Installing PWSH(powershell core) via chocolatey."
. $env:programdata\chocolatey\choco.exe install -y pwsh

Write-Host "Installing OpenSSH via chocolatey."
. $env:programdata\chocolatey\choco.exe install -y openssh -params "/SSHServerFeature"
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "$env:windir\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

Write-Host "##################### Finished installing choco packs. #####################"
