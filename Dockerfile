# Build stage - get compiled Python environment
FROM public.ecr.aws/awslabs-mcp/awslabs/eks-mcp-server:0.1.32 AS source

# Final minimal image
FROM python:3.14-alpine

WORKDIR /app

# Copy entire app directory from source (includes .venv and all app files)
COPY --from=source /app /app

# Copy local dependencies
COPY --from=source /root/.local /root/.local

ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1

ENTRYPOINT ["awslabs.eks-mcp-server"]