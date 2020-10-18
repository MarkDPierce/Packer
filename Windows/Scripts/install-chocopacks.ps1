. $env:programdata\chocolatey\choco.exe install -y git
. $env:programdata\chocolatey\choco.exe install -y notepadplusplus
. $env:programdata\chocolatey\choco.exe install -y chrome
. $env:programdata\chocolatey\choco.exe install -y firefox
. $env:programdata\chocolatey\choco.exe install -y 7zip
. $env:programdata\chocolatey\choco.exe install -y pwsh
. $env:programdata\chocolatey\choco.exe install -y openssh -params "/SSHServerFeature"
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "$env:windir\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
