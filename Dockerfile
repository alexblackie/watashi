FROM nginx:alpine

ADD . /srv/www

RUN echo "server { \
	listen 80; \
	server_name localhost; \
	root /srv/www; \
	location / { \
		ssi on; \
		index index.shtml index.html; \
	} \
}" > /etc/nginx/conf.d/default.conf

EXPOSE 80
