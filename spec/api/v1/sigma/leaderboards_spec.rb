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

  context "GET /rest/v1/sigma/leaderboard/currency" do
    before do
      gids = %w[200751504175398912 217081703137542145 273534239310479360 442252698964721669]
      ids.each.with_index(0) do |uid, i|
        CurrencySystem.create do |m|
          m.uid = uid,
          m.score = rand(10000)
          m.origins = {
            "guilds" => { gids[i % 4] => rand(99) },
            "users" => { rand(100_000_000_000_000_000).to_s => rand(99) },
            "channels" => { rand(100_000_000_000_000_000).to_s => rand(99) }
          }
        end
      end
    end

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
    before do
      ids.each do |uid|
        ExperienceSystem.create(uid: uid, score: rand(10000))
      end
    end

    it "lists the top 20 entries" do
      get "/rest/v1/sigma/leaderboard/experience"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results.size).to eq(20)
      expect_ordered(results)
    end
  end

  context "GET /rest/v1/sigma/leaderboard/cookies" do
    before do
      ids.each do |uid|
        Cookie.create(uid: uid, score: rand(20))
      end
    end

    it "lists the top 20 entries" do
      get "/rest/v1/sigma/leaderboard/cookies"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results.size).to eq(20)
      expect_ordered(results)
    end
  end
end
