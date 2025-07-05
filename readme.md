# Supabase Helm Chart

This Helm chart deploys a complete Supabase stack on Kubernetes.

## Quick Start

```bash
# Add the Helm repository
helm repo add supabase-helm https://wayli-app.github.io/supabase-helm
helm repo update

# Install the chart
helm install my-supabase supabase-helm/supabase
```

## Installation Methods

### Method 1: From Helm Repository (Recommended)

```bash
# Add the Helm repository
helm repo add supabase-helm https://wayli-app.github.io/supabase-helm
helm repo update

# Install the chart
helm install my-supabase supabase-helm/supabase

# Install a specific version
helm install my-supabase supabase-helm/supabase --version {version}

# Install with custom values
helm install my-supabase supabase-helm/supabase \
  --set global.supabase.publicUrl=https://my-supabase.example.com \
  --set global.supabase.organizationName="My Organization"
```

### Method 2: From GitHub Container Registry (OCI)

```bash
# Login to GHCR (only needed once)
helm registry login ghcr.io

# Install directly from GHCR
helm install my-supabase oci://ghcr.io/wayli-app/charts/supabase

# Install a specific version
helm install my-supabase oci://ghcr.io/wayli-app/charts/supabase --version {version}
```

## Prerequisites

Before installing, ensure you have:

1. **Kubernetes cluster** (1.19+)
2. **Helm** (3.2.0+)
3. **Required secrets** (see [Creating Required Secrets](#creating-required-secrets) section)
4. **Storage provisioner** support in your cluster

## Quick Start with Secrets

```bash
# Create required secrets first
kubectl create secret generic supabase-secret \
  --from-literal=jwtSecret='your-super-secret-jwt-token-with-at-least-32-characters-long' \
  --from-literal=anonKey='your-anon-key' \
  --from-literal=serviceRoleKey='your-service-role-key' \
  --from-literal=secretKeyBase='your-secret-key-base' \
  --from-literal=vaultEncKey='your-vault-encryption-key' \
  --from-literal=dbEncKey='your-db-encryption-key'

# Install from Helm repository
helm install my-supabase supabase-helm/supabase

# Check the deployment
kubectl get pods -l app.kubernetes.io/instance=my-supabase
```

## Upgrading the Chart

```bash
# Update the repository
helm repo update

# Upgrade to the latest version
helm upgrade my-supabase supabase-helm/supabase

# Upgrade to a specific version
helm upgrade my-supabase supabase-helm/supabase --version {version}

# Upgrade with custom values
helm upgrade my-supabase supabase-helm/supabase \
  --set global.supabase.publicUrl=https://my-supabase.example.com
```

## Uninstalling the Chart

```bash
# Uninstall the release
helm uninstall my-supabase

# Remove the Helm repository
helm repo remove supabase-helm
```

**Note:** This will remove all Supabase services but will **NOT** delete persistent data (databases, storage, etc.) unless you explicitly delete the PVCs.

## Accessing Supabase Services

After installation, you can access the various Supabase services:

### Studio (Dashboard)
```bash
# Port forward to access Studio
kubectl port-forward svc/my-supabase-studio 3000:3000
```
Then visit: http://localhost:3000

### API Gateway (Kong)
```bash
# Port forward to access Kong API
kubectl port-forward svc/my-supabase-kong 8000:8000
```
Then visit: http://localhost:8000

### Database
```bash
# Port forward to access PostgreSQL directly
kubectl port-forward svc/my-supabase-db 5432:5432
```

## Creating Required Secrets

Before deploying the chart, you need to create a secret containing the required keys:

```bash
kubectl create secret generic supabase-secret \
  --from-literal=jwtSecret='your-jwt-secret' \
  --from-literal=anonKey='your-anon-key' \
  --from-literal=serviceRoleKey='your-service-role-key' \
  --from-literal=secretKeyBase='your-secret-key-base' \
  --from-literal=vaultEncKey='your-vault-encryption-key' \
  --from-literal=dbEncKey='your-db-encryption-key'
```

## Configuration

The chart supports extensive configuration through values. Key configuration options include:

### Global Configuration

| Parameter                          | Description                               | Default                          |
| ---------------------------------- | ----------------------------------------- | -------------------------------- |
| `global.supabase.organizationName` | Organization name for Studio              | `"Supabase Demo"`                |
| `global.supabase.projectName`      | Project name for Studio                   | `"Example project"`              |
| `global.supabase.publicUrl`        | Public URL of the Supabase instance       | `"https://supabase.example.com"` |
| `global.supabase.existingSecret`   | Existing secret containing Supabase keys  | `"supabase-secret"`              |

### Required Secret Keys

| Key              | Description                       |
| ---------------- | --------------------------------- |
| `jwtSecret`      | JWT secret for authentication     |
| `anonKey`        | Anonymous key for public access   |
| `serviceRoleKey` | Service role key for admin access |
| `secretKeyBase`  | Secret key base for encryption    |
| `vaultEncKey`    | Vault encryption key              |
| `dbEncKey`       | Database encryption key           |

## Troubleshooting

### Common Issues

1. **Pods not starting**: Check if required secrets exist
   ```bash
   kubectl get secret supabase-secret
   ```

2. **Database connection issues**: Verify PostgreSQL is running
   ```bash
   kubectl get pods -l app.kubernetes.io/component=db
   ```

3. **Storage issues**: Check PVC status
   ```bash
   kubectl get pvc -l app.kubernetes.io/instance=my-supabase
   ```

### Getting Logs

```bash
# Get logs from all Supabase pods
kubectl logs -l app.kubernetes.io/instance=my-supabase --all-containers

# Get logs from a specific service
kubectl logs -l app.kubernetes.io/component=auth --all-containers

# Follow logs in real-time
kubectl logs -l app.kubernetes.io/instance=my-supabase -f
```

### Checking Chart Status

```bash
# Check Helm release status
helm status my-supabase

# List all resources created by the chart
helm get all my-supabase

# Check values used in the release
helm get values my-supabase
```

## Available Services

This chart deploys the following Supabase services:

- **Database** - PostgreSQL with connection pooling via Supavisor
- **Studio** - Web-based management interface
- **Kong** - API Gateway for routing and authentication
- **Auth** - Authentication and authorization service
- **REST** - REST API service for database operations
- **Realtime** - Real-time subscriptions and broadcasting
- **Storage** - File storage and management service
- **Imgproxy** - Image processing and optimization service
- **Meta** - Metadata and schema management service
- **Functions** - Edge functions for serverless compute
- **Analytics** - Analytics and monitoring service
- **Vector** - Vector search and similarity service
- **Supavisor** - Database connection pooling service

## Persistence

The chart supports persistence for the following components:

- Storage
- Functions
- Analytics
- Database

Each component can be configured with storage size, storage class, access mode, and existing PVC claims.

## Additional Resources

- [Full Configuration Reference](https://github.com/wayli-app/supabase-helm)
- [Supabase Documentation](https://supabase.com/docs)
- [Helm Documentation](https://helm.sh/docs)

## Support

For issues and questions:

1. Check the [troubleshooting section](#troubleshooting)
2. Review the [configuration options](#configuration)
3. Open an issue on [GitHub](https://github.com/wayli-app/supabase-helm/issues)
