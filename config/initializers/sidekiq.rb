# frozen_string_literal: true

# Logger configuration should come first, so that everything after it is properly logged.

SIDEKIQ_REDIS_URL = ENV.fetch("SIDEKIQ_REDIS_URL") { "redis://localhost:6379/10" }

def logger_for(name)
  layout = Logging.layouts.pattern(pattern: LOGGER_PATTERN, date_pattern: DATE_PATTERN)
  Logging.logger["Sidekiq#{name.capitalize}"].tap do |l|
    l.additive = false
    l.level = :info
    l.appenders = Logging.appenders.rolling_file("sidekiq_file",
      filename: Rails.root.join("log", "#{Rails.env}-sidekiq.log").to_s,
      keep: 7,
      age: "daily",
      truncate: false,
      auto_flushing: true,
      layout:
    )
  end
end

Sidekiq.configure_server do |config|
  config.logger = logger_for("server")

  config.redis = { url: SIDEKIQ_REDIS_URL }
end

Sidekiq.configure_client do |config|
  config.logger = logger_for("client")

  config.redis = { url: SIDEKIQ_REDIS_URL }
end

Rails.application.configure do
  config.active_job.logger = Logging.logger["SidekiqServer"]
end
