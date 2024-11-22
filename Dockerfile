FROM alpine:3.14

RUN mkdir -p /tmp/uploads/
RUN chmod 666 /tmp/uploads/

ARG SERVICE

# copy go binary
COPY  /home/runner/go/bin/slydell/$SERVICE ./app
# copy brotli
COPY /usr/local/lib/libbrotli* /usr/local/lib/.
COPY /usr/local/include/brotli /usr/local/include/.
RUN ls -la /usr/local/include/

EXPOSE 80
ENTRYPOINT ["/app"]


