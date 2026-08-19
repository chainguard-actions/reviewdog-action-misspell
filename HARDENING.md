<!-- markdownlint-disable -->

# Hardening Report: reviewdog--action-misspell/v1.27.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **reviewdog--action-misspell/v1.27.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### missing-permissions (severity: medium)

Workflow file has no top-level `permissions:` key and no job-level `permissions:` keys on any job. Without explicit permissions, the GITHUB_TOKEN is granted its default (potentially broad) permissions. All jobs in this workflow lack permission scoping.

Locations:

- `.github/workflows/depup.yml:1`
- `.github/workflows/dockerimage.yml:1`
- `.github/workflows/release.yml:1`
- `.github/workflows/reviewdog.yml:1`
- `.github/workflows/update_semver.yml:1`

## Iteration Notes

### Iteration 1

**Fixes applied:** missing-permissions

**Notes:**

Added top-level `permissions:` blocks to all five workflow files with minimal required permissions:
- depup.yml: `contents: write, pull-requests: write` (creates PRs via peter-evans/create-pull-request)
- dockerimage.yml: `contents: read` (only checks out code and builds a Docker image)
- release.yml: `contents: write, pull-requests: write` (creates releases/tags and posts PR comments via action-bumpr)
- reviewdog.yml: `contents: read, pull-requests: write` (checks out code and posts reviewdog review comments on PRs)
- update_semver.yml: `contents: write` (updates semver git tags)

