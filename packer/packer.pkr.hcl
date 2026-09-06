packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/qemu"
    }
    ansible = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "qemu" "almalinux-10" {
  iso_url      = "https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/AlmaLinux-10-GenericCloud-10.2-20260817.0.x86_64.qcow2"
  iso_checksum = "sha256:bc59485c4828861a15887e30ff1bb913f0f16202fd7286208518f4814da1e10a"
  ssh_username = "almalinux"
  # ssh_password = 
  headless     = true
  disk_image = true
  format = "qcow2"
  accelerator = "kvm"
}

build {
  name = "app-almalinux-image"
  sources = [
    "source.qemu.almalinux-10"
  ]

  provisioner "ansible" {
    playbook_file = "packer.yml"
    # skip_version_check = true
    extra_arguments = [
      "--extra-vars",
      "vm=app ansible_user=root"
    ]
  }
}

# variable "sudo_pw" {
#   type        = string
#   description = "The password for the sudo user."
#   sensitive   = true
# }