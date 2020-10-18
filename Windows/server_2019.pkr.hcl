variable "template"{
    type    = string
    default = "Server-2019"
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

variable "iso_check"{
    type    = string
    default = ""
}

variable "iso_dir"{
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
    default = "Templates/Windows/server2019"
}

variable "vsphere_network"{
    type    = string
    default = "VM Network"
}

variable "vsphere_iso"{
    type    = string
    default = "[Software] ISO/Microsoft/Windows/ENG(English)/2019/en_windows_server_2019_x64_dvd_4cb967d8.iso"
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


source "vsphere-iso" "server2019"{
    boot_wait             = "1m"
    boot_command=[
        "<enter>"
    ]
    CPUs                  = var.cpu
    RAM                   = var.memory
    RAM_reserve_all       = false
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
    floppy_files          = [ "./server_2019/autounattend.xml" ]
    folder                = var.vsphere_folder
    guest_os_type         = "windows9Server64Guest"
    insecure_connection   = "true"
    boot_order            = "disk,cdrom"
    iso_paths             = [var.vsphere_iso]
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

source "hyperv-iso" "server2019"{

    boot_wait                           = var.boot_wait
    communicator                        = var.communicator
    cpus                                = var.cpu
    disk_size                           = var.disk_size
    enable_secure_boot                  = true
    enable_virtualization_extensions    = false
    floppy_dirs                         = [ "./floppy"]
    floppy_files                        = [ "./server_2019/autounattend.xml" ]
    guest_additions_mode                = "disable"
    iso_checksum                        = var.iso_check
    iso_url                             = var.iso_dir
    memory                              = var.memory
    shutdown_command                    = var.windows_shutdown_command
    #                                   V2 doesnt support floppy drives
    switch_name                         = var.hyperv_default_switch
    generation                          = 1
    vm_name                             = var.template
    winrm_password                      = "packer"
    winrm_timeout                       = "2h"
    winrm_username                      = "packer"
    output_directory                    = "${var.build_directory}/packer-${var.template}-hyperv"
    headless                            = true
}

source "virtualbox-iso" "server2019"{
    boot_wait                           = var.boot_wait
    communicator                        = var.communicator
    cpus                                = var.cpu
    disk_size                           = var.disk_size
    guest_additions_mode                = "disable"
    guest_os_type                       = "Windows2016_64"
    headless                            = true
    iso_checksum                        = var.iso_check
    iso_url                             = var.iso_dir
    memory                              = var.memory
    shutdown_command                    = var.windows_shutdown_command
    vm_name                             = var.template
    winrm_password                      = "packer"
    winrm_timeout                       = "2h"
    winrm_username                      = "packer"
    floppy_dirs                         = [ "./floppy"]
    floppy_files                        = [ "./server_2019/autounattend.xml" ]
    output_directory                    = "${var.build_directory}/packer-${var.template}-virtualbox"
}

build {
    sources = [
        "source.hyperv-iso.server2019",
        "source.vsphere-iso.server2019",
        "source.virtualbox-iso.server2019"
    ]

    provisioner "windows-shell"{
        scripts = ["./floppy/install-vm-tools.cmd"]
        only = ["vsphere-iso"]
    }

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
