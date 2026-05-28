#!/usr/bin/env bash
set -euo pipefail

# Builds the matrix JSON consumed by the build/scan/release jobs and prints it
# to stdout.
#
# Usage:
#   ./build_image_matrix.sh <--all | json-array> [--tags=<mode>]
#
# Input forms for the first argument:
#   --all              every top-level dir containing a config.yml
#   '["dir1","dir2"]'  explicit JSON array of dir names
#
# --tags controls per-image tag fields in each matrix entry. Default: none.
#   none       only image, description, platforms
#   versioned  also ghcr_tag (next patch), git_tag (<image>/v<next>), current_tag
#   daily      also ghcr_tag (<current_version>-<UTC datetime>)

INPUT="${1:-}"
TAGS_MODE="none"
if [ "${2:-}" = "--tags=versioned" ]; then TAGS_MODE="versioned"; fi
if [ "${2:-}" = "--tags=daily" ]; then TAGS_MODE="daily"; fi

if [ "$INPUT" = "--all" ]; then
  IMAGE_DIRS=$(find . -maxdepth 1 -mindepth 1 -type d -name '[^.]*' \
    -exec test -f '{}/config.yml' \; -print \
    | sed 's|^\./||' \
    | jq -Rsc '[split("\n")[] | select(. != "")]')
else
  IMAGE_DIRS=$(echo "$INPUT" | jq -c '[.[] | select(startswith(".") | not)]')
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DATETIME=$(date -u +'%Y%m%d%H%M')

MATRIX='[]'
for dir in $(echo "$IMAGE_DIRS" | jq -r '.[]'); do
  CONFIG="$dir/config.yml"
  if [ ! -f "$CONFIG" ]; then
    echo "Skipping $dir: no config.yml" >&2
    continue
  fi
  DESCRIPTION=$(yq '.description' "$CONFIG")
  PLATFORMS=$(yq -o=json -I=0 '.platforms' "$CONFIG")
  ENTRY=$(jq -nc \
    --arg image "$dir" \
    --arg description "$DESCRIPTION" \
    --arg platforms "$PLATFORMS" \
    '{image: $image, description: $description, platforms: $platforms}')

  case "$TAGS_MODE" in
    versioned)
      VERSION_INFO=$("$SCRIPT_DIR/get_next_version.sh" "$dir")
      NEXT=$(echo "$VERSION_INFO" | jq -r '.next_version')
      CURRENT_TAG=$(echo "$VERSION_INFO" | jq -r '.current_tag')
      ENTRY=$(echo "$ENTRY" | jq -c \
        --arg ghcr_tag "$NEXT" \
        --arg git_tag "${dir}/v${NEXT}" \
        --arg current_tag "$CURRENT_TAG" \
        '. + {ghcr_tag: $ghcr_tag, git_tag: $git_tag, current_tag: $current_tag}')
      ;;
    daily)
      VERSION_INFO=$("$SCRIPT_DIR/get_next_version.sh" "$dir")
      CURRENT=$(echo "$VERSION_INFO" | jq -r '.current_version')
      ENTRY=$(echo "$ENTRY" | jq -c \
        --arg ghcr_tag "${CURRENT}-${DATETIME}" \
        '. + {ghcr_tag: $ghcr_tag}')
      ;;
  esac

  MATRIX=$(echo "$MATRIX" | jq -c --argjson entry "$ENTRY" '. += [$entry]')
done

echo "$MATRIX"