FROM ubuntu:20.04 as builder
ENV DEBIAN_FRONTEND=noninteractive \
	WATASHI_ENV=production
RUN apt-get update && apt-get install -y chroma make && apt-get clean
ADD . /app
RUN cd /app && make clean all

FROM ghcr.io/blackieops/static:v1.2.1
ADD .static.yaml /config.yaml
COPY --from=builder /app/_build /www
