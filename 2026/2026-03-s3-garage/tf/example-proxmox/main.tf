terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.70.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure
}

resource "proxmox_virtual_environment_vm" "control_plane" {
  count = var.cp_count

  name      = "${var.cluster_name}-cp${count.index + 1}"
  node_name = var.proxmox_node
  vm_id     = var.vm_id_base + count.index
  tags      = [var.cluster_name, "control-plane", "talos"]

  on_boot         = false
  started         = true
  stop_on_destroy = false
  scsi_hardware   = "virtio-scsi-single"

  cpu {
    cores = var.control_plane.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.control_plane.memory
  }

  disk {
    datastore_id = var.storage
    interface    = "scsi0"
    size         = var.control_plane.disk
    file_format  = "raw"
  }

  cdrom {
    file_id   = var.talos_iso
    interface = "ide2"
  }

  boot_order = ["scsi0", "ide2"]

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  agent {
    enabled = true
    type    = "virtio"
    timeout = "45s"
  }

  operating_system {
    type = "l26"
  }
}

resource "proxmox_virtual_environment_vm" "worker" {
  count = var.worker_count

  name      = "${var.cluster_name}-worker${count.index + 1}"
  node_name = var.proxmox_node
  vm_id     = var.vm_id_base + 10 + count.index
  tags      = [var.cluster_name, "worker", "talos"]

  on_boot         = false
  started         = true
  stop_on_destroy = false
  scsi_hardware   = "virtio-scsi-single"

  cpu {
    cores = var.worker.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.worker.memory
  }

  disk {
    datastore_id = var.storage
    interface    = "scsi0"
    size         = var.worker.disk
    file_format  = "raw"
  }

  cdrom {
    file_id   = var.talos_iso
    interface = "ide2"
  }

  boot_order = ["scsi0", "ide2"]

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  agent {
    enabled = true
    type    = "virtio"
    timeout = "45s"
  }

  operating_system {
    type = "l26"
  }
}

output "control_plane_vms" {
  value = {
    for vm in proxmox_virtual_environment_vm.control_plane : vm.name => {
      id = vm.vm_id
      ip = try([for ip in flatten(vm.ipv4_addresses) : ip if ip != "127.0.0.1"][0], "pending")
    }
  }
}

output "worker_vms" {
  value = {
    for vm in proxmox_virtual_environment_vm.worker : vm.name => {
      id = vm.vm_id
      ip = try([for ip in flatten(vm.ipv4_addresses) : ip if ip != "127.0.0.1"][0], "pending")
    }
  }
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint (available after first boot via qemu-agent)"
  value       = try([for ip in flatten(proxmox_virtual_environment_vm.control_plane[0].ipv4_addresses) : ip if ip != "127.0.0.1"][0], "pending")
}
