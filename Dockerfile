FROM alpine:3.10 AS builder

RUN apk add wget ca-certificates

ARG KUBECTL_VERSION="1.16.2"
ARG KUSTOMIZE_VERSION="3.2.1"
ARG HELM_VERSION="2.15.0"

RUN set -ex \
  ; KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  ; wget -q "${KUBECTL_URL}" -O kubectl \
  ; chmod 0755 kubectl \
  ; mv kubectl /usr/local/bin/kubectl \
  ; kubectl version --short --client

RUN set -ex \
  ; KUSTOMIZE_BASE_URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}" \
  ; KUSTOMIZE_BINARY="kustomize_kustomize.v${KUSTOMIZE_VERSION}_linux_amd64" \
  ; KUSTOMIZE_CHECKSUMS="checksums.txt" \
  ; wget "${KUSTOMIZE_BASE_URL}/${KUSTOMIZE_BINARY}" \
  ; wget "${KUSTOMIZE_BASE_URL}/${KUSTOMIZE_CHECKSUMS}" \
  ; SHA256SUM=`grep linux_amd64 ${KUSTOMIZE_CHECKSUMS} | cut -d' ' -f1` \
  ; echo "${SHA256SUM}  ${KUSTOMIZE_BINARY}" | sha256sum -c - \
  ; chmod 0755 ${KUSTOMIZE_BINARY} \
  ; mv ${KUSTOMIZE_BINARY} /usr/local/bin/kustomize \
  ; ls -la /usr/local/bin/ \
  ; kustomize version

RUN set -ex \
  ; HELM_BASE_URL="https://get.helm.sh" \
  ; HELM_PACKAGE="helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
  ; HELM_CHECKSUMS="${HELM_PACKAGE}.sha256" \
  ; wget "${HELM_BASE_URL}/${HELM_PACKAGE}" \
  ; wget "${HELM_BASE_URL}/${HELM_CHECKSUMS}" \
  ; SHA256SUM=`cat ${HELM_CHECKSUMS}` \
  ; echo "${SHA256SUM}  ${HELM_PACKAGE}" | sha256sum -c - \
  ; tar xzf ${HELM_PACKAGE} \
  ; mv ./linux-amd64/helm /usr/local/bin/helm \
  ; chmod 0755 /usr/local/bin/helm \
  ; ls -la /usr/local/bin/ \
  ; helm version --client --short

COPY scripts /scripts

RUN set -ex \
  ; chmod 0755 /scripts/* \
  ; cp /scripts/* /usr/local/bin/

FROM alpine:3.10

COPY --from=builder /usr/local/bin /usr/local/bin

RUN set -ex \
  ; apk add --no-cache git openssl \
  ; git --version \
  ; openssl version
