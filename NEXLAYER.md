# Nexlayer — n8n

<!-- nexlayer:meta version=1 analyzed=2026-06-26T18:41:38Z repo=https://github.com/armondhonore/n8n branch=nexlayer -->

> **For AI agents (Claude Code, Cursor, Gemini CLI, Copilot):**
> This file is the **project context** for this Nexlayer deployment — tech stack, env vars, secrets, live URL.
> For full platform detail (nexlayer.yaml schema, Dockerfile rules, CI/CD, task recipes) read **`nexlayer.skills`** in this repo.
>
> **Critical rules (full detail in `nexlayer.skills`):**
> - Inter-pod refs: `${podName:port}` only — never `localhost` or bare hostnames
> - Docker Hub images: prefix with `mirror.gcr.io/library/` — bare tags fail on the cluster
> - Secrets: set in the Nexlayer dashboard — never commit to `nexlayer.yaml` or Dockerfile
>
> **This file:** `agent-managed` sections update automatically. `user-editable` sections (Local Development Setup, Nexlayer Deployment Plan, Build Notes) are yours — preserved across re-analysis.

## Project Summary
<!-- nexlayer:section agent-managed=project_summary -->
n8n is a low-code workflow automation platform that allows users to build complex automations using a visual editor and AI-native capabilities. It supports a vast library of integrations and provides an extensible environment for JavaScript and Python coding.
<!-- nexlayer:end -->

## Technology Stack
<!-- nexlayer:section agent-managed=tech_stack -->
| Name | Kind | Version | Detected From |
|------|------|---------|---------------|
| TypeScript | language | unknown | tsconfig.json, package.json |
| Node.js | language | >=18 | Dockerfile, README.md |
| TurboRepo | build | unknown | turbo.json |
| pnpm | tool | unknown | pnpm-lock.yaml, pnpm-workspace.yaml |
| PostgreSQL | database | unknown | .tbls.postgres.yml |
| SQLite | database | unknown | .tbls.sqlite.yml |
<!-- nexlayer:end -->

## Repository Structure
<!-- nexlayer:section agent-managed=structure_map -->
- packages/ — Monorepo packages containing the core logic and editor UI
- packages/cli/ — Command line interface for starting n8n
- packages/core/ — Core workflow engine and orchestration logic
- packages/nodes-base/ — The extensive library of integration nodes
- packages/editor-ui/ — The visual frontend for building workflows
- scripts/ — Build and deployment utility scripts
<!-- nexlayer:end -->

## External Services Required
<!-- nexlayer:section agent-managed=external_deps -->
Services that must be configured separately (not deployed by Nexlayer):

- LangChain (AI Orchestration)
- npm registry (for dynamic package loading)
<!-- nexlayer:end -->

## Local Development Setup
<!-- nexlayer:section user-editable=local_setup -->
### Prerequisites

- Node.js >= 22.22
- pnpm >= 10.22.0

### Environment variables

Copy `.env.example` to `.env.local` and fill in:

```
N8N_USER_FOLDER=/home/node/.n8n
N8N_LICENSE_TENANT_ID=local-dev
DATABASE_URL=postgresql://user:pass@localhost:5432/n8n
```

### Steps

1. `pnpm install` — Install monorepo dependencies
2. `pnpm build` — Build all packages using Turbo
3. `pnpm dev` — Start development servers in parallel

<!-- nexlayer:end -->

## Nexlayer Setup
<!-- nexlayer:section agent-managed=nexlayer_setup -->
### Pod Environment Variables

| Pod | Variable | Value | Kind |
|-----|----------|-------|------|
| `app` | `NODE_ENV` | `production` | plain |
| `app` | `N8N_PORT` | `"5678"` | plain |
| `app` | `N8N_ENCRYPTION_KEY` | `${N8N_ENCRYPTION_KEY}` | inter-pod |
| `app` | `DB_TYPE` | `postgresdb` | plain |
| `app` | `DB_POSTGRESDB_HOST` | `postgres.pod` | plain |
| `app` | `DB_POSTGRESDB_PORT` | `"5432"` | plain |
| `app` | `DB_POSTGRESDB_DATABASE` | `n8n` | plain |
| `app` | `DB_POSTGRESDB_USER` | `n8n_user` | plain |
| `app` | `DB_POSTGRESDB_PASSWORD` | `${POSTGRES_PASSWORD}` | inter-pod |
| `postgres` | `POSTGRES_DB` | `n8n` | plain |
| `postgres` | `POSTGRES_USER` | `n8n_user` | plain |
| `postgres` | `POSTGRES_PASSWORD` | `${POSTGRES_PASSWORD}` | inter-pod |
| `n8n-postgres-data` | `size` | `10Gi` | plain |
| `n8n-postgres-data` | `mountPath` | `/var/lib/postgresql` | plain |

### nexlayer.yaml

```yaml
application:
  name: n8n
  pods:
    - name: app
      image: "registry.nexlayer.io/user_01kece1xyh817dwff7wnarhkxd/n8n:9f0597f-fix8"
      path: /
      servicePorts:
        - 5678
      vars:
        NODE_ENV: production
        N8N_PORT: "5678"
        N8N_ENCRYPTION_KEY: ${N8N_ENCRYPTION_KEY}
        DB_TYPE: postgresdb
        DB_POSTGRESDB_HOST: postgres.pod
        DB_POSTGRESDB_PORT: "5432"
        DB_POSTGRESDB_DATABASE: n8n
        DB_POSTGRESDB_USER: n8n_user
        DB_POSTGRESDB_PASSWORD: ${POSTGRES_PASSWORD}
    - name: postgres
      image: mirror.gcr.io/library/postgres:16-alpine
      servicePorts:
        - 5432
      vars:
        POSTGRES_DB: n8n
        POSTGRES_USER: n8n_user
        POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      volumes:
        - name: n8n-postgres-data
          size: 10Gi
          mountPath: /var/lib/postgresql
```
<!-- nexlayer:end -->

## Nexlayer Deployment Plan
<!-- nexlayer:section user-editable=deployment_plan -->
### Pod Topology

| Pod | Image | Port | Role |
|-----|-------|------|------|
| n8n | mirror.gcr.io/library/node:22-alpine | 5678 | web |
| postgres | mirror.gcr.io/library/postgres:16-alpine | 5432 | database |

### Deployment notes

- The n8n application pod connects to the database using the Nexlayer pattern: postgres.pod:5432
- Node.js 22-alpine is used as the base image to comply with official mirror requirements
- Persistence for n8n user data should be mapped to /home/node/.n8n

<!-- nexlayer:end -->

## Build Notes
<!-- nexlayer:section user-editable=build_notes -->
<!-- Add notes for future builds here — preserved across re-analysis -->
<!-- nexlayer:end -->

## Nexlayer Configuration
<!-- nexlayer:section agent-managed=nexlayer_config -->
**Last deployed:** 2026-06-26T21:12:26Z  
**Live URL:** https://relaxed-weasel-n8n.cloud.nexlayer.ai  
**Runtime:**  · **Port:** auto-detected  
**Deploy branch:** nexlayer  

```yaml
application:
  name: n8n
  pods:
    - name: app
      image: "registry.nexlayer.io/user_01kece1xyh817dwff7wnarhkxd/n8n:9f0597f-fix8"
      path: /
      servicePorts:
        - 5678
      vars:
        NODE_ENV: production
        N8N_PORT: "5678"
        N8N_ENCRYPTION_KEY: ${N8N_ENCRYPTION_KEY}
        DB_TYPE: postgresdb
        DB_POSTGRESDB_HOST: postgres.pod
        DB_POSTGRESDB_PORT: "5432"
        DB_POSTGRESDB_DATABASE: n8n
        DB_POSTGRESDB_USER: n8n_user
        DB_POSTGRESDB_PASSWORD: ${POSTGRES_PASSWORD}
    - name: postgres
      image: mirror.gcr.io/library/postgres:16-alpine
      servicePorts:
        - 5432
      vars:
        POSTGRES_DB: n8n
        POSTGRES_USER: n8n_user
        POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      volumes:
        - name: n8n-postgres-data
          size: 10Gi
          mountPath: /var/lib/postgresql
```
<!-- nexlayer:end -->

## Build History
<!-- nexlayer:section agent-managed=build_history -->
| Date | Status | Notes |
|------|--------|-------|
| 2026-06-26T20:21:44Z | analyzed | initial repo analysis |
| 2026-06-26T21:12:26Z | success | deployed https://relaxed-weasel-n8n.cloud.nexlayer.ai |
<!-- nexlayer:end -->


