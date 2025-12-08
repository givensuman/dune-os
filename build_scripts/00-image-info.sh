#!/usr/bin/bash

echo "::group:: ===$(basename "$0")==="

set -eoux pipefail

echo "Image Information:"
docker image inspect "$BASE_IMAGE_NAME:$IMAGE_TAG"

echo "::endgroup::"
