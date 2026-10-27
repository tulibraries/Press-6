# hadolint global ignore=DL3006,DL3026

ARG BASE_IMAGE="harbor.k8s.temple.edu/library/ruby:4.0-alpine"
ARG BASH_VERSION="5.3.9-r1"
ARG GCOMPAT_VERSION="1.1.0-r4"
ARG LIBJPEG_TURBO_VERSION="3.1.3-r0"
ARG LIBXSLT_VERSION="1.1.43-r3"
ARG POSTGRESQL_VERSION="17.11-r0"
ARG TZDATA_VERSION="2026e-r0"

FROM "${BASE_IMAGE}" AS builder

USER 0

WORKDIR /app

ARG RAILS_ENV=production
ARG BASH_VERSION
ARG GCOMPAT_VERSION
ARG LIBJPEG_TURBO_VERSION
ARG LIBXSLT_VERSION
ARG POSTGRESQL_VERSION
ARG TZDATA_VERSION
ENV RAILS_ENV=${RAILS_ENV}

# gcompat is added to allow m1 build of nokogiri
RUN apk add -U --no-cache \
    bash=${BASH_VERSION} \
    build-base=0.5-r4 \
    gcompat=${GCOMPAT_VERSION} \
    git=2.54.0-r0 \
    yaml=0.2.5-r2 \
    yaml-dev=0.2.5-r2 \
    libjpeg-turbo-dev=${LIBJPEG_TURBO_VERSION} \
    libxslt-dev=${LIBXSLT_VERSION} \
    libxml2-dev=2.13.9-r2 \
    postgresql17-dev=${POSTGRESQL_VERSION} \
    tzdata=${TZDATA_VERSION}

COPY Gemfile Gemfile.lock ./

RUN if [ "${RAILS_ENV}" = "production" ]; then bundle config set --local without "development test"; fi && \
    bundle install --jobs=8 && \
    find "$GEM_HOME" -name Gemfile.lock -exec rm "{}" \;

COPY . .

RUN mkdir -p /secure-tmp && \
    SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile && \
    rm -rf tmp/*

USER 65534

FROM "${BASE_IMAGE}" AS runner

WORKDIR /app

USER 0

ARG RAILS_ENV=production
ARG BASH_VERSION
ARG GCOMPAT_VERSION
ARG LIBJPEG_TURBO_VERSION
ARG LIBXSLT_VERSION
ARG POSTGRESQL_VERSION
ARG TZDATA_VERSION

ENV RAILS_ENV=${RAILS_ENV} \
    LD_PRELOAD="libjemalloc.so.2" \
    MALLOC_CONF="dirty_decay_ms:1000,narenas:2,background_thread:true" \
    RUBY_YJIT_ENABLE="1"

RUN apk add -U --no-cache \
    bash=${BASH_VERSION} \
    busybox=1.37.0-r31 \
    gcompat=${GCOMPAT_VERSION} \
    imagemagick=7.1.2.34-r0 \
    jemalloc=5.3.0-r6 \
    libjpeg-turbo=${LIBJPEG_TURBO_VERSION} \
    libxslt=${LIBXSLT_VERSION} \
    postgresql17-client=${POSTGRESQL_VERSION} \
    shared-mime-info=2.4-r7 \
    ssl_client=1.37.0-r31 \
    tzdata=${TZDATA_VERSION}

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

RUN mkdir -p /secure-tmp /secure-tmp/log && \
    chown nobody:nobody -R /secure-tmp && \
    chmod 700 /secure-tmp /secure-tmp/log && \
    mkdir -p /app/tmp /app/log && \
    chown nobody:nobody -R /app/tmp /app/log

USER 65534

ENTRYPOINT [".docker/app/entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
