# aws-eks-mcp-server

Docker setup for an MCP server based on `flux159/mcp-server-kubernetes` with additional AWS and Kubernetes CLI tools.

## Intention

- The upstream base image includes many tools that are not needed for our AWS EKS use case.
- The upstream base image is larger than necessary for this deployment.
- The upstream base image has more vulnerabilities due to unnecessary tools and additional base image layers.

## Contents

- Base application from `flux159/mcp-server-kubernetes`
- Runtime image based on `node:24-alpine`
- Additional tools included in the container:
	- `aws-cli`
	- `kubectl`

## Requirements

- Docker

## Build the image

```sh
docker build -t aws-eks-mcp-server:latest .
```

## Run the container

```sh
docker run --rm -it aws-eks-mcp-server:latest
```

## Quick tool check inside the container

```sh
docker run --rm --entrypoint sh aws-eks-mcp-server:latest -lc "node --version && aws --version && kubectl version --client=true"
```

## AWS CLI note

If your deployment uses a read-only root filesystem, AWS CLI needs a writable path for config/cache (for example mounted at `/home/node/.aws`).

## Licenses

- Project license: see `LICENSE`
- Third-party notices: see `THIRD_PARTY_NOTICES`

