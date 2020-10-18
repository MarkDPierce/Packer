variable "template"{
    type    = string
    default = "ubuntu20-amd64"
}
variable "build_directory"{
    type    = string
    default = "../builds"
}
variable "boot_wait"{
    type    = string
    default = "10s"
}
variable "ssh_username"{
    type    = string
    default = "packer"
}
variable "ssh_password"{
    type    = string
    default = "packer"
}
variable "communicator"{
    type    = string
    default = "ssh"
}
variable "iso_check"{
    type    = string
    default = "sha256:F11BDA2F2CAED8F420802B59F382C25160B114CCC665DBAC9C5046E7FCEACED2"
}
variable "iso_dir"{
    type    = string
    default = ""
}
variable "ubuntu_shutdown_command"{
    type    = string
    default = "sudo -S shutdown -P now"
}
variable "hyperv_default_switch"{
    type    = string
    default = "Default Switch"
}
variable "vm_cpu_num" {
    type    = number
    default = 2
}
variable "vm_mem_size" {
    type    = number
    default = 1024
}
variable "vm_disk_size" {
    type    = number
    default = 102400
}
variable "vsphere_cluster" {
    type    = string
    default = ""
}
variable "vsphere_datacenter" {
    type    = string
    default = ""
}
variable "vsphere_datastore" {
    type    = string
    default = ""
}
variable "vsphere_folder" {
    type    = string
    default = "Templates/TemplatesV2/Ubuntu"
}
variable "vsphere_network" {
    type    = string
    default = "VM Network"
}
variable "vsphere_password" {
    type    = string
    default = ""
}
variable "vsphere_server" {
    type    = string
    default = "localhost"
}
variable "vsphere_user" {
    type    = string
    default = "admin@localhost"
}
variable "os_iso_path" {
    type    = string
    default = "[Software] ISO/Linux/Ubuntu/20.04 Server/ubuntu-20.04.1-legacy-server-amd64.iso"
}
variable "builderip" {
    type    = string
    default = "127.0.0.1"
}

source "vsphere-iso" "ubuntu20" {
    boot_wait                           = "5s"
    boot_command = [
        "<esc><wait>",
        "<esc><wait>",
        "<enter><wait>",
        "/install/vmlinuz<wait>",
        " initrd=/install/initrd.gz<wait>",
        " priority=critical<wait>",
        " locale=en_US<wait>",
        " file=/media/preseed.cfg<wait>",
        "<enter>"
    ]
    CPUs                                = var.vm_cpu_num
    RAM                                 = var.vm_mem_size
    RAM_reserve_all                     = true
    convert_to_template                 = var.template
    cluster                             = var.vsphere_cluster
    datacenter                          = var.vsphere_datacenter
    datastore                           = var.vsphere_datastore
    disk_controller_type                = ["lsilogic-sas"]
    folder                              = var.vsphere_folder
    guest_os_type                       = "ubuntu64Guest"
    floppy_files = [
        "./ubuntu-20.04/preseed.cfg"
    ]
    insecure_connection                 = "true"
    iso_paths                           = [var.os_iso_path]
    network_adapters {
        network                         = var.vsphere_network
        network_card                    = "vmxnet3"
    }

    shutdown_command                    = "echo ${var.ssh_password}|sudo -S shutdown -P now"
    ssh_password                        = var.ssh_password
    ssh_timeout                         = "10000s"
    ssh_username                        = var.ssh_username
    storage {
        disk_size             = var.vm_disk_size
        disk_thin_provisioned   = true
    }
    password                            = var.vsphere_password
    username                            = var.vsphere_user
    vcenter_server                      = var.vsphere_server
    vm_name                             = var.template
    notes                               = "Built via Packer"
}

source "hyperv-iso" "ubuntu20"{
    boot_wait = "10s"
    boot_command = [
        "<esc><wait>",
        "<esc><wait>",
        "<enter><wait>",
        "/install/vmlinuz<wait>",
        " initrd=/install/initrd.gz<wait>",
        " priority=critical<wait>",
        " locale=en_US<wait>",
        " preseed/url=http://${var.builderip}:{{ .HTTPPort }}/ubuntu18/preseedv.cfg <wait>",
        " -- <wait>",
        "<enter><wait>"
    ]
    communicator = "ssh"
    cpus                                = var.vm_cpu_num
    disk_size                           = var.vm_disk_size
    memory                              = var.vm_mem_size
    vm_name                             = var.template
    http_directory                      = "${path.root}/http"
    shutdown_command                    = "echo ${var.ssh_password}|${var.ubuntu_shutdown_command}"
    enable_secure_boot                  = false
    iso_checksum                        = var.iso_check
    iso_url                             = var.iso_dir
    switch_name                         = var.hyperv_default_switch
    #                                   V2 doesnt support floppy drives
    generation                          = 1
    ssh_timeout                         = "10000s"
    ssh_username                        = var.ssh_username
    ssh_password                        = var.ssh_password
    guest_additions_mode                = "disable"
    output_directory                    = "${var.build_directory}/packer-${var.template}-hyperv"
}

source "virtualbox-iso" "ubuntu20"{
    boot_wait                           = var.boot_wait
    boot_command = [
        "<esc><wait>",
        "<esc><wait>",
        "<enter><wait>",
        "/install/vmlinuz",
        " auto=true",
        " url=http://${var.builderip}:{{ .HTTPPort }}/ubuntu20/preseed.cfg",
        " locale=en_US<wait>",
        " console-setup/ask_detect=false<wait>",
        " console-setup/layoutcode=us<wait>",
        " console-setup/modelcode=pc105<wait>",
        " debconf/frontend=noninteractive<wait>",
        " debian-installer=en_US<wait>",
        " fb=false<wait>",
        " initrd=/install/initrd.gz<wait>",
        " kbd-chooser/method=us<wait>",
        " keyboard-configuration/layout=USA<wait>",
        " keyboard-configuration/variant=USA<wait>",
        " netcfg/get_domain=vm<wait>",
        " netcfg/get_hostname=packer<wait>",
        " grub-installer/bootdev=/dev/sda<wait>",
        " noapic<wait>",
        " -- <wait>",
        "<enter><wait>"
    ]
    communicator                        = var.communicator
    cpus                                = var.vm_cpu_num
    disk_size                           = var.vm_disk_size
    guest_additions_mode                = "disable"
    guest_os_type                       = "Ubuntu_64"
    headless                            = false
    iso_checksum                        = var.iso_check
    iso_url                             = var.iso_dir
    memory                              = var.vm_mem_size
    hard_drive_interface                = "sata"
    http_directory                      = "${path.root}/http"
    virtualbox_version_file             = ".vbox_version"
    shutdown_command                    = "echo ${var.ssh_password}|${var.ubuntu_shutdown_command}"
    vm_name                             = var.template
    ssh_password                        = var.ssh_password
    ssh_timeout                         = "10000s"
    ssh_username                        = var.ssh_username
    output_directory                    = "${var.build_directory}/packer-${var.template}-virtualbox"
}

build {
    sources = [
        "source.hyperv-iso.ubuntu20",
        "source.virtualbox-iso.ubuntu20",
        "source.vsphere-iso.ubuntu20",
    ]
    provisioner "shell"{
        script = "./http/hyperv.sh"
        only = ["hyperv-iso.ubuntu20"]
    }
    provisioner "shell"{
        script = "./http/vmware.sh"
        only = ["vmware-iso"]
    }
    provisioner "shell"{
        environment_vars = [
            "HOME_DIR=/home/packer"
        ]
        execute_command = "echo 'packer' | sudo -S env {{ .Vars }} {{ .Path }}"
        expect_disconnect = true
        scripts = [
          #"./http/networkingDHCP.sh",
          #"./http/cleanup.sh",
          "./http/update.sh",
        ]
    }
}
