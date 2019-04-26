require "rails_helper"

RSpec.describe ::API::V1::Sigma::Leaderboard do
  let(:ids) do
    Array.new(21) { rand(100_000_000_000_000_000) }
    # [217_078_934_976_724_992, 125_750_263_687_413_760, 137_951_917_644_054_529]
  end

  def expect_ordered(results)
    results[0..-2].each.with_index(1) do |result, i|
      expect(result["value"]).to be >= results.dig(i, "value")
    end
  end

  context "GET /rest/v1/sigma/leaderboards/currency" do
    before do
      ids.each do |uid|
        CurrencySystem.create(uid: uid, score: rand(10000))
      end
    end

    it "lists the top 20 entries" do
      get "/rest/v1/sigma/leaderboards/currency"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results.size).to eq(20)
      expect_ordered(results)
    end
  end

  context "GET /rest/v1/sigma/leaderboards/experience" do
    before do
      ids.each do |uid|
        ExperienceSystem.create(uid: uid, score: rand(10000))
      end
    end

    it "lists the top 20 entries" do
      get "/rest/v1/sigma/leaderboards/experience"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results.size).to eq(20)
      expect_ordered(results)
    end
  end

  context "GET /rest/v1/sigma/leaderboards/cookies" do
    before do
      ids.each do |uid|
        Cookie.create(uid: uid, score: rand(20))
      end
    end

    it "lists the top 20 entries" do
      get "/rest/v1/sigma/leaderboards/cookies"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results.size).to eq(20)
      expect_ordered(results)
    end
  end
end
