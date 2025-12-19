#!/bin/bash
set -e

IMAGE_NAME="volinc/postgis-arm64"
TAG="18-3.6-alpine"
FULL_TAG="${IMAGE_NAME}:${TAG}"
GHCR_TAG="ghcr.io/${IMAGE_NAME}:${TAG}"

echo "Setting up Docker Buildx..."

# Use default builder which already supports ARM64
echo "Using default builder (supports ARM64)..."
docker buildx use default

# Clean up problematic multiarch builder if it exists
if docker buildx ls | grep -q "multiarch"; then
    echo "Removing problematic multiarch builder..."
    docker buildx rm multiarch 2>/dev/null || true
fi

echo "Building Docker image for ARM64..."

# Check if --no-cache flag is provided
NO_CACHE=""
if [[ "$1" == "--no-cache" ]]; then
    NO_CACHE="--no-cache"
    echo "Building without cache (clearing problematic cached layers)..."
    docker builder prune -f > /dev/null 2>&1 || true
fi

docker buildx build --platform linux/arm64 \
  -t "${FULL_TAG}" \
  -t "${GHCR_TAG}" \
  --load \
  --progress=plain \
  ${NO_CACHE} \
  .

echo ""
echo "Build completed successfully!"
echo ""
echo "To push to GitHub Container Registry, run:"
echo "  docker push ${GHCR_TAG}"
echo ""
echo "Or use the push.sh script:"
echo "  ./push.sh"

