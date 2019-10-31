# |-------<[ Build ]>-------|

FROM ruby:2.6-alpine AS build

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
 && bundle install --deployment --without="development test" \
 && apk del build-dependencies


# |-------<[ App ]>-------|

FROM ruby:2.6-alpine AS lucia-core

LABEL maintainer="dev.patrick.auernig@gmail.com"

RUN apk add --update --no-cache \
    tzdata \
 && gem install \
    bundler

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
RUN bundle install --deployment --without="development test"
COPY --chown=app:app ./ ./

EXPOSE 3000
ENTRYPOINT ["bin/docker-entrypoint"]
