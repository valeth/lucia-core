# frozen_string_literal: true

require "discordrb"
require "dry-struct"
require_relative "config"

Discordrb::LOGGER.mode = :silent

module Discord
  APIError = Class.new(StandardError)

  module Types
    include Dry.Types()
  end

  module API
    BASE_URL = Discordrb::API::APIBASE

    class << self
      def cached(resource, *args)
        key = resource.cache_key(*args)
        config.cache.fetch("discord-#{key}", expires_in: config.cache_duration) do
          logger.debug { "Cache miss for 'discord-#{key}'" }
          yield if block_given?
        end
      end

      def set_cache(resource)
        key = resource.cache_key
        config.cache.write("discord-#{key}", resource, expires_in: config.cache_duration)
      end

      def configure
        yield config if block_given?
      end

      def config
        @config ||= Config.new
      end

      def logger
        config.logger
      end
    end
  end
end
