function Set-Firewall {
    Write-Output "######################################################"
    Write-Output "Configuring Firewall"
    #For WINRM
    netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=block
    netsh advfirewall firewall set rule group="Windows Remote Management" new enable=yes
    #For RDP
    netsh advfirewall firewall add rule name="Open Port 3389" dir=in action=allow protocol=TCP localport=3389
    $script:winrmService = Get-Service -Name WinRM
    Write-Output "Done Configuring"
    Write-Output "######################################################"
}

function Set-TempDirs {
    Write-Output "######################################################"
    Write-Output "Setting Environment Variables"
    # Set Temp Variable using PowerShell

    $TempFolder = "C:\TEMP"
    New-Item -ItemType Directory -Force -Path $TempFolder
    [Environment]::SetEnvironmentVariable("TEMP", $TempFolder, [EnvironmentVariableTarget]::Machine)
    [Environment]::SetEnvironmentVariable("TMP", $TempFolder, [EnvironmentVariableTarget]::Machine)
    [Environment]::SetEnvironmentVariable("TEMP", $TempFolder, [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("TMP", $TempFolder, [EnvironmentVariableTarget]::User)
    Write-Output "Done setting Variables"
    Write-Output "######################################################"
}


function Install-Choco {
    Write-Output "######################################################"
    Write-Output "Attempting To download and install Choco"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Output "Done installing Choco"
    Write-Output "######################################################"
}

function Set-NicsPrivate {
    Write-Output "######################################################"
    Write-Output "Setting NICs to Private"
    $NetworkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
    $Connections = $NetworkListManager.GetNetworkConnections()
    $Connections | ForEach-Object { $_.GetNetwork().SetCategory(1) }
    Write-Output "Done Setting NICs to Private"
    Write-Output "######################################################"
}

function Enable-RDP {
    Write-Output "######################################################"
    Write-Output "Enabling RDP"
    #Firewall Setting applied in different function
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
    Write-Output "Done Enabling RDP"
    Write-Output "######################################################"
}

function Start-GenericRegistrySetup {
    Write-Output "######################################################"
    Write-Output "Setting Generic registry Keys"
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" /v HideFileExt /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\" /v HibernateFileSizePercent /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\" /v HibernateEnabled /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount /t REG_DWORD /d 0 /f
    Write-Output "Done Setting Generic Registry Keys"
    Write-Output "######################################################"
}

function Disable-ScreenSaver{
    Write-Output "Disabling Screensaver"
    Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -Value 0 -Type DWord
    & powercfg -x -monitor-timeout-ac 0
    & powercfg -x -monitor-timeout-dc 0
}

function Start-Main {
    Write-Output "Running Main"

    Start-GenericRegistrySetup

    Set-Firewall

    Set-TempDirs

    Set-NicsPrivate

    Enable-RDP

    Disable-ScreenSaver

    New-Item -Path C:\SQLServer -ItemType Directory
}
Start-Main
