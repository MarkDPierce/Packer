variable "template"{
    type    = string
    default = "Server-2012"
}
variable "build_directory"{
    type    = string
    default = "../builds"
}

variable "boot_wait"{
    type    = string
    default = "60s"
}

variable "communicator"{
    type    = string
    default = "winrm"
}

variable "cpu"{
    type    = number
    default = 1
}

variable "memory"{
    type    = number
    default = 2048
}

variable "disk_size"{
    type    = number
    default = 120000
}

variable "iso_dir"{
    type    = string
    default = ""
}

variable "iso_check"{
    type    = string
    default = "sha256:6025A37D85C2CEC0C834D75EE65C9B8D068FBEBA118CB6309ED50B73DF0134B8"
}

variable "iso_checkr2"{
    type    = string
    default = "sha256:3EB647CE9900847E88D1D04BD339D8027C94B87B5EBC1A6A0528A57622EE1B41"
}

variable "iso_dirr2"{
    type    = string
    default = ""
}

variable "windows_shutdown_command"{
    type    = string
    default = "shutdown -s -t 5"
}

variable "hyperv_default_switch"{
    type    = string
    default = "Default Switch"
}

#VSphere Stuff
variable "vsphere_cluster"{
    type    = string
    default = "cluster"
}

variable "enable_snapshot"{
    type    = bool
    default = false
}

variable "convert_to_template"{
    type    = bool
    default = false
}

variable "vsphere_datacenter"{
    type    = string
    default = "datacenter"
}

variable "vsphere_datastore"{
    type    = string
    default = "datastore"
}

variable "vsphere_folder"{
    type    = string
    default = "Templates/Windows/server2012"
}

variable "vsphere_network"{
    type    = string
    default = "VM Network"
}

variable "vsphere_iso"{
    type    = string
    default = "[Software] ISO/Microsoft/Windows/ENG(English)/2012/en_windows_server_2012_x64/en_windows_server_2012_x64_dvd_915478.iso"
}

variable "vsphere_isoR2"{
    type    = string
    default = "[Software] ISO/Microsoft/Windows/ENG(English)/2012R2/en_windows_server_2012_r2_x64_dvd_2707946.iso"
}

variable "vsphere_password"{
    type    = string
    default = "adminpass"
}

variable "vsphere_user"{
    type    = string
    default = "admin"
}

variable "vsphere_server"{
    type    = string
    default = "localhost"
}

source "vsphere-iso" "server2012" {
    boot_wait             = var.boot_wait
    CPUs                  = var.cpu
    RAM                   = var.memory
    RAM_reserve_all       = true
    cluster               = var.vsphere_cluster
    communicator          = var.communicator
    winrm_username        = "packer"
    winrm_password        = "packer"
    winrm_timeout         = "2h"
    shutdown_command      = var.windows_shutdown_command
    create_snapshot       = var.enable_snapshot
    convert_to_template   = var.convert_to_template
    datacenter            = var.vsphere_datacenter
    datastore             = var.vsphere_datastore
    disk_controller_type  = ["lsilogic-sas"]
    storage {
        disk_size             = var.disk_size
        disk_thin_provisioned = true
    }
    firmware              = "efi"
    floppy_dirs           = [ "./floppy"]
    floppy_files          = [ "./server_2012/autounattend.xml" ]
    folder                = var.vsphere_folder
    guest_os_type         = "windows9Server64Guest"
    insecure_connection   = "true"
    iso_paths             = [
        var.vsphere_iso,
        "[] /vmimages/tools-isoimages/windows.iso"
        ]
    network_adapters  {
        network               = var.vsphere_network
        network_card          = "vmxnet3"
    }
    notes                 = "Built via Packer"
    password              = var.vsphere_password
    username              = var.vsphere_user
    vcenter_server        = var.vsphere_server
    vm_name               = var.template
}

source "vsphere-iso" "server2012r2" {
    boot_wait             = var.boot_wait
    boot_command = [
        "<enter>"
    ]
    CPUs                  = var.cpu
    RAM                   = var.memory
    RAM_reserve_all       = true
    cluster               = var.vsphere_cluster
    communicator          = var.communicator
    winrm_username        = "packer"
    winrm_password        = "packer"
    winrm_timeout         = "2h"
    shutdown_command      = var.windows_shutdown_command
    create_snapshot       = var.enable_snapshot
    convert_to_template   = var.convert_to_template
    datacenter            = var.vsphere_datacenter
    datastore             = var.vsphere_datastore
    disk_controller_type  = ["lsilogic-sas"]
    storage  {
        disk_size             = var.disk_size
        disk_thin_provisioned = true
    }
    firmware              = "efi"
    floppy_dirs           = [ "./floppy"]
    floppy_files          = [ "./server_2012R2/autounattend.xml" ]
    folder                = var.vsphere_folder
    guest_os_type         = "windows9Server64Guest"
    insecure_connection   = "true"
    iso_paths             = [
        var.vsphere_isoR2,
        "[] /vmimages/tools-isoimages/windows.iso"
    ]
    network_adapters  {
        network               = var.vsphere_network
        network_card          = "vmxnet3"
    }
    notes                 = "Built via Packer"
    password              = var.vsphere_password
    username              = var.vsphere_user
    vcenter_server        = var.vsphere_server
    vm_name               = "${var.template}R2"
}


source "hyperv-iso" "server2012"{

    boot_wait                           = var.boot_wait
    communicator                        = var.communicator
    cpus                                = var.cpu
    disk_size                           = var.disk_size
    enable_secure_boot                  = false
    enable_virtualization_extensions    = false
    floppy_dirs                         = [ "./floppy"]
    floppy_files                        = [ "./server_2012/autounattend.xml" ]
    guest_additions_mode                = "disable"
    iso_checksum                        = var.iso_check
    iso_url                             = var.iso_dir
    memory                              = var.memory
    shutdown_command                    = var.windows_shutdown_command
    switch_name                         = var.hyperv_default_switch
    #                                   V2 doesnt support floppy drives
    generation                          = 1
    vm_name                             = "${var.template}"
    winrm_password                      = "packer"
    winrm_timeout                       = "2h"
    winrm_username                      = "packer"
    output_directory                    = "${var.build_directory}/packer-${var.template}-hyperv"
    headless                            = true
}

source "hyperv-iso" "server2012r2"{

    boot_wait                           = var.boot_wait
    communicator                        = var.communicator
    cpus                                = var.cpu
    disk_size                           = var.disk_size
    enable_secure_boot                  = true
    enable_virtualization_extensions    = false
    floppy_dirs                         = [ "./floppy"]
    floppy_files                        = [ "./server_2012R2/autounattend.xml" ]
    guest_additions_mode                = "disable"
    iso_checksum                        = var.iso_checkr2
    iso_url                             = var.iso_dirr2
    memory                              = var.memory
    shutdown_command                    = var.windows_shutdown_command
    switch_name                         = var.hyperv_default_switch
    #                                   V2 doesnt support floppy drives
    generation                          = 1
    vm_name                             = "${var.template}R2"
    winrm_password                      = "packer"
    winrm_timeout                       = "2h"
    winrm_username                      = "packer"
    output_directory                    = "${var.build_directory}/packer-${var.template}R2-hyperv"
    headless                            = true
}

source "virtualbox-iso" "server2012r2"{
    boot_wait                           = var.boot_wait
    communicator                        = var.communicator
    cpus                                = var.cpu
    disk_size                           = var.disk_size
    guest_additions_mode                = "disable"
    guest_os_type                       = "Windows2012_64"
    headless                            = true
    iso_checksum                        = var.iso_check
    iso_url                             = var.iso_dir
    memory                              = var.memory
    shutdown_command                    = var.windows_shutdown_command
    vm_name                             = "${var.template}R2"
    winrm_password                      = "packer"
    winrm_timeout                       = "2h"
    winrm_username                      = "packer"
    floppy_dirs                         = [ "./floppy"]
    floppy_files                        = [ "./server_2012R2/autounattend.xml" ]
    output_directory                    = "${var.build_directory}/packer-${var.template}-virtualbox"
}

build {
    sources  = [
            "source.hyperv-iso.server2012",
            "source.hyperv-iso.server2012r2",
            "source.vsphere-iso.server2012",
            "source.vsphere-iso.server2012r2",
            "source.virtualbox-iso.server2012r2"
     ]
    provisioner "windows-shell" {
        execute_command                 = "{{ .Vars }} cmd /c \"{{ .Path }}\""
        scripts                         = [
            "./scripts/enable-rdp.bat"
        ]
    }

    provisioner "powershell"{
        scripts = [
            "./scripts/install-choco.ps1",
            "./scripts/install-powershellmodules.ps1"
        ]
    }

    provisioner "windows-restart"{
        restart_timeout                 = "5m"
    }

    provisioner "powershell"{
        scripts = [
            "./scripts/install-chocopacks.ps1"
        ]
    }
}
