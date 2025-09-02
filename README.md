# HFS 3

## Run container
```bash
docker run \
  -d \
  -p 8080:8080 \
  -e HFS_CREATE_ADMIN=password123 \
  -e HFS_PORT=8080 \
  -v ./hfsconf:/home/hfs/.hfs \
  # -v ./myDisk:/app/myDisk \
  rejetto/hfs:latest
  # add any other volume with -v for every external drive you want to mount into the hfs container
```

## Environment Variables
This docker image doesn't have any specific env.

Every env starting with `HFS_` will be passed to HFS.
To change HFS configuration, use the envs starting with `HFS_` (read [How to modify configuration](https://github.com/rejetto/hfs/blob/main/config.md#how-to-modify-configuration) page to learn more about how envs work).

## Mounts
You can mount as many volumes as you wish in docker to persist the file storage, but keep in mind that if you want to persist HFS configurations as well you **must** mount a volume that points to the `cwd` of HFS (which you can override with `HFS_CWD` env).
The default hfs cwd of the container is `/home/hfs/.hfs`

## Docker compose example
Create a `docker-compose.yaml` using the following template.

We suggest to configure `network_mode` to `host` so HFS will be able to see real clients IP addresses, otherwise docker, by default, would use a natted bridge interface, masking clients IPs

```yaml
version: '3'

services:
  hfs:
    network_mode: host
    image: rejetto/hfs:latest
    volumes:
      - ./hfsconf:/home/hfs/.hfs # for hfs conf persistence
      # don't forget to share volumes for SSL certificates if you have any
    environment:
      - HFS_CREATE_ADMIN=password123 # will create the admin user with password "password123"
      # - HFS_PORT=1234 # example for changing http plain port. default is 80
    ports:
      - 8080:80 # if you change the env HFS_PORT, make sure to change it as well in the right hand side of this port mapping. this mapping exposes the host port 8080 and forwards traffic to the internal port 80 where HFS listens by default
```
