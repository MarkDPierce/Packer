

# Image list

Below you can find a list of all the provided images and their respective hypervisior/environment.

## Vsphere-iso
|OS     |       version     |created|
| ----- | ----------------- | ----- |
|Debian |   9.2.1           |   👍  |
|Debian |   10.1            |   ⛔  |
|Ubuntu |   20              |   👍  |
|Ubuntu |   19              |   👍  |
|Ubuntu |   18              |   ⛔  |
|Server |   2019            |   👍  |
|Server |   1709            |   ⛔  |
|Server |   2016            |   👍  |
|Server |   2012R2 update   |   ⛔  |
|Server |   2012R2          |   👍  |
|Server |   2012            |   👍  |
|Windows|10 2004            |   ⛔  |
|Windows|10 1909            |   👍  |
|Windows|10 1903            |   👍  |
|Windows|10 1809            |   👍  |
|Windows|10 1703            |   👍  |
___

## Hyperv-Iso
|OS     |       version     |created|
| ----- | ----------------- | ----- |
|Debian |   9.2.1           |   ⛔  |
|Debian |   10.1            |   ⛔  |
|Ubuntu |   20              |   👍  |
|Ubuntu |   19              |   ⛔  |
|Ubuntu |   18              |   👍  |
|Server |   2019            |   👍  |
|Server |   1709            |   👍  |
|Server |   2016            |   👍  |
|Server |   2012R2 update   |   ⛔  |
|Server |   2012R2          |   👍  |
|Server |   2012            |   ⛔  |
|Windows|10 2004            |   ⛔  |
|Windows|10 1909            |   👍  |
|Windows|10 1903            |   👍  |
|Windows|10 1809            |   👍  |
|Windows|10 1703            |   👍  |


___

## Virtualbox-iso

|OS     |       version     |created|
| ----- | ----------------- | ----- |
|Debian |   x               |   ⛔  |
|Ubuntu |   20              |   👍  |
|Ubuntu |   19              |   ⛔  |
|Ubuntu |   18              |   ⛔  |
|Server |   2019            |   ⛔  |
|Server |   1709            |   ⛔  |
|Server |   2016            |   ⛔  |
|Server |   2012R2 update   |   ⛔  |
|Server |   2012R2          |   ⛔  |
|Server |   2012            |   ⛔  |
|Windows|10 2004            |   ⛔  |
|Windows|10 1909            |   ⛔  |
|Windows|10 1903            |   ⛔  |
|Windows|10 1809            |   ⛔  |
|Windows|10 1703            |   ⛔  |
___

# Bootstrapping

The bootstrapping process is broken down by OS type and what is happening there.

## Windows

### Server

-  Winrm
   -  User: packer
   -  pass: packer
-  Choco
   -  git
   -  pwsh

### Desktop

-  Winrm
   -  User: packer
   -  pass: packer
-  Choco
   -  git
   -  pwsh
   -  openssh

## Debian

### Server

- OpenSSHserver
- git

## Ubuntu

### Server

- OpenSSHserver
- git

## Centos

### Server

- OpenSSHserver
- git
