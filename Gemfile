source "https://rubygems.org"

ruby "~> 2.5"

# -------[ Core ]-------
gem "rails", "~> 5.1.6"
gem "rack-handlers"
gem "dotenv-rails", "~> 2.2"
gem "unicorn", platforms: %i[ruby]
gem "puma", platforms: %i[mingw mswin x64_mingw]

# -------[ Database ]-------
gem "mongoid", "~> 7.0.1"

# -------[ API ]-------
gem "jbuilder", "~> 2.7"
gem "yajl-ruby"

# -------[ Cache ]-------
gem "hiredis"
gem "redis", "~> 4.0", require: ["redis", "redis/connection/hiredis"]
gem "redis-rails"

# -------[ Jobs ]-------
gem "childprocess", "~> 0.9"
gem "sidekiq"
gem "sidekiq-scheduler"

# -------[ Misc ]-------
gem "rest-client"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "rubocop", "0.57.1", require: false
  gem "pry-rails"
  gem "rack-cors", require: "rack/cors"
  gem "puma"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
