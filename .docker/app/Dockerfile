# busybox and ssl_client can be removed once alpine image update resolves them

# For circleci this arg gets overridden by value in the .env file.
ARG BASE_IMAGE="harbor.k8s.temple.edu/library/ruby:3.1-alpine" \
  RAILS_MASTER_KEY=foobar \
  RAILS_ENV=production

# hadolint ignore=DL3006,DL3026
FROM "${BASE_IMAGE}"

WORKDIR /app

COPY . .

USER root

# libc6-compat is added to allow m1 build of nokogiri
RUN apk add -U --no-cache \
      bash=5.2.15-r0 \
      imagemagick=7.1.0.52-r0 \
      busybox=1.35.0-r29 \ 
      libc6-compat=1.2.3-r4 \
      libxslt=1.1.37-r0 \
      mariadb-connector-c=3.3.3-r0 \
      shared-mime-info=2.2-r2 \
      tzdata=2022f-r1 && \
      ssl_client=1.35.0-r15 \
    apk add -U --no-cache --virtual build-dependencies \
      git=2.38.2-r0 \
      build-base=0.5-r3 \
      libxslt-dev=1.1.37-r0 \
      mariadb-dev=10.6.11-r0 \
      nodejs=18.12.1-r0 \
      yarn=1.22.19-r0 && \
    if [ "${RAILS_ENV}" = "production" ]; then bundle config set --local without "development test"; fi && \
    bundle install --jobs=8 && \
    find "$GEM_HOME" -name Gemfile.lock -exec rm "{}" \; && \
    find "$GEM_HOME" -name yarn.lock -exec rm "{}" \; && \
    bundle exec rails assets:precompile && \
    if [ "${RAILS_ENV}" = "production" ]; then rm -rf node_modules; fi && \
    if [ "${RAILS_ENV}" = "production" ]; then rm -rf tmp/*; fi && \
    if [ "${RAILS_ENV}" = "production" ]; then apk del build-dependencies; fi && \
    rm -rf /var/cache/apk/ && \
    chown nobody -R /app/tmp && \
    chown nobody -R /app/log

USER nobody

ENTRYPOINT [".docker/app/entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
