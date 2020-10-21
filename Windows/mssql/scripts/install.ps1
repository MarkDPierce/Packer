$pathToConfigurationFile = "a:\configuration.ini"

$copyFileLocation = "C:\Temp\configuration.ini"
$errorOutputFile = "C:\Temp\ErrorOutput.txt"
$standardOutputFile = "C:\Temp\StandardOutput.txt"

Write-Host "Copying the configuration.ini file."

New-Item "C:\Temp" -ItemType "Directory" -Force
Remove-Item $errorOutputFile -Force -ErrorAction SilentlyContinue
Remove-Item $standardOutputFile -Force -ErrorAction SilentlyContinue
Copy-Item $pathToConfigurationFile $copyFileLocation -Force

<#
# Currently we use the administrator group, modify the config.ini username with the replace string to use
Write-Host "Getting the name of the current user to replace in the copy ini file."

$user = "$env:UserDomain\$env:USERNAME"

write-host $user

Write-Host "Replacing the placeholder user name with your username"
$replaceText = (Get-Content -path $copyFileLocation -Raw) -replace "##MyUser##", $user
Set-Content $copyFileLocation $replaceText
#>

foreach($dir in Get-PSDrive){
    foreach($d in Get-ChildItem $dir.root -ErrorAction SilentlyContinue){
        if($d.name -eq 'setup.exe'){
            $exe = $d.FullName
        }
    }
}

Write-Host "Starting the install of SQL Server"
Start-Process $exe "/ConfigurationFile=$copyFileLocation" -Wait -RedirectStandardOutput $standardOutputFile -RedirectStandardError $errorOutputFile


$standardOutput = Get-Content $standardOutputFile -Delimiter "\r\n"

#Write-Host $standardOutput

$errorOutput = Get-Content $errorOutputFile -Delimiter "\r\n"

Write-Host $errorOutput
