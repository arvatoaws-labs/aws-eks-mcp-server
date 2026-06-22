# Build stage - extract the Kubernetes MCP server binary
FROM ghcr.io/containers/kubernetes-mcp-server:latest AS source

# Final minimal image with Amazon Linux
# FROM amazonlinux:latest
FROM amazon/aws-cli:latest

WORKDIR /app

# Copy the kubernetes-mcp-server binary from source
COPY --from=source /app/kubernetes-mcp-server /app/kubernetes-mcp-server

# Expose port 8080 (default HTTP/SSE port for the MCP server)
EXPOSE 8080

# Set the binary as entrypoint with default port 8080
ENTRYPOINT ["/app/kubernetes-mcp-server"]
CMD ["--port", "8080"]