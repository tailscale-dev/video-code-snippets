#!/bin/bash

# Exit on any error
set -e

# Must run as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

# Create required directories
echo "Creating directories..."
mkdir -p /var/lib/tsidp

# Set directory permissions
echo "Setting permissions..."
chown root:root /var/lib/tsidp
chmod 700 /var/lib/tsidp

# Create environment file with secure permissions
echo "Creating environment file..."
touch /etc/default/tsidp
chown root:root /etc/default/tsidp
chmod 600 /etc/default/tsidp

# Create the environment file content
cat > /etc/default/tsidp << EOF
HOME=.
TS_HOSTNAME=tsidp
TS_AUTHKEY=tskey-auth-k1234
TS_STATE_DIR=/var/lib/tsidp
TS_USERSPACE=false
TAILSCALE_USE_WIP_CODE=1
EOF

# Create systemd service file
echo "Creating systemd service..."
cat > /etc/systemd/system/tsidp.service << EOF
[Unit]
Description=TSIDP Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
WorkingDirectory=/usr/local
EnvironmentFile=/etc/default/tsidp
ExecStart=/usr/local/bin/tsidp
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "Setup complete! Don't forget to:"
echo "1. Copy your binary to /usr/local/bin/tsidp"
echo "2. Run: systemctl daemon-reload"
echo "3. Run: systemctl enable --now tsidp.service"
