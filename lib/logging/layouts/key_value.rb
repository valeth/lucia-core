# frozen_string_literal

require "logging"
require_relative "../context/base"

module Logging::Layouts
  # A key-value layout for parsable logs.
  # A context builder can be supplied to format log data into additional fields.
  #
  # **Default Format:**
  # ```log
  # timestamp=2019-10-31T20:50:00+00:00 loglevel=DEBUG logname=Rails message="Some message"
  # ````
  class KeyValue < ::Logging::Layout
    DATE_PATTERN = "%FT%T%:z"
    COMPONENTS = %i[timestamp loglevel logname].freeze

    def initialize(ctx: Logging::Context::Base, included: nil, date_pattern: nil)
      @ctx_builder = lookup_context(ctx)
      @date_pattern = date_pattern || DATE_PATTERN
      @components = select_components(included)
      super
    end

    def format(event)
      "#{format_components(event)} #{context(event)}\n"
    end

  private

    def lookup_context(ctx)
      if ctx.is_a?(Class) && ctx <= Logging::Context::Base
        ctx
      elsif ctx.respond_to?(:to_s)
        "Logging::Context::#{ctx.to_s.camelize}".constantize
      else
        raise
      end
    rescue StandardError
      raise TypeError, "#{ctx} is not a valid log context"
    end

    def timestamp(event)
      apply_utc_offset(event.time).strftime(@date_pattern)
    end

    def loglevel(event)
      Logging::LNAMES[event.level]
    end

    def logname(event)
      event.logger
    end

    def context(event)
      @ctx_builder.new(event.data)
    end

    def format_components(event)
      @components.map { |c| "#{c}=#{self.__send__(c, event)}" }.join(" ")
    end

    def select_components(included)
      case included
      when Array then COMPONENTS & included
      else COMPONENTS
      end
    end
  end
end
