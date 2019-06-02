FROM node:12
ADD . /app
WORKDIR /app
RUN npm install && npm run build

FROM nginx
COPY --from=0 /app/public /usr/share/nginx/html/
