# frozen_string_literal: true

module LuciaToken
  Error = Class.new(StandardError)
  ValidationError = Class.new(Error)
  InvalidPrefix = Class.new(ValidationError)
  InvalidTokenLength = Class.new(ValidationError)
  InvalidDivider = Class.new(ValidationError)

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
      raise InvalidPrefix unless token.start_with?(@prefix)

      validate_token(token[@prefix.size..])
    end

  private

    # Validates the 32 bit token after the prefix
    #
    # @param token [String] The un-prefixed token string
    # @raise ValidationError  If any validation step fails
    def validate_token(token)
      raise InvalidTokenLength unless token.size == REQUIRED_LENGTH

      total = token.each_char.with_index.reduce(0) do |acc, (char, idx)|
        hex = char.hex
        case idx
        when 10, 21 then raise InvalidTokenLength unless DIVIDERS.include?(hex)
        else acc += hex
        end

        acc
      end

      raise ValidationError unless (total % 10) == 8
    end
  end
end
