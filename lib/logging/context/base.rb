# frozen_string_literal

module Logging::Context
  class Base
    def initialize(message)
      @items =
        if message.is_a?(Hash)
          message
        elsif message.respond_to?(:to_s)
          { message: escape_message(message.to_s) }
        else
          { message: }
        end
    end

    def to_h
      @items
    end

    def to_s
      to_h.map { |k, v| "#{k}=#{v}" }.join(" ")
    end

  protected

    def escape_message(msg)
      quote_string(msg.dump[1..-2])
    end

    def quote_string(str)
      %{"#{str}"}
    end
  end
end
