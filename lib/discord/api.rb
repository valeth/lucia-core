# frozen_string_literal: true

require "rest-client"
require "json"
require "logger"
require "addressable"
require "active_support/cache"
require "active_support/core_ext/numeric/time"

module Discord
  APIError = Class.new(StandardError)

  class Config
    attr_reader :token
    attr_writer :cache
    attr_writer :cache_duration

    def token=(val)
      raise "Invalid Discord auth token" unless /^\S{24}\.\S{6}\.\S{27}$/.match?(val)

      @token = val
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def logger=(log)
      if %i[debug error warn info].all? { |x| log.respond_to?(x) }
        @logger = log
      else
        warn "#{self.class}: Cannot use #{log.class} as logger"
      end
    end

    def cache
      @cache ||= ActiveSupport::Cache.lookup_store :memory_store
    end

    def cache_duration
      @cache_duration ||= 5.minutes
    end
  end

  class API
    @singleton = nil
    @config = Config.new

    BASE_URL = Addressable::URI.parse("https://discordapp.com/api/")

    # @param config [Discord::Config] The API configuration.
    def initialize(config)
      raise "Token required" unless config&.token

      @token = "Bot #{config.token}"
      @logger = config.logger
      @cache = config.cache
      @cache_duration = config.cache_duration
    end

    def get_user_by_id(id)
      @logger.debug(self.class) { "Fetching user data for #{id}" }
      fetch("users/#{id}")
    rescue APIError => e
      @logger.error(self.class) { "Failed to fetch Discord user information: #{e}" }
      raise e
    end

    class << self
      def get_user_by_id(id)
        singleton.get_user_by_id(id)
      end

      def configure
        yield @config if block_given?
      end

      def singleton
        @singleton ||= new(@config)
      end
    end

  private

    def fetch(resource)
      url = BASE_URL.join(resource)
      cache_key = "discord-#{resource.tr('/', '-').tr(' ', '')}"

      @cache.fetch(cache_key, expires_in: @cache_duration) do
        RestClient.get(url.to_s, Authorization: @token).then(&JSON.method(:parse))
      end
    rescue RestClient::ExceptionWithResponse, JSON::ParserError => e
      raise APIError, e
    end
  end
end
