require "logging"

# Custom logging layout that converts mongoid logs into easier parsable key-value pairs.
class MongoidLogLayout < Logging::Layout
  DEFAULT_PATTERN = "timestamp=%d loglevel=%l logname=%c %m\n"

  def initialize(config, pattern: nil)
    @config = config
    @inner = Logging::Layouts::Pattern.new(pattern: pattern || DEFAULT_PATTERN)
  end

  def format(event)
    event.data = format_as_key_value_pair(event.data)
    @inner.format(event)
  end

private

  def format_as_key_value_pair(raw_message)
    # Ignore log prefix
    raw_log = raw_message.split(" | ")[1..]

    if raw_log.first == hostname
      format_query(*raw_log[1..])
    else
      format_raw_message(raw_log.join(" | "))
    end
  end

  def format_query(command, status, message)
    type = status == "STARTED" ? "query" : "elapsed_time"
    %{hostname=#{hostname} command=#{command} status=#{status} #{type}="#{escape_message(message)}"}
  end

  def format_raw_message(message)
    %{message="#{escape_message(message)}"}
  end

  def escape_message(msg)
    msg.dump[1..-2]
  end

  def hostname
     @hostname ||= @config.clients.dig("default", "hosts", 0)
  end
end
