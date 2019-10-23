# frozen_string_literal: true

require "rails_helper"

RSpec.describe LuciaToken::FormatValidator do
  let(:valid_token) { "lc-cd40471e85312c278a6a17b9bd53a388" }
  let(:invalid_token) { "lc-a050aeda033d257d34be239bcd810040" }
  let(:validator) { described_class.new(prefix: "lc-") }

  it "can check for token validity" do
    expect(validator.valid?(valid_token)).to eq(true)
    expect(validator.valid?(invalid_token)).to eq(false)
  end

  it "raises an exception on invalid tokens" do
    expect { validator.validate(valid_token) }
      .not_to raise_error

    expect { validator.validate("") }
      .to raise_error(LuciaToken::TokenIsEmpty)

    expect { validator.validate(nil) }
      .to raise_error(LuciaToken::TokenIsEmpty)

    expect { validator.validate(valid_token.tr("lc-", "no-")) }
      .to raise_error(LuciaToken::InvalidPrefix)

    expect { validator.validate(valid_token[0..-2]) }
      .to raise_error(LuciaToken::InvalidTokenLength)

    invalid_divider = valid_token.dup
    invalid_divider[13] = "4"
    expect { validator.validate(invalid_divider) }
      .to raise_error(LuciaToken::InvalidDivider)

    invalid_divider = valid_token.dup
    invalid_divider[24] = "4"
    expect { validator.validate(invalid_divider) }
      .to raise_error(LuciaToken::InvalidDivider)

    expect { validator.validate(invalid_token) }
      .to raise_error(LuciaToken::InvalidResult)
  end
end
