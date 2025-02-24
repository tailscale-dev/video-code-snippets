#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko hybrid.nix
nixos-generate-config --no-filesystems --root /mnt
