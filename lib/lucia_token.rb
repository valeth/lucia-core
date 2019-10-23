# frozen_string_literal: true

module LuciaToken
  Error = Class.new(StandardError)
  ValidationError = Class.new(Error)

  class InvalidPrefix < ValidationError
    def initialize(token, *args)
      super(%{Token "#{token} has invalid prefix}, *args)
    end
  end

  class InvalidTokenLength < ValidationError
    def initialize(len, *args)
      super("Invalid token length #{len}", *args)
    end
  end

  class InvalidDivider < ValidationError
    def initialize(idx, *args)
      super("Invalid divider found at position #{idx}", *args)
    end
  end

  class TokenIsEmpty < ValidationError
    def initialize(*args)
      super("Token was empty", *args)
    end
  end

  class TokenAlreadyUsed < ValidationError
    def initialize(*args)
      super("Token was already used", *args)
    end
  end

  class InvalidResult < ValidationError
    def initialize(*args)
      super("Token yielded invalid result")
    end
  end

  class FormatValidator
    DIVIDERS = [1, 3, 5, 7, 11, 13].freeze
    REQUIRED_LENGTH = 32 # minus prefix

    def initialize(prefix:)
      @prefix = prefix
    end

    # Checks if a token is valid
    #
    # @param token [String]  The full token
    # @return [Boolean]
    def valid?(token)
      validate(token)
      true
    rescue ValidationError
      false
    end

    # Validates a token, including prefix
    #
    # @param token [String]  The full token
    # @raise ValidationError  If any validation step fails
    def validate(token)
      raise TokenIsEmpty if token.blank?
      raise InvalidPrefix, token unless token.start_with?(@prefix)

      validate_token(token[@prefix.size..])
    end

  private

    # Validates the 32 bit token after the prefix
    #
    # @param token [String] The un-prefixed token string
    # @raise ValidationError  If any validation step fails
    def validate_token(token)
      raise InvalidTokenLength, token.size unless token.size == REQUIRED_LENGTH

      total = token.each_char.with_index.reduce(0) do |acc, (char, idx)|
        hex = char.hex
        case idx
        when 10, 21 then raise InvalidDivider, idx unless DIVIDERS.include?(hex)
        else acc += hex
        end

        acc
      end

      raise InvalidResult unless (total % 10) == 8
    end
  end

  module Authenticator
    TOKEN_PREFIX = Rails.configuration.lucia[:token_prefix].freeze
    CACHE_PREFIX = "lucia-token_#{Rails.env}_"

    @token_cache = Rails.cache
    @validator = LuciaToken::FormatValidator.new(prefix: TOKEN_PREFIX)

  module_function

    def authenticate(token)
      validate_token(token)
      mark_token_as_used(token)
      nil
    end

    def token_reusable?
      @token_reusable ||= Rails.configuration.lucia[:token_reusable]
    end

    def token_expiration_time
      @token_expiration_time ||= [Rails.configuration.lucia[:token_expiration_time], 1].max.seconds
    end

    def validate_token(token)
      raise TokenAlreadyUsed if token_used?(token)
      @validator.validate(token)
    end

    def token_cache_key(token)
      "#{CACHE_PREFIX}#{token}"
    end

    def token_used?(token)
      return false if token_reusable?

      @token_cache.exist?(token_cache_key(token))
    end

    def mark_token_as_used(token)
      return if token_reusable?

      key = token_cache_key(token)
      @token_cache.write(key, nil, expires_in: token_expiration_time)
    end

    def mark_token_as_unused(token)
      return if token_reusable?

      key = token_cache_key(token)
      @token_cache.delete(key)
    end

    def clear_token_cache
      return if token_reusable?

      @token_cache.delete_matched(/#{CACHE_PREFIX}.*/)
    end
  end
end
