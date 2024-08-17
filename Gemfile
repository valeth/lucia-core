source "https://rubygems.org"

ruby "~> 3.3"

# -------[ Core ]-------
gem "rails", "~> 7.1", "< 7.2"
gem "rack-handlers", "~> 0.7"
gem "dotenv-rails", "~> 3.1.2"
gem "unicorn", "~> 6.1", platforms: %i[ruby]

# -------[ Logging & Error Handling ]-------
gem "logging", "~> 2.4"
gem "syslog"
# TODO: this gem probably needs a proper replacement
gem "logging-rails", require: "logging/rails", git: "https://github.com/valeth/logging-rails", branch: "rails-7"
gem "lograge", "~> 0.14"

# -------[ Database ]-------
gem "mongoid", "~> 9.0.1"

# -------[ API ]-------
gem "multi_json", "~> 1.15"
gem "yajl-ruby", "~> 1.4"
gem "graphql", "~> 2.3"

# -------[ Cache ]-------
gem "redis", "~> 5.2"
gem "redis-rails", ">= 5.0.2"

# -------[ Jobs ]-------
gem "childprocess", "~> 5.1"
gem "sidekiq", "~> 7.3"
gem "sidekiq-scheduler", "~> 5.0"

# -------[ Misc ]-------
gem "rest-client", "~> 2.1"
gem "addressable", "~> 2.8"
gem "rack-cors", "2.0"
gem "dry-struct", "~> 1.6"
gem "discordrb", "~> 3.5"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

group :test do
  gem "database_cleaner-mongoid", "~> 2.0"
  gem "webmock", "~> 3.23"
  gem "simplecov", "~> 0.22", require: false
end

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails", "~> 6.1"
end

group :development do
  gem "listen", ">= 3.9"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.1.0"
  gem "rubocop", "1.65", require: false
  gem "pry-rails", "~> 0.3"
  gem "puma", "~> 6.4"
end
