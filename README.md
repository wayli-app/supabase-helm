# Supabase Helm Chart

This Helm chart deploys a complete Supabase stack on Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

### Method 1: From GitHub Container Registry (Recommended)

The chart is published to GitHub Container Registry (GHCR) and can be installed directly:

```bash
# Install directly from GHCR
helm install my-supabase oci://ghcr.io/wayli-app/charts/supabase

# Install a specific version
helm install my-supabase oci://ghcr.io/wayli-app/charts/supabase --version {version}

# Install with custom values
helm install my-supabase oci://ghcr.io/wayli-app/charts/supabase \
  --set global.supabase.publicUrl=https://my-supabase.example.com \
  --set global.supabase.organizationName="My Organization"
```

### Method 2: From Helm Repository

Add the Helm repository and install:

```bash
# Add the Helm repository
helm repo add supabase-helm https://wayli-app.github.io/supabase-helm
helm repo update

# Install the chart
helm install my-supabase supabase-helm/supabase

# Install a specific version
helm install my-supabase supabase-helm/supabase --version {version}
```

### Method 3: From Local Chart Directory

For development or custom modifications:

```bash
# Clone the repository
git clone https://github.com/wayli-app/supabase-helm.git
cd supabase-helm

# Install from local chart directory
helm install my-supabase ./charts/supabase
```

### Prerequisites

Before installing, ensure you have:

1. **Kubernetes cluster** (1.19+)
2. **Helm** (3.2.0+)
3. **Required secrets** (see [Creating Required Secrets](#creating-required-secrets) section)
4. **Storage provisioner** support in your cluster
5. **GHCR authentication** (if using Method 1):
   ```bash
   # Login to GHCR (only needed once)
   helm registry login ghcr.io
   ```

### Quick Start

For a quick test deployment with default settings:

```bash
# Create required secrets first
kubectl create secret generic supabase-secret \
  --from-literal=jwtSecret='your-super-secret-jwt-token-with-at-least-32-characters-long' \
  --from-literal=anonKey='your-anon-key' \
  --from-literal=serviceRoleKey='your-service-role-key' \
  --from-literal=secretKeyBase='your-secret-key-base' \
  --from-literal=vaultEncKey='your-vault-encryption-key' \
  --from-literal=dbEncKey='your-db-encryption-key'

# Install from GHCR
helm install my-supabase oci://ghcr.io/wayli-app/charts/supabase

# Check the deployment
kubectl get pods -l app.kubernetes.io/instance=my-supabase
```

## Upgrading the Chart

### From GHCR (Recommended)

```bash
# Upgrade to the latest version
helm upgrade my-supabase oci://ghcr.io/wayli-app/charts/supabase

# Upgrade to a specific version
helm upgrade my-supabase oci://ghcr.io/wayli-app/charts/supabase --version 0.3.0

# Upgrade with custom values
helm upgrade my-supabase oci://ghcr.io/wayli-app/charts/supabase \
  --set global.supabase.publicUrl=https://my-supabase.example.com
```

### From Helm Repository

```bash
# Update the repository
helm repo update

# Upgrade to the latest version
helm upgrade my-supabase supabase-helm/supabase

# Upgrade to a specific version
helm upgrade my-supabase supabase-helm/supabase --version 0.3.0
```

## Uninstalling the Chart

```bash
# Uninstall the release
helm uninstall my-supabase

# Remove the Helm repository (if added)
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

4. **Authentication issues**: Verify JWT secrets are properly set
   ```bash
   kubectl describe secret supabase-secret
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

## Configuration

The following table lists the configurable parameters of the Supabase chart and their default values.

### Global Configuration

| Parameter                          | Description                               | Default                          |
| ---------------------------------- | ----------------------------------------- | -------------------------------- |
| `global.openApi.key`               | OpenAI API key                            | `""`                             |
| `global.openApi.existingSecret`    | Existing secret containing OpenAI API key | `""`                             |
| `global.supabase.organizationName` | Organization name for Studio              | `"Supabase Demo"`                |
| `global.supabase.projectName`      | Project name for Studio                   | `"Example project"`              |
| `global.supabase.publicUrl`        | Public URL of the Supabase instance       | `"https://supabase.example.com"` |
| `global.supabase.existingSecret`   | Existing secret containing Supabase keys  | `"supabase-secret"`              |

#### Required Secret Keys for `global.supabase.existingSecret`

| Key              | Description                       |
| ---------------- | --------------------------------- |
| `jwtSecret`      | JWT secret for authentication     |
| `anonKey`        | Anonymous key for public access   |
| `serviceRoleKey` | Service role key for admin access |
| `secretKeyBase`  | Secret key base for encryption    |
| `vaultEncKey`    | Vault encryption key              |
| `dbEncKey`       | Database encryption key           |

### Studio Configuration

| Parameter                 | Description                      | Default                    |
| ------------------------- | -------------------------------- | -------------------------- |
| `studio.enabled`          | Enable Studio deployment         | `true`                     |
| `studio.replicaCount`     | Number of Studio replicas        | `1`                        |
| `studio.image.repository` | Studio image repository          | `"supabase/studio"`        |
| `studio.image.tag`        | Studio image tag                 | `"2025.06.30-sha-6f5982d"` |
| `studio.image.pullPolicy` | Studio image pull policy         | `"IfNotPresent"`           |
| `studio.service.type`     | Studio service type              | `"ClusterIP"`              |
| `studio.service.port`     | Studio service port              | `3000`                     |
| `studio.podAnnotations`   | Additional pod annotations       | `{}`                       |
| `studio.volumeMounts`     | Additional volume mounts         | `[]`                       |
| `studio.volumes`          | Additional volumes               | `[]`                       |
| `studio.extraEnvVars`     | Additional environment variables | `[]`                       |

### Kong Configuration

| Parameter                | Description                               | Default          |
| ------------------------ | ----------------------------------------- | ---------------- |
| `kong.enabled`           | Enable Kong deployment                    | `true`           |
| `kong.image.repository`  | Kong image repository                     | `"kong"`         |
| `kong.image.tag`         | Kong image tag                            | `"2.8.1"`        |
| `kong.image.pullPolicy`  | Kong image pull policy                    | `"IfNotPresent"` |
| `kong.service.type`      | Kong service type                         | `"ClusterIP"`    |
| `kong.service.httpPort`  | Kong HTTP port                            | `8000`           |
| `kong.service.httpsPort` | Kong HTTPS port                           | `8443`           |
| `kong.service.port`      | Kong service port (for backward compatibility) | `8000`           |
| `kong.existingConfigMap` | Existing ConfigMap for Kong configuration | `""`             |
| `kong.extraEnvVars`      | Additional environment variables          | `[]`             |

### Auth Configuration

| Parameter               | Description                      | Default             |
| ----------------------- | -------------------------------- | ------------------- |
| `auth.enabled`          | Enable Auth deployment           | `true`              |
| `auth.image.repository` | Auth image repository            | `"supabase/gotrue"` |
| `auth.image.tag`        | Auth image tag                   | `"v2.176.1"`        |
| `auth.image.pullPolicy` | Auth image pull policy           | `"IfNotPresent"`    |
| `auth.service.type`     | Auth service type                | `"ClusterIP"`       |
| `auth.service.port`     | Auth service port                | `9999`              |
| `auth.extraEnvVars`     | Additional environment variables | `[]`                |

### REST Configuration

| Parameter               | Description                      | Default                 |
| ----------------------- | -------------------------------- | ----------------------- |
| `rest.enabled`          | Enable REST deployment           | `true`                  |
| `rest.image.repository` | REST image repository            | `"postgrest/postgrest"` |
| `rest.image.tag`        | REST image tag                   | `"v12.2.12"`            |
| `rest.image.pullPolicy` | REST image pull policy           | `"IfNotPresent"`        |
| `rest.service.type`     | REST service type                | `"ClusterIP"`           |
| `rest.service.port`     | REST service port                | `3000`                  |
| `rest.extraEnvVars`     | Additional environment variables | `[]`                    |

### Realtime Configuration

| Parameter                   | Description                      | Default               |
| --------------------------- | -------------------------------- | --------------------- |
| `realtime.enabled`          | Enable Realtime deployment       | `true`                |
| `realtime.image.repository` | Realtime image repository        | `"supabase/realtime"` |
| `realtime.image.tag`        | Realtime image tag               | `"v2.40.0"`           |
| `realtime.image.pullPolicy` | Realtime image pull policy       | `"IfNotPresent"`      |
| `realtime.service.type`     | Realtime service type            | `"ClusterIP"`         |
| `realtime.service.port`     | Realtime service port            | `4000`                |
| `realtime.extraEnvVars`     | Additional environment variables | `[]`                  |

### Storage Configuration

| Parameter                           | Description                      | Default                  |
| ----------------------------------- | -------------------------------- | ------------------------ |
| `storage.enabled`                   | Enable Storage deployment        | `true`                   |
| `storage.image.repository`          | Storage image repository         | `"supabase/storage-api"` |
| `storage.image.tag`                 | Storage image tag                | `"v1.25.3"`              |
| `storage.image.pullPolicy`          | Storage image pull policy        | `"IfNotPresent"`         |
| `storage.service.type`              | Storage service type             | `"ClusterIP"`            |
| `storage.service.port`              | Storage service port             | `5000`                   |
| `storage.persistence.enabled`       | Enable persistence               | `true`                   |
| `storage.persistence.size`          | Storage size                     | `"10Gi"`                 |
| `storage.persistence.existingClaim` | Existing PVC claim name          | `""`                     |
| `storage.persistence.storageClass`  | Storage class name               | `""`                     |
| `storage.persistence.accessMode`    | Access mode                      | `"ReadWriteOnce"`        |
| `storage.extraEnvVars`              | Additional environment variables | `[]`                     |

### Imgproxy Configuration

| Parameter                   | Description                      | Default               |
| --------------------------- | -------------------------------- | --------------------- |
| `imgproxy.enabled`          | Enable Imgproxy deployment       | `true`                |
| `imgproxy.image.repository` | Imgproxy image repository        | `"darthsim/imgproxy"` |
| `imgproxy.image.tag`        | Imgproxy image tag               | `"v3.28.0"`           |
| `imgproxy.image.pullPolicy` | Imgproxy image pull policy       | `"IfNotPresent"`      |
| `imgproxy.service.type`     | Imgproxy service type            | `"ClusterIP"`         |
| `imgproxy.service.port`     | Imgproxy service port            | `5001`                |
| `imgproxy.extraEnvVars`     | Additional environment variables | `[]`                  |

### Meta Configuration

| Parameter               | Description                      | Default                    |
| ----------------------- | -------------------------------- | -------------------------- |
| `meta.enabled`          | Enable Meta deployment           | `true`                     |
| `meta.image.repository` | Meta image repository            | `"supabase/postgres-meta"` |
| `meta.image.tag`        | Meta image tag                   | `"v0.91.0"`                |
| `meta.image.pullPolicy` | Meta image pull policy           | `"IfNotPresent"`           |
| `meta.service.type`     | Meta service type                | `"ClusterIP"`              |
| `meta.service.port`     | Meta service port                | `8080`                     |
| `meta.extraEnvVars`     | Additional environment variables | `[]`                       |

### Functions Configuration

| Parameter                             | Description                      | Default                   |
| ------------------------------------- | -------------------------------- | ------------------------- |
| `functions.enabled`                   | Enable Functions deployment      | `true`                    |
| `functions.image.repository`          | Functions image repository       | `"supabase/edge-runtime"` |
| `functions.image.tag`                 | Functions image tag              | `"v1.67.4"`               |
| `functions.image.pullPolicy`          | Functions image pull policy      | `"IfNotPresent"`          |
| `functions.service.type`              | Functions service type           | `"ClusterIP"`             |
| `functions.service.port`              | Functions service port           | `54321`                   |
| `functions.persistence.enabled`       | Enable persistence               | `true`                    |
| `functions.persistence.size`          | Storage size                     | `"1Gi"`                   |
| `functions.persistence.existingClaim` | Existing PVC claim name          | `""`                      |
| `functions.persistence.storageClass`  | Storage class name               | `""`                      |
| `functions.persistence.accessMode`    | Access mode                      | `"ReadWriteOnce"`         |
| `functions.extraEnvVars`              | Additional environment variables | `[]`                      |

### Analytics Configuration

| Parameter                             | Description                      | Default               |
| ------------------------------------- | -------------------------------- | --------------------- |
| `analytics.enabled`                   | Enable Analytics deployment      | `true`                |
| `analytics.image.repository`          | Analytics image repository       | `"supabase/logflare"` |
| `analytics.image.tag`                 | Analytics image tag              | `"1.15.4"`            |
| `analytics.image.pullPolicy`          | Analytics image pull policy      | `"IfNotPresent"`      |
| `analytics.service.type`              | Analytics service type           | `"ClusterIP"`         |
| `analytics.service.port`              | Analytics service port           | `4000`                |
| `analytics.persistence.enabled`       | Enable persistence               | `true`                |
| `analytics.persistence.size`          | Storage size                     | `"1Gi"`               |
| `analytics.persistence.existingClaim` | Existing PVC claim name          | `""`                  |
| `analytics.persistence.storageClass`  | Storage class name               | `""`                  |
| `analytics.persistence.accessMode`    | Access mode                      | `"ReadWriteOnce"`     |
| `analytics.extraEnvVars`              | Additional environment variables | `[]`                  |

### Database Configuration

| Parameter                      | Description                                    | Default               |
| ------------------------------ | ---------------------------------------------- | --------------------- |
| `db.enabled`                   | Enable Database deployment                     | `true`                |
| `db.postgres.image.repository` | Database image repository                      | `"supabase/postgres"` |
| `db.postgres.image.tag`        | Database image tag                             | `"17.4.1.049"`        |
| `db.postgres.image.pullPolicy` | Database image pull policy                     | `"IfNotPresent"`      |
| `db.postgres.service.type`     | Database service type                          | `"ClusterIP"`         |
| `db.postgres.service.port`     | Database service port                          | `5432`                |
| `db.postgres.persistence.enabled` | Enable persistence                             | `true`                |
| `db.postgres.persistence.size` | Storage size                                   | `"10Gi"`              |
| `db.postgres.persistence.existingClaim` | Existing PVC claim name                        | `""`                  |
| `db.postgres.persistence.storageClass` | Storage class name                             | `""`                  |
| `db.postgres.persistence.accessMode` | Access mode                                    | `"ReadWriteOnce"`     |
| `db.postgres.existingSecret`   | Existing secret containing PostgreSQL password | `""`                  |
| `db.postgres.secretKeys.userPasswordKey` | Key in existing secret for database password | `"password"`          |

### Vector Configuration

| Parameter                 | Description                      | Default             |
| ------------------------- | -------------------------------- | ------------------- |
| `vector.enabled`          | Enable Vector deployment         | `true`              |
| `vector.image.repository` | Vector image repository          | `"timberio/vector"` |
| `vector.image.tag`        | Vector image tag                 | `"0.47.X-alpine"`   |
| `vector.image.pullPolicy` | Vector image pull policy         | `"IfNotPresent"`    |
| `vector.service.type`     | Vector service type              | `"ClusterIP"`       |
| `vector.service.port`     | Vector service port              | `9001`              |
| `vector.extraEnvVars`     | Additional environment variables | `[]`                |

### Supavisor Configuration

| Parameter                          | Description                      | Default                |
| ---------------------------------- | -------------------------------- | ---------------------- |
| `supavisor.enabled`                | Enable Supavisor deployment      | `true`                 |
| `supavisor.image.repository`       | Supavisor image repository       | `"supabase/supavisor"` |
| `supavisor.image.tag`              | Supavisor image tag              | `"2.5.7"`              |
| `supavisor.image.pullPolicy`       | Supavisor image pull policy      | `"IfNotPresent"`       |
| `supavisor.service.type`           | Supavisor service type           | `"ClusterIP"`          |
| `supavisor.service.port`           | Supavisor service port           | `4000`                 |
| `supavisor.pooler.tenantId`        | Pooler tenant ID                 | `"default"`            |
| `supavisor.pooler.defaultPoolSize` | Default pool size                | `20`                   |
| `supavisor.pooler.maxClientConn`   | Maximum client connections       | `100`                  |
| `supavisor.pooler.dbPoolSize`      | Database pool size               | `10`                   |
| `supavisor.extraEnvVars`           | Additional environment variables | `[]`                   |

## Creating Required Secrets

Before deploying the chart, you need to create secrets containing the required keys:

### Supabase Secret

```bash
kubectl create secret generic supabase-secret \
  --from-literal=jwtSecret='your-jwt-secret' \
  --from-literal=anonKey='your-anon-key' \
  --from-literal=serviceRoleKey='your-service-role-key' \
  --from-literal=secretKeyBase='your-secret-key-base' \
  --from-literal=vaultEncKey='your-vault-encryption-key' \
  --from-literal=dbEncKey='your-db-encryption-key'
```

### Database Secret

```bash
kubectl create secret generic supabase-db-secret \
  --from-literal=password='your-user-password'
```

**Note:** The database secret uses only the `password` field.

## Persistence

The chart supports persistence for the following components:

- Storage
- Functions
- Analytics
- Database

Each component can be configured with:

- Storage size
- Storage class
- Access mode
- Existing PVC claim

## Additional Configuration

Each component supports additional environment variables through the `extraEnvVars` parameter. These can be used to configure component-specific settings not covered by the default parameters.
