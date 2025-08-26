# Helm Release Workflow

This document explains how the Helm chart release workflow works and what was fixed to ensure charts are properly pushed to the registry on patch releases.

## Overview

The Helm chart release process consists of two main workflows:

1. **Automated Versioning** (`.github/workflows/version.yaml`)
2. **Release Charts** (`.github/workflows/release.yaml`)

## How It Works

### 1. Automated Versioning Workflow

**Trigger**: Runs on:
- Pull request merges to `main`
- Direct pushes to `main` (excluding documentation changes)

**What it does**:
- Analyzes commit messages and PR labels to determine version bump type
- Updates `charts/supabase/Chart.yaml` version
- Updates `CHANGELOG.md` with new version entry
- Creates Git tag (e.g., `v0.7.3`)
- Creates GitHub release

**Version Bump Logic**:
- **Major**: PR labeled with "major" or contains breaking changes
- **Minor**: PR labeled with "minor" or contains feature commits (`feat:`)
- **Patch**: PR labeled with "patch" or contains bug fixes (`fix:`, `docs:`, etc.)

### 2. Release Charts Workflow

**Trigger**: Runs on:
- Changes to `charts/**`
- Changes to `.github/workflows/release.yaml`
- Changes to `CHANGELOG.md`

**What it does**:
- Uses `helm/chart-releaser-action` to package the chart
- Pushes chart to GitHub Container Registry (GHCR)
- Updates GitHub Pages with chart index

## What Was Fixed

### Issue 1: Version Mismatch
- **Problem**: Local repository was out of sync with remote tags
- **Solution**: Synced local repository with remote changes

### Issue 2: Workflow Trigger Mismatch
- **Problem**: Version workflow used `[skip ci]` flag, preventing release workflow from running
- **Solution**: Removed `[skip ci]` flag from version bump commits

### Issue 3: Missing Changelog Structure
- **Problem**: `CHANGELOG.md` was missing `[Unreleased]` section required by version workflow
- **Solution**: Added proper changelog structure with `[Unreleased]` section

### Issue 4: Workflow Paths
- **Problem**: Release workflow didn't trigger on changelog updates
- **Solution**: Added `CHANGELOG.md` to release workflow trigger paths

## Current Status

- ✅ Chart version: `0.7.2`
- ✅ Workflows properly configured
- ✅ Changelog structure fixed
- ✅ Chart packaging verified locally

## Testing the Workflow

To test that the fix works:

1. Make a small change to trigger a patch release
2. The version workflow should:
   - Bump version to `0.7.3`
   - Update changelog
   - Create tag `v0.7.3`
3. The release workflow should:
   - Package the chart
   - Push to GHCR
   - Update GitHub Pages

## Troubleshooting

### Chart Not Being Pushed

1. Check if version workflow ran successfully
2. Verify Chart.yaml version was updated
3. Check if release workflow was triggered
4. Look for errors in chart-releaser action
5. Verify GHCR permissions

### Version Not Bumping

1. Check commit message format
2. Verify PR labels (if applicable)
3. Check workflow permissions
4. Review workflow logs for errors

## Manual Chart Release

If needed, you can manually release a chart:

```bash
# Package the chart
cd charts/supabase
helm package . --destination ../../.cr-release-packages/

# Push to GHCR (requires login)
helm push .cr-release-packages/supabase-*.tgz oci://ghcr.io/wayli-app/charts
```

## Future Improvements

- Add chart testing before release
- Implement semantic release based on conventional commits
- Add release notes generation from changelog
- Implement rollback mechanism for failed releases
