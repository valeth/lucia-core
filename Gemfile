source 'https://rubygems.org'

# -------[ Core ]-------

gem 'rails', '~> 5.1.6'
gem 'puma', '~> 3.7'
gem "dotenv-rails", "~> 2.2"


# -------[ Database ]-------
gem "mongoid", "~> 7.0.1"


# -------[ Misc ]-------
gem "rest-client"
gem "jbuilder", "~> 2.7"


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "rubocop", "0.57.1", require: false
  gem "pry-rails"
end

group :production do
  gem "unicorn"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
