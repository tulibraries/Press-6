FROM harbor.k8s.temple.edu/library/ruby:2.7.0-alpine3.11

RUN apk add --update --no-cache \
  bash \
  build-base \
  git \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev \
  tzdata

RUN mkdir /app
WORKDIR /app

RUN gem update --system && \
  gem install bundler && \
  bundle config build.nokogiri --use-system-libraries

COPY . .
RUN bundle install && echo test

ENTRYPOINT [".docker/entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
