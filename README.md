# Supabase Helm Chart

This Helm chart deploys a complete Supabase stack on Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Important notes

- The Supabase Auth service will fail to run its migrations, because of [this issue](https://github.com/supabase/auth/pull/2047).
  You will have to run the following query on your database:
  ```sql
  create type auth.factor_type as enum('totp', 'webauthn');
  create type auth.factor_status as enum('unverified', 'verified');
  create type auth.aal_level as enum('aal1', 'aal2', 'aal3');
  create type auth.code_challenge_method as enum('s256', 'plain');
  ```

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
| `global.imageRegistry`             | Global image registry                     | `""`                             |
| `global.imagePullSecrets`          | Global image pull secrets                 | `[]`                             |
| `global.defaultStorageClass`       | Global default storage class             | `""`                             |
| `global.openApi.key`               | OpenAI API key                            | `""`                             |
| `global.openApi.existingSecret`    | Existing secret containing OpenAI API key | `""`                             |
| `global.openApi.secretKey`         | Secret key for OpenAI API key            | `"openai-api-key"`               |
| `global.supabase.organizationName` | Organization name for Studio              | `"Supabase Demo"`                |
| `global.supabase.projectName`      | Project name for Studio                   | `"Example project"`              |
| `global.supabase.publicUrl`        | Public URL of the Supabase instance       | `"https://supabase.example.com"` |
| `global.supabase.siteUrl`          | Site URL of the Supabase instance         | `"https://example.com"`          |
| `global.supabase.existingSecret`   | Existing secret containing Supabase keys  | `"supabase-secret"`              |
| `global.supabase.jwtExpiry`        | JWT token expiry in seconds              | `3600`                           |

#### Global Security Context

| Parameter                                    | Description                                    | Default                    |
| -------------------------------------------- | ---------------------------------------------- | -------------------------- |
| `global.securityContext.pod.runAsNonRoot`   | Run as non-root user by default               | `true`                     |
| `global.securityContext.pod.runAsUser`      | Default user ID                               | `1000`                     |
| `global.securityContext.pod.runAsGroup`     | Default group ID                              | `1000`                     |
| `global.securityContext.pod.fsGroup`        | Default filesystem group                      | `1000`                     |
| `global.securityContext.pod.fsGroupChangePolicy` | Filesystem group change policy            | `"OnRootMismatch"`         |
| `global.securityContext.pod.seccompProfile.type` | Security profile for syscall filtering | `"RuntimeDefault"`         |
| `global.securityContext.pod.allowPrivilegeEscalation` | Allow privilege escalation              | `false`                    |
| `global.securityContext.pod.readOnlyRootFilesystem` | Read-only root filesystem               | `false`                    |

#### Global Auth Configuration

| Parameter                                    | Description                                    | Default                    |
| -------------------------------------------- | ---------------------------------------------- | -------------------------- |
| `global.supabase.auth.disableSignup`         | Disable user signup                           | `false`                    |
| `global.supabase.auth.enableEmailSignup`     | Enable email signup                            | `true`                     |
| `global.supabase.auth.enableAnonymousUsers`  | Enable anonymous users                         | `false`                    |
| `global.supabase.auth.enableEmailAutoconfirm` | Enable email autoconfirm                    | `false`                    |
| `global.supabase.auth.enablePhoneSignup`     | Enable phone signup                            | `false`                    |
| `global.supabase.auth.enablePhoneAutoconfirm` | Enable phone autoconfirm                    | `false`                    |
| `global.supabase.auth.additionalRedirectUrls` | Additional redirect URLs                    | `""`                       |

#### Global SMTP Configuration

| Parameter                                    | Description                                    | Default                    |
| -------------------------------------------- | ---------------------------------------------- | -------------------------- |
| `global.supabase.auth.smtp.adminEmail`       | SMTP admin email                               | `""`                       |
| `global.supabase.auth.smtp.host`             | SMTP host                                     | `""`                       |
| `global.supabase.auth.smtp.port`             | SMTP port                                     | `587`                      |
| `global.supabase.auth.smtp.user`             | SMTP user                                     | `""`                       |
| `global.supabase.auth.smtp.password`         | SMTP password                                 | `""`                       |
| `global.supabase.auth.smtp.senderName`       | SMTP sender name                              | `""`                       |
| `global.supabase.auth.smtp.existingSecret`   | Existing secret containing SMTP credentials   | `""`                       |

#### Global Mailer Configuration

| Parameter                                    | Description                                    | Default                    |
| -------------------------------------------- | ---------------------------------------------- | -------------------------- |
| `global.supabase.auth.mailer.urlpathsInvite` | Invite URL path                               | `"/auth/v1/verify"`        |
| `global.supabase.auth.mailer.urlpathsConfirmation` | Confirmation URL path                     | `"/auth/v1/verify"`        |
| `global.supabase.auth.mailer.urlpathsRecovery` | Recovery URL path                           | `"/auth/v1/verify"`        |
| `global.supabase.auth.mailer.urlpathsEmailChange` | Email change URL path                     | `"/auth/v1/verify"`        |

#### Required Secret Keys for `global.supabase.existingSecret`

| Key              | Description                       |
| ---------------- | --------------------------------- |
| `jwtSecret`      | JWT secret for authentication     |
| `anonKey`        | Anonymous key for public access   |
| `serviceRoleKey` | Service role key for admin access |
| `secretKeyBase`  | Secret key base for encryption    |
| `vaultEncKey`    | Vault encryption key              |
| `dbEncKey`       | Database encryption key           |

### Common Configuration

| Parameter                | Description                           | Default |
| ------------------------ | ------------------------------------- | ------- |
| `commonLabels`           | Common labels to add to all resources | `{}`    |
| `commonAnnotations`      | Common annotations to add to all resources | `{}` |
| `secretAnnotations`      | Annotations to add to all secrets    | `{}`    |
| `fullnameOverride`       | Override the full name of the release | `""`    |
| `nameOverride`           | Override the name of the chart        | `""`    |
| `namespaceOverride`      | Override the namespace                | `""`    |

### ServiceAccount Configuration

| Parameter                          | Description                           | Default |
| ---------------------------------- | ------------------------------------- | ------- |
| `serviceAccount.create`            | Create a service account              | `true`  |
| `serviceAccount.annotations`       | Annotations to add to the service account | `{}` |
| `serviceAccount.name`              | The name of the service account to use | `""`   |
| `serviceAccount.automountServiceAccountToken` | Automount API credentials | `true` |

### Studio Configuration

| Parameter                 | Description                      | Default                    |
| ------------------------- | -------------------------------- | -------------------------- |
| `studio.enabled`          | Enable Studio deployment         | `true`                     |
| `studio.replicaCount`     | Number of Studio replicas        | `1`                        |
| `studio.image.repository` | Studio image repository          | `"supabase/studio"`        |
| `studio.image.tag`        | Studio image tag                 | `"2025.08.25-sha-72a94af"` |
| `studio.image.pullPolicy` | Studio image pull policy         | `"IfNotPresent"`           |
| `studio.service.type`     | Studio service type              | `"ClusterIP"`              |
| `studio.service.port`     | Studio service port              | `3000`                     |
| `studio.service.name`     | Studio service name (optional, defaults to release-name-studio) | `""` |
| `studio.service.namespace` | Studio service namespace (optional, for cross-namespace communication) | `""` |
| `studio.podAnnotations`   | Additional pod annotations       | `{}`                       |
| `studio.volumeMounts`     | Additional volume mounts         | `[]`                       |
| `studio.volumes`          | Additional volumes               | `[]`                       |
| `studio.extraEnvVars`     | Additional environment variables | `[]`                       |
| `studio.config.enableLogs` | Enable logs in Studio           | `true`                     |
| `studio.config.analyticsBackendProvider` | Analytics backend provider | `"postgres"`               |

#### Studio Authentication Configuration

| Parameter                                    | Description                                    | Default                    |
| -------------------------------------------- | ---------------------------------------------- | -------------------------- |
| `studio.config.auth.username`                | Studio username                               | `"supabase"`               |
| `studio.config.auth.password`                | Studio password                               | `""`                       |
| `studio.config.auth.existingSecret`          | Existing secret containing studio credentials | `""`                       |
| `studio.config.auth.secretKeys.usernameKey`  | Username key in the secret                    | `"username"`               |
| `studio.config.auth.secretKeys.passwordKey`  | Password key in the secret                    | `"password"`               |

| Parameter                                    | Description                                    | Default                    |
| -------------------------------------------- | ---------------------------------------------- | -------------------------- |
| `studio.config.auth.username`                | Studio username                               | `"supabase"`               |
| `studio.config.auth.password`                | Studio password                               | `""`                       |
| `studio.config.auth.existingSecret`          | Existing secret containing studio credentials | `""`                       |

### Kong Configuration

| Parameter                | Description                               | Default          |
| ------------------------ | ----------------------------------------- | ---------------- |
| `kong.enabled`           | Enable Kong deployment                    | `true`           |
| `kong.image.repository`  | Kong image repository                     | `"kong"`         |
| `kong.image.tag`         | Kong image tag                            | `"3.9.1"`        |
| `kong.image.pullPolicy`  | Kong image pull policy                    | `"IfNotPresent"` |
| `kong.service.type`      | Kong service type                         | `"ClusterIP"`    |
| `kong.service.httpPort`  | Kong HTTP port                            | `8000`           |
| `kong.service.httpsPort` | Kong HTTPS port                           | `8443`           |
| `kong.service.port`      | Kong service port (for backward compatibility) | `8000`           |
| `kong.service.name`      | Kong service name (optional, defaults to release-name-kong) | `""` |
| `kong.service.namespace` | Kong service namespace (optional, for cross-namespace communication) | `""` |
| `kong.existingConfigMap` | Existing ConfigMap for Kong configuration | `""`             |
| `kong.extraEnvVars`      | Additional environment variables          | `[]`             |

### Auth Configuration

| Parameter               | Description                      | Default             |
| ----------------------- | -------------------------------- | ------------------- |
| `auth.enabled`          | Enable Auth deployment           | `true`              |
| `auth.image.repository` | Auth image repository            | `"supabase/auth"`   |
| `auth.image.tag`        | Auth image tag                   | `"v2.178.0"`        |
| `auth.image.pullPolicy` | Auth image pull policy           | `"IfNotPresent"`    |
| `auth.service.type`     | Auth service type                | `"ClusterIP"`       |
| `auth.service.port`     | Auth service port                | `9999`              |
| `auth.service.name`     | Auth service name (optional, defaults to release-name-auth) | `""` |
| `auth.service.namespace` | Auth service namespace (optional, for cross-namespace communication) | `""` |
| `auth.extraEnvVars`     | Additional environment variables | `[]`                |

### REST Configuration

| Parameter               | Description                      | Default                 |
| ----------------------- | -------------------------------- | ----------------------- |
| `rest.enabled`          | Enable REST deployment           | `true`                  |
| `rest.image.repository` | REST image repository            | `"postgrest/postgrest"` |
| `rest.image.tag`        | REST image tag                   | `"v13.0.5"`            |
| `rest.image.pullPolicy` | REST image pull policy           | `"IfNotPresent"`        |
| `rest.service.type`     | REST service type                | `"ClusterIP"`           |
| `rest.service.port`     | REST service port                | `3000`                  |
| `rest.service.name`     | REST service name (optional, defaults to release-name-rest) | `""` |
| `rest.service.namespace` | REST service namespace (optional, for cross-namespace communication) | `""` |
| `rest.extraEnvVars`     | Additional environment variables | `[]`                    |

#### REST Configuration

| Parameter                    | Description                    | Default                           |
| ---------------------------- | ------------------------------ | --------------------------------- |
| `rest.config.dbSchemas`      | Database schemas to expose     | `"public,storage,graphql_public"` |
| `rest.config.anonRole`       | Anonymous role                 | `"anon"`                          |
| `rest.config.useLegacyGucs`  | Use legacy GUCs                | `false`                           |

#### REST Health Checks

| Parameter                                    | Description                    | Default                    |
| -------------------------------------------- | ------------------------------ | -------------------------- |
| `rest.livenessProbe.httpGet.path`            | Liveness probe path            | `"/"`                       |
| `rest.livenessProbe.httpGet.port`            | Liveness probe port            | `http`                      |
| `rest.readinessProbe.httpGet.path`           | Readiness probe path           | `"/"`                       |
| `rest.readinessProbe.httpGet.port`           | Readiness probe port           | `http`                      |

### Realtime Configuration

| Parameter                   | Description                      | Default               |
| --------------------------- | -------------------------------- | --------------------- |
| `realtime.enabled`          | Enable Realtime deployment       | `true`                |
| `realtime.image.repository` | Realtime image repository        | `"supabase/realtime"` |
| `realtime.image.tag`        | Realtime image tag               | `"v2.43.1"`           |
| `realtime.image.pullPolicy` | Realtime image pull policy       | `"IfNotPresent"`      |
| `realtime.service.type`     | Realtime service type            | `"ClusterIP"`         |
| `realtime.service.port`     | Realtime service port            | `4000`                |
| `realtime.service.name`     | Realtime service name (optional, defaults to release-name-realtime) | `""` |
| `realtime.service.namespace` | Realtime service namespace (optional, for cross-namespace communication) | `""` |
| `realtime.extraEnvVars`     | Additional environment variables | `[]`                  |

#### Realtime Configuration

| Parameter                        | Description                    | Default                    |
| -------------------------------- | ------------------------------ | -------------------------- |
| `realtime.config.dbUser`        | Database user                  | `"supabase_admin"`         |
| `realtime.config.afterConnectQuery` | Database after connect query | `"SET search_path TO _realtime"` |
| `realtime.config.erlAflags`     | Erlang flags                  | `"-proto_dist inet_tcp"`   |
| `realtime.config.dnsNodes`      | DNS nodes                     | `"''"`                     |
| `realtime.config.rlimitNofile`  | File descriptor limit         | `"10000"`                  |
| `realtime.config.appName`       | Application name              | `"realtime"`               |
| `realtime.config.seedSelfHost`  | Seed self host                | `true`                     |
| `realtime.config.runJanitor`    | Run janitor                   | `true`                     |

### Storage Configuration

| Parameter                           | Description                      | Default                  |
| ----------------------------------- | -------------------------------- | ------------------------ |
| `storage.enabled`                   | Enable Storage deployment        | `true`                   |
| `storage.image.repository`          | Storage image repository         | `"supabase/storage-api"` |
| `storage.image.tag`                 | Storage image tag                | `"v1.26.4"`              |
| `storage.image.pullPolicy`          | Storage image pull policy        | `"IfNotPresent"`         |
| `storage.service.type`              | Storage service type             | `"ClusterIP"`            |
| `storage.service.port`              | Storage service port             | `5000`                   |
| `storage.service.name`              | Storage service name (optional, defaults to release-name-storage) | `""` |
| `storage.service.namespace`         | Storage service namespace (optional, for cross-namespace communication) | `""` |
| `storage.persistence.enabled`       | Enable persistence               | `true`                   |
| `storage.persistence.size`          | Storage size                     | `"10Gi"`                 |
| `storage.persistence.existingClaim` | Existing PVC claim name          | `""`                     |
| `storage.persistence.storageClass`  | Storage class name               | `""`                     |
| `storage.persistence.accessMode`    | Access mode                      | `"ReadWriteOnce"`        |
| `storage.extraEnvVars`              | Additional environment variables | `[]`                     |

#### Storage Health Checks

| Parameter                                    | Description                    | Default                    |
| -------------------------------------------- | ------------------------------ | -------------------------- |
| `storage.livenessProbe.httpGet.path`         | Liveness probe path            | `"/status"`                |
| `storage.livenessProbe.httpGet.port`         | Liveness probe port            | `http`                     |
| `storage.readinessProbe.httpGet.path`        | Readiness probe path           | `"/status"`                |
| `storage.readinessProbe.httpGet.port`        | Readiness probe port           | `http`                     |

#### Storage Configuration

| Parameter                                    | Description                    | Default                    |
| -------------------------------------------- | ------------------------------ | -------------------------- |
| `storage.config.fileSizeLimit`               | File size limit in bytes       | `52428800`                 |
| `storage.config.storageBackend`              | Storage backend type           | `"file"`                   |
| `storage.config.fileStorageBackendPath`      | File storage backend path      | `"/var/lib/storage"`       |
| `storage.config.tenantId`                    | Tenant ID                      | `""`                       |
| `storage.config.region`                      | Region                         | `""`                       |
| `storage.config.globalS3Bucket`              | Global S3 bucket               | `""`                       |
| `storage.config.globalS3Endpoint`            | Global S3 endpoint             | `""`                       |
| `storage.config.enableImageTransformation`  | Enable image transformation     | `true`                     |

**Note:** For S3 storage, set the values for `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in the `extraEnvVars` or create a secret with these credentials.

### Imgproxy Configuration

| Parameter                   | Description                      | Default               |
| --------------------------- | -------------------------------- | --------------------- |
| `imgproxy.enabled`          | Enable Imgproxy deployment       | `true`                |
| `imgproxy.image.repository` | Imgproxy image repository        | `"darthsim/imgproxy"` |
| `imgproxy.image.tag`        | Imgproxy image tag               | `"v3.29.1"`           |
| `imgproxy.image.pullPolicy` | Imgproxy image pull policy       | `"IfNotPresent"`      |
| `imgproxy.service.type`     | Imgproxy service type            | `"ClusterIP"`         |
| `imgproxy.service.port`     | Imgproxy service port            | `5001`                |
| `imgproxy.service.name`     | Imgproxy service name (optional, defaults to release-name-imgproxy) | `""` |
| `imgproxy.service.namespace` | Imgproxy service namespace (optional, for cross-namespace communication) | `""` |
| `imgproxy.extraEnvVars`     | Additional environment variables | `[]`                  |

#### Imgproxy Configuration

| Parameter                                    | Description                    | Default                    |
| -------------------------------------------- | ------------------------------ | -------------------------- |
| `imgproxy.config.bind`                       | Bind address and port          | `":5001"`                  |
| `imgproxy.config.localFilesystemRoot`        | Local filesystem root          | `"/"`                      |
| `imgproxy.config.useEtag`                    | Use ETag                       | `true`                     |
| `imgproxy.config.enableWebpDetection`        | Enable WebP detection          | `true`                     |

#### Imgproxy Health Checks

| Parameter                                    | Description                    | Default                    |
| -------------------------------------------- | ------------------------------ | -------------------------- |
| `imgproxy.livenessProbe.httpGet.path`        | Liveness probe path            | `"/health"`                |
| `imgproxy.livenessProbe.httpGet.port`        | Liveness probe port            | `5001`                     |
| `imgproxy.readinessProbe.httpGet.path`       | Readiness probe path           | `"/health"`                |
| `imgproxy.readinessProbe.httpGet.port`       | Readiness probe port           | `5001`                     |

### Meta Configuration

| Parameter               | Description                      | Default                    |
| ----------------------- | -------------------------------- | -------------------------- |
| `meta.enabled`          | Enable Meta deployment           | `true`                     |
| `meta.image.repository` | Meta image repository            | `"supabase/postgres-meta"` |
| `meta.image.tag`        | Meta image tag                   | `"v0.91.5"`                |
| `meta.image.pullPolicy` | Meta image pull policy           | `"IfNotPresent"`           |
| `meta.service.type`     | Meta service type                | `"ClusterIP"`              |
| `meta.service.port`     | Meta service port                | `8080`                     |
| `meta.service.name`     | Meta service name (optional, defaults to release-name-meta) | `""` |
| `meta.service.namespace` | Meta service namespace (optional, for cross-namespace communication) | `""` |
| `meta.extraEnvVars`     | Additional environment variables | `[]`                       |

#### Meta Configuration

| Parameter                    | Description                    | Default                    |
| ---------------------------- | ------------------------------ | -------------------------- |
| `meta.config.dbUser`         | Database user                  | `"supabase_admin"`         |
| `meta.config.dbSchema`       | Database schema                | `"public"`                 |
| `meta.config.dbSsl`          | Database SSL                   | `false`                    |

### Functions Configuration

| Parameter                             | Description                      | Default                   |
| ------------------------------------- | -------------------------------- | ------------------------- |
| `functions.enabled`                   | Enable Functions deployment      | `true`                    |
| `functions.image.repository`          | Functions image repository       | `"supabase/edge-runtime"` |
| `functions.image.tag`                 | Functions image tag              | `"v1.69.2"`               |
| `functions.image.pullPolicy`          | Functions image pull policy      | `"IfNotPresent"`          |
| `functions.service.type`              | Functions service type           | `"ClusterIP"`             |
| `functions.service.port`              | Functions service port           | `9000`                    |
| `functions.service.name`              | Functions service name (optional, defaults to release-name-functions) | `""` |
| `functions.service.namespace`         | Functions service namespace (optional, for cross-namespace communication) | `""` |
| `functions.persistence.enabled`       | Enable persistence               | `false`                   |
| `functions.persistence.size`          | Storage size                     | `"1Gi"`                   |
| `functions.persistence.existingClaim` | Existing PVC claim name          | `""`                      |
| `functions.persistence.storageClass`  | Storage class name               | `""`                      |
| `functions.persistence.accessMode`    | Access mode                      | `"ReadWriteOnce"`         |
| `functions.extraEnvVars`              | Additional environment variables | `[]`                      |

#### Functions Configuration

| Parameter                        | Description                    | Default                    |
| -------------------------------- | ------------------------------ | -------------------------- |
| `functions.config.dbUser`       | Database user                  | `"supabase_admin"`         |
| `functions.config.dbSchema`     | Database schema                | `"public"`                 |
| `functions.config.dbSsl`        | Database SSL                   | `false`                    |
| `functions.config.verifyJwt`    | Verify JWT                     | `true`                     |
| `functions.config.mainService`  | Main service path for edge functions | `"/home/deno/functions/main"` |

#### Functions Volume Configuration

| Parameter                                    | Description                    | Default                    |
| -------------------------------------------- | ------------------------------ | -------------------------- |
| `functions.extraVolumeMounts`                | Additional volume mounts       | `[]`                        |
| `functions.extraVolumes`                     | Additional volumes             | `[]`                        |

### Analytics Configuration

| Parameter                             | Description                      | Default               |
| ------------------------------------- | -------------------------------- | --------------------- |
| `analytics.enabled`                   | Enable Analytics deployment      | `true`                |
| `analytics.image.repository`          | Analytics image repository       | `"supabase/logflare"` |
| `analytics.image.tag`                 | Analytics image tag              | `"1.15.4"`            |
| `analytics.image.pullPolicy`          | Analytics image pull policy      | `"IfNotPresent"`      |
| `analytics.service.type`              | Analytics service type           | `"ClusterIP"`         |
| `analytics.service.port`              | Analytics service port           | `4000`                |
| `analytics.service.name`              | Analytics service name (optional, defaults to release-name-analytics) | `""` |
| `analytics.service.namespace`         | Analytics service namespace (optional, for cross-namespace communication) | `""` |
| `analytics.persistence.enabled`       | Enable persistence               | `true`                |
| `analytics.persistence.size`          | Storage size                     | `"1Gi"`               |
| `analytics.persistence.existingClaim` | Existing PVC claim name          | `""`                  |
| `analytics.persistence.storageClass`  | Storage class name               | `""`                  |
| `analytics.persistence.accessMode`    | Access mode                      | `"ReadWriteOnce"`     |
| `analytics.extraEnvVars`              | Additional environment variables | `[]`                  |

#### Analytics Configuration

| Parameter                                    | Description                    | Default                    |
| -------------------------------------------- | ------------------------------ | -------------------------- |
| `analytics.config.dbUser`                    | Database user                  | `"supabase_admin"`         |
| `analytics.config.dbDatabase`                | Database name                  | `"_supabase"`              |
| `analytics.config.dbSchema`                  | Database schema                | `"_analytics"`             |
| `analytics.config.singleTenant`              | Single tenant mode             | `true`                     |
| `analytics.config.supabaseMode`              | Supabase mode                  | `true`                     |
| `analytics.config.minClusterSize`            | Minimum cluster size           | `1`                        |
| `analytics.config.featureFlagOverride`       | Feature flag override          | `"multibackend=true"`      |

#### Analytics Secret Configuration

| Parameter                                    | Description                    | Default                    |
| -------------------------------------------- | ------------------------------ | -------------------------- |
| `analytics.logflarePublicAccessToken`        | Logflare public access token   | `""`                       |
| `analytics.logflarePrivateAccessToken`       | Logflare private access token  | `""`                       |
| `analytics.existingSecret`                   | Existing secret containing Logflare tokens | `""`        |
| `analytics.secretKeys.logflarePublicAccessToken` | Public access token key in secret | `"logflare-public-access-token"` |
| `analytics.secretKeys.logflarePrivateAccessToken` | Private access token key in secret | `"logflare-private-access-token"` |

### Database Configuration

| Parameter                      | Description                                    | Default               |
| ------------------------------ | ---------------------------------------------- | --------------------- |
| `db.enabled`                   | Enable Database deployment                     | `true`                |
| `db.postgres.image.repository` | Database image repository                      | `"supabase/postgres"` |
| `db.postgres.image.tag`        | Database image tag                             | `"17.4.1.075"`        |
| `db.postgres.image.pullPolicy` | Database image pull policy                     | `"IfNotPresent"`      |
| `db.postgres.service.type`     | Database service type                          | `"ClusterIP"`         |
| `db.postgres.service.port`     | Database service port                          | `5432`                |
| `db.postgres.service.name`     | Database service name (optional, defaults to release-name-db) | `""` |
| `db.postgres.service.namespace` | Database service namespace (optional, for cross-namespace communication) | `""` |
| `db.postgres.persistence.enabled` | Enable persistence                             | `true`                |
| `db.postgres.persistence.size` | Storage size                                   | `"10Gi"`              |
| `db.postgres.persistence.existingClaim` | Existing PVC claim name                        | `""`                  |
| `db.postgres.persistence.storageClass` | Storage class name                             | `""`                  |
| `db.postgres.persistence.accessMode` | Access mode                                    | `"ReadWriteOnce"`     |
| `db.postgres.existingSecret`   | Existing secret containing PostgreSQL password | `""`                  |
| `db.postgres.secretKeys.userPasswordKey` | Key in existing secret for database password | `"password"`          |

#### PgBouncer Configuration

**Note:** You must deploy PgBouncer yourself. This configuration will configure the Supabase components to connect to your PgBouncer instance.

| Parameter                    | Description                                    | Default               |
| ---------------------------- | ---------------------------------------------- | --------------------- |
| `db.pgbouncer.enabled`      | Enable PgBouncer connection configuration     | `false`               |
| `db.pgbouncer.service.name` | PgBouncer service name                         | `""`                  |
| `db.pgbouncer.service.namespace` | PgBouncer service namespace (if different from release namespace) | `""` |
| `db.pgbouncer.service.port` | PgBouncer service port                         | `5432`                |

### Vector Configuration

| Parameter                 | Description                      | Default             |
| ------------------------- | -------------------------------- | ------------------- |
| `vector.enabled`          | Enable Vector deployment         | `true`              |
| `vector.image.repository` | Vector image repository          | `"timberio/vector"` |
| `vector.image.tag`        | Vector image tag                 | `"0.49.X-alpine"`   |
| `vector.image.pullPolicy` | Vector image pull policy         | `"IfNotPresent"`    |
| `vector.service.type`     | Vector service type              | `"ClusterIP"`       |
| `vector.service.port`     | Vector service port              | `9001`              |
| `vector.service.name`     | Vector service name (optional, defaults to release-name-vector) | `""` |
| `vector.service.namespace` | Vector service namespace (optional, for cross-namespace communication) | `""` |
| `vector.extraEnvVars`     | Additional environment variables | `[]`                |



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

### Init Containers

Most components support init containers through the `initContainers` parameter. This is useful for:

- Waiting for dependencies (e.g., database)
- Copying migration files
- Running setup scripts
- Health checks

Example init container configuration:

```yaml
initContainers:
  - name: wait-for-db
    image: busybox:1.35
    command: ['sh', '-c', 'until nc -z {{ include "supabase.fullname" . }}-db 5432; do echo waiting for database; sleep 2; done;']
    resources:
      requests:
        cpu: 10m
        memory: 16Mi
      limits:
        cpu: 100m
        memory: 64Mi
```

### Security Context

The chart provides comprehensive security context configuration at both global and component levels:

- **Global defaults**: Applied to all components unless overridden
- **Component-specific**: Can override global defaults for specific services
- **Modern security**: Uses current Kubernetes security best practices

### Resource Management

Each component can be configured with resource requests and limits:

```yaml
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

### Ingress Configuration

Studio, Kong, and Analytics support ingress configuration for external access:

```yaml
ingress:
  enabled: true
  ingressClassName: nginx
  hostname: my-supabase.example.com
  tls:
    - hosts:
        - my-supabase.example.com
      secretName: my-supabase-tls
```
