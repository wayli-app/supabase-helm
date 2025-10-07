# Workflow Sequencing

This document explains how the GitHub Actions workflows are sequenced to ensure the release pipeline always runs after the version pipeline.

## Workflow Overview

The Helm chart release process consists of two main workflows that run in sequence:

1. **Automated Versioning** (`.github/workflows/version.yaml`)
2. **Release Charts** (`.github/workflows/release.yaml`)

## How the Sequencing Works

### 1. Version Workflow Trigger

**Trigger**: Runs on:
- Pull request merges to `main`
- Direct pushes to `main` (excluding documentation changes)

**What it does**:
- Analyzes commit messages and PR labels
- Determines version bump type (major/minor/patch)
- Updates `charts/supabase/Chart.yaml` version
- **Creates and pushes Git tag** (e.g., `v0.7.4`)
- Creates GitHub release

### 2. Release Workflow Trigger

**Trigger**: Runs on:
- **Tag pushes** (e.g., `v0.7.4`) ← **This ensures sequencing!**
- Manual workflow dispatch (for emergency releases)

**What it does**:
- Packages the Helm chart
- Pushes chart to GitHub Container Registry (GHCR)
- Updates GitHub Pages with chart index

## Why This Ensures Proper Sequencing

### Before the Fix
- Both workflows were triggered by file changes
- They could run independently or in the wrong order
- Release workflow might run before version workflow completed
- Charts could be published with wrong versions

### After the Fix
- **Version workflow runs first** and creates a Git tag
- **Release workflow is triggered by the tag creation**
- **Guaranteed sequence**: Version → Tag → Release
- Charts are always published with the correct version

## Workflow Flow Diagram

```
Commit to main
       ↓
Version Workflow
       ↓
Creates Git tag (v0.7.4)
       ↓
Tag push triggers Release Workflow
       ↓
Chart packaged and published to GHCR
       ↓
GitHub Pages updated
```

## Example Timeline

1. **Developer pushes commit** to main branch
2. **Version workflow starts** (within ~1 minute)
3. **Version workflow completes**:
   - Chart.yaml updated to 0.7.4
   - Git tag `v0.7.4` created and pushed
4. **Release workflow starts** (triggered by tag push)
5. **Release workflow completes**:
   - Chart packaged as `supabase-0.7.4.tgz`
   - Chart pushed to `ghcr.io/wayli-app/charts/supabase:0.7.4`
   - GitHub Pages index updated

## Benefits of This Approach

✅ **Guaranteed Sequencing**: Release always runs after version
✅ **Version Consistency**: Charts are always published with correct version
✅ **No Race Conditions**: Workflows cannot run out of order
✅ **Manual Override**: Can manually trigger releases if needed
✅ **Audit Trail**: Clear sequence of events in GitHub Actions

## Manual Release Process

If you need to manually release a chart:

1. Go to Actions → Release Charts
2. Click "Run workflow"
3. Enter the version (e.g., `0.7.4`)
4. Click "Run workflow"

This bypasses the version workflow and directly triggers the release process.

## Troubleshooting

### Release Workflow Not Running
- Check if the version workflow created a tag
- Verify the tag format is `v*` (e.g., `v0.7.4`)
- Check if the tag was pushed to the remote repository

### Version Workflow Not Running
- Check if the commit affects the right paths
- Verify the commit is to the main branch
- Check workflow permissions and secrets

### Workflows Running Out of Order
- This should no longer happen with the tag-based triggers
- If it does, check the workflow trigger configurations
