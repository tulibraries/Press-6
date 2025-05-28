# For circleci this arg gets overridden via configuration.
ARG BASE_IMAGE="harbor.k8s.temple.edu/library/ruby:3.4-alpine" \
  RAILS_MASTER_KEY=foobar \
  RAILS_ENV=production

# hadolint ignore=DL3006,DL3026
FROM "${BASE_IMAGE}"

WORKDIR /app

COPY . .

ENV LD_PRELOAD="libjemalloc.so.2" \
      MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true" \
      RUBY_YJIT_ENABLE="1" \
      TMPDIR=/app/tmp \
      SKIP_TMPDIR_INIT=1

USER root

# gcompat is added to allow m1 build of nokogiri
RUN apk add -U --no-cache \
      jemalloc=5.3.0-r6 \
      bash=5.2.37-r0 \
      busybox=1.37.0-r12 \
      gcompat=1.1.0-r4 \
      imagemagick=7.1.1.41-r0 \
      libxslt=1.1.42-r2 \
      postgresql16-client=16.9-r0 \
      shared-mime-info=2.4-r2 \
      ssl_client=1.37.0-r12 \
      tzdata=2025b-r0 && \
    apk add -U --no-cache --virtual build-dependencies \
      build-base=0.5-r3 \
      yaml=0.2.5-r2 \
      yaml-dev=0.2.5-r2 \
      git=2.47.2-r0 \
      libjpeg-turbo-dev=3.0.4-r0 \
      libxslt-dev=1.1.42-r2 \
      libxml2-dev=2.13.4-r6 \
      postgresql16-dev=16.9-r0 \
      nodejs=22.13.1-r0 \
      yarn=1.22.22-r1 && \
    if [ "${RAILS_ENV}" = "production" ]; then bundle config set --local without "development test"; fi && \
    bundle install --jobs=8 && \
    find "$GEM_HOME" -name Gemfile.lock -exec rm "{}" \; && \
    find "$GEM_HOME" -name yarn.lock -exec rm "{}" \; && \
    bundle exec rails assets:precompile && \
    if [ "${RAILS_ENV}" = "production" ]; then rm -rf node_modules; fi && \
    if [ "${RAILS_ENV}" = "production" ]; then rm -rf tmp/*; fi && \
    if [ "${RAILS_ENV}" = "production" ]; then apk del build-dependencies; fi && \
    rm -rf /var/cache/apk/

    RUN mkdir -p /app/tmp \
    chown nobody -R /app/tmp

USER nobody

ENTRYPOINT [".docker/app/entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
