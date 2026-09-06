packer {
  required_plugins {
    proxmox = {
      version = ">= 1.2.4"
      source  = "github.com/hashicorp/proxmox"
    }
    ansible = {
      version = ">= 1.1.6"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "proxmox-iso" "almalinux" {
  proxmox_url  = "http://controller.ndm.zachneill.com:8006/api2/json"
  node         = "odpndmcnt01"
  username     = "terraform-prov@pve!terraform"
  token        = var.proxmox_api_token
  tags         = "packer-managed;app;aut"
  vm_id        = 100
  ssh_username = "almalinux"
  ssh_password = var.proxmox_ssh_password

  boot_iso {
    type         = "scsi"
    iso_url     = "https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/AlmaLinux-10-GenericCloud-10.2-20260817.0.x86_64.qcow2"
    iso_storage_pool = "local"
    unmount      = true
    iso_checksum = "sha256:bc59485c4828861a15887e30ff1bb913f0f16202fd7286208518f4814da1e10a"
  }
}

build {
  name = "app-almalinux-image"
  sources = [
    "source.proxmox-iso.almalinux"
  ]

  # provisioner "ansible" {
  #   playbook_file = "packer.yml"
  #   # skip_version_check = true
  #   extra_arguments = [
  #     "--extra-vars",
  #     "vm=app ansible_user=root"
  #   ]
  # }
}

variable "proxmox_api_token" {
  type        = string
  description = "The password for the sudo user."
  sensitive   = true
}

variable "proxmox_ssh_password" {
  type        = string
  description = "The password for the proxmox iso ssh user."
  sensitive   = true
}