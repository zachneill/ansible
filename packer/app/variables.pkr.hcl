variable "cpus" {
  description = "The number of virtual cpus"

  type    = number
  default = 4
}

variable "memory" {
  description = "The amount of memory to use when building the x86_64 VM in megabytes"

  type    = number
  default = 3072
}

variable "ssh_timeout" {
  description = "The time to wait for SSH to become available"

  type    = string
  default = "3600s"
}

variable "qemu_binary" {
  description = "Path of QEMU binary"

  type    = string
  default = null
}

variable "ovmf_code" {
  description = "Path of OVMF code file"

  type    = string
  default = "/usr/share/kvm/OVMF_CODE-pure-efi.fd"
}

variable "ovmf_vars" {
  description = "Path of OVMF variables file"

  type    = string
  default = "/usr/share/kvm/OVMF_VARS-pure-efi.fd"
}

variable "disk_size" {
  description = "The size in GB of hard disk of VM"

  type    = string
  default = "10G"
}

variable "ssh_password" {
  description = "A plaintext password to use to authenticate with SSH"

  type      = string
  default   = "password"
  sensitive = true
}