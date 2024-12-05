# For circleci this arg gets overridden via configuration.
ARG BASE_IMAGE="harbor.k8s.temple.edu/library/ruby:3.3-alpine" \
  RAILS_MASTER_KEY=foobar \
  RAILS_ENV=production

# hadolint ignore=DL3006,DL3026
FROM "${BASE_IMAGE}"

WORKDIR /app

COPY . .

USER root

# gcompat is added to allow m1 build of nokogiri
RUN apk add -U --no-cache \
      bash=5.2.26-r0 \
      busybox=1.36.1-r29 \ 
      gcompat=1.1.0-r4 \
      imagemagick=7.1.1.32-r2 \
      libxslt=1.1.39-r1 \
      postgresql16-client=16.6-r0 \
      shared-mime-info=2.4-r0 \
      ssl_client=1.36.1-r29 \
      tzdata=2024b-r0 && \
    apk add -U --no-cache --virtual build-dependencies \
      build-base=0.5-r3 \
      git=2.45.2-r0 \
      libjpeg-turbo-dev=3.0.3-r0 \
      libxslt-dev=1.1.39-r1 \
      postgresql16-dev=16.6-r0 \
      nodejs=20.15.1-r0 \
      yarn=1.22.22-r0 && \
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
