# frozen_string_literal: true

require "discord/api"

Discord::API.configure do |config|
  lc_config = Rails.configuration.lucia

  config.logger = Logging.logger["Discord"].tap do |l|
    l.level = :info
  end

  config.token = ENV["DISCORD_BOT_TOKEN"]

  # We need a cache store that works across processes.
  # Otherwise cached data will simply be discarded on jobs that set them.
  unless Rails.env.test?
    redis_url = ENV.fetch("REDIS_URL") { "redis://localhost:6379/0/cache" }
    config.cache = ActiveSupport::Cache.lookup_store(:redis_store, redis_url)
  end
end
