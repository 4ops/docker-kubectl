FROM alpine:3.10 AS builder

RUN apk add wget ca-certificates

ARG KUBECTL_VERSION="1.15.2"
ARG KUSTOMIZE_VERSION="3.1.0"

RUN set -ex \
  ; KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  ; wget -q "${KUBECTL_URL}" -O kubectl \
  ; chmod 0755 kubectl \
  ; mv kubectl /usr/local/bin/kubectl \
  ; kubectl version --short --client

RUN set -ex \
  ; KUSTOMIZE_BASE_URL="https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VERSION}" \
  ; KUSTOMIZE_BINARY="kustomize_${KUSTOMIZE_VERSION}_linux_amd64" \
  ; KUSTOMIZE_CHECKSUMS="checksums.txt" \
  ; wget "${KUSTOMIZE_BASE_URL}/${KUSTOMIZE_BINARY}" \
  ; wget "${KUSTOMIZE_BASE_URL}/${KUSTOMIZE_CHECKSUMS}" \
  ; grep "${KUSTOMIZE_BINARY}" $KUSTOMIZE_CHECKSUMS | sha256sum -c - \
  ; chmod 0755 $KUSTOMIZE_BINARY \
  ; mv $KUSTOMIZE_BINARY /usr/local/bin/kustomize \
  ; ls -la /usr/local/bin/ \
  ; kustomize version

FROM alpine:3.10

COPY --from=builder /usr/local/bin /usr/local/bin
