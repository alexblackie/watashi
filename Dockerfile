FROM nginx:latest
RUN rm /etc/nginx/conf.d/default.conf
RUN echo "server { \
	listen 80; \
	server_name localhost; \
	root /srv/www/; \
	location / { \
		ssi on; \
		index index.shtml; \
	} \
}" > /etc/nginx/conf.d/self.conf
RUN mkdir /srv/www
VOLUME /srv/www
EXPOSE 80
