require "logging"
require "logging/layouts/key_value"
require "logging/context/mongoid"

Rails.application.configure do
  logger = Logging.logger["Mongoid"]

  # This avoids logging to any other log appenders, especially stdout.
  # Mongoid logs can be quite verbose, and spam stdout quickly.
  logger.additive = false

  layout = Logging::Layouts::KeyValue.new(ctx: :mongoid, date_pattern: DATE_PATTERN)

  # Creates a separate log file for mongoid.
  logger.appenders = Logging.appenders.rolling_file("db_file",
    filename: Rails.root.join("log", "#{Rails.env}-mongoid.log").to_s,
    keep: 7,
    age: "daily",
    truncate: false,
    auto_flushing: true,
    layout:
  )

  config.mongoid.logger = logger
end
