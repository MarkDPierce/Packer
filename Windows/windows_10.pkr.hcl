variable "template"{
    type    = string
    default = "Windows-10"
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
variable "windows_shutdown_command"{
    type    = string
    default = "shutdown -s -t 5"
}
variable "hyperv_default_switch"{
    type    = string
    default = "Default Switch"
}
variable "iso"{
    type    = string
    default = ""
}
variable "checksum"{
    type    = string
    default = "SHA256:466C1CD1E7B9BCF3B984D5A41E24500D4945C0B71B2B6B446D68D26A9C0F2320"
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
    default = "storage"
}

variable "vsphere_folder"{
    type    = string
    default = "Templates/Windows/windows/10"
}

variable "vsphere_network"{
    type    = string
    default = "VM Network"
}

variable "vsphere_iso"{
    type    = string
    default = ""
}


variable "vsphere_password"{
    type    = string
    default = "adminpass"
}

variable "vsphere_user"{
    type    = string
    default = "admin@localhost"
}

variable "vsphere_server"{
    type    = string
    default = "localhost"
}

variable "firmware"{
    type    = string
    default = "bios"
}

variable "windows_version"{
    type    = string
    default = "1909"
}


source "vsphere-iso" "windows10"{
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
    storage {
        disk_size             = var.disk_size
        disk_thin_provisioned = true
    }
    firmware              = var.firmware
    floppy_dirs           = [ "./floppy"]
    floppy_files          = [
        "./desktop/10/autounattend.xml",
        "./floppy/disable-network-discovery.cmd",
        "./floppy/disable-screensaver.ps1",
        "./floppy/disable-winrm.ps1",
        "./floppy/enable-winrm.ps1",
        "./floppy/Server-Bootstrap.ps1",
        "./floppy/install-vm-tools.cmd"
     ]
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
    vm_name               = "${var.template}-${var.windows_version}"
}

/*
source "virtualbox-iso" "windows10_1909"{
    boot_wait                           = var.boot_wait
    communicator                        = var.communicator
    cpus                                = var.cpu
    disk_size                           = var.disk_size
    guest_additions_mode                = "disable"
    #TODO: Lookup virtualbox guest_os_type for virtualbox
    guest_os_type                       = "Windows2016_64"
    headless                            = true
    iso_checksum                        = var.checksum_1909
    iso_url                             = var.iso_1909
    memory                              = var.memory
    shutdown_command                    = var.windows_shutdown_command
    vm_name                             = "${var.template}-1909"
    winrm_password                      = "packer"
    winrm_timeout                       = "2h"
    winrm_username                      = "packer"
    floppy_dirs                         = [ "./floppy"]
    floppy_files                        = [ "./windows_10/autounattend.xml" ]
    output_directory                    = "${var.build_directory}/packer-${var.template}-1909-virtualbox"
}
*/

source "hyperv-iso" "windows10"{
    boot_wait                           = var.boot_wait
    communicator                        = var.communicator
    cpus                                = var.cpu
    disk_size                           = var.disk_size
    enable_secure_boot                  = true
    enable_virtualization_extensions    = false
    floppy_dirs                         = [ "./floppy"]
    floppy_files                        = [
        "./desktop/10/autounattend.xml",
        "./floppy/disable-network-discovery.cmd",
        "./floppy/disable-screensaver.ps1",
        "./floppy/disable-winrm.ps1",
        "./floppy/enable-winrm.ps1",
        "./floppy/Server-Bootstrap.ps1"
     ]
    guest_additions_mode                = "disable"
    iso_checksum                        = var.checksum
    iso_url                             = var.iso
    memory                              = var.memory
    shutdown_command                    = var.windows_shutdown_command
    switch_name                         = var.hyperv_default_switch
    #                                   V2 doesnt support floppy drives
    generation                          = 1
    vm_name                             = "${var.template}-${var.windows_version}"
    winrm_password                      = "packer"
    winrm_timeout                       = "2h"
    winrm_username                      = "packer"
    output_directory                    = "${var.build_directory}/packer-${var.template}-${var.windows_version}-hyperv"
    headless                            = true
}

build {
    sources = [
        "source.vsphere-iso.windows10",
        #"source.virtualbox-iso.windows10_1909",
        "source.hyperv-iso.windows10"
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
