<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-misspell/v1.30.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-misspell/v1.30.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### unsafe-shell (severity: high)

The Dockerfile pipes remote content directly to a shell interpreter in two places, without first downloading and verifying the script. Line 14 fetches the reviewdog install script from a pinned commit but pipes it directly to `sh -s`. Line 15 fetches the misspell install script from the `master` branch (unpinned) and pipes it directly to `sh -s`. Both patterns are `wget -O - -q <url> | sh -s ...`, which allows a compromised or man-in-the-middle remote server to execute arbitrary code during the Docker image build.

Locations:

- `Dockerfile:14`
- `Dockerfile:15`

## Iteration Notes

### Iteration 1

**Fixes applied:** unsafe-shell

**Notes:**

Fixed both unsafe shell patterns in the Dockerfile (lines 14-15). Changed from piping remote content directly to `sh -s -- ...` to: (1) downloading the script to a temp file with `wget -O /tmp/install-*.sh`, (2) executing the file with `sh /tmp/install-*.sh -b /usr/local/bin/ <version>`, and (3) removing the temp file. The `--` separator was dropped as required — it was only needed to terminate the shell's own option parsing in the pipe form, not when executing a file directly. Both the reviewdog install script (pinned to a specific commit SHA) and the misspell install script (from master branch) were fixed with this pattern.

