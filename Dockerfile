# Build stage - get compiled Python environment
FROM public.ecr.aws/awslabs-mcp/awslabs/eks-mcp-server:0.1.32 AS source

# Final minimal image - Chainguard Python (secure, minimal, glibc-compatible)
FROM amazonlinux:latest

WORKDIR /app

# Copy entire app directory from source (includes .venv and all app files)
COPY --from=source /app /app

# Copy local dependencies
COPY --from=source /root/.local /root/.local

ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1

ENTRYPOINT ["awslabs.eks-mcp-server"]

# # Base Image for the MCP stuff
# FROM flux159/mcp-server-kubernetes:v3.9.1 AS source

# # Final Image for the whole app
# FROM node:24-alpine

# ENV NODE_ENV=production
# WORKDIR /usr/local/app

# # App from Upstream-Image
# COPY --from=source /usr/local/app /usr/local/app

# # Install awscli and kubectl
# RUN apk add --no-cache \
#     ca-certificates \
#     aws-cli \
#     kubectl

# CMD ["node", "dist/index.js"]