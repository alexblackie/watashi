FROM ubuntu:bionic
RUN apt-get update && apt-get install -y make && apt-get clean && rm -rf /var/cache/apt
ADD . /app
WORKDIR /app
RUN make

FROM nginx:1.17
COPY --from=0 /app/_build /usr/share/nginx/html/
