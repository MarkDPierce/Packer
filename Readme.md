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
        - [Terraform](#installing-terraform)
            - [Windows](#windows)
            - [WSL](#WSL)
            - [Mac](#mac)
        - [Ansible](#installing-ansible)
            - [Windows](#windows)
            - [WSL](#wsl)
            - [Mac](#mac)
- **[Packer](#packer)**
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

You can be lazy and run [this](). What it is doing can be found here []()

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

### Installing Terraform

This stuff is literally taken from [here](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started)

#### Windows
The exe is portable, Choco just does a little more like adding it to our path and stuff.

```Powershell
choco install terraform
```

#### WSL

Debian
```Shell
sudo apt install software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

RHEL
```Shell
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
```

#### Mac

Installing brew is outside the scope of this.

```shell
brew tap hashicorp/tap
brew install hashicorp/tap/packer
```

# Installing Ansible

This stuff is literally taken from [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

#### Windows
Refer to the WSL section. There is no real way to run it outside of linux. Another method, not outlined, you could run a docker container and wrap all your ansible commands to run through that.

#### WSL
Installing WSL is outside the scope of this document.

Debian < version 20
```Shell
sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
```

Ubuntu 20
```Shell
sudo apt-get install ansible
```

#### Mac

Brewing all day long

```shell
brew install ansible
```

# Packer

Packer information

Example Commands

Build a hyperv image from iso with a specific config file
```
packer build -force -on-error=cleanup -only='hyperv-iso.windows10_1703' -var-file='windows10.json' .\windows_10.pkr.hcl
```

## Defaults

Default packer settings related to networking, remote connections.

### Winrm

This is all boiler plate
|name|port|password|
|----|----|-------|
|packer|5985|packer|

### SSH

This is all boiler plate
|name|port|password|
|----|----|-------|
|packer|22|packer|

## 🦮 Contributing & Developing
___
**TODO:**
 - Need to organize unatended scripts better
   - Disks
   - Script Execution
 - Need to enhance linux stuff
 - Need to work on virtualbox implementation
 - Test vsphere-iso stuff
 - Enhance documentation
 - Update powershell wrapper to reflect configs

## 📱 Troubleshooting
___

Todo: Add troubleshooting section.
