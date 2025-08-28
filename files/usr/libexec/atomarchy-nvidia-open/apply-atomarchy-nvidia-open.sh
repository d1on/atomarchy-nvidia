#!/usr/bin/env bash
# Apply Omarchy configs to an existing user (run as root)
set -euo pipefail

TARGET_USER="${1:-$SUDO_USER}"
if [[ -z "${TARGET_USER:-}" ]]; then
  echo "Usage: sudo $0 <username>"
  exit 1
fi

TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
if [[ -z "$TARGET_HOME" || ! -d "$TARGET_HOME" ]]; then
  echo "Could not resolve home for user: $TARGET_USER"
  exit 2
fi

echo "[atomarchy-nvidia-open] Applying Omarchy configs to $TARGET_USER at $TARGET_HOME"
install -d "$TARGET_HOME/.config"
# copy but don't overwrite existing user configs
cp -an /etc/skel/.config/. "$TARGET_HOME/.config/" || true
chown -R "$TARGET_USER":"$TARGET_USER" "$TARGET_HOME/.config"

echo "[atomarchy-nvidia-open] Done."
