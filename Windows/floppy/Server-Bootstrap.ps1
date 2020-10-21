function Set-Firewall {
    write-host "######################################################"
    write-host "Configuring Firewall"
    #For WINRM
    netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes action=block
    netsh advfirewall firewall set rule group="Windows Remote Management" new enable=yes
    #For RDP
    netsh advfirewall firewall add rule name="Open Port 3389" dir=in action=allow protocol=TCP localport=3389
    $script:winrmService = Get-Service -Name WinRM
    write-host "Done Configuring"
    write-host "######################################################"
}

function Set-TempDirs {
    write-host "######################################################"
    write-host "Setting Environment Variables"
    # Set Temp Variable using PowerShell

    $TempFolder = "C:\TEMP"
    New-Item -ItemType Directory -Force -Path $TempFolder
    [Environment]::SetEnvironmentVariable("TEMP", $TempFolder, [EnvironmentVariableTarget]::Machine)
    [Environment]::SetEnvironmentVariable("TMP", $TempFolder, [EnvironmentVariableTarget]::Machine)
    [Environment]::SetEnvironmentVariable("TEMP", $TempFolder, [EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("TMP", $TempFolder, [EnvironmentVariableTarget]::User)
    write-host "Done setting Variables"
    write-host "######################################################"
}


function Install-Choco {
    write-host "######################################################"
    write-host "Attempting To download and install Choco"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    write-host "Done installing Choco"
    write-host "######################################################"
}

function Set-NicsPrivate {
    write-host "######################################################"
    write-host "Setting NICs to Private"
    $NetworkListManager = [Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]"{DCB00C01-570F-4A9B-8D69-199FDBA5723B}"))
    $Connections = $NetworkListManager.GetNetworkConnections()
    $Connections | ForEach-Object { $_.GetNetwork().SetCategory(1) }
    write-host "Done Setting NICs to Private"
    write-host "######################################################"
}

function Enable-RDP {
    write-host "######################################################"
    write-host "Enabling RDP"
    #Firewall Setting applied in different function
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
    write-host "Done Enabling RDP"
    write-host "######################################################"
}

function Start-GenericRegistrySetup {
    write-host "######################################################"
    write-host "Setting Generic registry Keys"
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
    reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" /v HideFileExt /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\" /v HibernateFileSizePercent /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\" /v HibernateEnabled /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount /t REG_DWORD /d 0 /f
    write-host "Done Setting Generic Registry Keys"
    write-host "######################################################"
}

function Disable-ScreenSaver{
    write-host "Disabling Screensaver"
    Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -Value 0 -Type DWord
    & powercfg -x -monitor-timeout-ac 0
    & powercfg -x -monitor-timeout-dc 0
}

function Start-Main {
    write-host "Running Main"

    Start-GenericRegistrySetup

    Set-Firewall

    Set-TempDirs

    Set-NicsPrivate

    Enable-RDP

    Disable-ScreenSaver

    New-Item -Path C:\SQLServer -ItemType Directory
}
Start-Main
