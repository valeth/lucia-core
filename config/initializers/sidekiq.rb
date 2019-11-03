# frozen_string_literal: true

# Logger configuration should come first, so that everything after it is properly logged.

SIDEKIQ_REDIS_URL = ENV.fetch("SIDEKIQ_REDIS_URL") { "redis://localhost:6379/10" }

Sidekiq.configure_server do |config|
  logger = Logging.logger["SidekiqServer"]
  logger.level = :info
  config.logger = logger

  config.redis = { url: SIDEKIQ_REDIS_URL }
end

Sidekiq.configure_client do |config|
  logger = Logging.logger["SidekiqClient"]
  logger.level = :info
  config.logger = logger

  config.redis = { url: SIDEKIQ_REDIS_URL }
end
