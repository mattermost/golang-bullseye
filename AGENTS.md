# Agent guidance

## Adding or updating a Go version

Use the provided scripts — do not edit `versions.json` or Dockerfiles by hand.

### Prerequisites (macOS)

`apply-templates.sh` requires `gawk`, and `tip` updates require GNU `date`:

```bash
brew install gawk coreutils
```

Linux environments have these by default.

### Steps

```bash
# 1. Update versions.json and regenerate Dockerfiles for the target version(s)
./update.sh 1.26
./update.sh 1.26 tip   # include tip if refreshing it at the same time

# 2. Verify the generated files look correct
git diff
```

`./update.sh` fetches the latest release for each major version from `https://golang.org/dl/?mode=json`, updates `versions.json`, and regenerates the Dockerfiles via `apply-templates.sh`.

To add a brand-new major version (e.g., 1.26 for the first time), pass its major version string and the script will pick up the latest patch release automatically.

## Branch, commit, and PR conventions

- **Branch name**: `update-go-X.Y.Z` (e.g., `update-go-1.26.2`)
- **Commit/PR title**: `go X.Y.Z update` (lowercase, no period)
- **PR body**:

```
#### Summary
<one sentence describing what changed>

#### Ticket Link
https://mattermost.atlassian.net/browse/MM-XXXXX
```

Create PRs as **draft** by default.

## What the scripts do

| Script | Purpose |
|--------|---------|
| `versions.sh` | Fetches release metadata from go.dev and writes `versions.json` |
| `apply-templates.sh` | Reads `versions.json` and renders `Dockerfile-linux.template` into each `<version>/bullseye/Dockerfile` |
| `update.sh` | Runs both in sequence |
| `test-local.sh` | Builds images locally and runs smoke tests without pushing |
