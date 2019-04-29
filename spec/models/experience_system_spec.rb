# frozen_string_literal: true

require "rails_helper"
require_relative "score"

RSpec.describe ExperienceSystem do
  include_context "score"

  it "should return base title and level" do
    expect(zero_user).to have_attributes(
      uid: 1,
      score: 0,
      tier: 0,
      current_level: 0
    )
  end

  it "should return correct title and level" do
    expect(high_level_user).to have_attributes(
      tier: 10_000,
      current_level: 75,
      next_level_required: 1_008_280,
      title: "Supersonic Loudmouth"
    )
  end
end
