#!/usr/bin/env bash
set -euo pipefail

# Reads the latest <image-dir>/v<MAJOR>.<MINOR>.<PATCH> git tag and prints a
# JSON object to stdout with current_version, current_tag, and next_version
# (patch-incremented). Defaults to 0.1.0 when no prior tag exists.
#
# Usage: get_next_version.sh <image-dir>

IMAGE_DIR="$1"
PREFIX="${IMAGE_DIR}/v"

LATEST_TAG=$(git tag -l "${PREFIX}*" --sort=-v:refname \
  | grep -E "^${PREFIX}[0-9]+\.[0-9]+\.[0-9]+$" \
  | head -1 || true)

if [ -z "$LATEST_TAG" ]; then
  CURRENT_VERSION="0.0.0"
  CURRENT_TAG=""
  NEXT_VERSION="0.1.0"
else
  CURRENT_VERSION="${LATEST_TAG#"$PREFIX"}"
  CURRENT_TAG="$LATEST_TAG"
  IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"
  NEXT_VERSION="${MAJOR}.${MINOR}.$((PATCH + 1))"
fi

jq -nc \
  --arg current_version "$CURRENT_VERSION" \
  --arg current_tag "$CURRENT_TAG" \
  --arg next_version "$NEXT_VERSION" \
  '{current_version: $current_version, current_tag: $current_tag, next_version: $next_version}'