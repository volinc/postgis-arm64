# Quick Start

## Local build

```bash
./build.sh
```

## Publishing to GitHub Container Registry

1. Get a GitHub Personal Access Token with `write:packages` permissions
2. Log in to GitHub Container Registry:

```bash
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin
```

3. Publish the image:

```bash
./push.sh
```

## Using the image

```bash
docker run --name postgis \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRES_DB=gis \
  -p 5432:5432 \
  ghcr.io/volinc/postgis-arm64:18-3.6-alpine
```

## Verification

```bash
docker exec -it postgis psql -U postgres -d gis -c "SELECT PostGIS_Version();"
```
