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

### Prerequisites

The build script uses Docker's default buildx builder which already supports ARM64. If you're building on a non-ARM64 machine, QEMU emulation should be automatically handled by Docker Desktop.

If you encounter issues, you can manually set up QEMU:

```bash
# Set up QEMU for ARM64 emulation (if building on non-ARM64 machine)
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

### Using scripts (recommended)

1. Build the image:

```bash
./build.sh
```

If you encounter architecture-related errors, try building without cache first:

```bash
./build.sh --no-cache
```

The script automatically uses the default buildx builder which supports ARM64.

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

## Troubleshooting

If you encounter build errors, especially related to QEMU emulation, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for solutions.

## License

MIT License
