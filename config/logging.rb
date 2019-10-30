# frozen_string_literal: true

Logging::Rails.configure do |config|
  LOGGER_PATTERN = "timestamp=%d loglevel=%l logname=%c %m\n"

  # Configure the Logging framework with the default log levels
  Logging.init %w[debug info warn error fatal]

  # Objects will be converted to strings using the :inspect method.
  Logging.format_as :inspect

  Logging.backtrace false

  # Setup a color scheme called 'bright' than can be used to add color codes
  # to the pattern layout. Color schemes should only be used with appenders
  # that write to STDOUT or STDERR; inserting terminal color codes into a file
  # is generally considered bad form.
  Logging.color_scheme("bright",
    levels: {
      debug: :green,
      info: :white,
      warn: :yellow,
      error: :red,
      fatal: %i[white on_red]
    },
    date: :blue,
    logger: :cyan,
    message: :white
  )

  # Configure an appender that will write log events to STDOUT. A colorized
  # pattern layout is used to format the log events into strings before
  # writing.
  Logging.appenders.stdout("stdout",
    auto_flushing: true,
    layout: Logging.layouts.pattern(pattern: LOGGER_PATTERN, color_scheme: "bright")
  ) if config.log_to.include? "stdout"

  # Configure an appender that will write log events to a file. The file will
  # be rolled on a daily basis, and the past 7 rolled files will be kept.
  # Older files will be deleted. The default pattern layout is used when
  # formatting log events into strings.
  Logging.appenders.rolling_file("file",
    filename: config.paths["log"].first,
    keep: 7,
    age: "daily",
    truncate: false,
    auto_flushing: true,
    layout: Logging.layouts.pattern(pattern: LOGGER_PATTERN)
  ) if config.log_to.include? "file"

  Logging.logger["ActiveSupport::Cache"].level = :off
  Logging.logger["GraphQL"].level = :debug

  Logging.logger.root.level = config.log_level
  Logging.logger.root.appenders = config.log_to unless config.log_to.empty?
end
