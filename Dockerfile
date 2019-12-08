FROM nginx:1.17

RUN apt-get update && apt-get install --no-install-recommends -y make && apt-get clean && rm -Rf /var/cache/apt

ADD ./ /usr/src/www
RUN cd /usr/src/www && make clean all && cp -a ./_build/* /usr/share/nginx/html/
