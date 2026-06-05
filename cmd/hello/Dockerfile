FROM ghcr.io/vungle/alpine:3.19
ARG TARGETARCH

RUN echo "target arch is ${TARGETARCH}" \
    && apk add -q --update \
    && apk add -q \
            bash \
            curl \
    && rm -rf /var/cache/apk/*

COPY ./_out/hello_${TARGETARCH} /hello

USER 1010
ENTRYPOINT ["/hello"]
