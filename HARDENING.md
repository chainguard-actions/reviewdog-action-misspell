<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-misspell/v1.29.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-misspell/v1.29.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile pipes remote shell scripts directly to `sh` without first downloading and verifying them. Line 14 fetches `install.sh` from a commit-pinned GitHub raw URL but still pipes it directly to `sh -s`. Line 15 fetches `install-misspell.sh` from the `master` branch (completely unpinned) and pipes it directly to `sh -s`. Both patterns allow a compromised or man-in-the-middle remote source to execute arbitrary code during the Docker image build. Scripts should be downloaded to a file first, verified (e.g. via checksum), and then executed separately.

Locations:

- `Dockerfile:14`
- `Dockerfile:15`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed both unsafe shell patterns in the Dockerfile (lines 14-15). Instead of piping remote scripts directly to `sh -s`, each script is now downloaded to a temporary file first (`/tmp/install-reviewdog.sh` and `/tmp/install-misspell.sh`), executed separately, then removed. The `--` shell option terminator was dropped from both invocations since it was the shell's own option terminator in the pipe form (`sh -s -- ARGS`) and is not needed (or wanted) when executing a file directly — keeping it would pass `--` as `$1` to the installer script, breaking argument parsing.

