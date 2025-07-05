# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of Supabase Helm Chart
- Complete Supabase stack deployment
- All core services (Database, Auth, Storage, Realtime, etc.)
- Comprehensive configuration options
- Production-ready resource limits and health checks
- Proper secret management and RBAC support

### Changed
- N/A

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- N/A

### Security
- N/A

## [0.1.0] - 2025-01-XX

### Added
- Initial release of Supabase Helm Chart
- PostgreSQL database with connection pooling via Supavisor
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