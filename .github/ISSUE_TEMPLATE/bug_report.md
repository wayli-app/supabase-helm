---
name: Bug report
about: Create a report to help us improve
title: '[BUG] '
labels: ['bug', 'needs-triage']
assignees: ''
---

## Bug Description

A clear and concise description of what the bug is.

## Steps to Reproduce

1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

## Expected Behavior

A clear and concise description of what you expected to happen.

## Actual Behavior

A clear and concise description of what actually happened.

## Environment

### Kubernetes Version
```bash
kubectl version --short
```

### Helm Version
```bash
helm version --short
```

### Chart Version
```bash
helm list -n <namespace>
```

### Values File
```yaml
# Please share your values file (with sensitive data redacted)
```

## Logs

### Pod Logs
```bash
# Please include relevant pod logs
kubectl logs -n <namespace> <pod-name>
```

### Events
```bash
# Please include relevant events
kubectl get events -n <namespace> --sort-by='.lastTimestamp'
```

## Additional Context

Add any other context about the problem here, such as:
- Screenshots
- Error messages
- Cluster configuration
- Storage class information
- Network policies

## Checklist

- [ ] I have searched existing issues to avoid duplicates
- [ ] I have provided all required information
- [ ] I have included relevant logs and error messages
- [ ] I have tested with the latest chart version
- [ ] I have checked the documentation for similar issues

## Priority

- [ ] Critical (service completely broken)
- [ ] High (major functionality affected)
- [ ] Medium (minor functionality affected)
- [ ] Low (cosmetic issue)