# aws-eks-mcp-server

Docker setup for an MCP server based on `containers/kubernetes-mcp-server` with AWS CLI in a minimal runtime image.

## Intention

- The upstream base image does not have AWS compatibility for switching roles in a multi-cluster setup. Therefore we are using the aws-cli.

## Contents

- Base application binary copied from `ghcr.io/containers/kubernetes-mcp-server`
- Runtime image based on `public.ecr.aws/aws-cli/aws-cli`

## Requirements

- Docker

## Build the image

```sh
docker build -t aws-eks-mcp-server:latest .
```

## Run the container

```sh
docker run --rm -it -p 8080:8080 ghcr.io/arvatoaws-labs/aws-eks-mcp-server:latest
```

## Quick tool check inside the container

```sh
docker run --rm --entrypoint sh ghcr.io/arvatoaws-labs/aws-eks-mcp-server:latest -lc "/app/kubernetes-mcp-server --help >/dev/null && aws --version"
```

## AWS CLI note

If your deployment uses a read-only root filesystem, AWS CLI needs a writable path for config/cache (for example a writable mount used for AWS config files).

## Licenses

- Project license: Apache License 2.0 (see `LICENSE`)
- Third-party notices: see `THIRD_PARTY_NOTICES`

