# PostGIS ARM64 Docker Image

Docker image for PostGIS on ARM64 architecture, based on the official `postgis/postgis:18-3.6-alpine` image.

## Description

This image provides PostgreSQL 18 with PostGIS 3.6 extension on Alpine Linux, optimized for ARM64 architecture.

## Usage

### Running the container

```bash
docker run --name postgis \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRES_DB=gis \
  -p 5432:5432 \
  ghcr.io/volinc/postgis-arm64:18-3.6-alpine
```

### Connecting to the database

```bash
docker exec -it postgis psql -U postgres -d gis
```

### Verifying PostGIS

```sql
SELECT PostGIS_Version();
```

## Building the image

### Using scripts (recommended)

1. Build the image:

```bash
./build.sh
```

2. Publish to GitHub Container Registry:

First, log in to GitHub Container Registry:

```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin
```

Then publish:

```bash
./push.sh
```

### Manual build

#### Local build for ARM64

```bash
docker buildx build --platform linux/arm64 \
  -t volinc/postgis-arm64:18-3.6-alpine \
  --load .
```

#### Build and publish to GitHub Container Registry

1. Log in to GitHub Container Registry:

```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin
```

2. Build and publish the image:

```bash
docker buildx build --platform linux/arm64 \
  -t ghcr.io/volinc/postgis-arm64:18-3.6-alpine \
  --push .
```

### Automatic build via GitHub Actions

When pushing to the `main` branch or creating a tag, the image is automatically built and published to GitHub Container Registry via GitHub Actions.

## Tags

- `18-3.6-alpine` - PostgreSQL 18, PostGIS 3.6, Alpine Linux

## Compatibility

This image is fully compatible with the official `postgis/postgis:18-3.6-alpine` image and can be used as a replacement for ARM64 platforms.

## License

MIT License
