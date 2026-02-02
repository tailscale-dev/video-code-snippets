# Use cloud-init manually

Always refer to [this KB doc](https://tailscale.com/kb/1293/cloud-init) first, it is more actively maintained than this repo.

## Using an auth key

Inject this code snippet to use an auth key to automatically add a node to your tailnet.

If using Digitalocean as per the video accompanying this guide, look under "advanced options" and check the "Add Initialization scripts (free)" option. Paste the snippet below into the text box. For more information on using Digitalocean systems with cloud-init specifically, refer to their [documentation](https://docs.digitalocean.com/products/droplets/how-to/automate-setup-with-cloud-init/).

```
#cloud-config
# The above header must generally appear on the first line of a cloud config
# file, but all other lines that begin with a # are optional comments.

runcmd:
  # One-command install, from https://tailscale.com/download/
  - ['sh', '-c', 'curl -fsSL https://tailscale.com/install.sh | sh']
  # Set sysctl settings for IP forwarding (useful when configuring an exit node)
  - ['sh', '-c', "echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf && echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf && sudo sysctl -p /etc/sysctl.d/99-tailscale.conf" ]
  # Generate an auth key from your Admin console
  # https://login.tailscale.com/admin/settings/keys
  # and replace the placeholder below
  - ['tailscale', 'up', '--authkey=tskey-auth-123-nguVY4quaJeBrjTwNwZGPeXDvgR8LJ3i']
  # (Optional) Include this line to make this node available over Tailscale SSH
  - ['tailscale', 'set', '--ssh']
  # (Optional) Include this line to configure this machine as an exit node
  - ['tailscale', 'set', '--advertise-exit-node']
```

## Using an OAuth token

```
#cloud-config
# The above header must generally appear on the first line of a cloud config
# file, but all other lines that begin with a # are optional comments.

runcmd:
  # One-command install, from https://tailscale.com/download/
  - ['sh', '-c', 'curl -fsSL https://tailscale.com/install.sh | sh']
  # Set sysctl settings for IP forwarding (useful when configuring an exit node)
  - ['sh', '-c', "echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf && echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf && sudo sysctl -p /etc/sysctl.d/99-tailscale.conf" ]
  # Generate an auth key from your Admin console
  # https://login.tailscale.com/admin/settings/keys
  # and replace the placeholder below
  - ['tailscale', 'up', '--authkey=tskey-client-exampletoken-VwbYz8VrewLt5UXjT9Lf2M39ydgaAzD92', '--advertise-tags=tag:dev']
  # (Optional) Include this line to make this node available over Tailscale SSH
  - ['tailscale', 'set', '--ssh']
  # (Optional) Include this line to configure this machine as an exit node
  - ['tailscale', 'set', '--advertise-exit-node']
```