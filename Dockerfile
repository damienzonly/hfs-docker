FROM node:20-alpine AS builder

WORKDIR /build

ARG version
ARG TARGETARCH

RUN apk add --update build-base git jq zip
RUN git clone https://github.com/rejetto/hfs; \
    cd hfs; \
    git checkout "$version"; \
    npm i; \
    npm audit fix; \
    npm run build-all; \
    npm run dist-pre; \
    cd dist; \
    crc="$TARGETARCH"; \
    if [[ "$TARGETARCH" == "amd64" ]]; then crc="x64"; fi; \
    npm i -f --no-save --omit=dev @node-rs/crc32-linux-$crc-gnu; \
    npx pkg . --public -C gzip -t node18-alpine-$crc

FROM alpine:3.20
WORKDIR /app
RUN apk add --update zip
RUN adduser -h /home/hfs -D hfs hfs && \
    mkdir /home/hfs/.hfs && \
    cd /home/hfs/.hfs && \
    touch config.yaml && \
    chown -R hfs /home/hfs/.hfs
USER hfs
COPY --from=builder /build/hfs/dist/hfs hfs
ENTRYPOINT [ "/app/hfs" ]