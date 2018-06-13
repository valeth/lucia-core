# frozen_string_literal: true

SIDEKIQ_REDIS_URL = ENV.fetch("SIDEKIQ_REDIS_URL") { "redis://localhost:6379/10" }

Sidekiq.configure_server do |config|
  config.redis = { url: SIDEKIQ_REDIS_URL }
end

Sidekiq.configure_client do |config|
  config.redis = { url: SIDEKIQ_REDIS_URL }
end
