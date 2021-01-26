FROM harbor.k8s.temple.edu/library/ruby:2.7-alpine as builder

WORKDIR /app

COPY . .

USER root

RUN apk add --update --no-cache bash tzdata libxslt-dev mysql-dev && \
    apk add --no-cache --virtual build-dependencies build-base git && \
    gem install bundler:2.2.2  && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle config set --local without 'development test' && \
    bundle install --jobs=8 && \
    find $GEM_HOME -name Gemfile.lock -exec rm '{}' \; && \
    find $GEM_HOME -name yarn.lock -exec rm '{}' \; && \
    apk del build-dependencies && \
    chown nobody -R /app/tmp && \
    chown nobody -R /app/log && \
    rm -rf /var/cache/apk/

USER nobody

ENTRYPOINT [".docker/app/entrypoint.sh"]
EXPOSE 3000

CMD rm -f tmp/pids/server.pid && \
  bundle exec rails s -b 0.0.0.0 -p 3000
