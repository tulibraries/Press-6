FROM harbor.k8s.temple.edu/library/ruby:2.7-alpine

WORKDIR /app

COPY . .

USER root

ARG RAILS_MASTER_KEY

RUN apk add -U --no-cache \
      bash=5.1.0-r0 \
      tzdata=2021a-r0 \
      libxslt-dev=1.1.34-r0 \
      mariadb-dev=10.5.8-r0 && \
    apk add -U --no-cache --virtual build-dependencies \
      git=2.30.1-r0 \
      build-base=0.5-r2 \
      nodejs=14.16.0-r0 \
      yarn=1.22.10-r0 && \
    gem install bundler:2.2.4  && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle config set --local without "development test" && \
    bundle install --jobs=8 && \
    find "$GEM_HOME" -name Gemfile.lock -exec rm "{}" \; && \
    find "$GEM_HOME" -name yarn.lock -exec rm "{}" \; && \
    RAILS_ENV=production bundle exec rails assets:precompile && \
    rm -rf app/node_modules && \
    rm -rf app/tmp/* && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/ && \
    chown nobody -R /app/tmp && \
    chown nobody -R /app/log

USER nobody

ENTRYPOINT [".docker/app/entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
