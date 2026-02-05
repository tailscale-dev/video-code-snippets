

## Static IP (Ubuntu 24.04)

Find your network interface name (e.g. `enp6s18`, `eth0`):

```bash
ip a
```

Edit netplan (replace the interface name as needed):

```bash
sudo nano /etc/netplan/01-static.yaml
```

```yaml
network:
  version: 2
  ethernets:
    enp6s18:
      dhcp4: no
      addresses: [192.168.1.53/24]
      routes:
        - to: default
          via: 192.168.1.1
```

Apply:

```bash
sudo chmod 600 /etc/netplan/*.yaml
sudo netplan apply
```

### If you see two IPv4 addresses

Another netplan file is still enabling DHCP.

```bash
ls /etc/netplan
sudo mv /etc/netplan/00-installer-config.yaml \
        /etc/netplan/00-installer-config.yaml.bak
sudo netplan apply
```

Verify:

```bash
ip -4 addr show enp6s18
```

And finally, reboot to make sure the static IP sticks.