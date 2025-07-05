# Automated Versioning System

This document explains how the automated versioning system works in the Supabase Helm Chart project.

## Overview

The project uses a sophisticated automated versioning system that:
- Analyzes commit messages to determine version bumps
- Supports manual overrides via PR labels
- Automatically creates releases and updates the Helm repository
- Maintains a comprehensive changelog

## How It Works

### 1. Commit-Based Versioning

The system analyzes commit messages using [Conventional Commits](https://www.conventionalcommits.org/) specification:

| Commit Type | Version Bump | Example |
|-------------|--------------|---------|
| `feat:` | Minor (0.X.0) | `feat: add new authentication service` |
| `fix:` | Patch (0.0.X) | `fix: resolve database connection issue` |
| `docs:` | Patch (0.0.X) | `docs: update installation instructions` |
| `style:` | Patch (0.0.X) | `style: fix code formatting` |
| `refactor:` | Patch (0.0.X) | `refactor: improve error handling` |
| `test:` | Patch (0.0.X) | `test: add unit tests for auth service` |
| `chore:` | Patch (0.0.X) | `chore: update dependencies` |
| `BREAKING CHANGE:` | Major (X.0.0) | See breaking changes section |

### 2. PR Label Override

You can override the automatic versioning by adding labels to your pull request:

| Label | Version Bump | Use Case |
|-------|--------------|----------|
| `major` | Major (X.0.0) | Breaking changes, major rewrites |
| `minor` | Minor (0.X.0) | New features, enhancements |
| `patch` | Patch (0.0.X) | Bug fixes, documentation, refactoring |

### 3. Automatic Release Process

When a PR is merged or changes are pushed to main:

1. **Version Analysis**: System determines the appropriate version bump
2. **Chart Update**: Updates `Chart.yaml` with new version
3. **Changelog Update**: Adds entry to `CHANGELOG.md`
4. **Git Tag**: Creates version tag (e.g., `v1.2.3`)
5. **GitHub Release**: Publishes release with notes
6. **Helm Repository**: Updates the Helm chart repository

## Workflow Files

### `.github/workflows/version.yaml`
Main versioning workflow that:
- Triggers on PR merge or direct push to main
- Analyzes commits and PR labels
- Updates version and changelog
- Creates releases and tags

### `.github/workflows/test-versioning.yaml`
Test workflow for validating the versioning system:
- Can be run manually via GitHub Actions
- Tests version calculation logic
- Validates changelog and release note generation
- Does not create actual releases

## Configuration

### `.github/version-config.yaml`
Configuration file that defines:
- Commit types and their version bump types
- PR labels and their overrides
- Default bump type
- Files that trigger versioning
- Changelog and release templates

## Manual Version Control

For cases where you need manual control, use the manual version script:

```bash
# Show current version
./scripts/manual-version.sh show

# Bump versions
./scripts/manual-version.sh patch
./scripts/manual-version.sh minor
./scripts/manual-version.sh major

# Set specific version
./scripts/manual-version.sh set 1.2.3

# Create git tag
./scripts/manual-version.sh tag
```

## Breaking Changes

To indicate a breaking change, use one of these methods:

### 1. Commit Message
```bash
git commit -m "feat: completely rewrite authentication API

BREAKING CHANGE: The authentication API has been completely rewritten.
All existing integrations will need to be updated."
```

### 2. PR Label
Add the `major` label to your pull request.

### 3. Manual Override
Use the manual version script:
```bash
./scripts/manual-version.sh major
```

## Examples

### Example 1: Feature Addition
```bash
git commit -m "feat: add support for OAuth providers"
git push origin feature/oauth-support
# Create PR with 'minor' label (optional)
```

**Result**: Minor version bump (0.X.0)

### Example 2: Bug Fix
```bash
git commit -m "fix: resolve database connection timeout"
git push origin fix/db-timeout
```

**Result**: Patch version bump (0.0.X)

### Example 3: Breaking Change
```bash
git commit -m "feat: redesign user management API

BREAKING CHANGE: User management endpoints have been completely redesigned.
All existing API calls will need to be updated."
```

**Result**: Major version bump (X.0.0)

### Example 4: Documentation Update
```bash
git commit -m "docs: update installation guide"
git push origin docs/installation
```

**Result**: Patch version bump (0.0.X)

## Best Practices

### 1. Use Conventional Commits
Always use conventional commit format:
```bash
git commit -m "type: description"
```

### 2. Be Specific with Commit Messages
Good:
```bash
git commit -m "feat: add JWT token validation"
```

Bad:
```bash
git commit -m "add stuff"
```

### 3. Use PR Labels for Override
When you need to override automatic versioning:
- Add `major` label for breaking changes
- Add `minor` label for new features
- Add `patch` label for bug fixes

### 4. Test Versioning
Use the test workflow to validate versioning logic:
1. Go to Actions → Test Versioning
2. Select bump type
3. Run workflow
4. Review results

## Troubleshooting

### Version Not Bumping
- Check commit message format
- Verify PR labels (if applicable)
- Ensure changes are in trigger files
- Check workflow logs for errors

### Wrong Version Bump
- Use PR labels to override automatic detection
- Use manual version script for precise control
- Check commit message for breaking change indicators

### Release Not Created
- Verify GitHub token permissions
- Check workflow logs for errors
- Ensure main branch protection allows workflow runs

## Migration from Manual Versioning

If you're migrating from manual versioning:

1. **Update commit messages**: Use conventional commit format
2. **Add PR labels**: Use labels to control version bumps
3. **Test the system**: Use the test workflow
4. **Monitor releases**: Verify automatic releases are created correctly

## Support

For issues with the versioning system:
- Check workflow logs in GitHub Actions
- Review this documentation
- Create an issue with the `versioning` label
- Use the test workflow to validate logic