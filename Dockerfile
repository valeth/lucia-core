# |-------<[ Build ]>-------|

FROM ruby:2.5-alpine AS build

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

FROM ruby:2.5-alpine AS lucia-core

LABEL maintainer="dev.patrick.auernig@gmail.com"

RUN apk add --update --no-cache \
    tzdata \
 && gem install \
    bundler

RUN addgroup -S app && adduser -S -H -G app app

ENV APP_ROOT="/app"
RUN mkdir -p "$APP_ROOT" && chown app:app "$APP_ROOT"

WORKDIR "$APP_ROOT"
USER app

COPY --chown=app:app --from=build /build/vendor/bundle ./vendor/bundle
COPY Gemfile Gemfile.lock ./
RUN bundle install --deployment --without="development test"
COPY --chown=app:app ./ ./

ENTRYPOINT ["bundle", "exec"]

EXPOSE 3000
CMD ["bin/rails", "server", "unicorn", "-b", "0.0.0.0", "-p", "3000"]
