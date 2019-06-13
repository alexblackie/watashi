FROM ubuntu:bionic
ADD . /app
WORKDIR /app
RUN ./build.sh

FROM nginx:1.17
COPY --from=0 /app/_build /usr/share/nginx/html/
