[CmdletBinding()]
param (
    [Parameter()]
    [ValidateSet("2012", "2016", "2019", "windows10")]
    [string]
    $serverVersion = "2019",

    [ValidateSet("vsphere", "hyperv", "virtualbox")]
    [string]
    $build = "hyperv"
)
<#

    Super duper quick wrapper to pacer build your fav OS.
    This is super rough and POC/MVP to help me stop having
    to remember things and start working towards automation.

#>
#TODO: Create a way to do versions per source instead of all

function Packer-Build{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $source,
        $pkrHcl,

        $VersionList
    )
    foreach($ver in $VersionList){
        packer build -force -on-error=cleanup -only="$source.$ver" $pkrHcl
    }
}


switch ($serverVersion) {

    "2012"{
        $pkrHcl = "server_2012.pkr.hcl"
        $server2012 = @(
            "server2012",
            "server2012r2"
        )

        if($build -eq "hyperv"){
            Packer-Build -source "$build-iso" -VersionList $server2012 -pkrHcl $pkrHcl
        }
        if ($build -eq "virtualbox") {
            Packer-Build -source "$build-iso" -VersionList $server2012 -pkrHcl $pkrHcl
        }
        if ($build -eq "vsphere") {
            Packer-Build -source "$build-iso" -VersionList $server2012 -pkrHcl $pkrHcl
        }
     }
    "2016"{
        $pkrHcl = "server_2016.pkr.hcl"
        $server2016 = @(
            "server2016"
        )
        if ($build -eq "hyperv") {
            Packer-Build -source "$build-iso" -VersionList $server2016 -pkrHcl $pkrHcl
        }
        if ($build -eq "virtualbox") {
            Packer-Build -source "$build-iso" -VersionList $server2016 -pkrHcl $pkrHcl
        }
        if ($build -eq "vsphere") {
            Packer-Build -source "$build-iso" -VersionList $server2016 -pkrHcl $pkrHcl
        }
     }
    "2019"{
        $pkrHcl = "server_2019.pkr.hcl"
        $server2019 = @(
            "server2019"
        )

        if ($build -eq "hyperv") {
            Packer-Build -source "$build-iso" -VersionList $server2019 -pkrHcl $pkrHcl
        }
        if ($build -eq "virtualbox") {
            Packer-Build -source "$build-iso" -VersionList $server2019 -pkrHcl $pkrHcl
        }
        if ($build -eq "vsphere") {
            Packer-Build -source "$build-iso" -VersionList $server2019 -pkrHcl $pkrHcl
        }
     }
    "windows10"{
        $pkrHcl = "windows_10.pkr.hcl"
        $windows10 = @(
            "windows10_1703",
            "windows10_1809",
            "windows10_1903",
            "windows10_1909"
        )
        if ($build -eq "hyperv") {
            Packer-Build -source "$build-iso" -VersionList $windows10 -pkrHcl $pkrHcl
        }
        if ($build -eq "virtualbox") {
            Packer-Build -source "$build-iso" -VersionList $windows10 -pkrHcl $pkrHcl
        }
        if ($build -eq "vsphere") {
            Packer-Build -source "$build-iso" -VersionList $windows10 -pkrHcl $pkrHcl
        }
     }
}
