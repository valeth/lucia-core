# frozen_string_literal: true

require "rails_helper"
require_relative "score"

RSpec.describe CurrencySystem do
  include_context "score"

  it "should return base title and level" do
    expect(zero_user).to have_attributes(
      uid: 1,
      score: 0,
      tier: 0,
      current_level: 0,
      next_level_required: 7537,
      title: "Regular Pickpocket"
    )
  end

  it "should return correct title and level" do
    expect(high_level_user).to have_attributes(
      tier: 10_000,
      current_level: 132,
      next_level_required: 1_002_421,
      title: "Silver Professional"
    )
  end
end
