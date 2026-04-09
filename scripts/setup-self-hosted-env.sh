#!/usr/bin/env bash

set -euo pipefail

JDK_VERSION="17.0.18+8"
JDK_ARCHIVE="OpenJDK17U-jdk_x64_linux_hotspot_17.0.18_8.tar.gz"
JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.18%2B8/${JDK_ARCHIVE}"
FLUTTER_VERSION="3.41.4"
FLUTTER_ARCHIVE="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${FLUTTER_ARCHIVE}"
ANDROID_CMDLINE_TOOLS_VERSION="14742923"
ANDROID_CMDLINE_TOOLS_ZIP="commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip"
ANDROID_CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/${ANDROID_CMDLINE_TOOLS_ZIP}"
ANDROID_PLATFORM="android-36"
ANDROID_EXTRA_PLATFORMS=("android-35" "android-34")
ANDROID_BUILD_TOOLS="36.0.0"
ANDROID_EXTRA_BUILD_TOOLS=("35.0.0")
ANDROID_CMAKE_VERSION="3.22.1"
ANDROID_NDK="28.2.13676358"

HOME_DIR="${HOME}"
APPS_DIR="${HOME_DIR}/apps"
DOWNLOADS_DIR="${HOME_DIR}/downloads"
ANDROID_SDK_ROOT="${HOME_DIR}/Android/Sdk"
ENV_FILE="${HOME_DIR}/.config/oneshelf-runner/env.sh"
JDK_DIR="${APPS_DIR}/jdk-${JDK_VERSION}"
FLUTTER_DIR="${APPS_DIR}/flutter"

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

ensure_line() {
  local file="$1"
  local line="$2"

  touch "$file"
  if ! grep -Fqx "$line" "$file"; then
    printf "%s\n" "$line" >>"$file"
  fi
}

download_if_missing() {
  local url="$1"
  local output="$2"

  if [ ! -f "$output" ]; then
    curl -fL "$url" -o "$output"
  fi
}

need_cmd curl
need_cmd tar
need_cmd unzip
need_cmd python3

mkdir -p "$APPS_DIR" "$DOWNLOADS_DIR" "$ANDROID_SDK_ROOT/cmdline-tools" "$(dirname "$ENV_FILE")"

if [ ! -d "$JDK_DIR" ]; then
  download_if_missing "$JDK_URL" "${DOWNLOADS_DIR}/${JDK_ARCHIVE}"
  tar -xzf "${DOWNLOADS_DIR}/${JDK_ARCHIVE}" -C "$APPS_DIR"
fi
ln -sfn "$JDK_DIR" "${APPS_DIR}/java-current"

if [ ! -d "$FLUTTER_DIR" ]; then
  download_if_missing "$FLUTTER_URL" "${DOWNLOADS_DIR}/${FLUTTER_ARCHIVE}"
  tar -xJf "${DOWNLOADS_DIR}/${FLUTTER_ARCHIVE}" -C "$APPS_DIR"
fi

if [ ! -d "${ANDROID_SDK_ROOT}/cmdline-tools/latest" ]; then
  download_if_missing "$ANDROID_CMDLINE_TOOLS_URL" "${DOWNLOADS_DIR}/${ANDROID_CMDLINE_TOOLS_ZIP}"
  rm -rf "${ANDROID_SDK_ROOT}/cmdline-tools/latest.tmp"
  mkdir -p "${ANDROID_SDK_ROOT}/cmdline-tools/latest.tmp"
  unzip -q -o "${DOWNLOADS_DIR}/${ANDROID_CMDLINE_TOOLS_ZIP}" -d "${ANDROID_SDK_ROOT}/cmdline-tools/latest.tmp"
  rm -rf "${ANDROID_SDK_ROOT}/cmdline-tools/latest"
  mv "${ANDROID_SDK_ROOT}/cmdline-tools/latest.tmp/cmdline-tools" "${ANDROID_SDK_ROOT}/cmdline-tools/latest"
  rmdir "${ANDROID_SDK_ROOT}/cmdline-tools/latest.tmp" || true
fi

cat >"$ENV_FILE" <<'EOF'
export JAVA_HOME="$HOME/apps/java-current"
export FLUTTER_HOME="$HOME/apps/flutter"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$JAVA_HOME/bin:$FLUTTER_HOME/bin:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH"
EOF

ensure_line "${HOME_DIR}/.bashrc" '[ -f "$HOME/.config/oneshelf-runner/env.sh" ] && . "$HOME/.config/oneshelf-runner/env.sh"'
ensure_line "${HOME_DIR}/.profile" '[ -f "$HOME/.config/oneshelf-runner/env.sh" ] && . "$HOME/.config/oneshelf-runner/env.sh"'

# shellcheck source=/dev/null
. "$ENV_FILE"

set +o pipefail
yes | sdkmanager --licenses >/tmp/oneshelf-sdk-licenses.log
set -o pipefail
sdkmanager \
  "platform-tools" \
  "platforms;${ANDROID_PLATFORM}" \
  "build-tools;${ANDROID_BUILD_TOOLS}" \
  "cmake;${ANDROID_CMAKE_VERSION}" \
  "ndk;${ANDROID_NDK}" \
  >/tmp/oneshelf-sdk-install.log

for platform in "${ANDROID_EXTRA_PLATFORMS[@]}"; do
  sdkmanager "platforms;${platform}" >>/tmp/oneshelf-sdk-install.log
done

for build_tools in "${ANDROID_EXTRA_BUILD_TOOLS[@]}"; do
  sdkmanager "build-tools;${build_tools}" >>/tmp/oneshelf-sdk-install.log
done

flutter config --no-analytics >/tmp/oneshelf-flutter-config.log
flutter precache --android >/tmp/oneshelf-flutter-precache.log
flutter doctor -v
