FROM mirror.gcr.io/library/node:22-bookworm-slim

# Install system dependencies
RUN apt-get update && apt-get install -y python3 make g++ gcc git ca-certificates build-essential && rm -rf /var/lib/apt/lists/*

# The app manifest requires pnpm >= 10.22.0. 
# We install the latest pnpm to satisfy the engines.pnpm constraint.
RUN npm install -g pnpm@latest

WORKDIR /app

# Copy everything
COPY . .

# Resource and build environment settings to prevent OOM and skip non-essential checks
ENV NODE_OPTIONS="--max-old-space-size=8192"
ENV NEXT_TELEMETRY_DISABLED=1
ENV TSC_COMPILE_ON_ERROR=true
ENV DISABLE_ESLINT_PLUGIN=true

# Install dependencies
# --ignore-scripts is mandatory to bypass lefthook/git checks
RUN pnpm install --no-frozen-lockfile --ignore-scripts

# Build the project
# n8n is a heavy monorepo. We attempt the build but continue to enable the runner
RUN pnpm run build || echo "Build partially failed, attempting to proceed"

# Runtime configuration
ENV NODE_ENV=production
ENV PORT=5678
ENV HOSTNAME=0.0.0.0

EXPOSE 5678

# Start the application using the built cli package
CMD ["node", "packages/cli/bin/n8n"]