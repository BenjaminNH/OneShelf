#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <apk-directory>" >&2
  exit 1
fi

apk_dir="$1"
sdk_root="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}"

if [ -z "$sdk_root" ]; then
  echo "ANDROID_SDK_ROOT or ANDROID_HOME must be set." >&2
  exit 1
fi

mapfile -t apks < <(find "$apk_dir" -maxdepth 1 -type f -name '*.apk' | sort)
if [ "${#apks[@]}" -eq 0 ]; then
  echo "No APKs found in ${apk_dir}" >&2
  exit 1
fi

mapfile -t apksigner_candidates < <(find "$sdk_root/build-tools" -type f -name apksigner | sort -V)
if [ "${#apksigner_candidates[@]}" -eq 0 ]; then
  echo "Unable to find apksigner under ${sdk_root}/build-tools" >&2
  exit 1
fi

apksigner_bin="${apksigner_candidates[-1]}"

for apk in "${apks[@]}"; do
  echo "Verifying ${apk}"
  output="$("$apksigner_bin" verify --print-certs "$apk" 2>&1)"
  printf '%s\n' "$output"

  if printf '%s\n' "$output" | grep -q 'CN=Android Debug'; then
    echo "Refusing APK signed with Android debug certificate: ${apk}" >&2
    exit 1
  fi

  if ! printf '%s\n' "$output" | grep -q 'Signer #1 certificate DN:'; then
    echo "Could not confirm signing certificate for ${apk}" >&2
    exit 1
  fi
done
