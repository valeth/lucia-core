# frozen_string_literal

require_relative "base"

module Logging::Context
  # Mongoid log outputs are separated by " | ".
  # Query logs are always preceeded by the hostname.
  class Mongoid < Base
    def initialize(message)
      # Ignore log prefix
      raw_log = message.split(" | ")[1..]

      ctx =
        if raw_log.first == hostname
          prepare_query_context(*raw_log[1..])
        else
          raw_log.join(" | ")
        end

      super(ctx)
    end

  private

    def prepare_query_context(command, status, message)
      type = status == "STARTED" ? :query : :elapsed_time
      { hostname: hostname, command: command, status: status, type => escape_message(message) }
    end

    def hostname
      @hostname ||= ::Mongoid::Config.clients.dig("default", "hosts", 0)
    end
  end
end
