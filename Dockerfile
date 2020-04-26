FROM busybox:1.31 AS installer

ARG VERSION="1.18.1"

ADD https://storage.googleapis.com/kubernetes-release/release/v${VERSION}/bin/linux/amd64/kubectl /install/kubectl
COPY --chown=root:root entrypoint.sh /install/entrypoint
RUN chmod 0755 /install/kubectl /install/entrypoint


FROM busybox:1.31

RUN mkdir -p /config && chown -R 1042 /config
COPY --from=installer /install /usr/bin
USER 1042
VOLUME ["/config"]
ENTRYPOINT ["entrypoint"]
CMD ["version", "--short", "--client"]
