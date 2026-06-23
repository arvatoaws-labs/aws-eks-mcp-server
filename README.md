# aws-eks-mcp-server

Docker setup for an MCP server based on `containers/kubernetes-mcp-server` with AWS CLI in a minimal runtime image.

## Intention

- The upstream base image includes many tools that are not needed for our AWS EKS use case.
- The upstream base image is larger than necessary for this deployment.
- The upstream base image has more vulnerabilities due to unnecessary tools and additional base image layers.

## Contents

- Base application binary copied from `ghcr.io/containers/kubernetes-mcp-server:v0.0.63`
- Runtime image based on `public.ecr.aws/aws-cli/aws-cli`
- Additional tools included in the container:
	- `aws-cli`

## Requirements

- Docker

## Build the image

```sh
docker build -t aws-eks-mcp-server:latest .
```

## Run the container

```sh
docker run --rm -it -p 8080:8080 aws-eks-mcp-server:latest
```

## Quick tool check inside the container

```sh
docker run --rm --entrypoint sh aws-eks-mcp-server:latest -lc "/app/kubernetes-mcp-server --help >/dev/null && aws --version"
```

## AWS CLI note

If your deployment uses a read-only root filesystem, AWS CLI needs a writable path for config/cache (for example a writable mount used for AWS config files).

## Licenses

- Project license: Apache License 2.0 (see `LICENSE`)
- Third-party notices: see `THIRD_PARTY_NOTICES`

