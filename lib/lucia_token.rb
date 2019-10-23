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
end
