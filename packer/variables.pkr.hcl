variable "os_ver_10" {
  description = "AlmaLinux OS 10 version"

  type    = string
  default = "10.2"

  validation {
    condition     = can(regex("10.[0-9]$|10.[1-9][0-9]$", var.os_ver_10))
    error_message = "The os_ver_10 value must be one of released or prereleased versions of AlmaLinux OS 10."
  }
}

variable "build_number" {
  description = "Build number identifier of an image version"

  type    = number
  default = 0
}

locals {
  iso_url_10_x86_64      = "https://repo.almalinux.org/almalinux/${var.os_ver_10}/isos/x86_64/AlmaLinux-${var.os_ver_10}-x86_64-boot.iso"
  iso_checksum_10_x86_64 = "file:https://repo.almalinux.org/almalinux/${var.os_ver_10}/isos/x86_64/CHECKSUM"
}

# Common

variable "headless" {
  description = "Disable GUI"

  type    = bool
  default = true
}

variable "boot_wait" {
  description = "Time to wait before typing boot command"

  type    = string
  default = "30s"
}

variable "cpus" {
  description = "The number of virtual cpus"

  type    = number
  default = 4
}

variable "memory_x86_64" {
  description = "The amount of memory to use when building the x86_64 VM in megabytes"

  type    = number
  default = 3072
}

variable "post_cpus" {
  description = "The number of virtual cpus after the build"

  type    = number
  default = 1
}

variable "post_memory" {
  description = "The number of virtual cpus after the build"

  type    = number
  default = 1024
}

variable "http_directory" {
  description = "Path to a directory to serve kickstart files"

  type    = string
  default = "http"
}

variable "ssh_timeout" {
  description = "The time to wait for SSH to become available"

  type    = string
  default = "3600s"
}

variable "root_shutdown_command" {
  description = "The command to use to gracefully shut down the machine"

  type    = string
  default = "/sbin/shutdown -hP now"
}

variable "qemu_binary" {
  description = "Path of QEMU binary"

  type    = string
  default = null
}

variable "ovmf_code" {
  description = "Path of OVMF code file"

  type    = string
  default = "/usr/share/OVMF/OVMF_CODE.secboot.fd"
}

variable "ovmf_vars" {
  description = "Path of OVMF variables file"

  type    = string
  default = "/usr/share/OVMF/OVMF_VARS.secboot.fd"
}

variable "aavmf_code" {
  description = "Path of AAVMF code file"

  type    = string
  default = "/usr/share/AAVMF/AAVMF_CODE.fd"
}

# Generic Cloud (Cloud-init)

variable "gencloud_disk_size" {
  description = "The size in GB of hard disk of VM"

  type    = string
  default = "10G"
}

variable "gencloud_ssh_username" {
  description = "The username to connect to SSH with"

  type    = string
  default = "root"
}

variable "gencloud_ssh_password" {
  description = "A plaintext password to use to authenticate with SSH"

  type      = string
  default   = "almalinux"
  sensitive = true
}

variable "gencloud_boot_command_10_x86_64" {
  description = "Boot command for AlmaLinux OS 10 Generic Cloud x86_64"

  type = list(string)
  default = [
    "e",
    "<down><down>",
    "<leftCtrlOn>e<leftCtrlOff>",
    "<spacebar>",
    "biosdevname=0",
    "<spacebar>",
    "net.ifnames=0",
    "<spacebar>",
    "inst.text",
    "<spacebar>",
    "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/almalinux-10.gencloud-x86_64.ks",
    "<leftCtrlOn>x<leftCtrlOff>",
  ]
}