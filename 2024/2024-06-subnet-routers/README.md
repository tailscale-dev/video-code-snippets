# Subnet Routers | Tailscale Explained

This readme accompanies our YouTube video about subnet routers.

[![Subnet Routers | Tailscale Explained](https://img.youtube.com/vi/UmVMaymH1-s/maxresdefault.jpg)](https://www.youtube.com/watch?v=UmVMaymH1-s)

## ACL snippet for autoApprovers

+ https://tailscale.com/kb/1337/acl-syntax#autoapprovers

Copy and paste the snippet below into your access controls file and modify accordingly to start making use of `autoApprovers`.

```
	"autoApprovers": {
		"routes": {
			"192.168.79.0/24": ["group:admin", "amelie@tailandscales.com", "tag:dev"],
		},
		"exitNode": ["tag:dev"],
	},
```
