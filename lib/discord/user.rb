# frozen_string_literal: true

require "json"
require_relative "api"

module Discord
  class User < Dry::Struct
    FALLBACK_AVATAR_URL = "https://i.imgur.com/QnYSlld.png"

    # Transform nil type to default
    transform_types do |type|
      next type unless type.default?
      type.constructor { |v| v.nil? ? Dry::Types::Undefined : v }
    end

    attribute :id, Types::Coercible::Integer
    attribute? :name, Types::Coercible::String.default("{Unknown}")
    attribute? :avatar_url, Types::Coercible::String.default(FALLBACK_AVATAR_URL)
    attribute? :discriminator, Types::Coercible::Integer.optional

    def cache_key
      self.class.cache_key(id)
    end

    class << self
      def logger
        API.logger
      end

      # Try to get a cached user
      #
      # @param id [Integer, String]
      # @return [User, nil]
      def try_cache(id, &block)
        API.cached(self, id, &block)
      end

      def cache_key(id)
        "user-#{id}"
      end

      # @param id [Integer, String]
      # @param use_cache [Boolean]
      # @return [User]
      # @raise APIError
      def fetch(id, use_cache: true)
        if use_cache
          try_cache(id) { raw_fetch(id) }
        else
          raw_fetch(id)
        end
      end

      # @param id [Integer, String]
      # @return [User]
      # @raise APIError
      def raw_fetch(id)
        logger.debug(self.class) { "Fetching user data for #{id}" }

        response = Discordrb::API::User.resolve(API.config.token, id)
        data = JSON.parse(response.body)

        avatar_id = data["avatar"]
        ext = avatar_id.start_with?("a_") ? "gif" : "png"
        avatar_url = "https://cdn.discordapp.com/avatars/#{id}/#{avatar_id}.#{ext}"

        new(id: id, name: data["username"], discriminator: data["discriminator"], avatar_url: avatar_url)
      rescue RestClient::Exception => e
        logger.error(self.class) { "Failed to fetch Discord user information: #{e}" }
        raise APIError, e
      end
    end
  end
end
