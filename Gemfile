source "https://rubygems.org"

ruby "~> 2.6"

# -------[ Core ]-------
gem "rails", "~> 5.2.3"
gem "bootsnap", ">= 1.1.0", require: false
gem "rack-handlers"
gem "dotenv-rails", "~> 2.4", ">= 2.4.0"
gem "unicorn", platforms: %i[ruby]

# -------[ Database ]-------
gem "mongoid", "~> 7.0.1"

# -------[ API ]-------
gem "multi_json", "~> 1.14"
gem "yajl-ruby", "~> 1.4"
gem "graphql", "~> 1.9"

# -------[ Cache ]-------
gem "hiredis"
gem "redis", "~> 4.0", require: ["redis", "redis/connection/hiredis"]
gem "redis-rails", ">= 5.0.2"

# -------[ Jobs ]-------
gem "childprocess", "~> 0.9"
gem "sidekiq"
gem "sidekiq-scheduler"

# -------[ Misc ]-------
gem "rest-client"
gem "addressable", "~> 2.6"
gem "rack-cors", require: "rack/cors"

group :test do
  gem "database_cleaner", "~> 1.7"
  gem "webmock", "~> 3.5"
  gem "simplecov", "~> 0.16", require: false
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
  gem "pry-rails"
  gem "puma"
end
