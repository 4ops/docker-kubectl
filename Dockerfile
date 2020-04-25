FROM busybox:1.31 AS installer
ADD https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/linux/amd64/kubectl /kubectl
RUN chmod 0755 /kubectl

FROM scratch
COPY --from=installer /kubectl /kubectl
USER 1042
ENTRYPOINT ["/kubectl"]
