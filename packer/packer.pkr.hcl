packer {
  required_plugins {
    # proxmox = {
    #   version = ">= 1.2.4"
    #   source  = "github.com/hashicorp/proxmox"
    # }
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
  iso_url        = local.iso_url_10_x86_64
  iso_checksum   = local.iso_checksum_10_x86_64
  http_directory = "packer/http"
  # http_directory     = var.http_directory
  shutdown_command   = var.root_shutdown_command
  ssh_username       = var.gencloud_ssh_username
  ssh_password       = var.gencloud_ssh_password
  ssh_timeout        = var.ssh_timeout
  boot_command       = var.gencloud_boot_command_10_x86_64
  boot_wait          = var.boot_wait
  accelerator        = "kvm"
  disk_interface     = "virtio-scsi"
  disk_size          = var.gencloud_disk_size
  disk_cache         = "unsafe"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  disk_compression   = true
  format             = "qcow2"
  headless           = var.headless
  machine_type       = "q35"
  memory             = var.memory_x86_64
  net_device         = "virtio-net"
  qemu_binary        = var.qemu_binary
  vm_name            = "AlmaLinux-10-GenericCloud-${var.os_ver_10}-${formatdate("YYYYMMDD", timestamp())}.${var.build_number}.x86_64.qcow2"
  cpu_model          = "host"
  cpus               = var.cpus
  # efi_boot           = true
  # efi_firmware_code  = var.ovmf_code
  # efi_firmware_vars  = var.ovmf_vars
  # efi_drop_efivars   = true
}

build {
  sources = [
    "source.qemu.almalinux_10_gencloud_x86_64"
  ]

  # provisioner "ansible" {
  #   galaxy_file          = "./ansible/requirements.yml"
  #   galaxy_force_install = true
  #   collections_path     = "./ansible/collections"
  #   roles_path           = "./ansible/roles"
  #   playbook_file        = "./ansible/gencloud.yml"
  #   ansible_env_vars = [
  #     "ANSIBLE_PIPELINING=True",
  #     "ANSIBLE_REMOTE_TEMP=/tmp",
  #     "ANSIBLE_SSH_TRANSFER_METHOD=scp",
  #     "ANSIBLE_SCP_EXTRA_ARGS=-O",
  #   ]
  # }
  provisioner "ansible" {
    playbook_file = "packer.yml"
    # skip_version_check = true
    extra_arguments = [
      "--extra-vars",
      "vm=app ansible_user=root"
    ]
  }
}