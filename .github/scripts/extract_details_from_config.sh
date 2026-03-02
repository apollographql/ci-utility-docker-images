#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="$1"

echo "platforms=$(yq '.platforms | join(",")' "$CONFIG_PATH")" >> "$GITHUB_OUTPUT"
echo "description=$(yq '.description' "$CONFIG_PATH")" >> "$GITHUB_OUTPUT"
