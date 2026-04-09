#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${GITHUB_WORKSPACE:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
KEY_PROPERTIES="${ROOT_DIR}/android/key.properties"

required_cmds=(java flutter)
for cmd in "${required_cmds[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd" >&2
    exit 1
  fi
done

if [ -z "${ANDROID_SDK_ROOT:-}" ] && [ -z "${ANDROID_HOME:-}" ]; then
  echo "ANDROID_SDK_ROOT or ANDROID_HOME must be set." >&2
  exit 1
fi

if [ ! -f "$KEY_PROPERTIES" ]; then
  cat >&2 <<'EOF'
Missing android/key.properties.
Refusing to build a release APK because the Gradle config would otherwise fall back to debug signing.
EOF
  exit 1
fi

property() {
  local key="$1"
  awk -F= -v key="$key" '
    $1 == key {
      sub(/^[[:space:]]+/, "", $2)
      sub(/[[:space:]]+$/, "", $2)
      print $2
      exit
    }
  ' "$KEY_PROPERTIES"
}

store_file="$(property storeFile)"
store_password="$(property storePassword)"
key_alias="$(property keyAlias)"
key_password="$(property keyPassword)"

for pair in \
  "storeFile:$store_file" \
  "storePassword:$store_password" \
  "keyAlias:$key_alias" \
  "keyPassword:$key_password"; do
  key="${pair%%:*}"
  value="${pair#*:}"
  if [ -z "$value" ]; then
    echo "Missing ${key} in android/key.properties" >&2
    exit 1
  fi
done

if [[ "$store_file" = /* ]]; then
  keystore_path="$store_file"
else
  keystore_path="${ROOT_DIR}/android/${store_file}"
fi

if [ ! -f "$keystore_path" ]; then
  echo "Keystore file not found: ${keystore_path}" >&2
  exit 1
fi

echo "Release signing prerequisites look complete."
echo "Keystore: ${keystore_path}"
