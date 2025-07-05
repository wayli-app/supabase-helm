# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Which versions are eligible for receiving such patches depends on the CVSS v3.0 Rating:

| Version | Supported          | Notes                  |
| ------- | ------------------ | ---------------------- |
| 1.x.x   | :white_check_mark: | Full support           |
| 0.x.x   | :white_check_mark: | Full support (pre-1.0) |

**Note**: We support the latest two major versions and all patch releases within those versions.

## Reporting a Vulnerability

We take the security of the Supabase Helm Chart seriously. If you believe you have found a security vulnerability, please report it to us as described below.

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via email to [security@wayli.app](mailto:security@wayli.app).

You should receive a response within 48 hours. If for some reason you do not, please follow up via email to ensure we received your original message.

### Required Information

Please include the requested information listed below (as much as you can provide) to help us better understand the nature and scope of the possible issue:

#### General Information
- Type of issue (container escape, privilege escalation, data exposure, etc.)
- Full paths of source file(s) related to the vulnerability
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

#### Helm Chart Specific Information
- Chart version affected
- Kubernetes version where the issue was discovered
- Helm version used
- Values file configuration (with sensitive data redacted)
- Whether the issue affects default or custom configurations
- Any specific Supabase service components involved
- Network policies or RBAC configurations in place

#### Container Security Information
- Container image versions affected
- Base image vulnerabilities (if applicable)
- Runtime security context configurations
- Pod security policies or pod security standards in use
- Any security scanning results (Trivy, Snyk, etc.)

## Preferred Languages

We prefer all communications to be in English.

## Disclosure Policy

When we receive a security bug report, we will assign it to a primary handler. This person will coordinate the fix and release process, involving the following steps:

1. **Confirmation**: Confirm the problem and determine the affected versions
2. **Assessment**: Evaluate the severity and scope of the vulnerability
3. **Audit**: Audit code to find any similar problems across all components
4. **Fix Development**: Prepare fixes for all supported versions
5. **Testing**: Test fixes in various Kubernetes environments
6. **Release**: Release fixes as new patch or minor versions
7. **Disclosure**: Publish security advisories and update documentation

## Security Response Timeline

- **Initial Response**: Within 48 hours
- **Assessment**: Within 5 business days
- **Fix Development**: 1-4 weeks (depending on severity)
- **Release**: Within 1 week of fix completion
- **Public Disclosure**: Within 90 days of initial report

## Security Best Practices

### For Helm Chart Users

#### 1. **Chart Security**
- Always verify chart signatures and checksums
- Use specific chart versions, not `latest`
- Review the chart's source code before deployment
- Validate values files against security policies

#### 2. **Kubernetes Security**
- **RBAC**: Implement least-privilege access controls
- **Network Policies**: Restrict pod-to-pod communication
- **Pod Security Standards**: Enable and configure pod security
- **Secrets Management**: Use external secret management solutions
- **Image Scanning**: Scan container images for vulnerabilities

#### 3. **Supabase-Specific Security**
- **Database Security**: Use strong passwords and connection encryption
- **API Security**: Secure JWT tokens and API keys
- **Storage Security**: Configure proper bucket policies
- **Authentication**: Implement proper OAuth and SAML configurations
- **Network Security**: Use ingress controllers with TLS termination

#### 4. **Runtime Security**
- **Resource Limits**: Set appropriate CPU and memory limits
- **Security Contexts**: Configure non-root users and read-only filesystems
- **Health Checks**: Implement proper liveness and readiness probes
- **Logging**: Enable security event logging and monitoring
- **Backup Security**: Secure database backups and storage

### For Contributors

#### 1. **Code Security**
- **Security Review**: All changes must undergo security review
- **Dependency Scanning**: Regularly scan for vulnerable dependencies
- **Secret Management**: Never commit secrets or sensitive data
- **Input Validation**: Validate all user inputs in templates
- **Least Privilege**: Follow the principle of least privilege

#### 2. **Container Security**
- **Base Images**: Use minimal, secure base images
- **Multi-stage Builds**: Reduce attack surface with multi-stage builds
- **Image Scanning**: Scan images before publishing
- **Vulnerability Management**: Keep base images updated
- **Security Contexts**: Configure appropriate security contexts

#### 3. **Helm Chart Security**
- **Template Security**: Validate template outputs
- **Value Validation**: Implement proper value validation
- **Default Security**: Secure by default configurations
- **Documentation**: Document security considerations
- **Testing**: Test security configurations in CI/CD

## Security Checklist

### Before Releasing a New Version

#### Chart Security
- [ ] No secrets or sensitive data in templates
- [ ] All dependencies are up to date
- [ ] Security scanning passes (Trivy, Snyk, etc.)
- [ ] Chart validation passes (`helm lint`)
- [ ] Template security validation completed

#### Container Security
- [ ] Base images are up to date
- [ ] Container images scanned for vulnerabilities
- [ ] Security contexts configured appropriately
- [ ] Resource limits and requests defined
- [ ] Non-root users configured where possible

#### Kubernetes Security
- [ ] RBAC rules are appropriate and minimal
- [ ] Network policies are documented and tested
- [ ] Pod security standards are enforced
- [ ] Service accounts have minimal permissions
- [ ] Secrets are properly managed

#### Documentation
- [ ] Security considerations documented
- [ ] Security configuration examples provided
- [ ] Known limitations documented
- [ ] Security best practices guide updated
- [ ] Migration guides for security changes

## Security Tools and Scanning

### Recommended Security Tools

#### Container Security
- **Trivy**: Container vulnerability scanning
- **Snyk**: Dependency and container scanning
- **Clair**: Static analysis of container images
- **Falco**: Runtime security monitoring

#### Kubernetes Security
- **kube-bench**: CIS Kubernetes benchmark
- **kube-hunter**: Security testing tool
- **OPA Gatekeeper**: Policy enforcement
- **Kyverno**: Policy management

#### Helm Security
- **helm-secrets**: Secret management
- **helm-diff**: Change validation
- **helm-test**: Chart testing
- **helm-lint**: Chart validation

### Security Scanning in CI/CD

Our CI/CD pipeline includes:
- Container image vulnerability scanning
- Helm chart security validation
- Kubernetes manifest security checks
- Dependency vulnerability scanning
- Secret detection in code

## Security Advisories

Security advisories are published for:
- Critical vulnerabilities (CVSS 9.0-10.0)
- High severity vulnerabilities (CVSS 7.0-8.9)
- Medium severity vulnerabilities (CVSS 4.0-6.9)
- Low severity vulnerabilities (CVSS 0.1-3.9) - when exploitation is likely

## Acknowledgments

We would like to thank all security researchers and users who have responsibly disclosed security vulnerabilities to us. Your contributions help make the Supabase Helm Chart more secure for everyone.

## Security Contacts

- **Security Email**: [security@wayli.app](mailto:security@wayli.app)
- **PGP Key**: Available upon request
- **Security Team**: [@wayli-app/security](https://github.com/orgs/wayli-app/teams/security)

## References

- [Kubernetes Security Best Practices](https://kubernetes.io/docs/concepts/security/)
- [Helm Security](https://helm.sh/docs/topics/security/)
- [Container Security Best Practices](https://docs.docker.com/develop/security-best-practices/)
- [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes/)
