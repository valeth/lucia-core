require "rails_helper"

RSpec.describe ::API::V1::Sigma::Leaderboard do
  def expect_ordered(results)
    results[0..-2].each.with_index(1) do |result, i|
      expect(result["value"]).to be >= results.dig(i, "value")
    end
  end

  context "GET /rest/v1/sigma/leaderboard/currency" do
    it "lists the top 20 entries" do
      get "/rest/v1/sigma/leaderboard/currency"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results.size).to eq(20)
      expect_ordered(results)
    end

    it "lists only users from specific guild" do
      get "/rest/v1/sigma/leaderboard/currency?filter[guild_id]=200751504175398912"

      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results.size).to eq(6)
    end
  end

  context "GET /rest/v1/sigma/leaderboard/experience" do
    it "lists the top 20 entries" do
      get "/rest/v1/sigma/leaderboard/experience"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results.size).to eq(20)
      expect_ordered(results)
    end
  end

  context "GET /rest/v1/sigma/leaderboard/cookies" do
    it "lists the top 20 entries" do
      get "/rest/v1/sigma/leaderboard/cookies"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results.size).to eq(20)
      expect_ordered(results)
    end
  end
end
