# Base Image for the MCP stuff
FROM flux159/mcp-server-kubernetes:v3.5.0 AS source

# Final Image for the whole app
FROM node:24-alpine

ENV NODE_ENV=production
WORKDIR /usr/local/app

# App from Upstream-Image
COPY --from=source /usr/local/app /usr/local/app

# Install awscli and kubectl
RUN apk add --no-cache \
    ca-certificates \
    aws-cli \
    kubectl

CMD ["node", "dist/index.js"]