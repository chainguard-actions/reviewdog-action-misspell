<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-misspell/v1.28.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-misspell/v1.28.0** was hardened automatically. 3 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### missing-permissions (severity: medium)

Workflow file 'depup.yml' has no top-level 'permissions:' key and neither of its jobs ('reviewdog', 'misspell') defines job-level permissions. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad.

Locations:

- `.github/workflows/depup.yml:1`

### missing-permissions (severity: medium)

Workflow file 'dockerimage.yml' has no top-level 'permissions:' key and its only job ('build') defines no job-level permissions. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad.

Locations:

- `.github/workflows/dockerimage.yml:1`

### missing-permissions (severity: medium)

Workflow file 'reviewdog.yml' has no top-level 'permissions:' key and its only job ('misspell') defines no job-level permissions. Without explicit permissions, the workflow inherits the repository's default token permissions, which may be overly broad.

Locations:

- `.github/workflows/reviewdog.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** missing-permissions

**Notes:**

Added top-level 'permissions:' blocks to all three workflow files with minimal required permissions:
- depup.yml: `contents: write, pull-requests: write` (needed to create PRs with commits)
- dockerimage.yml: `contents: read` (only checks out code and builds Docker image locally)
- reviewdog.yml: `contents: read, pull-requests: write` (checks out code and posts reviewdog comments on PRs)

### Iteration 2

**Fixes applied:** unsafe-shell

**Notes:**

Fixed both unsafe pipe-to-shell patterns in the Dockerfile:

1. Line 14 (reviewdog install.sh): Changed from `wget -O - -q ... | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}` to downloading the script to `/tmp/reviewdog-install.sh` first, then executing `sh /tmp/reviewdog-install.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION}`, then removing the temp file.

2. Line 15 (misspell install-misspell.sh): Changed from `wget -O - -q ... | sh -s -- -b /usr/local/bin/ "${MISSPELL_VERSION}"` to downloading the script to `/tmp/misspell-install.sh` first, then executing `sh /tmp/misspell-install.sh -b /usr/local/bin/ "${MISSPELL_VERSION}"`, then removing the temp file.

In both cases, the `--` was dropped because it was the shell's own option terminator (used with `-s` to separate shell options from positional arguments when reading from stdin). Once the script is run from a file rather than piped via stdin, `-s` and `--` are no longer applicable — keeping `--` would pass it as `$1` to the downloaded installer script, breaking it.

Note: The misspell script is still fetched from the unpinned `master` branch (as in the original), which is a separate concern from the pipe-to-shell pattern fixed here.

