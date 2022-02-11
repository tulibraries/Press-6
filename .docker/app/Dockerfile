# For circleci this arg gets overridden by value in the .env file.
ARG BASE_IMAGE_NAME="harbor.k8s.temple.edu/library/ruby:2.7-alpine" \
  RAILS_MASTER_KEY=foobar \
  RAILS_ENV=production

# hadolint ignore=DL3006,DL3026
FROM "${BASE_IMAGE_NAME}"

WORKDIR /app

COPY . .

USER root

RUN apk add -U --no-cache \
      bash=5.1.8-r0 \
      libxslt=1.1.34-r1 \
      tzdata=2021e-r0 \
      mariadb-connector-c=3.1.13-r2 \
      imagemagick=7.1.0.16-r0 \
      shared-mime-info=2.1-r0 && \
    apk add -U --no-cache --virtual build-dependencies \
      git=2.34.1-r0 \
      build-base=0.5-r2 \
      libxslt-dev=1.1.34-r1 \
      mariadb-dev=10.6.4-r2 \
      nodejs=16.14.0-r0 \
      yarn=1.22.17-r0 && \
    gem install bundler:2.2.27  && \
    bundle config build.nokogiri --use-system-libraries && \
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
