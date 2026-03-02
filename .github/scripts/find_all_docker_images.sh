#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="$1"

DOCKER_IMAGES=$(tree -J -d -L 1 "$WORKSPACE" | jq -c '[.[0].contents[].name]')
echo "docker_images=$DOCKER_IMAGES" >> "$GITHUB_OUTPUT"
