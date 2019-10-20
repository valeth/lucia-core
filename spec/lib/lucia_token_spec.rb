# frozen_string_literal: true

require "rails_helper"

RSpec.describe LuciaToken::FormatValidator do
  let(:valid_token) { "lc-cd40471e85312c278a6a17b9bd53a388" }
  let(:invalid_token) { "lc-a050aeda033d257d34be239bcd810040" }

  it "can check for token validity" do
    validator = described_class.new(prefix: "lc-")

    expect(validator.valid?(valid_token)).to eq(true)
    expect(validator.valid?(invalid_token)).to eq(false)
  end

  it "raises an exception on invalid tokens" do
    validator = described_class.new(prefix: "lc-")

    expect { validator.validate(valid_token) }
      .not_to raise_error

    expect { validator.validate(invalid_token) }
      .to raise_error(LuciaToken::ValidationError)
  end
end
