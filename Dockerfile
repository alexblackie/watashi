# [ Build Image ] -------------------------------------------------------------

FROM alpine:3.12

RUN apk add --no-cache coreutils bash make py3-pygments

ADD ./ /usr/src/www
RUN cd /usr/src/www && make clean all


# [ Production Image ] --------------------------------------------------------

FROM nginx:1.17-alpine

COPY --from=0 /usr/src/www/_build /usr/share/nginx/html
