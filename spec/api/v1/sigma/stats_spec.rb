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

    it "can filter commands" do
      get "/rest/v1/sigma/stats?filter[command][only]=givecookie,hunt"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results["commands"].keys).to include("givecookie", "hunt")
      expect(results["commands"].keys).not_to include("fish")

      get "/rest/v1/sigma/stats?filter[command][except]=givecookie,hunt"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results["commands"].keys).not_to include("givecookie", "hunt")
      expect(results["commands"].keys).to include("fish")
    end

    it "can filter events" do
      get "/rest/v1/sigma/stats?filter[event][only]=ready,command"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results["events"].keys).to include("ready", "command")
      expect(results["events"].keys).not_to include("dbinit")

      get "/rest/v1/sigma/stats?filter[event][except]=ready,command"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results["events"].keys).not_to include("ready", "command")
      expect(results["events"].keys).to include("dbinit")
    end

    it "can show only general statistics" do
      get "/rest/v1/sigma/stats/general"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results.keys).to include("population", "cmd_count")
    end

    it "can show only event statistics" do
      get "/rest/v1/sigma/stats/events"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results).to be_an(Hash)
      expect(results.keys).to include("ready", "dbinit", "command")

      get "/rest/v1/sigma/stats/events?filter[only]=ready"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results).to be_an(Hash)
      expect(results.keys).to include("ready")
      expect(results.keys).not_to include("dbinit", "command")

      get "/rest/v1/sigma/stats/events?filter[except]=ready,command"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results).to be_an(Hash)
      expect(results.keys).not_to include("ready", "command")
      expect(results.keys).to include("dbinit")
    end

    it "can show only command statistics" do
      get "/rest/v1/sigma/stats/commands"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results).to be_an(Hash)
      expect(results.keys).to include("givecookie", "hunt", "fish")

      get "/rest/v1/sigma/stats/commands?filter[only]=fish"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results).to be_an(Hash)
      expect(results.keys).to include("fish")
      expect(results.keys).not_to include("givecookie", "hunt")

      get "/rest/v1/sigma/stats/commands?filter[except]=givecookie,hunt"
      expect(response.status).to eq(200)
      results = JSON.parse(response.body)
      expect(results).to be_an(Hash)
      expect(results.keys).not_to include("givecookie", "hunt")
      expect(results.keys).to include("fish")
    end
  end
end
