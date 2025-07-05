# Commit Message Standards

This document explains the commit message standards and enforcement for the Supabase Helm Chart project.

## Overview

We enforce conventional commit messages to ensure:
- **Automated Versioning**: Proper version bumps based on commit types
- **Consistency**: All contributors follow the same format
- **Readability**: Clear, descriptive commit messages
- **Automation**: Reliable changelog generation and releases

## Commit Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Examples

```bash
# Feature addition
git commit -m "feat: add support for OAuth providers"

# Bug fix with scope
git commit -m "fix(auth): resolve JWT token validation issue"

# Documentation update
git commit -m "docs: update installation guide"

# Breaking change
git commit -m "feat: redesign authentication API

BREAKING CHANGE: The authentication API has been completely rewritten.
All existing integrations will need to be updated."

# Revert a commit
git commit -m "revert: feat: add experimental feature"
```

## Commit Types

| Type | Description | Version Bump | Example |
|------|-------------|--------------|---------|
| `feat` | New features | Minor (0.X.0) | `feat: add new service` |
| `fix` | Bug fixes | Patch (0.0.X) | `fix: resolve connection issue` |
| `docs` | Documentation | Patch (0.0.X) | `docs: update README` |
| `style` | Code style | Patch (0.0.X) | `style: fix formatting` |
| `refactor` | Code refactoring | Patch (0.0.X) | `refactor: improve error handling` |
| `test` | Tests | Patch (0.0.X) | `test: add unit tests` |
| `chore` | Maintenance | Patch (0.0.X) | `chore: update dependencies` |
| `perf` | Performance | Patch (0.0.X) | `perf: optimize database queries` |
| `ci` | CI/CD | Patch (0.0.X) | `ci: add security scanning` |
| `build` | Build system | Patch (0.0.X) | `build: update Docker images` |
| `revert` | Revert commits | None | `revert: feat: experimental feature` |
| `wip` | Work in progress | None | `wip: draft implementation` |

## Scopes

Scopes help categorize changes by component or service:

### Supabase Services
- `auth` - Authentication service
- `db` - Database service
- `storage` - Storage service
- `realtime` - Realtime service
- `rest` - REST API service
- `kong` - API Gateway
- `studio` - Studio interface
- `functions` - Edge functions
- `analytics` - Analytics service
- `vector` - Vector search
- `imgproxy` - Image processing
- `meta` - Metadata service
- `supavisor` - Connection pooling

### Chart Components
- `chart` - Chart configuration
- `templates` - Kubernetes templates
- `values` - Values files
- `docs` - Documentation
- `ci` - CI/CD configuration
- `deps` - Dependencies
- `release` - Release process
- `security` - Security updates
- `test` - Testing
- `lint` - Linting and formatting

### Examples with Scopes

```bash
git commit -m "feat(auth): add OAuth provider support"
git commit -m "fix(db): resolve connection pool issue"
git commit -m "docs(chart): update configuration guide"
git commit -m "ci(security): add vulnerability scanning"
```

## Breaking Changes

Breaking changes must be indicated with `BREAKING CHANGE:` in the commit body or footer:

```bash
git commit -m "feat: redesign API structure

BREAKING CHANGE: The API endpoints have been completely redesigned.
All existing integrations will need to be updated to use the new structure."
```

## Enforcement

### Local Enforcement (Husky)

We use Husky to enforce commit messages locally:

```bash
# Install dependencies
npm install

# Husky will automatically install git hooks
# Now all commits will be validated locally
```

### CI Enforcement (GitHub Actions)

The GitHub Actions workflow validates commit messages on pull requests:

- Checks all commits in the PR
- Fails the build if any commit doesn't follow the standard
- Provides detailed error messages for fixes

### Manual Validation

You can manually validate commit messages:

```bash
# Validate a specific commit
npx commitlint --from HEAD~1 --to HEAD

# Validate a range of commits
npx commitlint --from abc123 --to def456

# Validate a specific commit message
echo "feat: add new feature" | npx commitlint
```

## Common Mistakes

### ❌ Bad Commit Messages

```bash
# Too vague
git commit -m "fix stuff"

# No type
git commit -m "update configuration"

# Wrong case
git commit -m "Fix: resolve issue"

# Too long subject
git commit -m "feat: add comprehensive authentication system with multiple providers and advanced security features"

# No description
git commit -m "feat:"
```

### ✅ Good Commit Messages

```bash
# Clear and specific
git commit -m "fix(auth): resolve JWT token validation issue"

# Proper scope
git commit -m "feat(storage): add S3-compatible backend support"

# Concise but descriptive
git commit -m "feat: add OAuth provider support"

# Breaking change properly indicated
git commit -m "feat: redesign API structure

BREAKING CHANGE: API endpoints have been redesigned"
```

## Troubleshooting

### Commit Message Rejected

If your commit message is rejected:

1. **Check the error message** - It will tell you what's wrong
2. **Use the correct type** - See the commit types table above
3. **Add a scope if needed** - Use one of the defined scopes
4. **Keep it concise** - Subject should be under 72 characters
5. **Use lowercase** - Both type and subject should be lowercase

### Common Error Messages

```
⧗   input: fix stuff
✖   subject may not be empty [subject-empty]
✖   type may not be empty [type-empty]
```

**Fix**: `fix: resolve authentication issue`

```
⧗   input: feat: Add new feature
✖   type must be lower-case [type-case]
✖   subject must be lower-case [subject-case]
```

**Fix**: `feat: add new feature`

```
⧗   input: feat: add new feature.
✖   subject may not end with full stop [subject-full-stop]
```

**Fix**: `feat: add new feature`

## Best Practices

### 1. Be Specific
- Describe what changed, not just that something changed
- Include the component or service affected

### 2. Use Imperative Mood
- Write as if you're giving a command
- "add feature" not "added feature"

### 3. Keep It Short
- Subject line under 72 characters
- Use body for detailed explanations

### 4. Reference Issues
- Link to GitHub issues when relevant
- Use `Closes #123` or `Fixes #456` in footer

### 5. Test Your Messages
- Use `npx commitlint` to validate before committing
- Check the CI output for any issues

## Migration Guide

If you're migrating from non-conventional commits:

1. **Install dependencies**: `npm install`
2. **Learn the format**: Review this document
3. **Practice**: Use the examples above
4. **Validate**: Test your commit messages locally
5. **Update workflow**: Use conventional commits in all new commits

## Support

For questions about commit messages:
- Check this documentation
- Review the [Conventional Commits specification](https://www.conventionalcommits.org/)
- Look at existing commits in the repository
- Ask in GitHub Discussions