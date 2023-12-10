FROM debian:12-slim as builder
ENV HUGO_ENVIRONMENT=production \
    HUGO_VERSION=0.121.1
RUN apt-get update && apt install -y curl && apt-get clean
RUN curl -SsL "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" | \
    tar xzvf - && \
    mv hugo /usr/bin
ADD . /app
WORKDIR /app
RUN /usr/bin/hugo

FROM ghcr.io/blackieops/static:v1.3.0
ADD .static.yaml /config.yaml
COPY --from=builder /app/public /www
