# Self-Hosted Release Build

This repository keeps the existing hosted GitHub Actions release workflow and adds a separate self-hosted path for manual release builds.

## Goals

- Keep the current hosted workflow unchanged.
- Use one dedicated self-hosted runner only for release builds.
- Refuse to build if `android/key.properties` or the release keystore is missing.
- Refuse APKs signed by the Android debug certificate.

## Local toolchain on the runner host

Run:

```bash
cd /home/dev/workspace/oneshelf-runner
chmod +x scripts/*.sh
./scripts/setup-self-hosted-env.sh
```

This installs the toolchain under the `dev` user:

- Java 17 in `~/apps/java-current`
- Flutter 3.41.4 in `~/apps/flutter`
- Android SDK in `~/Android/Sdk`
- Android build tools, platform tools, platform 36, and NDK `28.2.13676358`

Environment variables are written to:

```bash
~/.config/oneshelf-runner/env.sh
```

## Configure the GitHub Actions runner

Create a repository runner token in GitHub, then run:

```bash
cd /home/dev/workspace/oneshelf-runner
./scripts/setup-github-runner.sh \
  https://github.com/<owner>/<repo> \
  <runner-token> \
  <runner-name> \
  release-self-hosted
```

Then start the runner:

```bash
cd ~/actions-runner-oneshelf-release
./run.sh
```

## Required release signing files

These must exist on the runner host before the self-hosted workflow is triggered:

- `android/key.properties`
- the keystore file referenced by `storeFile`

The self-hosted workflow fails before building if either is missing.

## Workflow

Use the new workflow:

- `Build Release APK (Self-Hosted)`

It expects:

- a tag such as `v0.3.0`
- a runner with label `release-self-hosted`

## Rollback

Rollback is simple:

- stop the self-hosted runner
- remove the repository runner in GitHub
- delete `~/actions-runner-oneshelf-release`
- delete the local toolchain directories if you no longer want them
- keep using `.github/workflows/release.yml`
