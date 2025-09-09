#!/bin/bash
# Forgejo setup for remote LXC containers
# Usage: ./setup.sh <hostname> [--install-docker]
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_HOST="${1:?Error: Hostname required. Usage: ./setup.sh <hostname> [--install-docker]}"
INSTALL_DOCKER="${2:+1}"

# Verify SSH and required files
ssh -o ConnectTimeout=5 -o BatchMode=yes "root@$TARGET_HOST" exit || {
    echo "Error: Cannot SSH to root@$TARGET_HOST. Check hostname/IP, SSH access, and root permissions."
    exit 1
}

for f in compose.yaml .env serve.json; do
    [[ -f "$SCRIPT_DIR/$f" ]] || { echo "Error: Missing $f"; exit 1; }
done

# Remote setup and file deployment in one go
ssh "root@$TARGET_HOST" INSTALL_DOCKER="$INSTALL_DOCKER" bash << 'REMOTE_SCRIPT'
set -e

# Install Docker if needed
if ! command -v docker &> /dev/null; then
    [[ -n "$INSTALL_DOCKER" ]] || {
        echo "Error: Docker required. Run with --install-docker to auto-install"
        exit 1
    }
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com | sh || { echo "Docker installation failed"; exit 1; }
fi

# Setup system
systemctl disable --now ssh.service ssh.socket 2>/dev/null || true
id -u forgejo &>/dev/null || useradd -m -s /bin/bash forgejo
usermod -a -G docker forgejo
REMOTE_SCRIPT

# Deploy files
CONTAINER_DIR="/home/forgejo/containers/forgejo"
tar -C "$SCRIPT_DIR" -czf - compose.yaml .env serve.json 2>/dev/null | ssh "root@$TARGET_HOST" "
    mkdir -p '$CONTAINER_DIR/forgejo/tailscale/serve' &&
    tar -xzf - -C /tmp/ 2>/dev/null &&
    mv /tmp/{compose.yaml,.env} '$CONTAINER_DIR/' &&
    mv /tmp/serve.json '$CONTAINER_DIR/forgejo/tailscale/serve/' &&
    chown -R forgejo:forgejo /home/forgejo/containers"

cat << EOF

✓ Setup complete on $TARGET_HOST

Next:
→ SSH as forgejo@$TARGET_HOST
→ cd /home/forgejo/containers/forgejo
→ edit .env with your Tailscale authkey and hostname
→ ensure PUID and PGID in compose.yaml match 'id forgejo' output
→ docker compose up -d
EOF