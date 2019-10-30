source "https://rubygems.org"

ruby "~> 2.6"

# -------[ Core ]-------
gem "rails", "~> 6.0.0"
gem "rack-handlers", "~> 0.7"
gem "dotenv-rails", "~> 2.4", ">= 2.4.0"
gem "unicorn", "~> 5.5", platforms: %i[ruby]

# -------[ Logging & Error Handling ]-------
gem "logging", "~> 2.2"
gem "logging-rails", "~> 0.6", require: "logging/rails"
gem "lograge", "~> 0.11"

# -------[ Database ]-------
gem "mongoid", "~> 7.0.5"

# -------[ API ]-------
gem "multi_json", "~> 1.14"
gem "yajl-ruby", "~> 1.4"
gem "graphql", "~> 1.9"

# -------[ Cache ]-------
gem "hiredis", "~> 0.6"
gem "redis", "~> 4.1", require: ["redis", "redis/connection/hiredis"]
gem "redis-rails", ">= 5.0.2"

# -------[ Jobs ]-------
gem "childprocess", "~> 0.9"
gem "sidekiq", "~> 6.0"
gem "sidekiq-scheduler", "~> 3.0"

# -------[ Misc ]-------
gem "rest-client", "~> 2.1"
gem "addressable", "~> 2.7"
gem "rack-cors", "~> 1.0", require: "rack/cors"

group :test do
  gem "database_cleaner", "~> 1.7"
  gem "webmock", "~> 3.5"
  gem "simplecov", "~> 0.17", require: false
end

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails", "~> 3.8", ">= 3.8.0"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "rubocop", "0.67.2", require: false
  gem "pry-rails", "~> 0.3"
  gem "puma", "~> 4.2"
end
