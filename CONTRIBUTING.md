# Contributing to Supabase Helm Chart

Thank you for your interest in contributing to the Supabase Helm Chart! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Release Process](#release-process)
- [Style Guides](#style-guides)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

- Use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md)
- Search existing issues to avoid duplicates
- Include detailed information about your environment
- Provide logs and error messages

### Suggesting Enhancements

- Use the [feature request template](.github/ISSUE_TEMPLATE/feature_request.md)
- Describe the problem you're trying to solve
- Explain why this enhancement would be useful
- Consider the impact on existing functionality

### Pull Requests

- Fork the repository
- Create a feature branch
- Make your changes
- Add tests if applicable
- Update documentation
- Submit a pull request

## Development Setup

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [chart-testing](https://github.com/helm/chart-testing)

### Local Development

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/wayli-app/supabase-helm.git
   cd supabase-helm
   ```

2. **Set up pre-commit hooks**
   ```bash
   # Install pre-commit hooks for commit message validation
   ./scripts/setup-commitlint.sh
   ```

3. **Set up a local Kubernetes cluster**
   ```bash
   kind create cluster --name supabase-test
   ```

4. **Install dependencies**
   ```bash
   # Install chart-testing
   pip install yamale yamllint pytest

   # Install additional tools (optional)
   pip install pre-commit
   ```

5. **Run tests**
   ```bash
   ct lint
   ct install
   ```

## Making Changes

### Chart Structure

```
charts/supabase/
├── Chart.yaml          # Chart metadata
├── values.yaml         # Default values
├── README.md           # Chart documentation
└── templates/          # Kubernetes manifests
    ├── _helpers.tpl    # Template helpers
    ├── serviceaccount.yaml
    ├── configmap.yaml
    ├── secret.yaml
    ├── deployment.yaml
    ├── service.yaml
    └── ingress.yaml
```

### Adding New Services

1. **Create service templates**
   - Add deployment, service, and serviceaccount templates
   - Follow existing naming conventions
   - Include proper labels and annotations

2. **Update values.yaml**
   - Add configuration options for the new service
   - Include resource limits and requests
   - Add persistence configuration if needed

3. **Update documentation**
   - Add service description to README.md
   - Document all configuration options
   - Include usage examples

### Configuration Guidelines

- Use consistent indentation (2 spaces)
- Group related configuration options
- Provide sensible defaults
- Include comments for complex options
- Follow Helm best practices

## Testing

### Running Tests

```bash
# Lint charts
ct lint

# Test chart installation
ct install

# Test with specific values
ct install --config ct.yaml --values values.example.yml
```

### Test Configuration

Create a `ct.yaml` file for chart-testing configuration:

```yaml
helm-extra-args: --timeout 600s
chart-dirs:
  - charts
chart-repos:
  - name: stable
    url: https://charts.helm.sh/stable
```

### Manual Testing

1. **Install the chart**
   ```bash
   helm install test-supabase ./charts/supabase -f values.example.yml
   ```

2. **Verify installation**
   ```bash
   kubectl get pods -l app.kubernetes.io/instance=test-supabase
   ```

3. **Test functionality**
   ```bash
   # Test database connection
   kubectl port-forward svc/test-supabase-postgres 5432:5432

   # Test Studio access
   kubectl port-forward svc/test-supabase-studio 3000:3000
   ```

4. **Clean up**
   ```bash
   helm uninstall test-supabase
   ```

## Submitting Changes

### Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow the style guides
   - Add tests if applicable
   - Update documentation

3. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new feature description"
   ```

4. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **Create a pull request**
   - Use the pull request template
   - Describe your changes clearly
   - Link related issues

### Commit Message Format

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification and **enforce it automatically** using pre-commit hooks.

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### Commit Types
- `feat`: New feature (triggers minor version bump)
- `fix`: Bug fix (triggers patch version bump)
- `docs`: Documentation changes (triggers patch version bump)
- `style`: Code style changes (triggers patch version bump)
- `refactor`: Code refactoring (triggers patch version bump)
- `test`: Adding or updating tests (triggers patch version bump)
- `chore`: Maintenance tasks (triggers patch version bump)
- `perf`: Performance improvements (triggers patch version bump)
- `ci`: CI/CD changes (triggers patch version bump)
- `build`: Build system changes (triggers patch version bump)
- `revert`: Revert previous commits
- `wip`: Work in progress (for draft PRs)

#### Scopes
Use scopes to categorize changes:
- **Supabase Services**: `auth`, `db`, `storage`, `realtime`, `rest`, `kong`, `studio`, `functions`, `analytics`, `vector`, `imgproxy`, `meta`
- **Chart Components**: `chart`, `templates`, `values`, `docs`, `ci`, `deps`, `release`, `security`, `test`, `lint`

**Breaking Changes**: Use `BREAKING CHANGE:` in the commit body or footer to trigger a major version bump.

**For detailed commit message guidelines, see [docs/COMMIT_MESSAGES.md](docs/COMMIT_MESSAGES.md).**

#### Pre-commit Hooks

This project uses pre-commit hooks to automatically validate:
- Conventional commit message format
- YAML syntax validation
- Helm chart linting
- Markdown formatting
- Shell script linting
- Secret detection
- Spell checking

**Setup**: Run `./scripts/setup-commitlint.sh` to install pre-commit hooks.

### Versioning and Releases

This project uses **manual versioning** for releases:

#### How It Works

1. **Version is tracked in Chart.yaml**: The `version` field in `charts/supabase/Chart.yaml` is the single source of truth
2. **Manual version bumps**: Contributors or maintainers manually update the version before release
3. **Manual release trigger**: Releases are triggered manually via GitHub Actions workflow
4. **Auto-generated release notes**: GitHub automatically generates release notes from commits

#### Versioning Guidelines

We follow [Semantic Versioning](https://semver.org/) (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking changes that require user action
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes and minor improvements (backward compatible)

#### When to Bump Versions

- **Patch** (`0.0.X`): Bug fixes, documentation updates, dependency updates
- **Minor** (`0.X.0`): New features, new services, non-breaking enhancements
- **Major** (`X.0.0`): Breaking changes, major rewrites, incompatible API changes

#### Examples

```bash
# Bug fix - bump patch version
# Change 0.0.8 → 0.0.9
git commit -m "fix: resolve database connection issue"

# New feature - bump minor version
# Change 0.0.8 → 0.1.0
git commit -m "feat: add support for OAuth providers"

# Breaking change - bump major version
# Change 0.0.8 → 1.0.0
git commit -m "feat: redesign user management API

BREAKING CHANGE: User management endpoints have been completely redesigned."
```

### Pull Request Checklist

- [ ] Code follows style guidelines
- [ ] Tests pass
- [ ] Documentation is updated
- [ ] No breaking changes (or documented)
- [ ] Commit messages follow conventional commits standard
- [ ] All commits pass pre-commit validation
- [ ] Branch is up to date with main

## Release Process

### Overview

Releases are **manually triggered** by maintainers. This gives full control over release timing and ensures quality.

### Release Steps

1. **Update the version in Chart.yaml**
   ```bash
   # Edit charts/supabase/Chart.yaml
   # Update both 'version' and 'appVersion' fields
   version: 0.0.9
   appVersion: 0.0.9
   ```

2. **Commit the version bump**
   ```bash
   git add charts/supabase/Chart.yaml
   git commit -m "chore: bump version to 0.0.9"
   git push origin main
   ```

3. **Trigger the release workflow**
   - Go to [GitHub Actions](https://github.com/wayli-app/supabase-helm/actions)
   - Select "Release Pipeline"
   - Click "Run workflow"
   - Optionally enable "dry-run" to test without publishing
   - Click "Run workflow" button

4. **What happens automatically**
   - CI runs to validate the chart
   - Git tag is created (e.g., `v0.0.9`)
   - Helm chart is packaged
   - Chart is published to GitHub Pages
   - Chart is pushed to GHCR (GitHub Container Registry)
   - GitHub Release is created with auto-generated notes

### Dry-Run Mode

Test the release process without actually publishing:

1. Go to GitHub Actions → Release Pipeline
2. Click "Run workflow"
3. Check the "dry-run" checkbox
4. Review the output to see what would happen

### Release Checklist for Maintainers

- [ ] All tests pass on main branch
- [ ] Version is bumped in Chart.yaml
- [ ] CHANGELOG.md is updated (if maintained)
- [ ] Breaking changes are documented
- [ ] Version follows semantic versioning
- [ ] Tag doesn't already exist
- [ ] Run dry-run first to verify
- [ ] Trigger release workflow
- [ ] Verify release appears on GitHub
- [ ] Verify chart is available in GHCR
- [ ] Verify chart is available on GitHub Pages

## Style Guides

### YAML Style

- Use 2-space indentation
- Use consistent naming conventions
- Quote strings when needed
- Use anchors and aliases for repeated values

### Template Style

- Use descriptive variable names
- Include comments for complex logic
- Follow Helm template best practices
- Use proper indentation

### Documentation Style

- Use clear, concise language
- Include code examples
- Update both README.md and chart README.md
- Use proper markdown formatting

## Getting Help

- [GitHub Issues](https://github.com/wayli-app/supabase-helm/issues)
- [GitHub Discussions](https://github.com/wayli-app/supabase-helm/discussions)
- [Documentation](./charts/supabase/README.md)

## Recognition

Contributors will be recognized in:
- Release notes
- Contributors list
- Project documentation

Thank you for contributing to the Supabase Helm Chart!