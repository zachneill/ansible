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

source "qemu" "ubuntu_26_server_cloud" {
  vm_name = "Ubuntu-26-ServerCloud-26.04-${formatdate("YYYYMMDD", timestamp())}.qcow2"

  iso_url          = "https://cloud-images.ubuntu.com/releases/resolute/release/ubuntu-26.04-server-cloudimg-amd64.img"
  iso_checksum     = "file:https://cloud-images.ubuntu.com/releases/resolute/release/SHA256SUMS"
  ssh_username     = "packer"
  ssh_password     = var.ssh_password
  cpus             = var.cpus
  memory           = "2048"
  disk_size        = var.disk_size
  ssh_timeout      = var.ssh_timeout
  accelerator      = "kvm"
  disk_image       = true
  output_directory = "output"
  format           = "qcow2"
  use_backing_file = true
  disk_compression = true

  headless = true

  cd_content = {
    "user-data" = file("cloud-init/user-data")
    "meta-data" = file("cloud-init/meta-data")
  }
  cd_label = "cidata"
}

build {
  sources = ["source.qemu.ubuntu_26_server_cloud"]

  # wait for cloud-init to successfully finish
  provisioner "shell" {
    inline = [
      "cloud-init status --wait > /dev/null 2>&1"
    ]
  }

  provisioner "ansible" {
    user          = "packer"
    playbook_file = "packer.yml"
    ansible_env_vars = [
      "ANSIBLE_SSH_TRANSFER_METHOD=scp",
      "ANSIBLE_SCP_EXTRA_ARGS=-O",
      "ANSIBLE_REMOTE_TEMP=/tmp"
    ]
    extra_arguments = [
      "-v",
      "--extra-vars",
      "vm=plt target=default"
    ]
  }
}