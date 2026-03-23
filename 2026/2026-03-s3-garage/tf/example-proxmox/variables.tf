variable "proxmox_endpoint" {
  description = "Proxmox API endpoint (e.g. https://proxmox.local:8006)"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token — set via TF_VAR_proxmox_api_token. Format: user@realm!tokenid=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS verification for Proxmox API"
  type        = bool
  default     = false
}

variable "proxmox_node" {
  description = "Proxmox node name to deploy VMs on"
  type        = string
}

variable "storage" {
  description = "Proxmox datastore for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Network bridge for VM interfaces"
  type        = string
  default     = "vmbr0"
}

variable "talos_iso" {
  description = "Talos ISO reference in Proxmox storage (e.g. local:iso/talos-v1.9.5-amd64.iso)"
  type        = string
}

variable "cluster_name" {
  description = "Name prefix for VMs and tags"
  type        = string
  default     = "k8s"
}

variable "vm_id_base" {
  description = "Base VM ID; control planes get base+0..N, workers get base+10..N"
  type        = number
  default     = 300
}

variable "cp_count" {
  description = "Number of control plane nodes (1 for dev, 3 for HA)"
  type        = number
  default     = 1
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "control_plane" {
  description = "Control plane node resource specs"
  type = object({
    cores  = number
    memory = number # MiB
    disk   = number # GiB
  })
  default = {
    cores  = 2
    memory = 4096
    disk   = 32
  }
}

variable "worker" {
  description = "Worker node resource specs"
  type = object({
    cores  = number
    memory = number # MiB
    disk   = number # GiB
  })
  default = {
    cores  = 4
    memory = 8192
    disk   = 64
  }
}
