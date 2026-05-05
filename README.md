# Go (Golang) Docker Images - Bullseye Only

This repository contains Dockerfiles for building Go (Golang) Docker images based on Debian Bullseye.

## Overview

This is a simplified fork of the [docker-library/golang](https://github.com/docker-library/golang) repository, customized to:
- Generate only Debian Bullseye-based images
- Support publishing to custom registries via GitHub Actions
- Maintain a streamlined codebase focused on a single variant

## Features

- **Single Variant**: Only generates Bullseye-based images
- **Custom Registry Publishing**: Built-in GitHub Actions workflow for publishing to own registry
- **Automated Updates**: Scripts to automatically update Go versions from upstream
- **Multi-Architecture Support**: Supports all architectures that Go provides binaries for

## Usage

### Updating Go Versions and Generating Dockerfiles

This will generate proper Dockerfile files according to what's configured in `versions.json`

> **macOS prerequisite**: the scripts require `gawk` and (for `tip` updates) GNU `date`:
> ```bash
> brew install gawk coreutils
> ```

```bash
# Update versions.json from upstream and generate all Dockerfiles
./update.sh

# Update and generate for specific version(s)
./update.sh 1.25
./update.sh 1.24 1.25
```

### Testing Images Locally

```bash
# Test all versions locally
./test-local.sh

# Test specific version
./test-local.sh 1.25
./test-local.sh 1.24 1.25
```

This script builds the images locally and runs the same tests as the CI workflow (go version, go env, compilation, etc.) without pushing to any registry.

### Publishing Images

Configure GitHub Secrets:
- `DOCKERHUB_TOKEN` - Registry password/token

Images are built, tested and published to Docker Hub as `mattermost/golang-bullseye`

- **Push to `main`**: Builds and publishes the `tip` version (e.g., `mattermost/golang-bullseye:tip`)
- **Push tag `vX.Y.Z`**: Builds and publishes that version (e.g., tag `v1.24.10` → `mattermost/golang-bullseye:1.24.10`)

The tag must match a `version` field in `versions.json` (e.g., `v1.24.10` requires existing `"1.24": { "version": "1.24.10", ... }`).

## Attribution

This repository is based on the work from [docker-library/golang](https://github.com/docker-library/golang), which is maintained by the Docker Community. The original repository is part of the [Docker Official Images](https://github.com/docker-library/official-images) program.

Significant modifications:
- Removed support for Alpine, Windows, and other Debian variants
- Added custom registry publishing functionality
- Simplified codebase to support only Bullseye variant

## License

See [LICENSE](LICENSE) file for details.
