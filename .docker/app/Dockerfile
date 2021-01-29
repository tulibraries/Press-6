FROM harbor.k8s.temple.edu/library/ruby:2.7-alpine as builder

WORKDIR /app

COPY . .

USER root

RUN apk add --no-cache bash=5.0.17-r0 tzdata=2020f-r0 libxslt-dev=1.1.34-r0 mariadb-dev=10.4.15-r0 && \
    apk add --no-cache --virtual build-dependencies git=2.26.2-r0 build-base=0.5-r2 nodejs=12.20.1-r0 yarn=1.22.4-r0 && \
    gem install bundler:2.2.2  && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle config set --local without "development test" && \
    bundle install --jobs=8 && \
    find "$GEM_HOME" -name Gemfile.lock -exec rm "{}" \; && \
    find "$GEM_HOME" -name yarn.lock -exec rm "{}" \; && \
    chown nobody -R /app/tmp && \
    chown nobody -R /app/log && \
    yarn install --check-files && \
    RAILS_ENV=production bundle exec rake assets:precompile && \
    rm -rf app/node_modules && \
    rm -rf app/tmp/*
    apk del build-dependencies && \
    rm -rf /var/cache/apk/ && \

USER nobody

ENTRYPOINT [".docker/app/entrypoint.sh"]
EXPOSE 3000

CMD ["rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0 -p 3000"]
