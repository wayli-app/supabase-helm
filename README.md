# Supabase Helm Chart

This Helm chart deploys a complete Supabase stack on Kubernetes.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Installing the Chart

```bash
helm install my-supabase ./charts/supabase
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
| `db.postgres.secretKeys.userPasswordKey` | Key in existing secret for PostgreSQL password | `"password"`          |

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
