# Changelog

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

## [$NEW_VERSION] - $TODAY

$COMMITS

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
## [0.7.10] - 2025-08-26

### What Changed
- Automated version bump (patch): Direct push contains patch-level commits

### Recent Changes
- test: Trigger version workflow to test tag-based release workflow trigger
- test: Trigger version workflow to test tag-based release workflow trigger
- chore: bump version to 0.7.9
- fix: Remove conflicting path filters from release workflow and add debugging to tag creation
- docs: Add workflow sequencing documentation explaining the tag-based trigger system

### Breaking Changes
- None

### Migration Guide
- No migration required

---

## [0.7.9] - 2025-08-26

### What Changed
- Automated version bump (patch): Direct push contains patch-level commits

### Recent Changes
- fix: Remove conflicting path filters from release workflow and add debugging to tag creation
- docs: Add workflow sequencing documentation explaining the tag-based trigger system
- docs: Restore workflow documentation files after rebase
- docs: Add workflow sequencing documentation explaining the tag-based trigger system
- chore: bump version to 0.7.8

### Breaking Changes
- None

### Migration Guide
- No migration required

---

## [0.7.8] - 2025-08-26

### What Changed
- Automated version bump (patch): Direct push contains patch-level commits

### Recent Changes
- fix: Ensure release pipeline always runs after version pipeline by using tag-based triggers
- chore: bump version to 0.7.7
- fix: Improve security context helper functions to filter invalid fields and prevent deployment errors
- chore: bump version to 0.7.6
- fix: Improve manual chart-releaser step with better error handling and download method

### Breaking Changes
- None

### Migration Guide
- No migration required

---

## [0.7.7] - 2025-08-26

### What Changed
- Automated version bump (patch): Direct push contains patch-level commits

### Recent Changes
- fix: Improve security context helper functions to filter invalid fields and prevent deployment errors
- chore: bump version to 0.7.6
- fix: Improve manual chart-releaser step with better error handling and download method
- test: Trigger version workflow to create proper release
- chore: bump version to 0.7.5

### Breaking Changes
- None

### Migration Guide
- No migration required

---

## [0.7.6] - 2025-08-26

### What Changed
- Automated version bump (patch): Direct push contains patch-level commits

### Recent Changes
- fix: Improve manual chart-releaser step with better error handling and download method
- test: Trigger version workflow to create proper release
- chore: bump version to 0.7.5
- fix: Add manual chart-releaser fallback and improve debugging
- chore: bump version to 0.7.4

### Breaking Changes
- None

### Migration Guide
- No migration required

---

## [0.7.5] - 2025-08-26

### What Changed
- Automated version bump (patch): Direct push contains patch-level commits

### Recent Changes
- fix: Add manual chart-releaser fallback and improve debugging
- chore: bump version to 0.7.4
- fix: Simplify chart-releaser configuration and add fallback packaging
- docs: Add Helm release workflow documentation
- chore: bump version to 0.7.3

### Breaking Changes
- None

### Migration Guide
- No migration required

---

## [0.7.4] - 2025-08-26

### What Changed
- Automated version bump (patch): Direct push contains patch-level commits

### Recent Changes
- fix: Simplify chart-releaser configuration and add fallback packaging
- docs: Add Helm release workflow documentation
- chore: bump version to 0.7.3
- fix: Update workflows and changelog to ensure Helm chart is pushed to registry on patch releases
- chore: bump version to 0.7.2 [skip ci]

### Breaking Changes
- None

### Migration Guide
- No migration required

---

## [0.7.3] - 2025-08-26

### What Changed
- Automated version bump (patch): Direct push contains patch-level commits

### Recent Changes
- fix: Update workflows and changelog to ensure Helm chart is pushed to registry on patch releases
- chore: bump version to 0.7.2 [skip ci]
- chore: bump version to 0.7.1 [skip ci]
- fix: Allow adding init containers to the postgres db.
- chore: bump version to 0.7.0 [skip ci]

### Breaking Changes
- None

### Migration Guide
- No migration required

---


### Added
- Automated version bumping and release workflow
- GitHub Container Registry (GHCR) integration for Helm charts

---

## [0.7.2] - 2025-08-26

### What Changed
- Automated version bump (patch): Default patch bump for direct push

### Recent Changes
- chore: bump version to 0.7.2 [skip ci]

### Breaking Changes
- None

### Migration Guide
- No migration required

---

## [0.7.1] - 2025-08-26

### What Changed
- Automated version bump (patch): Default patch bump for direct push

### Recent Changes
- chore: bump version to 0.7.1 [skip ci]

### Breaking Changes
- None

### Migration Guide
- No migration required

---

## [0.7.0] - 2025-08-26

### What Changed
- Automated version bump (patch): Default patch bump for direct push

### Recent Changes
- chore: bump version to 0.7.0 [skip ci]

### Breaking Changes
- None

### Migration Guide
- No migration required

---

## [0.1.0] - 2025-01-XX

### Added
- Initial release of Supabase Helm Chart
- PostgreSQL database
- Studio web-based management interface
- Kong API Gateway for routing and authentication
- Auth service for authentication and authorization
- REST API service for database operations
- Realtime service for subscriptions and broadcasting
- Storage service for file management
- Imgproxy for image processing and optimization
- Meta service for metadata and schema management
- Functions service for edge functions
- Analytics service for monitoring
- Vector service for search and similarity
- Comprehensive documentation and examples
- GitHub Actions for CI/CD
- Chart testing and linting
- Automated releases with chart-releaser

### Configuration
- Global Supabase configuration
- Service-specific resource limits and requests
- Persistence configuration for stateful services
- Secret management for sensitive data
- Ingress configuration for external access
- Service account and RBAC configuration

### Documentation
- Detailed README with installation instructions
- Configuration reference for all services
- Troubleshooting guide
- Contributing guidelines
- Security policy

---

## Version History

- **0.1.0**: Initial release with complete Supabase stack

## Migration Guide

### From 0.1.0 to future versions

No migration required for the initial release.

## Support

- **0.1.x**: Supported
- **0.0.x**: Not supported (pre-release)

## Release Notes

Each release includes:
- New features and improvements
- Bug fixes and security updates
- Breaking changes (if any)
- Migration instructions
- Configuration changes

For detailed information about each release, see the [GitHub releases page](https://github.com/wayli-app/supabase-helm/releases).
