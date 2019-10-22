require_relative "boot"

require "rails"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LuciaCore
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.autoload_paths.push(
      Rails.root.join("lib"),
      Rails.root.join("app/graphql"),
      *Rails.root.glob("app/models/sigma/**/"),
    )

    config.eager_load_paths.push(*config.autoload_paths.dup)

    config.active_job.queue_adapter = :sidekiq

    redis_url = ENV.fetch("REDIS_URL") { "redis://localhost:6379/0/cache" }
    config.cache_store = :redis_store, redis_url, { expires_in: 1.day }

    # Loads config/lucia.yml
    config.lucia = config_for(:lucia)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
