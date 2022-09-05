# Factorio Server in Docker

Runs a minimal [Factorio](https://www.factorio.com/) server in Docker.

## Features

* Built on [Distroless](https://github.com/GoogleContainerTools/distroless)
containers for portability
* Uses a non-root user for security
* Only runs `factorio` in the container
* Simple `Dockerfile` and `docker-compose.yml` files
* One step deployment that creates a valid server on localhost
* Stores Factorio data and configs in a Docker volume

## Configuration

You should replace the `map-gen-settings.json`, `map-settings.json`, and
`server-settings.json` in the [settings directory](settings) with your own,
otherwise a default railworld server on LAN will be created.

## Build and Deploy

Building the container and deploying the service is simple.

### Build

```sh
docker build . --tag factorio-docker
docker swarm init || true  # this only needs to be run once
```

### Deploy

```sh
docker stack deploy -c docker-compose.yml factorio-docker
```
