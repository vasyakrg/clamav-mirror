# ClamAV-Mirror

This is a Docker Image for a lightweight containerized ClamAV Mirror using [CVD-Update](https://github.com/Cisco-Talos/cvdupdate) and [Caddy](https://github.com/caddyserver/caddy). This image uses Alpine to minimize the image size and unnecessary bloat.

## Dependencies

- Docker

## Quick Start Guide

Run the following commands to build and run the clamav-mirror Docker image locally.

### Build

```sh
docker build . --file Dockerfile --tag clamav-mirror:latest
```

### Run (Ephemeral)

```sh
docker compose up -d
```

### Manual update ClamAV Database definitions

```sh
docker exec -it clamav-mirror ./entrypoint.sh update
```

### Cron

Docker update automate and run always one day, but you may change it in .env file

## ClamAV Configuration

Once you have the mirror running, you can visit <http://localhost:8080> to see what files are hosted by this server. You can then point any of your ClamAV instances to use this mirror instead by changing the following in your `freshclam.conf` file:

```txt
DatabaseMirror http://localhost:8080
```

##### Author
- **Vassiliy Yegorov** [vasyakrg](https://github.com/vasyakrg)
- [site](https://realmanual.ru)
- [youtube](https://youtube.com/realmanual)
- [telegram](https://t.me/realmanual_group)
