#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko disko.nix
nixos-generate-config --no-filesystems --root /mnt

mount -t tmpfs -o size=1G tmpfs /tmp/extra-space
export TMPDIR=/tmp/extra-space

nixos-install --flake github:tailscale-dev/video-code-snippets/nix-nvidia?dir=2025-02-nix-nvidia-ollama#nix-llm --impure