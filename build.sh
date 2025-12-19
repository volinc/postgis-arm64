#!/bin/bash
set -e

IMAGE_NAME="volinc/postgis-arm64"
TAG="18-3.6-alpine"
FULL_TAG="${IMAGE_NAME}:${TAG}"
GHCR_TAG="ghcr.io/${IMAGE_NAME}:${TAG}"

echo "Building Docker image for ARM64..."
docker buildx build --platform linux/arm64 \
  -t "${FULL_TAG}" \
  -t "${GHCR_TAG}" \
  --load \
  .

echo ""
echo "Build completed successfully!"
echo ""
echo "To push to GitHub Container Registry, run:"
echo "  docker push ${GHCR_TAG}"
echo ""
echo "Or use the push.sh script:"
echo "  ./push.sh"

