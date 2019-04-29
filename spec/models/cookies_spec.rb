# frozen_string_literal: true

require "rails_helper"
require_relative "score"

RSpec.describe Cookie do
  include_context "score"

  it "should return base title and level" do
    expect(zero_user).to have_attributes(
      uid: 1,
      score: 0,
      tier: 0,
      current_level: 0,
      next_level_required: 5,
      title: "Starving Licker"
    )
  end

  it "should return correct title and level" do
    expect(high_level_user).to have_attributes(
      uid: 2,
      score: 1_000_000,
      tier: 10_000,
      current_level: 194174,
      next_level_required: 1_000_001,
      title: "Inhaling Connoisseur"
    )
  end
end
