FROM caddy:2.8-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/mholt/caddy-l4 \
    --with github.com/RussellLuo/caddy-ext/layer4

FROM caddy:2.8-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy