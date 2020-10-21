Write-Output "##################### Disabling Screensaver and setting power plan. #####################"
Set-ItemProperty "HKCU:\Control Panel\Desktop" -Name ScreenSaveActive -Value 0 -Type DWord
& powercfg -x -monitor-timeout-ac 0
& powercfg -x -monitor-timeout-dc 0
Write-Output "##################### Finished disabling Screensaver and setting power plan. #####################"
