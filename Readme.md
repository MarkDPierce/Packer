📦 Packer Documentation

~ ***Mood's a thing for cattle or making love***

**Standard image building tool.**
___

## 🚩Table of Contents:
-   **[Setup](#setup)**
    - [Installing Required Software](#install-required-software)
      - [Chocolatey](#installing-chocolatey)
        - [Windows](#windows)
        - [WSL](#WSL)
        - [Mac](#mac)
      - [Packer](#installing-packer)
        - [Windows](#windows)
        - [WSL](#WSL)
        - [Mac](#mac)
- **[Packer](#packer)**
  - [Examples](#examples)
  - [Defaults](#defaults)
      - [WINRM](#winrm)
      - [SSH](#ssh)
- **[Base Images](#base-images)**
    -[Windows](#windows)
    -[Linux](#linux)
- [Contributing & Developing](#🦮-contributing-&-developing)
- [Troubleshooting](#📱-troubleshooting)

# Setup

## Install Required Software

### Installing Chocolatey
This is a Windows only kinda thing. Also, everything in this document related to Powershell should be ran from an elevated prompt.

### Installing Packer

This stuff is literally taken from [here](https://learn.hashicorp.com/tutorials/packer/getting-started-install)

#### Windows

```Powershell
choco install packer
```

#### WSL

Debian

```Shell
sudo apt install software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```

RHEL
```Shell
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install packer
```


#### Mac
Installing brew is outside the scope of this.

```shell
brew tap hashicorp/tap
brew install hashicorp/tap/packer
```

# Packer

Packer is a standard tool for building images that can the be placed on popular cloud providers or on premise providers.

The concepts are simple. Supply an ISO, required kickstart/sysprep files and any supporting files and scripts and build out images or templates that can be distributed as standard or base images.

[More on packer here](https://www.packer.io/docs/)


# Examples

From the root directory.

Running Windows Servers for hyper-v
```powershell
cd windows
packer build -force -on-error=cleanup -var-file='/configs/windows_server_2019.json' -only='hyperv-iso.server' .\server.pkr.hcl
```

If you want to build vsphere and hyper-v images together
```powershell
cd windows
packer build -force -on-error=cleanup -var-file='/configs/windows_server_2019.json' .\server.pkr.hcl
```

## Defaults

Default packer settings related to networking, remote connections.

### Login

|name|domain|password|
|----|----|-------|
|packer|local|packer|

### Winrm

|name|port|password|
|----|----|-------|
|packer|5985|packer|

### SSH

|name|port|password|
|----|----|-------|
|packer|22|packer|

## 🦮 Contributing & Developing
___
**TODO:**
 - Clean-up unattended files
   - Make them a close to each other as possible
   - consistent disks
   - consistent start scripts
   - consistent user/group account creation
 - Clean-up bootstrapping scripts
   - Better OOP
   - Document the scripts and what they do
   - Standardize WINRM
 - Catalog
   - ISO's
   - ISO Checksums
   - ISO location
     - SMB mapping
     - Vsphere mapping

## 📱 Troubleshooting
___

Its an emojii. Dont call me. I'll update this ASAP
