FROM ubuntu:20.04 as builder
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y chroma make && apt-get clean
ADD . /app
RUN cd /app && make clean all

FROM nginx:1.19-alpine
COPY --from=builder /app/_build /usr/share/nginx/html
