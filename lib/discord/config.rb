require "logger"
require "active_support/cache"
require "active_support/core_ext/numeric/time"

module Discord
  class Config
    attr_reader :token
    attr_writer :cache
    attr_writer :cache_duration

    def token=(val)
      raise "Invalid Discord auth token" unless token_valid?(val)

      @token = "Bot #{val}"
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def logger=(log)
      if %i[debug error warn info].all? { |x| log.respond_to?(x) }
        @logger = log
      else
        raise "#{self.class}: Cannot use #{log.class} as logger"
      end
    end

    def cache=(cache_store)
      if cache_store.is_a?(ActiveSupport::Cache::NullStore)
        warn "NullStore cannot be used for the Discord cache"
        return
      end

      @cache = cache_store
    end

    # The default memory store backend is only useful for development.
    # A different caching solution should be used for production environments.
    def cache
      @cache ||= ActiveSupport::Cache.lookup_store(:memory_store)
    end

    def cache_duration
      @cache_duration ||= 2.hours
    end

  private

    def token_valid?(token)
      return false unless token

      # /^\S{24}\.\S{6}\.\S{27,39}$/.match?(token)
      true
    end
  end
end
