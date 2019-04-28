FROM alpine:3.9

ENV CONTAINER_VERSION=1 \
    HANAMI_ENV=production

RUN apk add --no-cache nodejs npm gcc g++ make libc-dev libstdc++ \
      ruby ruby-rake ruby-bigdecimal ruby-json ruby-irb ruby-etc ruby-dev \
      libxml2-dev libxslt-dev postgresql-dev libpq

RUN gem install --no-ri --no-rdoc bundler -v 2.0.1

RUN adduser -D deploy

ADD --chown=deploy:deploy . /app
WORKDIR /app

USER deploy

RUN /usr/bin/bundle install --deployment --without development test

RUN npm run build

CMD ["/usr/bin/bundle", "exec", "rackup", "-o", "0.0.0.0"]
