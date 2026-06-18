FROM flux159/mcp-server-kubernetes:v3.5.0 AS source

FROM debian:bookworm-slim AS tools
ARG TARGETARCH
ARG KUBECTL_APT_MINOR=v1.36
# ARG HELM_VERSION=v4.2.2
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

# RUN curl -fsSLo /tmp/helm.tgz \
#     "https://get.helm.sh/helm-${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" \
#  && tar -xzf /tmp/helm.tgz -C /tmp \
#  && install -m 0755 "/tmp/linux-${TARGETARCH}/helm" /out/helm \
#  && rm -rf /tmp/helm.tgz "/tmp/linux-${TARGETARCH}"

FROM node:24-bookworm-slim
ARG TARGETARCH

ENV NODE_ENV=production
WORKDIR /usr/local/app

# App from Upstream-Image
COPY --from=source /usr/local/app /usr/local/app

# Only the necessary tools
COPY --from=tools /out/kubectl /usr/local/bin/kubectl
# COPY --from=tools /out/helm /usr/local/bin/helm

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      unzip \
 && rm -rf /var/lib/apt/lists/*

RUN target_arch="${TARGETARCH:-$(dpkg --print-architecture)}" \
 && AWSCLI_ARCH=x86_64 \
 && [ "${target_arch}" = "arm64" ] && AWSCLI_ARCH=aarch64 || true \
 && curl -fsSLo /tmp/awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}.zip" \
 && unzip -q /tmp/awscliv2.zip -d /tmp \
 && /tmp/aws/install --install-dir /usr/local/aws-cli --bin-dir /usr/local/bin \
 && rm -rf /tmp/aws /tmp/awscliv2.zip

CMD ["node", "dist/index.js"]