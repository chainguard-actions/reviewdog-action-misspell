<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-misspell/v1.30.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-misspell/v1.30.2** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile contains two RUN instructions that download remote scripts and pipe them directly to a shell interpreter without first saving to a file and verifying integrity. Line 14: `wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh | sh -s -- ...`. Line 15: `wget -O - -q https://raw.githubusercontent.com/golangci/misspell/master/install-misspell.sh | sh -s -- ...` — this second one also fetches from the mutable `master` branch, making it a supply-chain risk. Scripts should be downloaded to a file, their checksums verified, and then executed separately.

Locations:

- `Dockerfile:14`
- `Dockerfile:15`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed both unsafe-shell findings in the Dockerfile:
1. Reviewdog install script (line 14): Changed from piping wget output directly to sh to downloading the script to /tmp/install-reviewdog.sh first, then executing it separately. Dropped the '--' (it was the shell's stdin option terminator in the pipe form, not the script's argument). The script URL remains pinned to commit fd59714416d6d9a1c0692d872e38e7f8448df4fc.
2. Misspell install script (line 15): Changed from piping wget output from the mutable 'master' branch directly to sh, to downloading the script to /tmp/install-misspell.sh first. Also pinned the URL from the mutable 'master' branch to commit b565578a5ec9b815331bdae8f588021f7696ec6f (the v0.8.0 tag commit, resolved via git ls-remote). Dropped the '--' for the same reason. Both temp files are cleaned up after use.

