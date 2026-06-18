FROM flux159/mcp-server-kubernetes:v3.5.0 AS source

FROM debian:bookworm-slim AS tools
# ARG TARGETARCH=arm64
ARG KUBECTL_APT_MINOR=v1.36
ARG HELM_VERSION=v4.2.2
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      gnupg \
      tar \
      apt-transport-https \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/apt/keyrings /out

RUN curl -fsSL "https://pkgs.k8s.io/core:/stable:/${KUBECTL_APT_MINOR}/deb/Release.key" \
 | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg \
 && chmod 0644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

RUN echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBECTL_APT_MINOR}/deb/ /" \
 > /etc/apt/sources.list.d/kubernetes.list \
 && chmod 0644 /etc/apt/sources.list.d/kubernetes.list

RUN apt-get update \
 && apt-get install -y --no-install-recommends kubectl \
 && install -m 0755 /usr/bin/kubectl /out/kubectl \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && apt-get install -y --no-install-recommends awscli \
 && rm -rf /var/lib/apt/lists/*

# RUN curl -fsSLo /tmp/helm.tgz \
#     "https://get.helm.sh/helm-${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" \
#  && tar -xzf /tmp/helm.tgz -C /tmp \
#  && install -m 0755 "/tmp/linux-${TARGETARCH}/helm" /out/helm \
#  && rm -rf /tmp/helm.tgz "/tmp/linux-${TARGETARCH}"

FROM node:24-bookworm-slim
# FROM node:24-alpine

ENV NODE_ENV=production
WORKDIR /usr/local/app

# App aus dem Upstream-Image
COPY --from=source /usr/local/app /usr/local/app

# Nur die benötigten Tools
COPY --from=tools /out/kubectl /usr/local/bin/kubectl
# COPY --from=tools /out/helm /usr/local/bin/helm

# Eigener eingeschränkter User
RUN useradd --create-home --uid 10001 --shell /usr/sbin/nologin appuser \
 && chown -R 10001:10001 /usr/local/app

# RUN addgroup -g 10001 -S appuser \
#   && adduser -S -D -H -u 10001 -G appuser appuser \
#   && chown -R 10001:10001 /usr/local/app

USER 10001:10001

CMD ["node", "dist/index.js"]