# |-------<[ Build ]>-------|

FROM docker.io/ruby:3.3-alpine AS build

RUN mkdir -p /build
WORKDIR /build

COPY Gemfile Gemfile.lock ./
RUN apk add --no-cache --virtual \
    build-dependencies \
    build-base \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    libc-dev \
    git \
 && bundle config set deployment true \
 && bundle config set without development test \
 && bundle install


# |-------<[ App ]>-------|

FROM docker.io/ruby:3.3-alpine AS lucia-core

LABEL maintainer="dev.patrick.auernig@gmail.com"

RUN apk add --update --no-cache tzdata \
 && gem install bundler

ARG user_uid=1000
ARG user_gid=1000
RUN addgroup -S -g "$user_gid" app \
 && adduser -S -G app -u "$user_uid" app \
 && mkdir -p /app /app/tmp /app/log \
 && chown -R app:app /app

WORKDIR /app
USER app

COPY --chown=app:app --from=build /build/vendor/bundle ./vendor/bundle
COPY Gemfile Gemfile.lock ./
RUN bundle config set deployment true
RUN bundle config set without development test
RUN bundle install
COPY --chown=app:app ./ ./

EXPOSE 3000
ENTRYPOINT ["bin/docker-entrypoint"]
