# HFS 3

## Run container
```bash
docker run \
  -d \
  -p 8080:8080 \
  -e HFS_CREATE_ADMIN=password123 \
  -e HFS_PORT=8080 \
  -v ./hfsconf:/app/ \
  -v ./myDisk:/app/myDisk \
  rejetto/hfs:0.53.0
```

## Environment Variables
This docker image doesn't have any specific env. Every env starting with `HFS_` will be passed to HFS.
Read [How to modify configuration](https://github.com/rejetto/hfs/blob/main/config.md#how-to-modify-configuration) page to learn more about how envs work.

## Mounts
You can mount as many volumes as you wish in docker to persist the file storage, but keep in mind that if you want to persist HFS configurations as well you **must** mount a volume that points to the `cwd` of HFS (which you can override with `HFS_CWD` env).
The default cwd of the container is `/app`

## Docker compose example
Create a `docker-compose.yaml` using the following template

```yaml
version: '3'

services:
  hfs:
    image: rejetto/hfs:0.53.0
    volumes:
      - ./hfsconf:/app/ # for hfs conf persistence
      - ./myDisk:/app/myDisk # for your files
      # don't forget to share volumes to access certificate files
    environment:
      - HFS_PORT=8080 # default is 80
      - HFS_CREATE_ADMIN=password123 # will create the admin user with password "password123" \
    ports:
      - 8080:8080
```
