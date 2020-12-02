FROM harbor.k8s.temple.edu/library/ruby:2.7.0-alpine3.11 as builder

USER root
RUN apk add --update --no-cache build-base libxslt-dev mysql-dev tzdata nodejs yarn && \
  rm -rf /var/cache/apk/

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
RUN bundle config build.nokogiri --use-system-libraries && \
  bundle config set deployment 'true' without development:test && \
  bundle install --jobs=4

COPY package.json yarn.lock $APP_HOME/
RUN yarn install  --check-files
COPY . $APP_HOME
RUN bin/rake assets:precompile && \
  rm -rf $APP_HOME/node_modules && \
  rm -rf $APP_HOME/tmp/*

FROM harbor.k8s.temple.edu/library/ruby:2.7.0-alpine3.11
USER root
RUN apk update && apk add --update bash build-base git mysql-dev tzdata && rm -rf /var/cache/apk/*
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY --from=builder /app $APP_HOME

RUN bundle config --local path vendor/bundle && \
  bundle config --local without development:test:assets && \
  bundle install --jobs=4

ENTRYPOINT [".docker/app/entrypoint.sh"]
EXPOSE 3000

CMD rm -f tmp/pids/server.pid && \
  bundle exec rails s -b 0.0.0.0 -p 3000
