#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

# disk partitioning etc
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko disko.nix
nixos-generate-config --no-filesystems --root /mnt

# installation
export NIXPKGS_ALLOW_UNFREE=1
nixos-install --root /mnt --flake .#nix-llm --impure