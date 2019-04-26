require "rails_helper"

RSpec.describe ::API::V1::Sigma::Stats do
  context "GET /rest/v1/sigma/stats" do
    before do
      %w[givecookie hunt fish].each do |cmd|
        CommandStatistic.create(command: cmd, count: rand(1000))
      end

      %w[ready dbinit command].each do |evt|
        EventStatistic.create(event: evt, count: rand(1000))
      end

      GeneralStatistic.create(name: "population", guild_count: 3, channel_count: 20, member_count: 100)
    end

    it "returns current usage statistics" do
      get "/rest/v1/sigma/stats"

      expect(response.status).to eq(200)
      results = JSON.parse(response.body)

      expect(results).to include("commands")
      expect(results["commands"].keys).to eq(%w[givecookie hunt fish])
      expect(results["commands"].values).to all(be_an(Integer))

      expect(results).to include("events")
      expect(results["events"].keys).to eq(%w[ready dbinit command])
      expect(results["events"].values).to all(be_an(Integer))

      expect(results).to include("general")
      expect(results["general"].keys).to eq(%w[population cmd_count])
      expect(results.dig("general", "population").keys).to eq(%w[guild_count member_count channel_count])
      expect(results.dig("general", "population").values).to all(be_an(Integer))
      expect(results.dig("general", "cmd_count")).to be_an(Integer)
    end
  end
end
