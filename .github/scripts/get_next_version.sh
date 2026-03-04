
#!/usr/bin/env bash
set -euo pipefail

IMAGE_DIR="$1"
PREFIX="${IMAGE_DIR}/v"

# Find the latest clean semver tag for this image
LATEST_TAG=$(git tag -l "${PREFIX}*" --sort=-v:refname \
  | grep -E "^${PREFIX}[0-9]+\.[0-9]+\.[0-9]+$" \
  | head -1 || true)

if [ -z "$LATEST_TAG" ]; then
  echo "No existing tags found for ${IMAGE_DIR}, defaulting to 0.1.0"
  echo "current_version=0.0.0" >> "$GITHUB_OUTPUT"
  echo "current_tag=" >> "$GITHUB_OUTPUT"
  echo "next_version=0.1.0" >> "$GITHUB_OUTPUT"
else
  CURRENT_VERSION="${LATEST_TAG#"$PREFIX"}"
  echo "current_version=$CURRENT_VERSION" >> "$GITHUB_OUTPUT"
  echo "current_tag=$LATEST_TAG" >> "$GITHUB_OUTPUT"

  IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"
  NEXT_PATCH=$((PATCH + 1))
  echo "next_version=${MAJOR}.${MINOR}.${NEXT_PATCH}" >> "$GITHUB_OUTPUT"
fi
