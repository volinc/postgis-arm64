#!/bin/bash
set -e

IMAGE_NAME="volinc/postgis-arm64"
TAG="18-3.6-alpine"
GHCR_TAG="ghcr.io/${IMAGE_NAME}:${TAG}"

echo "Pushing Docker image to GitHub Container Registry..."
echo "Image: ${GHCR_TAG}"
echo ""

# Check if user is logged in to GHCR
if ! docker info | grep -q "ghcr.io"; then
    echo "Please login to GitHub Container Registry first:"
    echo "  echo \$GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin"
    exit 1
fi

docker push "${GHCR_TAG}"

echo ""
echo "Image pushed successfully!"
echo "You can now use: docker pull ${GHCR_TAG}"

