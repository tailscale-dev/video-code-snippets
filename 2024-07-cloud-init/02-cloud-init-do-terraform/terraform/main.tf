terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}
variable "tailscale_auth_key" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "droplet" {
  image     = "ubuntu-24-04-x64"
  name      = "nyc1-terraform-caddy"
  region    = "nyc1"
  size      = "s-1vcpu-1gb"
  # doctl -t dop_v1_token compute ssh-key list
  ssh_keys  = [42950830]
  user_data = templatefile("digitalocean.tftpl", { tailscale_auth_key = var.tailscale_auth_key })
}