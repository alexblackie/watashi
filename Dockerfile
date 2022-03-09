FROM ubuntu:20.04 as builder
ENV DEBIAN_FRONTEND=noninteractive \
	WATASHI_ENV=production
RUN apt-get update && apt-get install -y chroma make && apt-get clean
ADD . /app
RUN cd /app && make clean all

FROM cr.b8s.dev/library/static:v1.0.0
ADD .static.yaml /config.yaml
COPY --from=builder /app/_build /www
