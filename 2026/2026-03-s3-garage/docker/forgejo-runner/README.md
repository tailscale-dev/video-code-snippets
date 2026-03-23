# forgejo-runner

Forgejo Actions runner using a Tailscale sidecar for network access.

## First-time registration

Register the runner non-interactively, generating the config and registering in one step:

```sh
docker compose -f /root/compose.yaml run --rm --entrypoint /bin/sh runner -c \
  '/bin/forgejo-runner generate-config > /data/config.yml && \
   /bin/forgejo-runner register \
     --instance https://<forgejo-hostname> \
     --token <registration-token> \
     --name <runner-name> \
     --no-interactive'
```

The registration token can be found in Forgejo under **Site Administration → Runners** (global) or **Repository Settings → Actions → Runners** (repo-scoped).

The generated config sets `docker_host: "automount"` by default, which auto-detects and mounts `/var/run/docker.sock` from the runner container into each job container. The compose file bind-mounts the host socket into the runner at `/var/run/docker.sock` for this to work.

## Start the daemon

```sh
docker compose -f ~/compose.yaml up -d
```
