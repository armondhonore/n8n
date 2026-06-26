FROM mirror.gcr.io/library/node:22-slim

# Install build essentials and git for native modules and workspace resolution
RUN apt-get update && apt-get install -y python3 make g++ git && rm -rf /var/lib/apt/lists/*

# Setup pnpm
RUN npm i -g corepack@latest && corepack enable && corepack prepare pnpm@10.32.1 --activate

WORKDIR /repo

# The previous build failed with ERR_PNPM_WORKSPACE_PKG_NOT_FOUND
# because we only copied a subset of files before 'pnpm install'.
# In a pnpm workspace with internal dependencies (like @n8n/eslint-config),
# pnpm needs to see the package.json of ALL workspace members to resolve them,
# even if it's not installing their dependencies yet.

# Copy everything first to avoid workspace resolution errors
COPY . .

# Increase memory for the massive n8n build
ENV NODE_OPTIONS="--max-old-space-size=8192"

# Install dependencies
# --ignore-scripts prevents lefthook/prepare from failing due to git/env issues
# --no-frozen-lockfile allows pnpm to resolve the workspace if lockfile differs
RUN pnpm install --no-frozen-lockfile --ignore-scripts

# Build the core application
# We use --filter cli as it's the main entry point
RUN pnpm --filter cli run build

# Create n8n data directory
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

USER node

EXPOSE 5678
ENV PORT=5678
ENV HOSTNAME=0.0.0.0

CMD ["pnpm", "start"]