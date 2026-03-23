#!/usr/bin/env bash
set -euo pipefail

HOST="${1:?usage: garage-init.sh <tailscale-hostname>}"
GARAGE="ssh $HOST docker exec garage /garage"

NODE_ID=$($GARAGE status 2>/dev/null | awk '/[0-9a-f]{16}/ { print $1; exit }')

# Tell Garage how much storage this node contributes and which zone it's in
$GARAGE layout assign -z dc1 -c 1G "$NODE_ID"
# Commit the layout — version must increment on each change
$GARAGE layout apply --version 1
# Create an S3 access key; output includes the key ID and secret needed for backend.hcl
$GARAGE key create tofu
# Create the bucket that will hold Terraform state
$GARAGE bucket create terraform-state
# Grant the key read/write access to that bucket
$GARAGE bucket allow terraform-state --read --write --key tofu
