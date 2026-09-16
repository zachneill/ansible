packer {
  required_plugins {
    ansible = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/ansible"
    }
    qemu = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

# AlmaLinux OS 10 Packer template for Cloud-init included and OpenStack compatible Generic Cloud images

source "qemu" "almalinux_10_gencloud_x86_64" {
  iso_url        = "https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/AlmaLinux-10-GenericCloud-ext4-10.2-20260817.0.x86_64.qcow2"
  iso_checksum   = "file:https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/CHECKSUM"
  ssh_username       = "packer"
  ssh_password       = var.gencloud_ssh_password
  ssh_timeout        = var.ssh_timeout
  accelerator        = "kvm"
  disk_image         = true
  disk_interface     = "virtio-scsi"
  disk_size          = var.gencloud_disk_size
  disk_cache         = "unsafe"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  disk_compression   = true
  format             = "qcow2"
  headless           = true
  machine_type       = "q35"
  memory             = var.memory_x86_64
  net_device         = "virtio-net"
  qemu_binary        = var.qemu_binary
  vm_name            = "AlmaLinux-10-GenericCloud-${var.os_ver_10}-${formatdate("YYYYMMDD", timestamp())}.${var.build_number}.x86_64.qcow2"
  cpu_model          = "host"
  cpus               = var.cpus
  efi_boot           = true
  efi_firmware_code  = var.ovmf_code
  efi_firmware_vars  = var.ovmf_vars
  efi_drop_efivars   = true
  vga = "virtio"
  use_backing_file = true
  cd_content = {
    "user-data" = file("cloud-init/user-data")
    "meta-data" = file("cloud-init/meta-data")
  }
  cd_label = "cidata"
}

build {
  sources = [
    "source.qemu.almalinux_10_gencloud_x86_64"
  ]

  provisioner "ansible" {
    user = "packer"
    playbook_file = "packer.yml"
    ansible_env_vars = [
      "ANSIBLE_SSH_TRANSFER_METHOD=scp",
      "ANSIBLE_SCP_EXTRA_ARGS=-O",
      "ANSIBLE_REMOTE_TEMP=/tmp"
    ]
    extra_arguments = [
      "-v",
      "--extra-vars",
      "vm=app target=default"
    ]
  }
}