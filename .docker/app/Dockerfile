FROM harbor.k8s.temple.edu/library/ruby:2.7-alpine

WORKDIR /app

COPY . .

USER root

ARG RAILS_MASTER_KEY

RUN apk add -U --no-cache \
      bash=5.1.8-r0 \
      libxslt=1.1.34-r1 \
      tzdata=2021e-r0 \
      mariadb-connector-c=3.1.13-r2 \
      imagemagick=7.0.11.16-r0 \
      shared-mime-info=2.1-r0 && \
    apk add -U --no-cache --virtual build-dependencies \
      git=2.32.0-r0 \
      build-base=0.5-r2 \
      libxslt-dev=1.1.34-r1 \
      mariadb-dev=10.5.13-r0 \
      nodejs=14.18.1-r0 \
      yarn=1.22.10-r0 && \
    gem install bundler:2.2.27  && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle config set --local without "development test" && \
    bundle install --jobs=8 && \
    find "$GEM_HOME" -name Gemfile.lock -exec rm "{}" \; && \
    find "$GEM_HOME" -name yarn.lock -exec rm "{}" \; && \
    RAILS_ENV=production bundle exec rails assets:precompile && \
    rm -rf node_modules && \
    rm -rf tmp/* && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/ && \
    chown nobody -R /app/tmp && \
    chown nobody -R /app/log

USER nobody

ENTRYPOINT [".docker/app/entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
