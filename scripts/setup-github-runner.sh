#!/usr/bin/env bash

set -euo pipefail

RUNNER_VERSION="2.333.1"
RUNNER_ARCHIVE="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
RUNNER_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_ARCHIVE}"
RUNNER_DIR="${HOME}/actions-runner-oneshelf-release"
DEFAULT_LABELS="release-self-hosted"
DEFAULT_RUNNER_NAME="$(hostname)-oneshelf-release"
REPO_URL="${1:-}"
RUNNER_TOKEN="${2:-}"
RUNNER_NAME="${3:-$DEFAULT_RUNNER_NAME}"
RUNNER_LABELS="${4:-$DEFAULT_LABELS}"

if [ -z "$REPO_URL" ] || [ -z "$RUNNER_TOKEN" ]; then
  cat >&2 <<'EOF'
Usage:
  scripts/setup-github-runner.sh <repo-url> <runner-token> [runner-name] [labels]

Example:
  scripts/setup-github-runner.sh \
    https://github.com/<owner>/<repo> \
    <runner-token> \
    oneshelf-release \
    release-self-hosted
EOF
  exit 1
fi

mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"

if [ ! -f "./config.sh" ]; then
  archive_path="${HOME}/downloads/${RUNNER_ARCHIVE}"
  if [ ! -f "$archive_path" ]; then
    curl -fL "$RUNNER_URL" -o "$archive_path"
  fi
  tar -xzf "$archive_path"
fi

./config.sh \
  --url "$REPO_URL" \
  --token "$RUNNER_TOKEN" \
  --name "$RUNNER_NAME" \
  --labels "$RUNNER_LABELS" \
  --runnergroup Default \
  --unattended \
  --replace

cat <<EOF
Runner configured in: $RUNNER_DIR

Start it manually:
  cd $RUNNER_DIR
  ./run.sh

Remove it later:
  cd $RUNNER_DIR
  ./config.sh remove --token <remove-token>
EOF
