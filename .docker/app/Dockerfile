FROM harbor.k8s.temple.edu/library/ruby:2.7-alpine as builder

WORKDIR /app

COPY . .

USER root

RUN apk add --update --no-cache bash=5.1.0-r0 tzdata=2021a-r0 libxslt-dev=1.1.34-r0 mariadb-dev=10.5.8-r0 && \
    apk add --no-cache --virtual build-dependencies git=-2.30.0-r0build-base=0.5-r2 && \
    gem install bundler:2.2.2  && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle config set --local without "development test" && \
    bundle install --jobs=8 && \
    find "$GEM_HOME" -name Gemfile.lock -exec rm "{}" \; && \
    find "$GEM_HOME" -name yarn.lock -exec rm "{}" \; && \
    apk del build-dependencies && \
    chown nobody -R /app/tmp && \
    chown nobody -R /app/log && \
    rm -rf /var/cache/apk/

USER nobody

ENTRYPOINT [".docker/app/entrypoint.sh"]
EXPOSE 3000

CMD ["rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3000"]
